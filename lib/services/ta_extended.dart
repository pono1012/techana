import 'dart:math' as math;
import '../models/models.dart';
import 'ta_indicators.dart';

// ============================================================
// OUTPUT KLASSEN
// ============================================================
class AroonOut {
  final List<double?> up, down, osc;
  AroonOut(this.up, this.down, this.osc);
}

class VortexOut {
  final List<double?> vip, vim;
  VortexOut(this.vip, this.vim);
}

class KeltnerOut {
  final List<double?> up, mid, lo;
  KeltnerOut(this.up, this.mid, this.lo);
}

class BBExtOut {
  final List<double?> pct, width;
  BBExtOut(this.pct, this.width);
}

class ParabolicSAROut {
  final List<double?> sar;
  final List<bool> bull;
  ParabolicSAROut(this.sar, this.bull);
}

class MacdExtOut {
  final List<double?> ppo, pvoLine;
  MacdExtOut(this.ppo, this.pvoLine);
}

class StochRsiOut {
  final List<double?> k, d;
  StochRsiOut(this.k, this.d);
}

class TSIOut {
  final List<double?> tsi, signal;
  TSIOut(this.tsi, this.signal);
}

class KSTOut {
  final List<double?> kst, signal;
  KSTOut(this.kst, this.signal);
}

class QQEOut {
  final List<double?> qqe, rsSmoothed;
  QQEOut(this.qqe, this.rsSmoothed);
}

class STCOut {
  final List<double?> stc;
  STCOut(this.stc);
}

class LinRegOut {
  final List<double?> value, slope, intercept;
  LinRegOut(this.value, this.slope, this.intercept);
}

class CandlePattern {
  final String name;
  final bool bullish;
  final int index;
  CandlePattern(this.name, this.bullish, this.index);
}

class PivotPointsOut {
  final double pp, r1, r2, r3, s1, s2, s3;
  PivotPointsOut({
    required this.pp,
    required this.r1,
    required this.r2,
    required this.r3,
    required this.s1,
    required this.s2,
    required this.s3,
  });
}

// ============================================================
// TAX - Erweiterte Indikatoren (Pandas-TA kompatibel)
// ============================================================
class TAX {
  // ---- HILFSFUNKTIONEN ----
  static List<double?> _nullList(int n) => List<double?>.filled(n, null);

  static List<double> _ema(List<double> x, int n) {
    final out = List<double>.filled(x.length, 0);
    if (x.isEmpty) return out;
    final k = 2.0 / (n + 1);
    out[0] = x[0];
    for (int i = 1; i < x.length; i++) {
      out[i] = x[i] * k + out[i - 1] * (1 - k);
    }
    return out;
  }

  static List<double?> _sma(List<double> x, int n) {
    final out = _nullList(x.length);
    double s = 0;
    for (int i = 0; i < x.length; i++) {
      s += x[i];
      if (i >= n) s -= x[i - n];
      if (i >= n - 1) out[i] = s / n;
    }
    return out;
  }

  // ============================================================
  // OVERLAP - Moving Averages
  // ============================================================

  /// Double EMA
  static List<double?> dema(List<double> x, int n) {
    final e1 = _ema(x, n);
    final e2 = _ema(e1, n);
    final out = _nullList(x.length);
    for (int i = 0; i < x.length; i++) out[i] = 2 * e1[i] - e2[i];
    return out;
  }

  /// Triple EMA
  static List<double?> tema(List<double> x, int n) {
    final e1 = _ema(x, n);
    final e2 = _ema(e1, n);
    final e3 = _ema(e2, n);
    final out = _nullList(x.length);
    for (int i = 0; i < x.length; i++) out[i] = 3 * e1[i] - 3 * e2[i] + e3[i];
    return out;
  }

  /// Weighted MA
  static List<double?> wma(List<double> x, int n) {
    final out = _nullList(x.length);
    final denom = n * (n + 1) / 2;
    for (int i = n - 1; i < x.length; i++) {
      double s = 0;
      for (int j = 0; j < n; j++) s += x[i - j] * (n - j);
      out[i] = s / denom;
    }
    return out;
  }

  /// Hull MA = WMA(2*WMA(n/2) - WMA(n), sqrt(n))
  static List<double?> hma(List<double> x, int n) {
    final half = (n / 2).ceil();
    final sqrtN = math.sqrt(n).round();
    final wHalf = wma(x, half);
    final wFull = wma(x, n);
    final diff = List<double>.filled(x.length, 0);
    for (int i = 0; i < x.length; i++) {
      final h = wHalf[i], f = wFull[i];
      diff[i] = h != null && f != null ? 2 * h - f : 0;
    }
    return wma(diff, sqrtN);
  }

  /// Volume Weighted MA
  static List<double?> vwma(List<PriceBar> bars, int n) {
    final out = _nullList(bars.length);
    for (int i = n - 1; i < bars.length; i++) {
      double pv = 0, v = 0;
      for (int j = i - n + 1; j <= i; j++) {
        pv += bars[j].close * bars[j].volume;
        v += bars[j].volume;
      }
      out[i] = v > 0 ? pv / v : bars[i].close;
    }
    return out;
  }

  /// VWAP - Volume Weighted Average Price (rolling, per window)
  static List<double?> vwap(List<PriceBar> bars, {int n = 14}) {
    final out = _nullList(bars.length);
    for (int i = n - 1; i < bars.length; i++) {
      double pv = 0, v = 0;
      for (int j = i - n + 1; j <= i; j++) {
        final tp = (bars[j].high + bars[j].low + bars[j].close) / 3;
        pv += tp * bars[j].volume;
        v += bars[j].volume;
      }
      out[i] = v > 0 ? pv / v : null;
    }
    return out;
  }

