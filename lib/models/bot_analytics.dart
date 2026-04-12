enum TimeFilter { allTime, last7Days, last30Days, yearToDate }

class GroupedPerformance {
  final String label;
  final int count;
  final double totalPnL;
  final int wins;
  final double grossProfit;
  final double grossLoss;
  final double avgEntryScore;

  GroupedPerformance({
    required this.label,
    required this.count,
    required this.totalPnL,
    required this.wins,
    required this.grossProfit,
    required this.grossLoss,
    required this.avgEntryScore,
  });

  double get winRate => count == 0 ? 0 : (wins / count) * 100;

  double get profitFactor {
    if (grossLoss == 0) return grossProfit > 0 ? double.infinity : 0.0;
    return grossProfit / grossLoss;
  }
}

class BotAnalyticsSummary {
  final List<EquityPoint> equityCurve;
  final double totalPnL;
  final int totalTrades;
  final int winningTrades;
  final int losingTrades;
  final double grossProfit;
  final double grossLoss;
  final double averageWin;
  final double averageLoss;
  final double winRate;

  // New Metrics
  final double expectancy;
  final double maxDrawdown; // Absolute or %
  final int maxWinningStreak;
  final int maxLosingStreak;
  final Duration averageTradeDuration;

  // Breakdown
  final List<GroupedPerformance> bySymbol;
  final List<GroupedPerformance> byTimeFrame;
  final List<GroupedPerformance> byEntryStrategy;
  final List<GroupedPerformance> bySlMethod;
  final List<GroupedPerformance> byTpMethod;

  // Combination
  final List<TopCombination> topLongCombinations;
  final List<TopCombination> topShortCombinations;

  BotAnalyticsSummary({
    required this.equityCurve,
    required this.totalPnL,
    required this.totalTrades,
    required this.winningTrades,
    required this.losingTrades,
    required this.grossProfit,
    required this.grossLoss,
    required this.averageWin,
    required this.averageLoss,
    required this.winRate,
    required this.expectancy,
    required this.maxDrawdown,
    required this.maxWinningStreak,
    required this.maxLosingStreak,
    required this.averageTradeDuration,
    required this.bySymbol,
    required this.byTimeFrame,
    required this.byEntryStrategy,
    required this.bySlMethod,
    required this.byTpMethod,
    required this.topLongCombinations,
    required this.topShortCombinations,
  });

  double get profitFactor {
    if (grossLoss == 0) return grossProfit > 0 ? double.infinity : 0.0;
    return grossProfit / grossLoss;
  }
}

class EquityPoint {
  final DateTime date;
  final double equity;

  EquityPoint(this.date, this.equity);
}

class TopCombination {
  final String settings;
  final String market;
  final GroupedPerformance performance;

  TopCombination({
    required this.settings,
    required this.market,
    required this.performance,
  });
}
