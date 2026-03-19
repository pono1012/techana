import '../models/models.dart';
import 'monte_carlo_service.dart';

/// Service zur automatischen Optimierung von SL/TP Parametern
class StrategyOptimizerService {
  final MonteCarloService _mc = MonteCarloService();

  /// Sucht nach den optimalen SL/TP Werten für ein gegebenes Signal
  Future<Map<String, double>> optimizeExit(
    List<PriceBar> bars,
    double entry,
    double currentSl,
    double currentTp1,
    double currentTp2,
    bool isLong,
  ) async {
    // Wir variieren SL und TP in einem Umkreis von +/- 20%
    final slVariations = [0.8, 0.9, 1.0, 1.1, 1.2];
    final tpVariations = [0.8, 1.0, 1.2, 1.5];

    double bestEv = -9999.0;
    Map<String, double> bestParams = {
      'sl': currentSl,
      'tp1': currentTp1,
      'tp2': currentTp2,
    };

    for (var slVar in slVariations) {
      for (var tpVar in tpVariations) {
        final testSl = isLong
            ? entry - (entry - currentSl) * slVar
            : entry + (currentSl - entry) * slVar;

        final testTp1 = isLong
            ? entry + (currentTp1 - entry) * tpVar
            : entry - (entry - currentTp1) * tpVar;

        try {
          // Mini-Monte Carlo für Tempo
          final mc = _mc.runSimulation(
            historicalBars: bars,
            daysToSimulate: 20,
            numSimulations: 100,
            tpPrice: testTp1,
            slPrice: testSl,
          );

          final tpProb = mc.tpProbability ?? 0.0;
          final slProb = mc.slProbability ?? 0.0;

          final reward = (testTp1 - entry).abs();
          final loss = (entry - testSl).abs();

          // Expected Value (EV) = (Prob(TP) * Reward) - (Prob(SL) * Loss)
          final ev = (tpProb * reward) - (slProb * loss);

          if (ev > bestEv) {
            bestEv = ev;
            bestParams = {
              'sl': testSl,
              'tp1': testTp1,
              'tp2': isLong ? testTp1 * 1.5 : testTp1 * 0.85, // Simple Scaling
            };
          }
        } catch (_) {}
      }
    }

    return bestParams;
  }
}
