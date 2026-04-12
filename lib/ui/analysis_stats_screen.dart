import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/models.dart';
import '../models/trade_record.dart';
import '../services/portfolio_service.dart';
import '../services/bot_analytics_service.dart';

class AnalysisStatsScreen extends StatefulWidget {
  const AnalysisStatsScreen({super.key});

  @override
  State<AnalysisStatsScreen> createState() => _AnalysisStatsScreenState();
}

class _AnalysisStatsScreenState extends State<AnalysisStatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BotAnalyticsService _analyticsService = BotAnalyticsService();
  TimeFilter _selectedFilter = TimeFilter.allTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bot = context.watch<PortfolioService>();
    final closedTrades = bot.trades
        .where((t) =>
            t.status == TradeStatus.takeProfit ||
            t.status == TradeStatus.stoppedOut ||
            t.status == TradeStatus.closed ||
            t.realizedPnL != 0)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Deep Dive Analyse"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<TimeFilter>(
                value: _selectedFilter,
                icon: const Icon(Icons.filter_list, color: Colors.white),
                dropdownColor: Theme.of(context).cardColor,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                items: const [
                  DropdownMenuItem(
                      value: TimeFilter.allTime, child: Text("All Time")),
                  DropdownMenuItem(
                      value: TimeFilter.last30Days, child: Text("30 Tage")),
                  DropdownMenuItem(
                      value: TimeFilter.last7Days, child: Text("7 Tage")),
                  DropdownMenuItem(
                      value: TimeFilter.yearToDate, child: Text("YTD")),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedFilter = val;
                    });
                  }
                },
              ),
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Übersicht"),
            Tab(text: "Details"),
            Tab(text: "Top Kombis"),
          ],
        ),
      ),
      body: closedTrades.isEmpty
          ? _buildEmptyState()
          : _buildDashboard(closedTrades),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text("Noch keine geschlossenen Trades für eine Analyse vorhanden."),
          SizedBox(height: 8),
          Text(
            "Warte auf erste Bot-Aktivitäten.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(List<TradeRecord> trades) {
    final stats = _analyticsService.calculateAnalytics(
        closedTrades: trades, timeFilter: _selectedFilter);

    if (stats.totalTrades == 0) {
      return const Center(
        child: Text("Keine Trades in diesem Zeitraum gefunden.",
            style: TextStyle(color: Colors.grey)),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildOverviewTab(stats),
        _buildDetailsTab(stats),
        _buildCombinationsTab(stats),
      ],
    );
  }

  // --- TAB 1: OVERVIEW ---
  Widget _buildOverviewTab(BotAnalyticsSummary stats) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildKpiGrid(stats),
        const SizedBox(height: 24),
        const Text("Equity Kurve (Kapitalverlauf)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildEquityCurve(stats),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildStreakCard(stats)),
            const SizedBox(width: 16),
            Expanded(child: _buildWinLossCard(stats)),
          ],
        ),
        const SizedBox(height: 24),
        const Text("Top / Flop Assets",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildSymbolPerformance(stats),
      ],
    );
  }

  Widget _buildKpiGrid(BotAnalyticsSummary stats) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _kpiBox(
          "Net PnL",
          "${stats.totalPnL >= 0 ? '+' : ''}${stats.totalPnL.toStringAsFixed(2)}€",
          color: stats.totalPnL >= 0 ? Colors.green : Colors.red,
        ),
        _kpiBox(
          "Profit Factor",
          stats.profitFactor == double.infinity
              ? "∞"
              : stats.profitFactor.toStringAsFixed(2),
          color: stats.profitFactor > 1.0 ? Colors.green : Colors.orange,
        ),
        _kpiBox(
          "Erwartungswert (EV)",
          "${stats.expectancy >= 0 ? '+' : ''}${stats.expectancy.toStringAsFixed(2)}€/Trade",
          color: stats.expectancy > 0 ? Colors.green : Colors.red,
        ),
        _kpiBox(
          "Max Drawdown",
          "${stats.maxDrawdown.toStringAsFixed(2)}€",
          color: Colors.redAccent,
        ),
      ],
    );
  }

  Widget _kpiBox(String title, String value, {Color color = Colors.white}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquityCurve(BotAnalyticsSummary stats) {
    if (stats.equityCurve.isEmpty) return const SizedBox.shrink();

    final List<FlSpot> spots = [];
    double minX = 0;
    double maxX = stats.equityCurve.length.toDouble() - 1;
    double minY = 0.0; // Base Start
    double maxY = 0.0;

    for (int i = 0; i < stats.equityCurve.length; i++) {
      final point = stats.equityCurve[i];
      spots.add(FlSpot(i.toDouble(), point.equity));
      if (point.equity < minY) minY = point.equity;
      if (point.equity > maxY) maxY = point.equity;
    }

    // Add padding to Y axis
    final yRange = maxY - minY;
    maxY += yRange * 0.1;
    minY -= yRange * 0.1;
    if (maxY == minY) {
      maxY += 1;
      minY -= 1;
    }

    final isPositive = stats.totalPnL >= 0;
    final lineColor = isPositive ? Colors.greenAccent : Colors.redAccent;
    final gradColors = isPositive
        ? [
            Colors.greenAccent.withOpacity(0.3),
            Colors.greenAccent.withOpacity(0.0)
          ]
        : [
            Colors.redAccent.withOpacity(0.3),
            Colors.redAccent.withOpacity(0.0)
          ];

    return AspectRatio(
      aspectRatio: 1.7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: Theme.of(context).cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              right: 18.0, left: 12.0, top: 24, bottom: 12),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _getInterval(minY, maxY),
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.white10,
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: _getInterval(minY, maxY),
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: lineColor,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: gradColors,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getInterval(double min, double max) {
    double diff = max - min;
    if (diff <= 10) return 2;
    if (diff <= 50) return 10;
    if (diff <= 100) return 20;
    return 50;
  }

  Widget _buildStreakCard(BotAnalyticsSummary stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Streaks & Dauer",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          _rowItem(
              "Max Winning Streak", "${stats.maxWinningStreak}", Colors.green),
          _rowItem("Max Losing Streak", "${stats.maxLosingStreak}", Colors.red),
          _rowItem("Ø Hold Time", "${stats.averageTradeDuration.inHours}h",
              Colors.blue),
        ],
      ),
    );
  }

  Widget _buildWinLossCard(BotAnalyticsSummary stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Win / Loss Profile",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          _rowItem(
              "Win Rate", "${stats.winRate.toStringAsFixed(1)}%", Colors.blue),
          _rowItem("Ø Winner", "+${stats.averageWin.toStringAsFixed(2)}€",
              Colors.green),
          _rowItem("Ø Loser", "-${stats.averageLoss.abs().toStringAsFixed(2)}€",
              Colors.red),
        ],
      ),
    );
  }

  Widget _rowItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13, color: color)),
        ],
      ),
    );
  }

  Widget _buildSymbolPerformance(BotAnalyticsSummary stats) {
    final topWinners =
        stats.bySymbol.where((s) => s.totalPnL > 0).take(5).toList();
    final topLosers =
        stats.bySymbol.where((s) => s.totalPnL < 0).take(5).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildSymbolList("Top Gewinner", topWinners, Colors.green),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSymbolList("Top Verlierer", topLosers, Colors.red),
        ),
      ],
    );
  }

  Widget _buildSymbolList(
      String title, List<GroupedPerformance> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const Text("Keine Daten", style: TextStyle(color: Colors.grey)),
        ...items.map((g) => Card(
              margin: const EdgeInsets.only(bottom: 6),
              elevation: 0,
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: color.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                title: Text(g.label,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    "${g.count} Trades | ${g.winRate.toStringAsFixed(0)}% WR",
                    style: const TextStyle(fontSize: 11)),
                trailing: Text(
                  "${g.totalPnL >= 0 ? '+' : ''}${g.totalPnL.toStringAsFixed(2)}€",
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
            )),
      ],
    );
  }

  // --- TAB 2: DETAILS ---
  Widget _buildDetailsTab(BotAnalyticsSummary stats) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildGroupedSection("Performance nach TimeFrame", stats.byTimeFrame),
        _buildGroupedSection(
            "Performance nach Strategie", stats.byEntryStrategy),
        _buildGroupedSection("Performance nach Stop-Loss", stats.bySlMethod),
        _buildGroupedSection("Performance nach Take-Profit", stats.byTpMethod),
      ],
    );
  }

  Widget _buildGroupedSection(String title, List<GroupedPerformance> groups) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...groups.map((g) => _buildStatRow(g)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStatRow(GroupedPerformance g) {
    final isWin = g.totalPnL >= 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(
            left:
                BorderSide(color: isWin ? Colors.green : Colors.red, width: 4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(g.label,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  "${g.count} Trades | WR: ${g.winRate.toStringAsFixed(0)}% | PF: ${g.profitFactor == double.infinity ? '∞' : g.profitFactor.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            "${isWin ? '+' : ''}${g.totalPnL.toStringAsFixed(2)}€",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isWin ? Colors.green : Colors.red),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: COMBINATIONS ---
  Widget _buildCombinationsTab(BotAnalyticsSummary stats) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: "LONG"),
              Tab(text: "SHORT"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildComboList(stats.topLongCombinations),
                _buildComboList(stats.topShortCombinations),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComboList(List<TopCombination> combos) {
    if (combos.isEmpty) {
      return const Center(child: Text("Zu wenig Daten für Kombinationen."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: combos.length,
      itemBuilder: (context, index) {
        final c = combos[index];
        final g = c.performance;
        final isWin = g.totalPnL >= 0;
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: isWin
                      ? Colors.green.withOpacity(0.5)
                      : Colors.red.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Kombination #${index + 1}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue)),
                    Text(
                      "${isWin ? '+' : ''}${g.totalPnL.toStringAsFixed(2)}€",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isWin ? Colors.green : Colors.red),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${g.count} Trades"),
                    Text("WR: ${g.winRate.toStringAsFixed(0)}%"),
                    Text(
                        "PF: ${g.profitFactor == double.infinity ? '∞' : g.profitFactor.toStringAsFixed(2)}"),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.tune, size: 14, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(c.settings,
                                  style: const TextStyle(fontSize: 12))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.insights,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(c.market,
                                  style: const TextStyle(fontSize: 12))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