  /// Kaufman Adaptive MA
  static List<double?> kama(List<double> x,
      {int n = 10, int fast = 2, int slow = 30}) {
    final out = _nullList(x.length);
    if (x.length < n + 1) return out;
    final fastK = 2.0 / (fast + 1);
    final slowK = 2.0 / (slow + 1);
    double kama = x[n - 1];
    out[n - 1] = kama;
    for (int i = n; i < x.length; i++) {
      final dir = (x[i] - x[i - n]).abs();
      double noise = 0;
      for (int j = i - n + 1; j <= i; j++) noise += (x[j] - x[j - 1]).abs();
      final er = noise > 0 ? dir / noise : 0.0;
      final sc = math.pow(er * (fastK - slowK) + slowK, 2).toDouble();
      kama = kama + sc * (x[i] - kama);
      out[i] = kama;
    }
    return out;
  }

  /// McGinley Dynamic
  static List<double?> mcgd(List<double> x, {int n = 14}) {
    final out = _nullList(x.length);
    if (x.isEmpty) return out;
    double md = x[0];
    out[0] = md;
    for (int i = 1; i < x.length; i++) {
      if (md == 0) {
        md = x[i];
        out[i] = md;
        continue;
      }
      md = md + (x[i] - md) / (n * math.pow(x[i] / md, 4));
      out[i] = md;
    }
    return out;
  }

  /// Triangular MA = SMA of SMA
  static List<double?> trima(List<double> x, int n) {
    final s = _sma(x, n);
    final validS = <double>[], idx = <int>[];
    for (int i = 0; i < s.length; i++) {
      if (s[i] != null) {
        validS.add(s[i]!);
        idx.add(i);
      }
    }
    final s2 = _sma(validS, (n / 2).ceil());
    final out = _nullList(x.length);
    for (int i = 0; i < s2.length; i++) out[idx[i]] = s2[i];
    return out;
  }

  /// Zero-Lag EMA
  static List<double?> zlma(List<double> x, int n) {
    final lag = ((n - 1) / 2).floor();
    final adj = List<double>.filled(x.length, 0);
    for (int i = lag; i < x.length; i++) adj[i] = 2 * x[i] - x[i - lag];
    final e = _ema(adj, n);
    final out = _nullList(x.length);
    for (int i = lag; i < x.length; i++) out[i] = e[i];
    return out;
  }

  /// T3 (Tillson Triple EMA)
  static List<double?> t3(List<double> x, {int n = 5, double vFactor = 0.7}) {
    final c1 = -(vFactor * vFactor * vFactor);
    final c2 = 3 * vFactor * vFactor + 3 * vFactor * vFactor * vFactor;
    final c3 =
        -6 * vFactor * vFactor - 3 * vFactor - 3 * vFactor * vFactor * vFactor;
    final c4 =
        1 + 3 * vFactor + vFactor * vFactor * vFactor + 3 * vFactor * vFactor;
    final e1 = _ema(x, n);
    final e2 = _ema(e1, n);
    final e3 = _ema(e2, n);
    final e4 = _ema(e3, n);
    final e5 = _ema(e4, n);
    final e6 = _ema(e5, n);
    final out = _nullList(x.length);
    for (int i = 0; i < x.length; i++) {
      out[i] = c1 * e6[i] + c2 * e5[i] + c3 * e4[i] + c4 * e3[i];
    }
    return out;
  }

  /// Linear Regression
  static LinRegOut linreg(List<double> x, {int n = 14}) {
    final val = _nullList(x.length);
    final slope = _nullList(x.length);
    final intercept = _nullList(x.length);
    for (int i = n - 1; i < x.length; i++) {
      double sx = 0, sy = 0, sxy = 0, sxx = 0;
      for (int j = 0; j < n; j++) {
        sx += j;
        sy += x[i - n + 1 + j];
        sxy += j * x[i - n + 1 + j];
        sxx += j * j;
      }
      final denom = n * sxx - sx * sx;
      if (denom == 0) continue;
      final s = (n * sxy - sx * sy) / denom;
      final b = (sy - s * sx) / n;
      slope[i] = s;
      intercept[i] = b;
      val[i] = b + s * (n - 1);
    }
    return LinRegOut(val, slope, intercept);
  }

  // ============================================================
  // MOMENTUM
  // ============================================================

  /// Rate of Change
  static List<double?> roc(List<double> x, {int n = 10}) {
    final out = _nullList(x.length);
    for (int i = n; i < x.length; i++) {
      if (x[i - n] != 0) out[i] = (x[i] - x[i - n]) / x[i - n] * 100;
    }
    return out;
  }

  /// Momentum
  static List<double?> mom(List<double> x, {int n = 10}) {
    final out = _nullList(x.length);
    for (int i = n; i < x.length; i++) out[i] = x[i] - x[i - n];
    return out;
  }

  /// Commodity Channel Index
  static List<double?> cci(List<PriceBar> bars, {int n = 20}) {
    final out = _nullList(bars.length);
    for (int i = n - 1; i < bars.length; i++) {
      double sum = 0;
      for (int j = i - n + 1; j <= i; j++) {
        sum += (bars[j].high + bars[j].low + bars[j].close) / 3;
      }
      final mean = sum / n;
      double dev = 0;
      for (int j = i - n + 1; j <= i; j++) {
        dev += ((bars[j].high + bars[j].low + bars[j].close) / 3 - mean).abs();
      }
      final tp = (bars[i].high + bars[i].low + bars[i].close) / 3;
      final md = dev / n;
      out[i] = md > 0 ? (tp - mean) / (0.015 * md) : 0;
    }
    return out;
  }

  /// Williams %R
  static List<double?> willr(List<PriceBar> bars, {int n = 14}) {
    final out = _nullList(bars.length);
    for (int i = n - 1; i < bars.length; i++) {
      double hi = -double.infinity, lo = double.infinity;
      for (int j = i - n + 1; j <= i; j++) {
        hi = math.max(hi, bars[j].high);
        lo = math.min(lo, bars[j].low);
      }
      final r = hi - lo;
      out[i] = r > 0 ? (hi - bars[i].close) / r * -100 : 0;
    }
    return out;
  }

