import '../models/models.dart';
import '../models/trade_record.dart';

class BotAnalyticsService {
  BotAnalyticsSummary calculateAnalytics({
    required List<TradeRecord> closedTrades,
    required TimeFilter timeFilter,
  }) {
    // 1. Time Filter
    final filtered = _filterTrades(closedTrades, timeFilter);

    // 2. Base Metrics
    double totalPnL = 0;
    int winningTrades = 0;
    int losingTrades = 0;
    double grossProfit = 0;
    double grossLoss = 0;
    double maxDrawdown = 0;

    int currentWinStreak = 0;
    int maxWinStreak = 0;
    int currentLossStreak = 0;
    int maxLossStreak = 0;

    Duration totalWinningDuration = Duration.zero;
    Duration totalLosingDuration = Duration.zero;

    List<EquityPoint> equityCurve = [];
    double currentEquity = 0.0;
    double peakEquity = 0.0;

    // Filter und Sort (Älteste zuerst, um den Verlauf korrekt abzubilden)
    final sortedTrades = List<TradeRecord>.from(filtered)
      ..sort((a, b) =>
          (a.exitDate ?? a.entryDate).compareTo(b.exitDate ?? b.entryDate));

    for (var t in sortedTrades) {
      final pnl = t.realizedPnL;
      totalPnL += pnl;

      // Drawdown & Equity
      currentEquity += pnl;
      if (currentEquity > peakEquity) {
        peakEquity = currentEquity;
      }
      final drawdown = peakEquity - currentEquity;
      if (drawdown > maxDrawdown) {
        maxDrawdown = drawdown;
      }
      equityCurve.add(EquityPoint(t.exitDate!, currentEquity));

      // Streaks & Win/Loss Logic
      final dur = t.exitDate!.difference(t.entryDate);
      if (pnl > 0) {
        winningTrades++;
        grossProfit += pnl;
        currentWinStreak++;
        currentLossStreak = 0;
        if (currentWinStreak > maxWinStreak) maxWinStreak = currentWinStreak;
        totalWinningDuration += dur;
      } else if (pnl < 0) {
        losingTrades++;
        grossLoss += pnl.abs();
        currentLossStreak++;
        currentWinStreak = 0;
        if (currentLossStreak > maxLossStreak)
          maxLossStreak = currentLossStreak;
        totalLosingDuration += dur;
      }
    }

    final totalCount = winningTrades + losingTrades;
    final winRate = totalCount == 0 ? 0.0 : (winningTrades / totalCount) * 100;
    final avgWin = winningTrades == 0 ? 0.0 : grossProfit / winningTrades;
    final avgLoss = losingTrades == 0 ? 0.0 : grossLoss / losingTrades;

    // Expectancy = (Win% * AvgWin) - (Loss% * AvgLoss)
    final wPerc = winningTrades / totalCount;
    final lPerc = losingTrades / totalCount;
    final expectancy = (wPerc * avgWin) - (lPerc * avgLoss);

    final avgDurUs = totalCount == 0
        ? 0
        : (totalWinningDuration.inMicroseconds +
                totalLosingDuration.inMicroseconds) ~/
            totalCount;

    // By Group Breakdowns
    final bySymbol = _groupTrades(filtered, (t) => t.symbol);
    final byTimeFrame =
        _groupTrades(filtered, (t) => t.botTimeFrame?.label ?? "Unbekannt");
    final byEntryStrategy = _groupTrades(filtered, (t) {
      int strat = t.aiAnalysisSnapshot['entryStrategy'] ?? 0;
      if (strat == 0) return "Market";
      if (strat == 1) return "Pullback";
      if (strat == 2) return "Breakout";
      return "Unbekannt";
    });
    final bySlMethod = _groupTrades(filtered, (t) {
      final snap = t.aiAnalysisSnapshot;
      int sm = snap['stopMethod'] ?? 2;
      if (sm == 0) return "Donchian";
      if (sm == 1) return "Prozentual";
      return "ATR";
    });
    final byTpMethod = _groupTrades(filtered, (t) {
      final snap = t.aiAnalysisSnapshot;
      int tm = snap['tpMethod'] ?? 0;
      if (tm == 0) return "Risk/Reward";
      if (tm == 1) return "Prozentual";
      return "ATR-Ziel";
    });

    // Combinations
    final longs = filtered.where((t) => t.takeProfit1 > t.entryPrice).toList();
    final shorts = filtered.where((t) => t.takeProfit1 < t.entryPrice).toList();

    return BotAnalyticsSummary(
      equityCurve: equityCurve,
      totalPnL: totalPnL,
      totalTrades: totalCount,
      winningTrades: winningTrades,
      losingTrades: losingTrades,
      grossProfit: grossProfit,
      grossLoss: grossLoss,
      averageWin: avgWin,
      averageLoss: avgLoss,
      winRate: winRate,
      expectancy: expectancy.isNaN ? 0.0 : expectancy,
      maxDrawdown: maxDrawdown,
      maxWinningStreak: maxWinStreak,
      maxLosingStreak: maxLossStreak,
      averageTradeDuration: Duration(microseconds: avgDurUs),
      bySymbol: bySymbol,
      byTimeFrame: byTimeFrame,
      byEntryStrategy: byEntryStrategy,
      bySlMethod: bySlMethod,
      byTpMethod: byTpMethod,
      topLongCombinations: _buildCombinations(longs),
      topShortCombinations: _buildCombinations(shorts),
    );
  }

