import '../models/models.dart';

class DataSampler {
  /// Reduziert die Anzahl der Datenpunkte im ComputedData Objekt,
  /// um die Rendering-Performance bei sehr großen Zeiträumen zu optimieren.
  static ComputedData sampleComputedData(ComputedData data, {int maxPoints = 500}) {
    if (data.bars.length <= maxPoints) {
      return data;
    }

    final double step = data.bars.length / maxPoints;
    
    // Hilfsfunktion zum Samplen von Listen beliebigen Typs
    List<T> sampleList<T>(List<T> original) {
      if (original.isEmpty) return original;
      // Einige Indikatoren (z.B. ProjectionResult) sind vielleicht kürzer/länger, 
      // aber in ComputedData haben die meisten Arrays exakt die Länge von `bars`
      if (original.length != data.bars.length) return original; 
      
      final List<T> sampled = [];
      for (int i = 0; i < maxPoints; i++) {
        final int index = (i * step).round().clamp(0, original.length - 1);
        sampled.add(original[index]);
      }
      
      // Letzten Punkt erzwingen
      if (sampled.isNotEmpty && original.isNotEmpty) {
        sampled.removeLast();
        sampled.add(original.last);
      }
      return sampled;
    }

    return ComputedData(
      bars: sampleList(data.bars),
      sma50: sampleList(data.sma50),
      ema20: sampleList(data.ema20),
      rsi: sampleList(data.rsi),
      macd: sampleList(data.macd),
      macdSignal: sampleList(data.macdSignal),
      macdHist: sampleList(data.macdHist),
      atr: sampleList(data.atr),
      bbUp: sampleList(data.bbUp),
      bbMid: sampleList(data.bbMid),
      bbLo: sampleList(data.bbLo),
      donchianUp: sampleList(data.donchianUp),
      donchianMid: sampleList(data.donchianMid),
      donchianLo: sampleList(data.donchianLo),
      stLine: sampleList(data.stLine),
      stBull: sampleList(data.stBull),
      squeezeFlags: sampleList(data.squeezeFlags),
      adx: sampleList(data.adx),
      stochK: sampleList(data.stochK),
      stochD: sampleList(data.stochD),
      obv: sampleList(data.obv),
      proj: data.proj, // Proj unberührt lassen, da es an den letzten echten Bar anknüpft
      fundamentals: data.fundamentals,
      latestSignal: data.latestSignal,
    );
  }
}