  /// True Strength Index
  static TSIOut tsi(List<double> x,
      {int long = 25, int short = 13, int sig = 13}) {
    final diff = List<double>.filled(x.length, 0);
    for (int i = 1; i < x.length; i++) diff[i] = x[i] - x[i - 1];
    final absDiff = diff.map((d) => d.abs()).toList();
    final smooth1 = _ema(_ema(diff, long), short);
    final absSmooth1 = _ema(_ema(absDiff, long), short);
    final tsiVal = _nullList(x.length);
    for (int i = 0; i < x.length; i++) {
      tsiVal[i] = absSmooth1[i] != 0 ? 100 * smooth1[i] / absSmooth1[i] : 0;
    }
    final tsiDouble = tsiVal.map((v) => v ?? 0.0).toList();
    final sigLine = _ema(tsiDouble, sig);
    final sigOut = _nullList(x.length);
    for (int i = 0; i < x.length; i++) sigOut[i] = sigLine[i];
    return TSIOut(tsiVal, sigOut);
  }

  /// Ultimate Oscillator
  static List<double?> uo(List<PriceBar> bars,
      {int s = 7, int m = 14, int l = 28}) {
    final out = _nullList(bars.length);
    for (int i = 1; i < bars.length; i++) {
      if (i < l) continue;
      double calcAvg(int period) {
        double bpSum = 0, trSum = 0;
        for (int j = i - period + 1; j <= i; j++) {
          final pc = bars[j - 1].close;
          bpSum += bars[j].close - math.min(bars[j].low, pc);
          trSum += math.max(bars[j].high, pc) - math.min(bars[j].low, pc);
        }
        return trSum > 0 ? bpSum / trSum : 0;
      }

      out[i] = 100 * (4 * calcAvg(s) + 2 * calcAvg(m) + calcAvg(l)) / 7;
    }
    return out;
  }

  /// Awesome Oscillator
  static List<double?> ao(List<PriceBar> bars) {
    final mid = bars.map((b) => (b.high + b.low) / 2).toList();
    final s5 = _sma(mid, 5);
    final s34 = _sma(mid, 34);
    final out = _nullList(bars.length);
    for (int i = 0; i < bars.length; i++) {
      if (s5[i] != null && s34[i] != null) out[i] = s5[i]! - s34[i]!;
    }
    return out;
  }

  /// Aroon
  static AroonOut aroon(List<PriceBar> bars, {int n = 25}) {
    final up = _nullList(bars.length);
    final down = _nullList(bars.length);
    final osc = _nullList(bars.length);
    for (int i = n; i < bars.length; i++) {
      int highIdx = i, lowIdx = i;
      for (int j = i - n; j <= i; j++) {
        if (bars[j].high >= bars[highIdx].high) highIdx = j;
        if (bars[j].low <= bars[lowIdx].low) lowIdx = j;
      }
      final u = (n - (i - highIdx)) / n * 100;
      final d = (n - (i - lowIdx)) / n * 100;
      up[i] = u;
      down[i] = d;
      osc[i] = u - d;
    }
    return AroonOut(up, down, osc);
  }

  /// Chande Momentum Oscillator
  static List<double?> cmo(List<double> x, {int n = 14}) {
    final out = _nullList(x.length);
    for (int i = n; i < x.length; i++) {
      double up = 0, dn = 0;
      for (int j = i - n + 1; j <= i; j++) {
        final d = x[j] - x[j - 1];
        if (d > 0)
          up += d;
        else
          dn += -d;
      }
      final sum = up + dn;
      out[i] = sum > 0 ? 100 * (up - dn) / sum : 0;
    }
    return out;
  }

  /// Detrended Price Oscillator
  static List<double?> dpo(List<double> x, {int n = 20}) {
    final out = _nullList(x.length);
    final shift = (n / 2).floor() + 1;
    final s = _sma(x, n);
    for (int i = n - 1 + shift; i < x.length; i++) {
      final smaIdx = i - shift;
      if (s[smaIdx] != null) out[i] = x[i] - s[smaIdx]!;
    }
    return out;
  }

  /// Fisher Transform
  static List<double?> fisher(List<PriceBar> bars, {int n = 9}) {
    final out = _nullList(bars.length);
    for (int i = n - 1; i < bars.length; i++) {
      double hi = -double.infinity, lo = double.infinity;
      for (int j = i - n + 1; j <= i; j++) {
        hi = math.max(hi, bars[j].high);
        lo = math.min(lo, bars[j].low);
      }
      final r = hi - lo;
      double val = r > 0 ? 2 * ((bars[i].close - lo) / r) - 1 : 0;
      val = val.clamp(-0.999, 0.999);
      out[i] = 0.5 * math.log((1 + val) / (1 - val));
    }
    return out;
  }

  /// KST (Know Sure Thing)
  static KSTOut kst(List<double> x) {
    List<double?> safeRoc(int period) => roc(x, n: period);
    List<double> smaRoc(int rP, int sP) {
      final r = safeRoc(rP);
      final valid = r.map((v) => v ?? 0.0).toList();
      return _sma(valid, sP).map((v) => v ?? 0.0).toList();
    }

    final rcma1 = smaRoc(10, 10);
    final rcma2 = smaRoc(15, 10);
    final rcma3 = smaRoc(20, 10);
    final rcma4 = smaRoc(30, 15);
    final kstVal = _nullList(x.length);
    for (int i = 0; i < x.length; i++) {
      kstVal[i] = rcma1[i] + 2 * rcma2[i] + 3 * rcma3[i] + 4 * rcma4[i];
    }
    final kstD = kstVal.map((v) => v ?? 0.0).toList();
    final sigOut = _sma(kstD, 9);
    return KSTOut(kstVal, sigOut);
  }

