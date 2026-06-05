import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../services/portfolio_service.dart';
import '../services/bot_settings_service.dart';
import '../services/watchlist_service.dart';
import '../services/trade_execution_service.dart';
import '../models/trade_record.dart';
import 'bot_settings_screen.dart';
import 'analysis_stats_screen.dart';

import 'top_movers_screen.dart';
import 'bot_dashboard_widgets.dart';
import '../l10n/l10n_extension.dart';

class BotDashboardScreen extends StatefulWidget {
  const BotDashboardScreen({super.key});

  @override
  State<BotDashboardScreen> createState() => _BotDashboardScreenState();
}

class _BotDashboardScreenState extends State<BotDashboardScreen> {
  String _filter = "all";

  @override
  Widget build(BuildContext context) {
    return Consumer4<PortfolioService, BotSettingsService, TradeExecutionService, WatchlistService>(
      builder: (context, portfolio, settings, exec, watchlist, child) {
        return Scaffold(
          backgroundColor: Colors.transparent, // Background is handled by DashboardScreen Stack
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "AutoTrade",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            actions: [
              IconButton(
                icon: exec.isScanning
                    ? const Icon(Icons.stop_circle, color: Colors.redAccent, size: 30)
                    : const Icon(Icons.play_circle_fill, color: Colors.greenAccent, size: 30),
                onPressed: () {
                  if (exec.isScanning) {
                    exec.cancelRoutine();
                  } else {
                    exec.runDailyRoutine(settings, portfolio, watchlist);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BotSettingsScreen())),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // HERO SECTION: Huge PnL Display
                  _buildHeroPnL(context, portfolio),
                  const SizedBox(height: 30),

                  // LIVE SCANNER HUD
                  if (exec.isScanning || exec.liveScanRecommendations.isNotEmpty)
                    BotLiveScannerWidget(exec: exec),
                  
                  const SizedBox(height: 30),

                  // STATS GRID (Glassmorphism)
                  _buildStatsGrid(context, portfolio),

                  const SizedBox(height: 30),

                  // ACTIVE TRADES SECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Offene Positionen",
                        style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => _confirmReset(context),
                        child: const Text("Reset", style: TextStyle(color: Colors.redAccent)),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...portfolio.trades
                      .where((t) => t.status == TradeStatus.open || t.status == TradeStatus.pending)
                      .map((t) => _buildModernTradeCard(context, t, portfolio)),

                  if (portfolio.trades.where((t) => t.status == TradeStatus.open || t.status == TradeStatus.pending).isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text("Keine aktiven Trades", style: TextStyle(color: Colors.white54)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroPnL(BuildContext context, PortfolioService portfolio) {
    final totalPnL = portfolio.totalRealizedPnL + portfolio.totalUnrealizedPnL;
    final isPositive = totalPnL >= 0;
    
    return Column(
      children: [
        Text(
          "TOTAL P&L",
          style: TextStyle(
            color: Colors.white54,
            letterSpacing: 2,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.currencyValue(totalPnL.toStringAsFixed(2)),
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 56,
            fontWeight: FontWeight.w900,
            color: isPositive ? Colors.greenAccent : Colors.redAccent,
            shadows: [
              Shadow(
                color: (isPositive ? Colors.greenAccent : Colors.redAccent).withOpacity(0.5),
                blurRadius: 20,
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Text(
            "Investiert: ${context.l10n.currencyValue(portfolio.totalInvested.toStringAsFixed(2))}",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, PortfolioService portfolio) {
    return Row(
      children: [
        Expanded(child: _buildGlassStatCard(context, "Win Rate", "${_calcWinRate(portfolio)}%", Icons.pie_chart)),
        const SizedBox(width: 16),
        Expanded(child: _buildGlassStatCard(context, "Trades", "${portfolio.closedTradesCount}", Icons.history)),
      ],
    );
  }
  
  String _calcWinRate(PortfolioService p) {
    if (p.closedTradesCount == 0) return "0";
    return ((p.closedTradesPositive / p.closedTradesCount) * 100).toStringAsFixed(1);
  }

  Widget _buildGlassStatCard(BuildContext context, String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white54, size: 20),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontFamily: 'Outfit', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(title, style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildModernTradeCard(BuildContext context, TradeRecord trade, PortfolioService portfolio) {
    final isOpen = trade.status == TradeStatus.open;
    final color = isOpen ? Colors.blueAccent : Colors.orangeAccent;
    final currentPrice = trade.lastPrice ?? trade.entryPrice;
    final pnl = trade.calcUnrealizedPnL(currentPrice);
    final pnlColor = pnl >= 0 ? Colors.greenAccent : Colors.redAccent;

    return Dismissible(
      key: Key(trade.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => portfolio.deleteTrade(trade.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Text(
                      trade.symbol.substring(0, min(2, trade.symbol.length)),
                      style: TextStyle(color: color, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trade.symbol, style: TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(isOpen ? "OPEN" : "PENDING", style: TextStyle(color: color, fontSize: 10, letterSpacing: 1)),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  context.l10n.currencyValue(pnl.toStringAsFixed(2)),
                  style: TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.bold, color: pnlColor),
                ),
                Text(
                  "Entry: ${trade.entryPrice.toStringAsFixed(2)}",
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Portfolio zurücksetzen"),
        content: const Text("Möchten Sie wirklich alle Trades und Statistiken löschen?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Abbrechen")),
          TextButton(
            onPressed: () {
              context.read<PortfolioService>().resetPortfolio();
              Navigator.pop(ctx);
            },
            child: const Text("Reset", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showWatchlistDialog(BuildContext context) {
    // Legacy dialog, keeping it simple
  }
}