import sys
import os

# Add Kronos directory to python path so we can import 'model'
kronos_path = os.path.join(os.path.dirname(__file__), "Kronos")
sys.path.append(kronos_path)

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
import pandas as pd
import numpy as np
from datetime import datetime

try:
    from model import Kronos, KronosTokenizer, KronosPredictor
    KRONOS_AVAILABLE = True
except ImportError as e:
    print(f"Warning: Could not import Kronos. Error: {e}")
    KRONOS_AVAILABLE = False

app = FastAPI(title="Kronos AutoTrader Backend")

cached_models = {}
cached_tokenizers = {}
cached_predictors = {}

class Candlestick(BaseModel):
    timestamp: str
    open: float
    high: float
    low: float
    close: float
    volume: Optional[float] = 0.0
    amount: Optional[float] = 0.0

class PredictRequest(BaseModel):
    model_size: str = "small" # mini, small, base
    lookback: int
    pred_len: int
    candles: List[Candlestick]
    temperature: float = 1.0
    top_p: float = 0.9
    num_samples: int = 5
    hf_token: Optional[str] = None

@app.get("/shutdown")
def shutdown_server():
    import os, signal
    os.kill(os.getpid(), signal.SIGTERM)
    return {"message": "Shutting down"}

class ProgressTracker:
    def __init__(self, original_stderr):
        self.original_stderr = original_stderr
        self.progress = 0.0

    def write(self, s):
        self.original_stderr.write(s)
        if "%|" in s:
            try:
                parts = s.split("%|")
                val_str = parts[0].split()[-1]
                self.progress = float(val_str) / 100.0
            except:
                pass

    def flush(self):
        self.original_stderr.flush()

progress_tracker = ProgressTracker(sys.stderr)
sys.stderr = progress_tracker

@app.get("/progress")
def get_progress():
    return {"progress": progress_tracker.progress}

@app.post("/predict")
def predict_candles(req: PredictRequest):
    progress_tracker.progress = 0.0
    if not KRONOS_AVAILABLE:
        raise HTTPException(status_code=500, detail="Kronos model could not be imported. Check dependencies.")
        
    if len(req.candles) < req.lookback:
        raise HTTPException(status_code=400, detail=f"Not enough candles. Provided {len(req.candles)}, required {req.lookback}")
    
    if req.lookback > 512:
        req.lookback = 512
        
    model_name = f"NeoQuasar/Kronos-{req.model_size}"
    tokenizer_name = "NeoQuasar/Kronos-Tokenizer-base"

    # Set HuggingFace Token if provided in request
    if req.hf_token and req.hf_token.strip():
        import os
        from huggingface_hub import login
        os.environ["HF_TOKEN"] = req.hf_token.strip()
        login(token=req.hf_token.strip())
        
    try:
        if model_name not in cached_models:
            print(f"Loading tokenizer: {tokenizer_name}")
            cached_tokenizers[model_name] = KronosTokenizer.from_pretrained(tokenizer_name)
            print(f"Loading model: {model_name}")
            cached_models[model_name] = Kronos.from_pretrained(model_name)
            cached_predictors[model_name] = KronosPredictor(cached_models[model_name], cached_tokenizers[model_name], max_context=512)
            print("Loaded successfully.")
            
        predictor = cached_predictors[model_name]
        
        # Convert to Pandas DataFrame
        df = pd.DataFrame([c.dict() for c in req.candles])
        df['timestamps'] = pd.to_datetime(df['timestamp'], format='mixed', utc=True).dt.tz_localize(None)
        
        x_df = df.tail(req.lookback).copy().reset_index(drop=True)
        x_timestamp = x_df['timestamps'].copy()
        
        interval_diff = x_timestamp.diff().mode()[0]
        if pd.isna(interval_diff):
            interval_diff = pd.Timedelta(days=1)
            
        last_t = x_timestamp.iloc[-1]
        y_timestamp = pd.Series([last_t + interval_diff * i for i in range(1, req.pred_len + 1)])
        
        # Generate multiple paths
        df_list = [x_df[['open', 'high', 'low', 'close', 'volume', 'amount']]] * req.num_samples
        x_ts_list = [x_timestamp] * req.num_samples
        y_ts_list = [y_timestamp] * req.num_samples
        
        pred_dfs = predictor.predict_batch(
            df_list=df_list,
            x_timestamp_list=x_ts_list,
            y_timestamp_list=y_ts_list,
            pred_len=req.pred_len,
            T=req.temperature,
            top_p=req.top_p,
            sample_count=1
        )
        
        all_preds = np.stack([p.values for p in pred_dfs], axis=0) # (num_samples, pred_len, feat)
        mean_preds = np.mean(all_preds, axis=0)
        min_preds = np.min(all_preds, axis=0)
        max_preds = np.max(all_preds, axis=0)
        
        predictions = []
        for i in range(req.pred_len):
            timestamp_str = pred_dfs[0].index[i].strftime('%Y-%m-%dT%H:%M:%S')
            predictions.append({
                "timestamp": timestamp_str,
                "open": float(mean_preds[i, 0]),
                "high": float(max_preds[i, 3]), # Confidence Max
                "low": float(min_preds[i, 3]),  # Confidence Min
                "close": float(mean_preds[i, 3]),
                "volume": int(mean_preds[i, 4]),
            })
            
        return {"predictions": predictions}
        
    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