  /// PPO (Percentage Price Oscillator)
  static List<double?> ppo(List<double> x, {int fast = 12, int slow = 26}) {
    final eFast = _ema(x, fast);
    final eSlow = _ema(x, slow);
    final out = _nullList(x.length);
    for (int i = 0; i < x.length; i++) {
      out[i] = eSlow[i] != 0 ? (eFast[i] - eSlow[i]) / eSlow[i] * 100 : 0;
    }
    return out;
  }

  /// Stochastic RSI
  static StochRsiOut stochRsi(List<double> x,
      {int rsiLen = 14, int kLen = 3, int dLen = 3}) {
    final rsiVals = TA.rsi(x, n: rsiLen);
    final rsiD = rsiVals.map((v) => v ?? 50.0).toList();
    final k = _nullList(x.length);
    for (int i = rsiLen + kLen - 1; i < x.length; i++) {
      double hi = -double.infinity, lo = double.infinity;
      for (int j = i - kLen + 1; j <= i; j++) {
        hi = math.max(hi, rsiD[j]);
        lo = math.min(lo, rsiD[j]);
      }
      k[i] = hi - lo > 0 ? (rsiD[i] - lo) / (hi - lo) * 100 : 50;
    }
    final kD = k.map((v) => v ?? 50.0).toList();
    final dSma = _sma(kD, dLen);
    return StochRsiOut(k, dSma);
  }

  /// TRIX
  static List<double?> trix(List<double> x, {int n = 18}) {
    final e3 = _ema(_ema(_ema(x, n), n), n);
    final out = _nullList(x.length);
    for (int i = 1; i < x.length; i++) {
      if (e3[i - 1] != 0) out[i] = (e3[i] - e3[i - 1]) / e3[i - 1] * 100;
    }
    return out;
  }

  /// Coppock Curve
  static List<double?> coppock(List<double> x,
      {int wm = 10, int long = 14, int short = 11}) {
    final r1 = roc(x, n: long);
    final r2 = roc(x, n: short);
    final sum = List<double>.filled(x.length, 0);
    for (int i = 0; i < x.length; i++) sum[i] = (r1[i] ?? 0) + (r2[i] ?? 0);
    final out = _sma(sum, wm);
    return out;
  }

  /// QQE (Quantitative Qualitative Estimation)
  static QQEOut qqe(List<double> x,
      {int rsiLen = 14, int smooth = 5, double factor = 4.236}) {
    final rsiVals = TA.rsi(x, n: rsiLen).map((v) => v ?? 50.0).toList();
    final rsSmoothed = _ema(rsiVals, smooth);
    final delta = List<double>.filled(x.length, 0);
    for (int i = 1; i < x.length; i++)
      delta[i] = (rsSmoothed[i] - rsSmoothed[i - 1]).abs();
    final trLevel = _ema(_ema(delta, smooth * 4), smooth * 4);
    final qqeOut = _nullList(x.length);
    final rsOut = _nullList(x.length);
    for (int i = 0; i < x.length; i++) {
      qqeOut[i] = rsSmoothed[i] + factor * trLevel[i];
      rsOut[i] = rsSmoothed[i];
    }
    return QQEOut(qqeOut, rsOut);
  }

  /// Schaff Trend Cycle
  static STCOut stc(List<double> x,
      {int fast = 23, int slow = 50, int kLen = 10}) {
    final maFast = _ema(x, fast);
    final maSlow = _ema(x, slow);
    final diff = List<double>.filled(x.length, 0);
    for (int i = 0; i < x.length; i++) diff[i] = maFast[i] - maSlow[i];
    final out = _nullList(x.length);
    for (int i = kLen - 1; i < x.length; i++) {
      double hi = -double.infinity, lo = double.infinity;
      for (int j = i - kLen + 1; j <= i; j++) {
        hi = math.max(hi, diff[j]);
        lo = math.min(lo, diff[j]);
      }
      out[i] = hi - lo > 0 ? (diff[i] - lo) / (hi - lo) * 100 : 50;
    }
    return STCOut(out);
  }

  /// BIAS
  static List<double?> bias(List<double> x, {int n = 26}) {
    final s = _sma(x, n);
    final out = _nullList(x.length);
    for (int i = 0; i < x.length; i++) {
      if (s[i] != null && s[i] != 0) out[i] = (x[i] - s[i]!) / s[i]! * 100;
    }
    return out;
  }

  // ============================================================
  // TREND
  // ============================================================

  /// Parabolic SAR
  static ParabolicSAROut psar(List<PriceBar> bars,
      {double step = 0.02, double max = 0.2}) {
    final sar = _nullList(bars.length);
    final bull = List<bool>.filled(bars.length, true);
    if (bars.length < 2) return ParabolicSAROut(sar, bull);
    bool isBull = true;
    double af = step;
    double ep = bars[0].high;
    double sarVal = bars[0].low;
    sar[0] = sarVal;
    for (int i = 1; i < bars.length; i++) {
      sarVal = sarVal + af * (ep - sarVal);
      if (isBull) {
        if (bars[i].low < sarVal) {
          isBull = false;
          sarVal = ep;
          ep = bars[i].low;
          af = step;
        } else {
          if (bars[i].high > ep) {
            ep = bars[i].high;
            af = math.min(af + step, max);
          }
          sarVal = math.min(sarVal, bars[i - 1].low);
          if (i > 1) sarVal = math.min(sarVal, bars[i - 2].low);
        }
      } else {
        if (bars[i].high > sarVal) {
          isBull = true;
          sarVal = ep;
          ep = bars[i].high;
          af = step;
        } else {
          if (bars[i].low < ep) {
            ep = bars[i].low;
            af = math.min(af + step, max);
          }
          sarVal = math.max(sarVal, bars[i - 1].high);
          if (i > 1) sarVal = math.max(sarVal, bars[i - 2].high);
        }
      }
      sar[i] = sarVal;
      bull[i] = isBull;
    }
    return ParabolicSAROut(sar, bull);
  }