  List<TradeRecord> _filterTrades(List<TradeRecord> trades, TimeFilter filter) {
    final validTrades = trades.where((t) => t.exitDate != null).toList();
    if (filter == TimeFilter.allTime) return validTrades;
    final now = DateTime.now();
    DateTime cutoff;
    switch (filter) {
      case TimeFilter.last7Days:
        cutoff = now.subtract(const Duration(days: 7));
        break;
      case TimeFilter.last30Days:
        cutoff = now.subtract(const Duration(days: 30));
        break;
      case TimeFilter.yearToDate:
        cutoff = DateTime(now.year, 1, 1);
        break;
      default:
        return trades;
    }
    return trades
        .where((t) => t.exitDate != null && t.exitDate!.isAfter(cutoff))
        .toList();
  }

  List<GroupedPerformance> _groupTrades(
      List<TradeRecord> trades, String Function(TradeRecord) grouper) {
    final Map<String, List<TradeRecord>> buckets = {};
    for (var t in trades) {
      final key = grouper(t);
      buckets.putIfAbsent(key, () => []).add(t);
    }

    final groups = buckets.entries.map((e) {
      double pnl = 0;
      int wins = 0;
      double gp = 0;
      double gl = 0;
      double avgScore = 0;

      for (var t in e.value) {
        pnl += t.realizedPnL;
        avgScore += t.entryScore;
        if (t.realizedPnL > 0) {
          wins++;
          gp += t.realizedPnL;
        } else {
          gl += t.realizedPnL.abs();
        }
      }

      return GroupedPerformance(
        label: e.key,
        count: e.value.length,
        totalPnL: pnl,
        wins: wins,
        grossProfit: gp,
        grossLoss: gl,
        avgEntryScore: e.value.isEmpty ? 0 : avgScore / e.value.length,
      );
    }).toList();

    // Sort by Total PnL descending
    groups.sort((a, b) => b.totalPnL.compareTo(a.totalPnL));
    return groups;
  }

  List<TopCombination> _buildCombinations(List<TradeRecord> trades) {
    // We group by a composite key
    final groups = _groupTrades(trades, (t) {
      final setKey = _getSettingsLabel(t);
      final marKey = _getMarketLabel(t);
      return "$setKey===$marKey";
    });

    // Filter < 2 and sort by Profit Factor
    final valid = groups.where((g) => g.count >= 2).toList();
    valid.sort((a, b) => b.profitFactor.compareTo(a.profitFactor));

    return valid.map((g) {
      final parts = g.label.split('===');
      return TopCombination(
        settings: parts[0],
        market: parts.length > 1 ? parts[1] : "-",
        performance: g,
      );
    }).toList();
  }

  String _getSettingsLabel(TradeRecord t) {
    final snap = t.aiAnalysisSnapshot;
    int strat = snap['entryStrategy'] ?? 0;
    String sName =
        strat == 0 ? "Market" : (strat == 1 ? "Pullback" : "Breakout");
    int sm = snap['stopMethod'] ?? 2;
    String slName = sm == 0 ? "Donchian" : (sm == 1 ? "Percent" : "ATR");
    int tm = snap['tpMethod'] ?? 0;
    String tpName = tm == 0 ? "RR" : (tm == 1 ? "Percent" : "ATR");
    return "$sName | SL:$slName | TP:$tpName";
  }

  String _getMarketLabel(TradeRecord t) {
    final snap = t.aiAnalysisSnapshot;
    double rsi = (snap['rsi'] as num?)?.toDouble() ?? 50.0;
    double adx = (snap['adx'] as num?)?.toDouble() ?? 0.0;
    bool squeeze = snap['squeeze'] ?? false;

    String rsiStr = rsi > 70 ? "OB" : (rsi < 30 ? "OS" : "Neutral");
    String trStr = adx > 25 ? "Trend" : "NoTrend";
    return "RSI:$rsiStr | $trStr ${squeeze ? '| Squeeze' : ''}";
  }
}
