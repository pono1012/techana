import 'dart:math' as math;
import '../models/models.dart';
import 'ta_indicators.dart';

class IndicatorAnalyzerService {
  IndicatorWinRates analyze(List<PriceBar> bars) {
    if (bars.length < 50) return IndicatorWinRates(rates: {});

    final Map<String, int> signals = {};
    final Map<String, int> successes = {};

    final closes = bars.map((b) => b.close).toList();

    // Indikatoren vorbereiten
    final rsi = TA.rsi(closes, n: 14);
    final macd = TA.macd(closes);
    final ema20 = TA.ema(closes, 20);
    final ema50 = TA.ema(closes, 50);
    final stoch = TA.stochastic(bars);
    final bb = TA.bollinger(closes);

    // Wir schauen uns die letzten 40 Bars an (bis 5 Bars vor Schluss, damit wir das Ergebnis prüfen können)
    final start = math.max(1, bars.length - 45);
    final end = bars.length - 6;

    for (int i = start; i <= end; i++) {
      final nextFive = bars[i + 5].close;
      final current = bars[i].close;

      // 1. RSI (Oversold=Bull, Overbought=Bear)
      if (rsi[i] != null && rsi[i - 1] != null) {
        if (rsi[i]! > 30 && rsi[i - 1]! <= 30) {
          _recordSignal(signals, successes, "rsi", nextFive > current);
        } else if (rsi[i]! < 70 && rsi[i - 1]! >= 70) {
          _recordSignal(signals, successes, "rsi", nextFive < current);
        }
      }

      // 2. MACD (Crossover)
      if (macd.hist[i] != null && macd.hist[i - 1] != null) {
        if (macd.hist[i]! > 0 && macd.hist[i - 1]! <= 0) {
          _recordSignal(signals, successes, "macd", nextFive > current);
        } else if (macd.hist[i]! < 0 && macd.hist[i - 1]! >= 0) {
          _recordSignal(signals, successes, "macd", nextFive < current);
        }
      }

      // 3. EMA 20/50 Cross
      if (ema20[i] != null &&
          ema50[i] != null &&
          ema20[i - 1] != null &&
          ema50[i - 1] != null) {
        if (ema20[i]! > ema50[i]! && ema20[i - 1]! <= ema50[i - 1]!) {
          _recordSignal(signals, successes, "ema", nextFive > current);
        } else if (ema20[i]! < ema50[i]! && ema20[i - 1]! >= ema50[i - 1]!) {
          _recordSignal(signals, successes, "ema", nextFive < current);
        }
      }

      // 4. Bollinger Bands
      if (bb.lo[i] != null && bb.up[i] != null) {
        if (current < bb.lo[i]!) {
          _recordSignal(signals, successes, "bb", nextFive > current);
        } else if (current > bb.up[i]!) {
          _recordSignal(signals, successes, "bb", nextFive < current);
        }
      }

      // 5. Stochastic
      if (stoch.k[i] != null && stoch.k[i - 1] != null) {
        if (stoch.k[i]! > 20 && stoch.k[i - 1]! <= 20) {
          _recordSignal(signals, successes, "stoch", nextFive > current);
        } else if (stoch.k[i]! < 80 && stoch.k[i - 1]! >= 80) {
          _recordSignal(signals, successes, "stoch", nextFive < current);
        }
      }
    }

    // Win Rates berechnen
    final Map<String, double> rates = {};
    signals.forEach((key, count) {
      if (count >= 3) {
        // Mindestens 3 Signale für Relevanz
        rates[key] = successes[key]! / count;
      } else {
        rates[key] = 0.5; // Neutral
      }
    });

    return IndicatorWinRates(rates: rates);
  }

  void _recordSignal(Map<String, int> signals, Map<String, int> successes,
      String name, bool win) {
    signals[name] = (signals[name] ?? 0) + 1;
    successes[name] = (successes[name] ?? 0) + (win ? 1 : 0);
  }
}