  /// Vortex Indicator
  static VortexOut vortex(List<PriceBar> bars, {int n = 14}) {
    final vip = _nullList(bars.length);
    final vim = _nullList(bars.length);
    for (int i = n; i < bars.length; i++) {
      double vm1 = 0, vm2 = 0, tr = 0;
      for (int j = i - n + 1; j <= i; j++) {
        vm1 += (bars[j].high - bars[j - 1].low).abs();
        vm2 += (bars[j].low - bars[j - 1].high).abs();
        tr += math.max(
            bars[j].high - bars[j].low,
            math.max((bars[j].high - bars[j - 1].close).abs(),
                (bars[j].low - bars[j - 1].close).abs()));
      }
      vip[i] = tr > 0 ? vm1 / tr : 0;
      vim[i] = tr > 0 ? vm2 / tr : 0;
    }
    return VortexOut(vip, vim);
  }

  /// Choppiness Index
  static List<double?> chop(List<PriceBar> bars, {int n = 14}) {
    final out = _nullList(bars.length);
    for (int i = n - 1; i < bars.length; i++) {
      double trSum = 0;
      for (int j = i - n + 1; j <= i; j++) {
        final prev = j > 0 ? bars[j - 1].close : bars[j].close;
        trSum += math.max(bars[j].high - bars[j].low,
            math.max((bars[j].high - prev).abs(), (bars[j].low - prev).abs()));
      }
      double hi = -double.infinity, lo = double.infinity;
      for (int j = i - n + 1; j <= i; j++) {
        hi = math.max(hi, bars[j].high);
        lo = math.min(lo, bars[j].low);
      }
      final range = hi - lo;
      if (range > 0 && trSum > 0) {
        out[i] = 100 * math.log(trSum / range) / math.log(n);
      }
    }
    return out;
  }

  /// Mass Index
  static List<double?> massIndex(List<PriceBar> bars,
      {int fast = 9, int slow = 25}) {
    final hl = bars.map((b) => b.high - b.low).toList();
    final e1 = _ema(hl, fast);
    final e2 = _ema(e1, fast);
    final ratio = List<double>.filled(bars.length, 0);
    for (int i = 0; i < bars.length; i++)
      ratio[i] = e2[i] != 0 ? e1[i] / e2[i] : 0;
    final out = _nullList(bars.length);
    for (int i = slow - 1; i < bars.length; i++) {
      double s = 0;
      for (int j = i - slow + 1; j <= i; j++) s += ratio[j];
      out[i] = s;
    }
    return out;
  }

  // ============================================================
  // VOLATILITY
  // ============================================================

  /// NATR - Normalized ATR
  static List<double?> natr(List<PriceBar> bars, {int n = 14}) {
    final atrVals = TA.atr(bars, period: n);
    final out = _nullList(bars.length);
    for (int i = 0; i < bars.length; i++) {
      if (atrVals[i] != null && bars[i].close > 0)
        out[i] = atrVals[i]! / bars[i].close * 100;
    }
    return out;
  }

  /// Keltner Channel
  static KeltnerOut keltner(List<PriceBar> bars,
      {int n = 20, double mult = 2.0}) {
    final closes = bars.map((b) => b.close).toList();
    final basis = _ema(closes, n);
    final atrVals = TA.atr(bars, period: n);
    final up = _nullList(bars.length);
    final lo = _nullList(bars.length);
    final mid = _nullList(bars.length);
    for (int i = 0; i < bars.length; i++) {
      final a = atrVals[i];
      if (a != null) {
        up[i] = basis[i] + mult * a;
        lo[i] = basis[i] - mult * a;
      }
      mid[i] = basis[i];
    }
    return KeltnerOut(up, mid, lo);
  }

  /// Bollinger %B and Width
  static BBExtOut bbExtended(List<double> x, {int n = 20, double k = 2}) {
    final bb = TA.bollinger(x, n: n, k: k);
    final pct = _nullList(x.length);
    final wid = _nullList(x.length);
    for (int i = 0; i < x.length; i++) {
      final u = bb.up[i], l = bb.lo[i], m = bb.mid[i];
      if (u != null && l != null && m != null) {
        final range = u - l;
        pct[i] = range > 0 ? (x[i] - l) / range : 0.5;
        wid[i] = m > 0 ? range / m : 0;
      }
    }
    return BBExtOut(pct, wid);
  }

  /// Relative Volatility Index
  static List<double?> rvi(List<double> x, {int n = 14, int smooth = 14}) {
    final std = List<double>.filled(x.length, 0);
    for (int i = n - 1; i < x.length; i++) {
      double s = 0, m = 0;
      for (int j = i - n + 1; j <= i; j++) m += x[j];
      m /= n;
      for (int j = i - n + 1; j <= i; j++) s += (x[j] - m) * (x[j] - m);
      std[i] = math.sqrt(s / n);
    }
    final upStd = List<double>.filled(x.length, 0);
    final dnStd = List<double>.filled(x.length, 0);
    for (int i = 1; i < x.length; i++) {
      if (x[i] > x[i - 1])
        upStd[i] = std[i];
      else
        dnStd[i] = std[i];
    }
    final avgUp = _ema(upStd, smooth);
    final avgDn = _ema(dnStd, smooth);
    final out = _nullList(x.length);
    for (int i = 0; i < x.length; i++) {
      final d = avgUp[i] + avgDn[i];
      out[i] = d > 0 ? avgUp[i] / d * 100 : 50;
    }
    return out;
  }

