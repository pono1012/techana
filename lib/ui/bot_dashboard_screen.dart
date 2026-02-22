import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/portfolio_service.dart';
import '../services/bot_settings_service.dart';
import '../services/watchlist_service.dart';
import '../services/trade_execution_service.dart';
import '../models/trade_record.dart';
import 'trade_details_screen.dart';
import 'bot_settings_screen.dart';
import 'analysis_stats_screen.dart';

import 'top_movers_screen.dart';

class BotDashboardScreen extends StatefulWidget {
  const BotDashboardScreen({super.key});

  @override
  State<BotDashboardScreen> createState() => _BotDashboardScreenState();
}

class _BotDashboardScreenState extends State<BotDashboardScreen> {
  // Filter für die "Alle Positionen" Liste (Legacy)
  String _filter =
      "Alle"; // Alle, Offen, Offen +, Offen -, Pending, Geschlossen, Geschlossen +, Geschlossen -

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bot Dashboard", style: TextStyle(fontSize: 16)),
        actions: [
          Consumer4<PortfolioService, BotSettingsService, TradeExecutionService,
                  WatchlistService>(
              builder: (context, portfolio, settings, exec, watchlist, _) {
            return IconButton(
              icon: exec.isScanning
                  ? const Icon(Icons.pause_circle_filled, color: Colors.orange)
                  : const Icon(Icons.play_arrow),
              onPressed: () {
                if (exec.isScanning) {
                  exec.cancelRoutine();
                } else {
                  exec.runDailyRoutine(settings, portfolio, watchlist);
                }
              },
              tooltip:
                  exec.isScanning ? "Scan abbrechen" : "Scan jetzt starten",
            );
          }),
          IconButton(
            icon: const Icon(Icons.trending_up),
            tooltip: "Top Movers Scan",
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const TopMoversScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Bot Einstellungen",
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => BotSettingsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: "Watchlist bearbeiten",
            onPressed: () => _showWatchlistDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: "Portfolio Reset",
            onPressed: () => _confirmReset(context),
          ),
        ],
      ),
      body: Consumer4<PortfolioService, BotSettingsService,
          TradeExecutionService, WatchlistService>(
        builder: (context, portfolio, settings, exec, watchlist, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- 0. Smart Progress Bar (Top) ---
                  if (exec.isScanning) _buildSmartProgressBar(exec),

                  // --- 1. Portfolio Value Graph ---
                  _buildPortfolioGraphCard(portfolio),

                  const SizedBox(height: 12),

                  // --- 2. Summary Stats Cards ---
                  _buildSummaryStats(portfolio),

                  const SizedBox(height: 16),

                  // --- 3. AutoBot Analyse Button ---
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AnalysisStatsScreen())),
                    icon: const Icon(Icons.analytics),
                    label: const Text("Detaillierte Bot Analyse öffnen"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- 4. Scanner Status Bar (Legacy / Bottom - removed or kept minimal?) ---
                  // User wanted "ganz oben", so we hide this simple one if we use the top one.
                  // allowing it to show ONLY if NOT scanning (which it never does) OR just removing it.
                  // Removing, as the top bar replaces it.

                  const SizedBox(height: 16),
                  const Text("Positionen nach Kategorie",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),

                  // --- 5. Categorized Lists ---
                  ..._buildCategorizedLists(portfolio, watchlist),

                  const SizedBox(height: 16),

                  // --- 6. All Positions (Expandable) ---
                  ExpansionTile(
                    title: const Text("Alle Positionen (Rohdaten)",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${portfolio.trades.length} Trades gesamt"),
                    initiallyExpanded: false,
                    children: [
                      // Filter Bar inside
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            _buildFilterChip("Alle"),
                            _buildFilterChip("Offen"),
                            _buildFilterChip("Offen +"),
                            _buildFilterChip("Offen -"),
                            _buildFilterChip("Pending"),
                            _buildFilterChip("Geschlossen"),
                            _buildFilterChip("Geschlossen +"),
                            _buildFilterChip("Geschlossen -"),
                          ],
                        ),
                      ),
                      const Divider(),
                      // List items
                      if (portfolio.trades.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Keine Trades vorhanden."),
                        )
                      else
                        ...portfolio.trades.reversed.map((trade) {
                          // Apply Filter
                          if (_filter == "Offen" &&
                              trade.status != TradeStatus.open)
                            return const SizedBox.shrink();
                          if (_filter == "Offen +" &&
                              (trade.status != TradeStatus.open ||
                                  trade.calcUnrealizedPnL(trade.lastPrice ??
                                          trade.entryPrice) <=
                                      0)) return const SizedBox.shrink();
                          if (_filter == "Offen -" &&
                              (trade.status != TradeStatus.open ||
                                  trade.calcUnrealizedPnL(trade.lastPrice ??
                                          trade.entryPrice) >=
                                      0)) return const SizedBox.shrink();
                          if (_filter == "Pending" &&
                              trade.status != TradeStatus.pending)
                            return const SizedBox.shrink();
                          if (_filter == "Geschlossen" &&
                              (trade.status == TradeStatus.open ||
                                  trade.status == TradeStatus.pending))
                            return const SizedBox.shrink();
                          if (_filter == "Geschlossen +") {
                            if (trade.status == TradeStatus.open ||
                                trade.status == TradeStatus.pending ||
                                trade.realizedPnL <= 0)
                              return const SizedBox.shrink();
                          }
                          if (_filter == "Geschlossen -") {
                            if (trade.status == TradeStatus.open ||
                                trade.status == TradeStatus.pending ||
                                trade.realizedPnL >= 0)
                              return const SizedBox.shrink();
                          }
                          return _buildTradeCard(context, trade, portfolio);
                        }).toList(),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSmartProgressBar(TradeExecutionService exec) {
    // Phase Logic & Progress Calculation
    double progress = 0.0;
    String phaseName = "";
    String timeEstimate = "";

    // Always calculate progress from current/total
    if (exec.scanTotal > 0) {
      progress = exec.scanCurrent / exec.scanTotal;
    }

    if (exec.taskPhase == 1) {
      phaseName = "Check Pending";
    } else if (exec.taskPhase == 2) {
      phaseName = "Check Open";
    } else if (exec.taskPhase == 3) {
      phaseName = "Markt Scan";
    }

    // Globale Zeitschätzung (ETA) unabhängig von Phase anzeigen
    timeEstimate = exec.estimatedTimeRemaining;

    // Safety clamp
    if (progress > 1.0) progress = 1.0;
    String percentText = "${(progress * 100).toInt()}%";

    return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: const Offset(0, 2))
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Phase ${exec.taskPhase}/3: $phaseName",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text(percentText,
                    style: const TextStyle(
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white10,
              color: exec.taskPhase == 3 ? Colors.blueAccent : Colors.blueGrey,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(exec.scanStatus,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                        overflow: TextOverflow.ellipsis)),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        color: Colors.white54, size: 14),
                    const SizedBox(width: 4),
                    Text(timeEstimate.isNotEmpty ? "Est: $timeEstimate" : "",
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12)),
                  ],
                )
              ],
            ),
            if (exec.taskPhase == 3)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text("${exec.scanCurrent} / ${exec.scanTotal} Items",
                        style: const TextStyle(
                            color: Colors.white30, fontSize: 10))),
              )
          ],
        ));
  }

  // --- Graph Section ---
  Widget _buildPortfolioGraphCard(PortfolioService bot) {
    final history = bot.history;

    // Create spots, ensuring chronological order
    List<FlSpot> spots = [];

    if (history.isEmpty) {
      // Fallback: Start at 0, Now at Current PnL
      spots.add(const FlSpot(0, 0));
      // Simple 1-point graph not ideal, maybe show "No History" text overlay
    } else {
      // Normalize time slices for graph (0 to N)
      // We really want to see the progression.
      for (int i = 0; i < history.length; i++) {
        // Plot Equity (Unrealized + Realized) or just PnL?
        // Request said "Wert des Portfolios ... unreal und realisiert verrechnet".
        // Since we track virtualBalance but it resets, better track Total PnL (Real + Unreal)
        double yVal = history[i].realizedPnL + history[i].unrealizedPnL;
        spots.add(FlSpot(i.toDouble(), yVal));
      }
    }

    // Add CURRENT state as last point if history > 0
    if (history.isNotEmpty) {
      double currentTotalPnL = bot.totalRealizedPnL + bot.totalUnrealizedPnL;
      spots.add(FlSpot(history.length.toDouble(), currentTotalPnL));
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Portfolio Performance (PnL)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
                "Aktuell: ${(bot.totalRealizedPnL + bot.totalUnrealizedPnL).toStringAsFixed(2)} €",
                style: TextStyle(
                    color: (bot.totalRealizedPnL + bot.totalUnrealizedPnL) >= 0
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                    gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          if (value == 0)
                            return FlLine(
                                color: Colors.white54, strokeWidth: 1);
                          return FlLine(color: Colors.white10, strokeWidth: 1);
                        }),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles:
                                  false)), // No timestamps for simplicity
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (val, meta) => Text(
                            val.toInt().toString(),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey)),
                      )),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: Colors.blueAccent,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blueAccent.withOpacity(0.1)),
                      ),
                    ],
                    lineTouchData:
                        LineTouchData(touchTooltipData: LineTouchTooltipData(
                            // color: Colors.blueGrey, // Use defaults or customize if needed
                            getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem("${spot.y.toStringAsFixed(2)} €",
                            const TextStyle(color: Colors.white));
                      }).toList();
                    }))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStats(PortfolioService bot) {
    // Combined Stats
    final totalPos = bot.openTradesPositive + bot.closedTradesPositive;
    final totalNeg = bot.openTradesNegative + bot.closedTradesNegative;
    final totalCount = bot.openTradesCount + bot.closedTradesCount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Row 1: Money
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCol(
                    "Investiert",
                    "${bot.totalInvested.toStringAsFixed(2)} €",
                    Colors.white70),
                _buildStatCol(
                    "Unreal. PnL",
                    "${bot.totalUnrealizedPnL.toStringAsFixed(2)} €",
                    bot.totalUnrealizedPnL >= 0 ? Colors.green : Colors.red),
                _buildStatCol(
                    "Realisiert PnL",
                    "${bot.totalRealizedPnL.toStringAsFixed(2)} €",
                    bot.totalRealizedPnL >= 0 ? Colors.green : Colors.red),
              ],
            ),
            const Divider(height: 24),
            // Row 2: Trade Counts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Open Splits
                Column(
                  children: [
                    const Text("Offen",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text("${bot.openTradesPositive}",
                            style: const TextStyle(color: Colors.green)),
                        const Text(" / ", style: TextStyle(color: Colors.grey)),
                        Text("${bot.openTradesNegative}",
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                    Text("Gesamt: ${bot.openTradesCount}",
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),

                Container(height: 30, width: 1, color: Colors.white10),

                // Closed Splits
                Column(
                  children: [
                    const Text("Geschlossen",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text("${bot.closedTradesPositive}",
                            style: const TextStyle(color: Colors.green)),
                        const Text(" / ", style: TextStyle(color: Colors.grey)),
                        Text("${bot.closedTradesNegative}",
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                    Text("Gesamt: ${bot.closedTradesCount}",
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),

                Container(height: 30, width: 1, color: Colors.white10),

                // Total Splits (NEW)
                Column(
                  children: [
                    const Text("Gesamt",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text("$totalPos",
                            style: const TextStyle(color: Colors.green)),
                        const Text(" / ", style: TextStyle(color: Colors.grey)),
                        Text("$totalNeg",
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                    Text("Trades: $totalCount",
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  List<Widget> _buildCategorizedLists(
      PortfolioService portfolio, WatchlistService watchlist) {
    // 1. Map defaults
    final categories = watchlist.defaultWatchlistByCategory;

    // 2. Identify trades that belong to categories
    Map<String, List<TradeRecord>> groupedTrades = {};
    List<TradeRecord> otherTrades = [];

    // Init keys
    for (var key in categories.keys) {
      groupedTrades[key] = [];
    }

    for (var trade in portfolio.trades) {
      bool found = false;
      for (var entry in categories.entries) {
        // Check if symbol is in this list
        if (entry.value.contains(trade.symbol)) {
          groupedTrades[entry.key]!.add(trade);
          found = true;
          break;
        }
      }
      if (!found) {
        otherTrades.add(trade);
      }
    }

    // 3. Build Widgets
    List<Widget> widgets = [];

    // Sort logic? Show active categories first?
    groupedTrades.forEach((category, trades) {
      if (trades.isNotEmpty) {
        // Only show categories with activity? Or all? User said "diese kann man aufklappen"
        widgets.add(_buildCategoryTile(context, category, trades, portfolio));
      }
    });

    if (otherTrades.isNotEmpty) {
      widgets
          .add(_buildCategoryTile(context, "Sonstige", otherTrades, portfolio));
    }

    if (widgets.isEmpty) {
      return [
        const Center(
            child: Text("Keine kategorisierten Trades vorhanden.",
                style: TextStyle(color: Colors.grey)))
      ];
    }

    return widgets;
  }

  Widget _buildCategoryTile(BuildContext context, String title,
      List<TradeRecord> trades, PortfolioService bot) {
    // Calc Aggregates
    double invested = 0;
    double pnl = 0; // both real and unreal mixed? Or separate?
    // User said: "Eigene insgesamt +- € und%"
    // Let's sum Realized + Unrealized for the "Net Value" of this bucket

    for (var t in trades) {
      double unreal = (t.status == TradeStatus.open)
          ? t.calcUnrealizedPnL(t.lastPrice ?? t.entryPrice)
          : 0;
      pnl += t.realizedPnL + unreal;
      if (t.status == TradeStatus.open) {
        invested += t.entryPrice * t.quantity;
      }
    }

    // Percent... difficult for mixed Real/Unreal.
    // Maybe simple sum of %? or Weighted?
    // Lets stick to absolute sum for header or implied ROI based on Invested (which is tricky if closed trades involved)
    // Just show Absolute PnL.

    final color = pnl >= 0 ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ExpansionTile(
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Row(
          children: [
            Text("${trades.length} Pos.",
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(width: 8),
            // Text("Invest: ${invested.toStringAsFixed(0)}€", style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        trailing: SizedBox(
          width: 100,
          child: Text("${pnl > 0 ? '+' : ''}${pnl.toStringAsFixed(2)} €",
              textAlign: TextAlign.end,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ),
        children: trades.reversed
            .map((t) => _buildTradeCard(context, t, bot))
            .toList(),
      ),
    );
  }

  // Reuse existing card logic with minor tweaks
  Widget _buildTradeCard(
      BuildContext context, TradeRecord trade, PortfolioService bot) {
    final isOpen = trade.status == TradeStatus.open;
    final isPending = trade.status == TradeStatus.pending;
    final color = isPending
        ? Colors.orange
        : (isOpen
            ? Colors.blue
            : (trade.realizedPnL >= 0 ? Colors.green : Colors.red));

    String statusText = isOpen ? "OPEN" : "CLOSED";
    if (trade.tp1Hit && isOpen) {
      statusText = "OPEN (TP1 Hit)";
    } else if (isPending) {
      // Prüfen ob Stop (Breakout) oder Limit (Pullback/Market)
      bool isStop = trade.entryReasons.contains("Breakout");
      if (trade.aiAnalysisSnapshot.containsKey('entryStrategy')) {
        if (trade.aiAnalysisSnapshot['entryStrategy'] == 2) isStop = true;
      }
      statusText = isStop ? "PENDING (Stop)" : "PENDING (Limit)";
    }

    return Dismissible(
      key: Key(trade.id),
      direction: DismissDirection.endToStart,
      background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white)),
      onDismissed: (_) => bot.deleteTrade(trade.id),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => TradeDetailsScreen(trade: trade))),
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: color.withOpacity(0.2),
            child: Text(trade.symbol.substring(0, min(2, trade.symbol.length)),
                style: TextStyle(
                    color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(trade.symbol,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              Text(statusText,
                  style: TextStyle(
                      fontSize: 9,
                      color: isPending
                          ? Colors.orange
                          : (isOpen ? Colors.blue : Colors.grey))),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Entry: ${trade.entryPrice.toStringAsFixed(2)} | Score: ${trade.entryScore}",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              if (trade.entryPattern.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: _buildPatternChip(trade.entryPattern),
                ),
            ],
          ),
          trailing: _buildTradeTrailing(trade, isOpen, isPending),
        ),
      ),
    );
  }

  /// Kleiner farbiger Chip für das Kerzenmuster
  Widget _buildPatternChip(String pattern) {
    // Bestimme ob bullish oder bearish anhand des Namens
    final bullishKeywords = [
      'Bullish',
      'Hammer',
      'Morning',
      'Soldier',
      'Piercing',
      'Doji'
    ];
    final isBullish = bullishKeywords.any((kw) => pattern.contains(kw));
    final chipColor = isBullish ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: chipColor.withOpacity(0.4), width: 0.5),
      ),
      child: Text(
        pattern,
        style: TextStyle(
            fontSize: 9, color: chipColor, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTradeTrailing(TradeRecord trade, bool isOpen, bool isPending) {
    if (!isOpen && !isPending) {
      final pnl = trade.realizedPnL;
      final pnlColor = pnl >= 0 ? Colors.green : Colors.red;
      // Prozent berechnen (basierend auf Entry/Exit Preisen)
      double pct = 0.0;
      if (trade.exitPrice != null && trade.entryPrice != 0) {
        bool isLong = trade.takeProfit1 > trade.entryPrice; // simple assumption
        // Better reuse isLong logic from Service but here we rely on basic maths
        if (isLong) {
          pct =
              ((trade.exitPrice! - trade.entryPrice) / trade.entryPrice) * 100;
        } else {
          pct =
              ((trade.entryPrice - trade.exitPrice!) / trade.entryPrice) * 100;
        }
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("${pnl > 0 ? '+' : ''}${pnl.toStringAsFixed(2)} €",
              style: TextStyle(
                  color: pnlColor, fontWeight: FontWeight.bold, fontSize: 12)),
          Text("${pct > 0 ? '+' : ''}${pct.toStringAsFixed(1)} %",
              style: TextStyle(color: pnlColor, fontSize: 10)),
        ],
      );
    }

    if (isOpen || isPending) {
      // Live PnL
      final currentPrice = trade.lastPrice ?? trade.entryPrice;
      final pnl = trade.calcUnrealizedPnL(currentPrice);
      final pct = trade.calcUnrealizedPercent(currentPrice);
      final pnlColor = pnl >= 0 ? Colors.green : Colors.red;

      if (isPending) {
        return const Text("-", style: TextStyle(color: Colors.grey));
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (trade.realizedPnL.abs() > 0.01)
            Text("Real: ${trade.realizedPnL.toStringAsFixed(0)}",
                style: const TextStyle(fontSize: 8, color: Colors.grey)),
          Text("${pnl > 0 ? '+' : ''}${pnl.toStringAsFixed(2)} €",
              style: TextStyle(
                  color: pnlColor, fontWeight: FontWeight.bold, fontSize: 12)),
          Text("${pct > 0 ? '+' : ''}${pct.toStringAsFixed(1)} %",
              style: TextStyle(color: pnlColor, fontSize: 10)),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        selected: _filter == label,
        onSelected: (v) => setState(() => _filter = label),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Portfolio zurücksetzen?"),
        content: const Text(
            "Dies löscht ALLE Trades und setzt das investierte Kapital auf 0 zurück. Bist du sicher?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Abbrechen")),
          TextButton(
            onPressed: () {
              context.read<PortfolioService>().resetPortfolio();
              Navigator.pop(ctx);
            },
            child: const Text("Alles Löschen",
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showWatchlistDialog(BuildContext context) {
    final watchlist = context.read<WatchlistService>();
    final textCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Bot Watchlist"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Add New
                    Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: textCtrl,
                          decoration: const InputDecoration(
                              hintText: "Symbol (z.B. BTC-USD)"),
                          onSubmitted: (val) {
                            if (val.isNotEmpty) {
                              watchlist.addWatchlistSymbol(val);
                              textCtrl.clear();
                              setState(() {});
                            }
                          },
                        )),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (textCtrl.text.isNotEmpty) {
                              watchlist.addWatchlistSymbol(textCtrl.text);
                              textCtrl.clear();
                              setState(() {});
                            }
                          },
                        )
                      ],
                    ),
                    const Divider(),
                    // Kategorisierte Liste
                    Expanded(
                      child: Consumer<WatchlistService>(
                        builder: (context, watchlist, _) {
                          final categories =
                              watchlist.defaultWatchlistByCategory;
                          return ListView(
                            children: categories.entries.map((categoryEntry) {
                              final categorySymbols = categoryEntry.value;

                              return ExpansionTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(categoryEntry.key,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        for (final symbol in categorySymbols) {
                                          watchlist.toggleWatchlistSymbol(
                                              symbol, true);
                                        }
                                        setState(() {});
                                      },
                                      child: const Text("Alle",
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        for (final symbol in categorySymbols) {
                                          watchlist.toggleWatchlistSymbol(
                                              symbol, false);
                                        }
                                        setState(() {});
                                      },
                                      child: const Text("Keine",
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                                // Initially open only active or common ones
                                initiallyExpanded: [
                                  "Germany (DAX & MDAX)",
                                  "Crypto"
                                ].contains(categoryEntry.key),
                                children: categoryEntry.value.map((symbol) {
                                  return CheckboxListTile(
                                    dense: true,
                                    title: Text(symbol),
                                    value:
                                        watchlist.watchListMap[symbol] ?? false,
                                    secondary: IconButton(
                                      icon: const Icon(Icons.delete,
                                          size: 20, color: Colors.grey),
                                      onPressed: () => watchlist
                                          .removeWatchlistSymbol(symbol),
                                    ),
                                    onChanged: (val) =>
                                        watchlist.toggleWatchlistSymbol(
                                            symbol, val ?? false),
                                  );
                                }).toList(),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Fertig")),
          ],
        );
      },
    );
  }
}
