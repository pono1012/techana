import '../models/models.dart';
import 'ta_indicators.dart';
import 'ta_extended.dart';

class MarketRegimeService {
  MarketRegime detectRegime(List<PriceBar> bars) {
    if (bars.length < 30) return MarketRegime.unknown;

    final lastPrice = bars.last.close;

    // 1. Trend Stärke (ADX)
    final adxOut = TA.calcAdx(bars, len: 14);
    final lastAdx = adxOut.adx.last ?? 0.0;

    // 2. Trend Richtung (LinReg Slope)
    final closes = bars.map((b) => b.close).toList();
    final linReg = TAX.linreg(closes, n: 20);
    final lastSlope = linReg.slope.last ?? 0.0;

    // Normalisierter Slope (% pro Bar)
    final normalizedSlope = (lastSlope / lastPrice) * 100;

    // 3. Volatilität (ATR % vom Preis)
    final atrVals = TA.atr(bars, period: 14);
    final lastAtr = atrVals.last ?? 0.0;
    final atrPct = (lastAtr / lastPrice) * 100;

    // --- REGELWERK ---

    // Volatil / Choppy: Hohe ATR bei gleichzeitig unklarem Trend (ADX mittel oder niedrig)
    if (atrPct > 2.5 && lastAdx < 25) {
      return MarketRegime.volatile;
    }

    // Trendphasen: ADX > 25
    if (lastAdx > 25) {
      if (normalizedSlope > 0.1) return MarketRegime.trendingBull;
      if (normalizedSlope < -0.1) return MarketRegime.trendingBear;
    }

    // Seitwärts / Range: Niedriger ADX oder extrem flacher Slope
    if (lastAdx < 20 || normalizedSlope.abs() < 0.05) {
      return MarketRegime.ranging;
    }

    // Fallback: Wenn ADX zwischen 20-25 liegt, schauen wir nur auf Slope
    if (normalizedSlope > 0) return MarketRegime.trendingBull;
    if (normalizedSlope < 0) return MarketRegime.trendingBear;

    return MarketRegime.ranging;
  }
}