  /// Ulcer Index
  static List<double?> ulcerIndex(List<double> x, {int n = 14}) {
    final out = _nullList(x.length);
    for (int i = n - 1; i < x.length; i++) {
      double maxH = 0, sum = 0;
      for (int j = i - n + 1; j <= i; j++) maxH = math.max(maxH, x[j]);
      for (int j = i - n + 1; j <= i; j++) {
        final dd = maxH > 0 ? (x[j] - maxH) / maxH * 100 : 0.0;
        sum += dd * dd;
      }
      out[i] = math.sqrt(sum / n);
    }
    return out;
  }

  // ============================================================
  // VOLUME
  // ============================================================

  /// Accumulation/Distribution
  static List<double?> ad(List<PriceBar> bars) {
    final out = _nullList(bars.length);
    double cumAD = 0;
    for (int i = 0; i < bars.length; i++) {
      final hl = bars[i].high - bars[i].low;
      if (hl > 0) {
        cumAD +=
            ((bars[i].close - bars[i].low) - (bars[i].high - bars[i].close)) /
                hl *
                bars[i].volume;
      }
      out[i] = cumAD;
    }
    return out;
  }

  /// Chaikin Oscillator (ADOSC)
  static List<double?> adosc(List<PriceBar> bars,
      {int fast = 3, int slow = 10}) {
    final adLine = ad(bars).map((v) => v ?? 0.0).toList();
    final eFast = _ema(adLine, fast);
    final eSlow = _ema(adLine, slow);
    final out = _nullList(bars.length);
    for (int i = 0; i < bars.length; i++) out[i] = eFast[i] - eSlow[i];
    return out;
  }

  /// Chaikin Money Flow
  static List<double?> cmf(List<PriceBar> bars, {int n = 20}) {
    final out = _nullList(bars.length);
    for (int i = n - 1; i < bars.length; i++) {
      double mfv = 0, vol = 0;
      for (int j = i - n + 1; j <= i; j++) {
        final hl = bars[j].high - bars[j].low;
        if (hl > 0)
          mfv +=
              ((bars[j].close - bars[j].low) - (bars[j].high - bars[j].close)) /
                  hl *
                  bars[j].volume;
        vol += bars[j].volume;
      }
      out[i] = vol > 0 ? mfv / vol : 0;
    }
    return out;
  }

  /// Elder Force Index
  static List<double?> efi(List<PriceBar> bars, {int n = 13}) {
    final fi = _nullList(bars.length);
    for (int i = 1; i < bars.length; i++) {
      fi[i] = (bars[i].close - bars[i - 1].close) * bars[i].volume.toDouble();
    }
    final fiD = fi.map((v) => v ?? 0.0).toList();
    final smoothed = _ema(fiD, n);
    final out = _nullList(bars.length);
    for (int i = 0; i < bars.length; i++) out[i] = smoothed[i];
    return out;
  }

  /// Money Flow Index
  static List<double?> mfi(List<PriceBar> bars, {int n = 14}) {
    final out = _nullList(bars.length);
    final tp = bars.map((b) => (b.high + b.low + b.close) / 3).toList();
    for (int i = n; i < bars.length; i++) {
      double pMF = 0, nMF = 0;
      for (int j = i - n + 1; j <= i; j++) {
        final flow = tp[j] * bars[j].volume;
        if (tp[j] > tp[j - 1])
          pMF += flow;
        else
          nMF += flow;
      }
      if (nMF == 0) {
        out[i] = 100;
        continue;
      }
      final mfRatio = pMF / nMF;
      out[i] = 100 - 100 / (1 + mfRatio);
    }
    return out;
  }

  /// Negative/Positive Volume Index
  static List<double?> nvi(List<PriceBar> bars) {
    final out = _nullList(bars.length);
    double nviVal = 1000;
    out[0] = nviVal;
    for (int i = 1; i < bars.length; i++) {
      if (bars[i].volume < bars[i - 1].volume) {
        nviVal +=
            nviVal * (bars[i].close - bars[i - 1].close) / bars[i - 1].close;
      }
      out[i] = nviVal;
    }
    return out;
  }

  static List<double?> pvi(List<PriceBar> bars) {
    final out = _nullList(bars.length);
    double pviVal = 1000;
    out[0] = pviVal;
    for (int i = 1; i < bars.length; i++) {
      if (bars[i].volume > bars[i - 1].volume) {
        pviVal +=
            pviVal * (bars[i].close - bars[i - 1].close) / bars[i - 1].close;
      }
      out[i] = pviVal;
    }
    return out;
  }

  /// Price Volume Trend
  static List<double?> pvt(List<PriceBar> bars) {
    final out = _nullList(bars.length);
    double pvtVal = 0;
    out[0] = 0;
    for (int i = 1; i < bars.length; i++) {
      pvtVal += (bars[i].close - bars[i - 1].close) /
          bars[i - 1].close *
          bars[i].volume;
      out[i] = pvtVal;
    }
    return out;
  }

