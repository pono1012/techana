import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import '../models/trade_record.dart';
import '../services/portfolio_service.dart';
import '../services/trade_execution_service.dart';
import 'trade_details_screen.dart';

class BotProgressWidget extends StatelessWidget {
  final TradeExecutionService exec;

  const BotProgressWidget({super.key, required this.exec});

  @override
  Widget build(BuildContext context) {
    double progress = 0.0;
    String phaseName = "";
    String timeEstimate = "";

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

    timeEstimate = exec.estimatedTimeRemaining;

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
}

class BotPortfolioGraphWidget extends StatelessWidget {
  final PortfolioService bot;

  const BotPortfolioGraphWidget({super.key, required this.bot});

  @override
  Widget build(BuildContext context) {
    final history = bot.history;

    List<FlSpot> spots = [];

    if (history.isEmpty) {
      spots.add(const FlSpot(0, 0));
    } else {
      for (int i = 0; i < history.length; i++) {
        double yVal = history[i].realizedPnL + history[i].unrealizedPnL;
        spots.add(FlSpot(i.toDouble(), yVal));
      }
    }

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
                          if (value == 0) {
                            return FlLine(
                                color: Colors.white54, strokeWidth: 1);
                          }
                          return FlLine(color: Colors.white10, strokeWidth: 1);
                        }),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
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
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blueAccent.withOpacity(0.1)),
                      ),
                    ],
                    lineTouchData: LineTouchData(touchTooltipData:
                        LineTouchTooltipData(getTooltipItems: (touchedSpots) {
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
}

class BotSummaryStatsWidget extends StatelessWidget {
  final PortfolioService bot;

  const BotSummaryStatsWidget({super.key, required this.bot});

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

  @override
  Widget build(BuildContext context) {
    final totalPos = bot.openTradesPositive + bot.closedTradesPositive;
    final totalNeg = bot.openTradesNegative + bot.closedTradesNegative;
    final totalCount = bot.openTradesCount + bot.closedTradesCount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
}

class TradeCardWidget extends StatelessWidget {
  final TradeRecord trade;
  final PortfolioService portfolio;

  const TradeCardWidget({
    super.key,
    required this.trade,
    required this.portfolio,
  });

  Widget _buildPatternChip(String pattern) {
    if (pattern.isEmpty || pattern == 'Kein Muster')
      return const SizedBox.shrink();
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

  Widget _buildMtcBadge(bool confirmed) {
    if (!confirmed) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.cyanAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border:
            Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 0.5),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, color: Colors.cyanAccent, size: 8),
          SizedBox(width: 2),
          Text("MTC",
              style: TextStyle(
                  fontSize: 8,
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildOptimizerBadge(bool exists) {
    if (!exists) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.amberAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border:
            Border.all(color: Colors.amberAccent.withOpacity(0.5), width: 0.5),
      ),
      child: const Text("OPT",
          style: TextStyle(
              fontSize: 8,
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTradeTrailing(TradeRecord trade, bool isOpen, bool isPending) {
    if (!isOpen && !isPending) {
      final pnl = trade.realizedPnL;
      final pnlColor = pnl >= 0 ? Colors.green : Colors.red;
      double pct = 0.0;
      if (trade.exitPrice != null && trade.entryPrice != 0) {
        bool isLong = trade.takeProfit1 > trade.entryPrice;
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

  @override
  Widget build(BuildContext context) {
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
      onDismissed: (_) => portfolio.deleteTrade(trade.id),
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
              Row(
                children: [
                  Text(trade.symbol,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                  _buildMtcBadge(
                      trade.aiAnalysisSnapshot['mtc_confirmed'] == true),
                  _buildOptimizerBadge(
                      trade.aiAnalysisSnapshot['optimized_params'] != null),
                ],
              ),
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
}
