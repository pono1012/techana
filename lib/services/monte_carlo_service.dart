import 'dart:math';
import '../models/models.dart';

class MonteCarloService {
  final Random _random = Random();

  double _nextGaussian() {
    double u1 = 1.0 - _random.nextDouble(); // uniform(0,1]
    double u2 = 1.0 - _random.nextDouble();
    return sqrt(-2.0 * log(u1)) * cos(2.0 * pi * u2);
  }

  MonteCarloResult runSimulation({
    required List<PriceBar> historicalBars,
    int daysToSimulate = 30,
    int numSimulations = 1000,
    double? tpPrice,
    double? slPrice,
  }) {
    if (historicalBars.length < 2) {
      throw Exception("Nicht genügend historische Daten für die Simulation");
    }

    // 1. Log Returns berechnen
    List<double> logReturns = [];
    for (int i = 1; i < historicalBars.length; i++) {
      double p0 = historicalBars[i - 1].close;
      double p1 = historicalBars[i].close;
      if (p0 > 0 && p1 > 0) {
        logReturns.add(log(p1 / p0));
      }
    }

    if (logReturns.isEmpty) {
      throw Exception("Konnte keine gültigen Returns berechnen");
    }

    // 2. Mean (Mittelwert) und Varianz berechnen
    double sum = 0;
    for (double r in logReturns) sum += r;
    double meanReturn = sum / logReturns.length;

    double varianceSum = 0;
    for (double r in logReturns) {
      varianceSum += pow(r - meanReturn, 2);
    }
    double varianceReturn = varianceSum / logReturns.length;
    double stdDevReturn = sqrt(varianceReturn);

    // 3. Drift berechnen (Mu)
    double drift = meanReturn - (0.5 * varianceReturn);

    // 4. Simulation ausführen
    double currentPrice = historicalBars.last.close;
    List<List<double>> allPaths = [];
    List<int> tpHitDays = [];
    List<int> slHitDays = [];

    for (int i = 0; i < numSimulations; i++) {
      List<double> path = [currentPrice];
      double p = currentPrice;
      bool hitTp = false;
      bool hitSl = false;

      for (int d = 1; d <= daysToSimulate; d++) {
        double z = _nextGaussian();
        p = p * exp(drift + stdDevReturn * z);
        path.add(p);

        if (!hitTp && !hitSl) {
          if (tpPrice != null && tpPrice > currentPrice) {
            if (p >= tpPrice) {
              hitTp = true;
              tpHitDays.add(d);
            }
          } else if (tpPrice != null && tpPrice < currentPrice) {
            if (p <= tpPrice) {
              hitTp = true;
              tpHitDays.add(d);
            }
          }

          if (slPrice != null && slPrice < currentPrice) {
            if (p <= slPrice) {
              hitSl = true;
              slHitDays.add(d);
            }
          } else if (slPrice != null && slPrice > currentPrice) {
            if (p >= slPrice) {
              hitSl = true;
              slHitDays.add(d);
            }
          }
        }
      }
      allPaths.add(path);
    }

    // 5. Statistische Auswertung am Ziel-Tag (T = daysToSimulate)
    List<double> finalPrices = allPaths.map((p) => p.last).toList();
    finalPrices.sort();

    double sumFinal = 0;
    for (double f in finalPrices) sumFinal += f;
    double expectedPrice = sumFinal / finalPrices.length;

    // 95% Confidence Interval (2.5th and 97.5th percentiles)
    int p025Index = (finalPrices.length * 0.025).round();
    int p975Index = (finalPrices.length * 0.975).round();

    if (p025Index < 0) p025Index = 0;
    if (p975Index >= finalPrices.length) p975Index = finalPrices.length - 1;

    double lowerBound = finalPrices[p025Index];
    double upperBound = finalPrices[p975Index];

    // Median Hit Days berechnen
    int? medianTpDay;
    if (tpHitDays.isNotEmpty) {
      tpHitDays.sort();
      medianTpDay = tpHitDays[tpHitDays.length ~/ 2];
    }

    int? medianSlDay;
    if (slHitDays.isNotEmpty) {
      slHitDays.sort();
      medianSlDay = slHitDays[slHitDays.length ~/ 2];
    }

    return MonteCarloResult(
      expectedPrice: expectedPrice,
      lowerBound95: lowerBound,
      upperBound95: upperBound,
      simulatedPaths: allPaths,
      historicalVolatility: stdDevReturn * sqrt(252),
      drift: drift * 252,
      currentPrice: currentPrice,
      tpProbability: tpHitDays.length / numSimulations,
      slProbability: slHitDays.length / numSimulations,
      medianTpDay: medianTpDay,
      medianSlDay: medianSlDay,
    );
  }

  /// Schnelle MC-Auswertung: Gibt nur die Bull-Wahrscheinlichkeit (0.0–1.0) zurück.
  /// Optimiert für Scoring-Integration (200 Sims, keine Pfade gespeichert).
  double quickBullProbability(List<PriceBar> bars,
      {int days = 30, int sims = 200}) {
    if (bars.length < 20) return 0.5; // Nicht genug Daten → neutral

    // Log Returns
    List<double> logReturns = [];
    for (int i = 1; i < bars.length; i++) {
      double p0 = bars[i - 1].close;
      double p1 = bars[i].close;
      if (p0 > 0 && p1 > 0) logReturns.add(log(p1 / p0));
    }
    if (logReturns.isEmpty) return 0.5;

    double sum = 0;
    for (double r in logReturns) sum += r;
    double meanReturn = sum / logReturns.length;

    double varSum = 0;
    for (double r in logReturns) varSum += pow(r - meanReturn, 2);
    double stdDev = sqrt(varSum / logReturns.length);
    double drift = meanReturn - (0.5 * (varSum / logReturns.length));

    double currentPrice = bars.last.close;
    int bullCount = 0;

    for (int i = 0; i < sims; i++) {
      double p = currentPrice;
      for (int d = 0; d < days; d++) {
        p = p * exp(drift + stdDev * _nextGaussian());
      }
      if (p > currentPrice) bullCount++;
    }

    return bullCount / sims;
  }
}