  /// Klinger Volume Oscillator
  static List<double?> kvo(List<PriceBar> bars,
      {int fast = 34, int slow = 55, int sig = 13}) {
    final out = _nullList(bars.length);
    final trend = List<double>.filled(bars.length, 0);
    for (int i = 1; i < bars.length; i++) {
      final tp = (bars[i].high + bars[i].low + bars[i].close) / 3;
      final tpPrev =
          (bars[i - 1].high + bars[i - 1].low + bars[i - 1].close) / 3;
      trend[i] =
          tp > tpPrev ? bars[i].volume.toDouble() : -bars[i].volume.toDouble();
    }
    final eFast = _ema(trend, fast);
    final eSlow = _ema(trend, slow);
    for (int i = 0; i < bars.length; i++) out[i] = eFast[i] - eSlow[i];
    return out;
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  /// Z-Score
  static List<double?> zscore(List<double> x, {int n = 20}) {
    final out = _nullList(x.length);
    for (int i = n - 1; i < x.length; i++) {
      double mean = 0;
      for (int j = i - n + 1; j <= i; j++) mean += x[j];
      mean /= n;
      double variance = 0;
      for (int j = i - n + 1; j <= i; j++)
        variance += (x[j] - mean) * (x[j] - mean);
      final std = math.sqrt(variance / n);
      out[i] = std > 0 ? (x[i] - mean) / std : 0;
    }
    return out;
  }

  /// Rolling Standard Deviation
  static List<double?> stdev(List<double> x, {int n = 20}) {
    final out = _nullList(x.length);
    for (int i = n - 1; i < x.length; i++) {
      double mean = 0;
      for (int j = i - n + 1; j <= i; j++) mean += x[j];
      mean /= n;
      double v = 0;
      for (int j = i - n + 1; j <= i; j++) v += (x[j] - mean) * (x[j] - mean);
      out[i] = math.sqrt(v / n);
    }
    return out;
  }

  /// Variance
  static List<double?> variance(List<double> x, {int n = 20}) {
    final out = _nullList(x.length);
    for (int i = n - 1; i < x.length; i++) {
      double mean = 0;
      for (int j = i - n + 1; j <= i; j++) mean += x[j];
      mean /= n;
      double v = 0;
      for (int j = i - n + 1; j <= i; j++) v += (x[j] - mean) * (x[j] - mean);
      out[i] = v / n;
    }
    return out;
  }

  /// Correlation
  static List<double?> corr(List<double> x, List<double> y, {int n = 20}) {
    if (x.length != y.length) return _nullList(x.length);
    final out = _nullList(x.length);
    for (int i = n - 1; i < x.length; i++) {
      double mx = 0, my = 0;
      for (int j = i - n + 1; j <= i; j++) {
        mx += x[j];
        my += y[j];
      }
      mx /= n;
      my /= n;
      double cov = 0, sx = 0, sy = 0;
      for (int j = i - n + 1; j <= i; j++) {
        cov += (x[j] - mx) * (y[j] - my);
        sx += (x[j] - mx) * (x[j] - mx);
        sy += (y[j] - my) * (y[j] - my);
      }
      final denom = math.sqrt(sx * sy);
      out[i] = denom > 0 ? cov / denom : 0;
    }
    return out;
  }

  /// Entropy
  static List<double?> entropy(List<double> x, {int n = 10}) {
    final out = _nullList(x.length);
    for (int i = n - 1; i < x.length; i++) {
      double h = 0;
      double total = 0;
      for (int j = i - n + 1; j <= i; j++) total += x[j].abs();
      if (total > 0) {
        for (int j = i - n + 1; j <= i; j++) {
          final p = x[j].abs() / total;
          if (p > 0) h -= p * math.log(p);
        }
      }
      out[i] = h;
    }
    return out;
  }

  // ============================================================
  // CANDLE PATTERNS (Erweiterung)
  // ============================================================

  /// Gibt alle erkannten Muster für die letzten 3 Bars zurück
  static List<CandlePattern> detectAllPatterns(List<PriceBar> bars) {
    if (bars.length < 3) return [];
    final patterns = <CandlePattern>[];
    final n = bars.length;

    void check(String name, bool bull, bool condition) {
      if (condition) patterns.add(CandlePattern(name, bull, n - 1));
    }

    final c = bars[n - 1], p = bars[n - 2], p2 = bars[n - 3];
    final cBody = (c.close - c.open).abs();
    final pBody = (p.close - p.open).abs();
    final cRange = c.high - c.low;
    final pRange = p.high - p.low;
    final cUp = c.close > c.open;
    final pUp = p.close > p.open;

    // Doji
    check('Doji', cUp, cBody <= 0.1 * cRange && cRange > 0);
    // Long-Legged Doji
    check(
        'Long-Legged Doji',
        cUp,
        cBody <= 0.05 * cRange &&
            cRange > 0 &&
            (c.high - math.max(c.open, c.close)) > cBody * 2 &&
            (math.min(c.open, c.close) - c.low) > cBody * 2);
    // Marubozu Bull
    check('Marubozu Bullish', true, cUp && cBody > 0.9 * cRange && cRange > 0);
    // Marubozu Bear
    check(
        'Marubozu Bearish', false, !cUp && cBody > 0.9 * cRange && cRange > 0);
    // Spinning Top
    check(
        'Spinning Top',
        cUp,
        cBody < 0.3 * cRange &&
            (c.high - math.max(c.open, c.close)) > cBody &&
            (math.min(c.open, c.close) - c.low) > cBody);
    // Hammer
    check(
        'Hammer',
        true,
        (math.min(c.open, c.close) - c.low) > 2 * cBody &&
            (c.high - math.max(c.open, c.close)) < cBody * 0.5);
    // Inverted Hammer
    check(
        'Inverted Hammer',
        true,
        (c.high - math.max(c.open, c.close)) > 2 * cBody &&
            (math.min(c.open, c.close) - c.low) < cBody * 0.5);
    // Shooting Star
    check(
        'Shooting Star',
        false,
        (c.high - math.max(c.open, c.close)) > 2 * cBody &&
            (math.min(c.open, c.close) - c.low) < cBody * 0.5);
    // Hanging Man
    check(
        'Hanging Man',
        false,
        pUp &&
            (math.min(c.open, c.close) - c.low) > 2 * cBody &&
            (c.high - math.max(c.open, c.close)) < cBody * 0.5);
    // Bullish Engulfing
    check('Bullish Engulfing', true,
        cUp && !pUp && c.open <= p.close && c.close >= p.open && cBody > pBody);
    // Bearish Engulfing
    check('Bearish Engulfing', false,
        !cUp && pUp && c.open >= p.close && c.close <= p.open && cBody > pBody);
    // Morning Star (3-Kerzen)
    check(
        'Morning Star',
        true,
        !p2.close.isNaN &&
            p2.close < p2.open &&
            p.close < p2.close &&
            cUp &&
            c.close > (p2.open + p2.close) / 2);
    // Evening Star
    check(
        'Evening Star',
        false,
        p2.close > p2.open &&
            p.close > p2.close &&
            !cUp &&
            c.close < (p2.open + p2.close) / 2);
    // Piercing Line
    check(
        'Piercing Line',
        true,
        !pUp &&
            cUp &&
            c.open < p.low &&
            c.close > (p.open + p.close) / 2 &&
            c.close < p.open);
    // Dark Cloud Cover
    check(
        'Dark Cloud Cover',
        false,
        pUp &&
            !cUp &&
            c.open > p.high &&
            c.close < (p.open + p.close) / 2 &&
            c.close > p.open);
    // Bullish Harami
    check(
        'Bullish Harami',
        true,
        !pUp &&
            cUp &&
            c.open > p.close &&
            c.close < p.open &&
            cBody < pBody * 0.5);
    // Bearish Harami
    check(
        'Bearish Harami',
        false,
        pUp &&
            !cUp &&
            c.open < p.close &&
            c.close > p.open &&
            cBody < pBody * 0.5);
    // 3 White Soldiers
    if (bars.length >= 3) {
      check(
          '3 White Soldiers',
          true,
          cUp &&
              pUp &&
              p2.close > p2.open &&
              c.close > p.close &&
              p.close > p2.close);
    }
    // 3 Black Crows
    if (bars.length >= 3) {
      check(
          '3 Black Crows',
          false,
          !cUp &&
              !pUp &&
              p2.close < p2.open &&
              c.close < p.close &&
              p.close < p2.close);
    }
    // Tweezers Bottom
    check('Tweezers Bottom', true,
        (c.low - p.low).abs() < (c.low * 0.001) && !pUp && cUp);
    // Tweezers Top
    check('Tweezers Top', false,
        (c.high - p.high).abs() < (c.high * 0.001) && pUp && !cUp);
    // Kicking Bullish
    check(
        'Kicking Bullish',
        true,
        !pUp &&
            pBody > 0.8 * pRange &&
            cUp &&
            cBody > 0.8 * cRange &&
            c.open > p.high);

    return patterns;
  }

  /// Gibt das stärkste Muster als String zurück (für Backward-Compat)
  static String detectBestPattern(List<PriceBar> bars) {
    final all = detectAllPatterns(bars);
    if (all.isEmpty) return 'Kein Muster';
    const priority = [
      'Morning Star',
      'Evening Star',
      'Bullish Engulfing',
      'Bearish Engulfing',
      '3 White Soldiers',
      '3 Black Crows',
      'Piercing Line',
      'Dark Cloud Cover',
      'Hammer',
      'Shooting Star'
    ];
    for (final name in priority) {
      final found = all.where((p) => p.name == name);
      if (found.isNotEmpty) return found.first.name;
    }
    return all.first.name;
  }

  // ============================================================
  // SWING POINTS
  // ============================================================

  /// Findet das letzte Swing-Low und Swing-High in einem Lookback-Fenster.
  /// Ein Swing-Low ist ein lokales Minimum: [i].low < [i-1].low AND [i].low < [i+1].low
  /// [lookback] = Anzahl der Bars, die nach links gesucht wird.
  /// Gibt (swingLow, swingHigh) zurück.
  static ({double swingLow, double swingHigh}) swingPoints(List<PriceBar> bars,
      {int lookback = 20}) {
    if (bars.length < 3) {
      return (swingLow: bars.last.low * 0.95, swingHigh: bars.last.high * 1.05);
    }
    final start = math.max(1, bars.length - lookback - 1);
    final end = bars.length - 2; // -2 so we have a right neighbour

    double bestLow = double.maxFinite;
    double bestHigh = -double.maxFinite;

    for (int i = start; i <= end; i++) {
      // Swing Low: local minimum
      if (bars[i].low < bars[i - 1].low && bars[i].low < bars[i + 1].low) {
        if (bars[i].low < bestLow) bestLow = bars[i].low;
      }
      // Swing High: local maximum
      if (bars[i].high > bars[i - 1].high && bars[i].high > bars[i + 1].high) {
        if (bars[i].high > bestHigh) bestHigh = bars[i].high;
      }
    }

    // Fallbacks basierend auf dem Lookback-Fenster
    if (bestLow == double.maxFinite) {
      bestLow = bars.sublist(start).map((b) => b.low).reduce(math.min);
    }
    if (bestHigh == -double.maxFinite) {
      bestHigh = bars.sublist(start).map((b) => b.high).reduce(math.max);
    }
    return (swingLow: bestLow, swingHigh: bestHigh);
  }

  // ============================================================
  // PIVOT POINTS (Classic Floor Pivots)
  // ============================================================

  /// Klassische Floor Pivot Points berechnet aus der vorherigen Kerze (Prev H/L/C).
  /// PP = (H + L + C) / 3
  /// R1 = 2*PP - L, R2 = PP + (H - L), R3 = H + 2*(PP - L)
  /// S1 = 2*PP - H, S2 = PP - (H - L), S3 = L - 2*(H - PP)
  static PivotPointsOut pivotPoints(List<PriceBar> bars) {
    if (bars.length < 2) {
      final p = bars.last.close;
      return PivotPointsOut(pp: p, r1: p, r2: p, r3: p, s1: p, s2: p, s3: p);
    }
    final prev = bars[bars.length - 2]; // Vorherige abgeschlossene Kerze
    final h = prev.high, l = prev.low, c = prev.close;
    final pp = (h + l + c) / 3;
    return PivotPointsOut(
      pp: pp,
      r1: 2 * pp - l,
      r2: pp + (h - l),
      r3: h + 2 * (pp - l),
      s1: 2 * pp - h,
      s2: pp - (h - l),
      s3: l - 2 * (h - pp),
    );
  }
}
