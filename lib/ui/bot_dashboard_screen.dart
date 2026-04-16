import 'package:flutter/material.dart';
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
  // Filter für die "Alle Positionen" Liste (Legacy)
  String _filter = "all";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.botDashboard, style: const TextStyle(fontSize: 16)),
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
                  exec.isScanning ? context.l10n.cancelScan : context.l10n.startScan,
            );
          }),
          IconButton(
            icon: const Icon(Icons.trending_up),
            tooltip: context.l10n.topMoversScan,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const TopMoversScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: context.l10n.botSettings,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => BotSettingsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: context.l10n.editWatchlist,
            onPressed: () => _showWatchlistDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: context.l10n.portfolioReset,
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
                  if (exec.isScanning) BotProgressWidget(exec: exec),

                  // --- 1. Portfolio Value Graph ---
                  BotPortfolioGraphWidget(bot: portfolio),

                  const SizedBox(height: 12),

                  // --- 2. Summary Stats Cards ---
                  BotSummaryStatsWidget(bot: portfolio),

                  const SizedBox(height: 16),

                  // --- 3. AutoBot Analyse Button ---
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AnalysisStatsScreen())),
                    icon: const Icon(Icons.analytics),
                    label: Text(context.l10n.openDetailedAnalysis),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- 4. Scanner Status Bar (Legacy / Bottom - removed or kept minimal?) ---

                  const SizedBox(height: 16),
                  Text(context.l10n.positionsByCategory,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),

                  // --- 5. Categorized Lists ---
                  ..._buildCategorizedLists(portfolio, watchlist),

                  const SizedBox(height: 16),

                  // --- 6. All Positions (Expandable) ---
                  ExpansionTile(
                    title: Text(context.l10n.allPositionsRaw,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(context.l10n.tradesTotal(portfolio.trades.length)),
                    initiallyExpanded: false,
                    children: [
                      // Filter Bar inside
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            _buildFilterChip(context.l10n.filterAll, "all"),
                            _buildFilterChip(context.l10n.filterOpen, "open"),
                            _buildFilterChip(context.l10n.filterOpenPositive, "openPos"),
                            _buildFilterChip(context.l10n.filterOpenNegative, "openNeg"),
                            _buildFilterChip(context.l10n.filterPending, "pending"),
                            _buildFilterChip(context.l10n.filterClosed, "closed"),
                            _buildFilterChip(context.l10n.filterClosedPositive, "closedPos"),
                            _buildFilterChip(context.l10n.filterClosedNegative, "closedNeg"),
                          ],
                        ),
                      ),
                      const Divider(),
                      // List items
                      if (portfolio.trades.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(context.l10n.noTrades),
                        )
                      else
                        ...portfolio.trades.reversed.map((trade) {
                          // Apply Filter
                          if (_filter == "open" &&
                              trade.status != TradeStatus.open)
                            return const SizedBox.shrink();
                          if (_filter == "openPos" &&
                              (trade.status != TradeStatus.open ||
                                  trade.calcUnrealizedPnL(trade.lastPrice ??
                                          trade.entryPrice) <=
                                      0)) return const SizedBox.shrink();
                          if (_filter == "openNeg" &&
                              (trade.status != TradeStatus.open ||
                                  trade.calcUnrealizedPnL(trade.lastPrice ??
                                          trade.entryPrice) >=
                                      0)) return const SizedBox.shrink();
                          if (_filter == "pending" &&
                              trade.status != TradeStatus.pending)
                            return const SizedBox.shrink();
                          if (_filter == "closed" &&
                              (trade.status == TradeStatus.open ||
                                  trade.status == TradeStatus.pending))
                            return const SizedBox.shrink();
                          if (_filter == "closedPos") {
                            if (trade.status == TradeStatus.open ||
                                trade.status == TradeStatus.pending ||
                                trade.realizedPnL <= 0)
                              return const SizedBox.shrink();
                          }
                          if (_filter == "closedNeg") {
                            if (trade.status == TradeStatus.open ||
                                trade.status == TradeStatus.pending ||
                                trade.realizedPnL >= 0)
                              return const SizedBox.shrink();
                          }
                          return TradeCardWidget(
                              trade: trade, portfolio: portfolio);
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

  // --- Graph Section ---

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
          .add(_buildCategoryTile(context, context.l10n.otherCategory, otherTrades, portfolio));
    }

    if (widgets.isEmpty) {
      return [
        Center(
            child: Text(context.l10n.noCategorizedTrades,
                style: const TextStyle(color: Colors.grey)))
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
            .map((t) => TradeCardWidget(trade: t, portfolio: bot))
            .toList(),
      ),
    );
  }

  // Reuse existing card logic with minor tweaks

  /// Kleiner farbiger Chip für das Kerzenmuster

  Widget _buildFilterChip(String label, String key) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        selected: _filter == key,
        onSelected: (v) => setState(() => _filter = key),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.resetPortfolioTitle),
        content: Text(context.l10n.resetPortfolioContent),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.l10n.cancel)),
          TextButton(
            onPressed: () {
              context.read<PortfolioService>().resetPortfolio();
              Navigator.pop(ctx);
            },
            child: Text(context.l10n.deleteAll,
                style: const TextStyle(color: Colors.red)),
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
          title: Text(context.l10n.botWatchlist),
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
                          decoration: InputDecoration(
                              hintText: context.l10n.symbolHint),
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
                                      child: Text(context.l10n.selectAll,
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
                                      child: Text(context.l10n.selectNone,
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
                child: Text(context.l10n.done)),
          ],
        );
      },
    );
  }
}
