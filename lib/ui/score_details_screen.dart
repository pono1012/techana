import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/watchlist_service.dart';
import '../models/models.dart';
import 'analysis_settings_dialog.dart';
import '../l10n/l10n_extension.dart';
import '../l10n/enum_localizations.dart';

class ScoreDetailsScreen extends StatelessWidget {
  final TradeSignal? externalSignal;
  final String? externalSymbol;

  const ScoreDetailsScreen(
      {super.key, this.externalSignal, this.externalSymbol});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    // Nutze externes Signal (vom Bot/TopMover) falls vorhanden, sonst AppProvider
    final sig = externalSignal ?? appProvider.computedData?.latestSignal;
    final symbol = externalSymbol ?? appProvider.symbol;

    // ComputedData ist nur verfügbar, wenn wir über den AppProvider kommen
    final data = externalSignal != null ? null : appProvider.computedData;

    if (sig == null) {
      return Scaffold(body: Center(child: Text(context.l10n.noData)));
    }

    final snapshot = sig.indicatorValues ?? {};

    final lastRsi = snapshot['rsi'] as double? ?? 50;
    final lastStBull =
        snapshot['stBull'] as bool? ?? (data?.stBull.last ?? false);
    final lastPrice =
        snapshot['price'] as double? ?? (data?.bars.last.close ?? 0.0);
    final lastEma20 =
        snapshot['ema20'] as double? ?? (data?.ema20.last ?? lastPrice);
    final lastEma50 = snapshot['ema50'] as double? ?? lastPrice;
    final lastMacdHist =
        snapshot['macdHist'] as double? ?? (data?.macdHist.last ?? 0);
    final squeeze =
        snapshot['squeeze'] as bool? ?? (data?.squeezeFlags.last ?? false);
    final lastAdx = snapshot['adx'] as double? ?? (data?.adx.last ?? 0);
    final lastStochK =
        snapshot['stochK'] as double? ?? (data?.stochK.last ?? 50);
    final lastObv = snapshot['obv'] as double? ?? (data?.obv.last ?? 0);
    final isCloudBullish = snapshot['ichimoku_cloud_bull'] as bool? ?? false;
    final isCrossBullish = snapshot['ichimoku_cross_bull'] as bool? ?? false;
    final divergenceType = snapshot['divergence'] as String? ?? 'none';
    // Neue Indikatoren
    final lastCci = snapshot['cci'] as double? ?? 0;
    final lastCmf = snapshot['cmf'] as double? ?? 0;
    final lastMfi = snapshot['mfi'] as double? ?? 50;
    final lastAo = snapshot['ao'] as double? ?? 0;
    final lastBbPct = snapshot['bbPct'] as double? ?? 0.5;
    final lastPsarBull = snapshot['psarBull'] as bool? ?? lastStBull;
    final lastVortex = snapshot['vortex'] as double? ?? 0;
    final lastChop = snapshot['chop'] as double? ?? 61.8;
    final isTrending = snapshot['isTrending'] as bool? ?? (lastChop < 61.8);
    // Kategorie-Scores
    final scoreTrend = snapshot['score_trend'] as double? ?? 0;
    final scoreMomentum = snapshot['score_momentum'] as double? ?? 0;
    final scoreVolume = snapshot['score_volume'] as double? ?? 0;
    final scorePattern = snapshot['score_pattern'] as double? ?? 0;
    final scoreVolatility = snapshot['score_volatility'] as double? ?? 0;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.analysisDetails),
        actions: [
          // NEU: Einstellungen Button
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: context.l10n.strategySettings,
            onPressed: () => showDialog(
                context: context, builder: (_) => AnalysisSettingsDialog()),
          ),
          // Feature: Zur Bot Watchlist hinzufügen
          Consumer<WatchlistService>(builder: (context, watchlist, _) {
            final isInWatchlist = watchlist.watchListMap.containsKey(symbol);
            return IconButton(
              icon: Icon(isInWatchlist
                  ? Icons.playlist_add_check
                  : Icons.playlist_add),
              tooltip: isInWatchlist
                  ? context.l10n.alreadyInWatchlist
                  : context.l10n.addToWatchlist,
              onPressed: isInWatchlist
                  ? null
                  : () {
                      watchlist.addWatchlistSymbol(symbol);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text(context.l10n.addedToWatchlist(symbol))));
                    },
            );
          })
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Score Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getColorForType(sig.type).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _getColorForType(sig.type), width: 2),
            ),
            child: Column(
              children: [
                Text(context.l10n.tradingScore,
                    style: Theme.of(context).textTheme.titleMedium),
                Text("${sig.score}/100",
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: _getColorForType(sig.type))),
                Text(sig.type,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getColorForType(sig.type))),
                const SizedBox(height: 12),
                if (sig.marketRegime != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.layers_outlined,
                            size: 16, color: Colors.blueGrey),
                        const SizedBox(width: 8),
                        Text(context.l10n.regimePrefix(sig.marketRegime!.label(context)),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // AI Probability Insights
          if (sig.aiConfidence != null) ...[
            Text(context.l10n.aiProbabilityInsights,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.l10n.avgConfidence),
                      Text("${(sig.aiConfidence! * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                      context.l10n.indicatorWeighting,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  _buildAiWeightRow(l.indicatorEMA, snapshot['weight_ema'] ?? 0.5),
                  _buildAiWeightRow(
                      l.indicatorRSI, snapshot['weight_rsi'] ?? 0.5),
                  _buildAiWeightRow(
                      l.indicatorMACD, snapshot['weight_macd'] ?? 0.5),
                  _buildAiWeightRow(
                      l.indicatorBB, snapshot['weight_bb'] ?? 0.5),
                  _buildAiWeightRow(
                      l.indicatorStoch, snapshot['weight_stoch'] ?? 0.5),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Kategorie-Scoring Aufschlüsselung
          Text(context.l10n.scoreBreakdown,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),

          _buildCategoryBar(context, "🔴 ${context.l10n.catTrend}", scoreTrend, 35, Colors.blue, [
            _buildIndicatorCard(
                context,
                l.indicatorSupertrend,
                lastStBull ? l.positive : l.negative,
                lastStBull ? l.bullish : l.bearish,
                l.stDesc,
                lastStBull ? Colors.green : Colors.red),
            _buildIndicatorCard(
                context,
                "EMA 20 / EMA 50",
                "${lastEma20.toStringAsFixed(2)} / ${lastEma50.toStringAsFixed(2)}",
                lastPrice > lastEma20 ? l.priceAboveEma : l.priceBelowEma,
                l.emaDesc,
                lastPrice > lastEma20 ? Colors.green : Colors.red),
            _buildIndicatorCard(
                context,
                l.indicatorSAR,
                lastPsarBull ? l.bullish : l.bearish,
                lastPsarBull ? l.trendUp : l.trendDown,
                l.psarDesc,
                lastPsarBull ? Colors.green : Colors.red),
            _buildIndicatorCard(
                context,
                l.indicatorIchimoku,
                isCrossBullish ? l.tenkanAboveKijun : l.tenkanBelowKijun,
                isCloudBullish ? l.aboveCloud : l.belowCloud,
                l.ichimokuDesc,
                isCloudBullish ? Colors.green : Colors.red),
            _buildIndicatorCard(
                context,
                l.indicatorVortexChoppiness,
                "VX: ${lastVortex.toStringAsFixed(3)} | CHOP: ${lastChop.toStringAsFixed(1)}",
                isTrending ? l.trending : l.sideways,
                l.vortexChopDesc,
                isTrending ? Colors.blue : Colors.grey),
          ]),
          _buildCategoryBar(
              context, "🟡 ${context.l10n.catMomentum}", scoreMomentum, 25, Colors.orange, [
            _buildIndicatorCard(
                context,
                "RSI (${lastRsi.toStringAsFixed(1)})",
                lastRsi.toStringAsFixed(1),
                lastRsi < 30
                    ? context.l10n.rsiOversold
                    : (lastRsi > 70 ? context.l10n.rsiOverbought : context.l10n.rsiNeutral),
                context.l10n.rsiDesc,
                lastRsi < 30
                    ? Colors.green
                    : (lastRsi > 70 ? Colors.red : Colors.grey)),
            _buildIndicatorCard(
                context,
                l.indicatorMACDHist,
                lastMacdHist.toStringAsFixed(4),
                lastMacdHist > 0 ? l.posMomentum : l.negMomentum,
                l.macdDesc,
                lastMacdHist > 0 ? Colors.green : Colors.red),
            _buildIndicatorCard(
                context,
                l.indicatorADX,
                lastAdx.toStringAsFixed(1),
                lastAdx > 25 ? l.strongTrend : l.sideways,
                l.adxDesc,
                lastAdx > 25 ? Colors.blue : Colors.grey),
            _buildIndicatorCard(
                context,
                "CCI (Commodity Channel)",
                lastCci.toStringAsFixed(1),
                lastCci < -100
                    ? context.l10n.rsiOversold
                    : (lastCci > 100 ? context.l10n.rsiOverbought : context.l10n.rsiNeutral),
                context.l10n.cciDesc,
                lastCci < -100
                    ? Colors.green
                    : (lastCci > 100 ? Colors.red : Colors.grey)),
            _buildIndicatorCard(
                context,
                "Stochastic (${lastStochK.toStringAsFixed(1)})",
                lastStochK.toStringAsFixed(1),
                lastStochK > 80
                    ? context.l10n.rsiOverbought
                    : (lastStochK < 20 ? context.l10n.rsiOversold : context.l10n.rsiNeutral),
                context.l10n.stochDesc,
                lastStochK > 80
                    ? Colors.red
                    : (lastStochK < 20 ? Colors.green : Colors.grey)),
            _buildIndicatorCard(
                context,
                l.indicatorAO,
                lastAo.toStringAsFixed(4),
                lastAo > 0 ? l.bullish : l.bearish,
                l.aoDesc,
                lastAo > 0 ? Colors.green : Colors.red),
          ]),
          _buildCategoryBar(
              context, "🟢 ${context.l10n.catVolume}", scoreVolume, 20, Colors.teal, [
            _buildIndicatorCard(
                context,
                l.indicatorOBV,
                _formatObv(lastObv),
                l.volMomentum,
                l.obvDesc,
                Colors.teal),
            _buildIndicatorCard(
                context,
                l.indicatorCMF,
                lastCmf.toStringAsFixed(3),
                lastCmf > 0.05
                    ? l.posMoneyFlow
                    : (lastCmf < -0.05 ? l.negMoneyFlow : l.rsiNeutral),
                l.cmfDesc,
                lastCmf > 0.05
                    ? Colors.green
                    : (lastCmf < -0.05 ? Colors.red : Colors.grey)),
            _buildIndicatorCard(
                context,
                l.indicatorMFI,
                lastMfi.toStringAsFixed(1),
                lastMfi < 20
                    ? l.rsiOversold
                    : (lastMfi > 80 ? l.rsiOverbought : l.rsiNeutral),
                l.mfiDesc,
                lastMfi < 20
                    ? Colors.green
                    : (lastMfi > 80 ? Colors.red : Colors.grey)),
          ]),
          _buildCategoryBar(
              context, "🟣 ${context.l10n.catPattern}", scorePattern, 15, Colors.purple, [
            if (divergenceType != 'none')
              _buildIndicatorCard(
                  context,
                  l.indicatorDiv,
                  divergenceType == 'bullish'
                      ? l.bullishDetected
                      : l.bearishDetected,
                  l.strongReversal,
                  l.divDesc,
                  divergenceType == 'bullish' ? Colors.green : Colors.red),
          ]),
          _buildCategoryBar(
              context, "⚪ ${context.l10n.catVolatility}", scoreVolatility, 5, Colors.grey, [
            if (squeeze)
              _buildIndicatorCard(
                  context,
                  l.indicatorSqueeze,
                  l.active,
                  l.breakoutPending,
                  l.squeezeDesc,
                  Colors.orange),
            _buildIndicatorCard(
                context,
                l.indicatorBBPercent,
                lastBbPct.toStringAsFixed(2),
                lastBbPct < 0.1
                    ? l.oversold
                    : (lastBbPct > 0.9 ? l.overbought : l.midRange),
                l.bbPctDesc,
                lastBbPct < 0.1
                    ? Colors.green
                    : (lastBbPct > 0.9 ? Colors.red : Colors.grey)),
          ]),

          const Divider(),
          const SizedBox(height: 16),

          // Setup Daten
          _buildRow(
              context.l10n.entryPrice, sig.entryPrice.toStringAsFixed(2), Colors.blue),
          _buildRow(context.l10n.stopLoss, sig.stopLoss.toStringAsFixed(2), Colors.red),
          _buildRow(
              context.l10n.takeProfit1,
              "${sig.takeProfit1.toStringAsFixed(2)} (+${sig.tp1Percent?.toStringAsFixed(1)}%)",
              Colors.green),
          _buildRow(
              context.l10n.takeProfit2,
              "${sig.takeProfit2.toStringAsFixed(2)} (+${sig.tp2Percent?.toStringAsFixed(1)}%)",
              Colors.green),
          const SizedBox(height: 8),
          _buildRow(context.l10n.riskRewardShort, sig.riskRewardRatio.toStringAsFixed(2),
              Colors.orange),
        ],
      ),
    );
  }

  String _formatObv(double v) {
    if (v.abs() > 1000000) return "${(v / 1000000).toStringAsFixed(2)}M";
    if (v.abs() > 1000) return "${(v / 1000).toStringAsFixed(1)}k";
    return v.toStringAsFixed(0);
  }

  Widget _buildCategoryBar(BuildContext context, String label, double score,
      double maxScore, Color color, List<Widget> indicators) {
    final l = context.l10n;
    final pct = ((score + maxScore) / (2 * maxScore)).clamp(0.0, 1.0);
    final displaySign =
        score > 0 ? "+${score.toStringAsFixed(1)}" : score.toStringAsFixed(1);

    return InkWell(
      onTap: () {
        if (indicators.isEmpty) return;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          builder: (ctx) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${label.split(' ').last} ${l.details}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: indicators,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
                Text("$displaySign / ${maxScore.toInt()}",
                    style: TextStyle(
                        fontSize: 12,
                        color: score >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                    score >= 0 ? color : Colors.red.withOpacity(0.7)),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 4),
            Text(context.l10n.tapForIndicators,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorCard(BuildContext context, String title, String value,
      String status, String desc, Color statusColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(status,
                      style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(context.l10n.indicatorValue(value),
                style: const TextStyle(fontFamily: "monospace")),
            const SizedBox(height: 8),
            Text(desc, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Color _getColorForType(String type) {
    if (type.contains("Buy")) return Colors.green;
    if (type.contains("Sell")) return Colors.red;
    return Colors.grey;
  }

  Widget _buildAiWeightRow(String name, dynamic weight) {
    final double w = (weight is num) ? weight.toDouble() : 0.5;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontSize: 11)),
              Text("${(w * 100).toStringAsFixed(0)}%",
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: w > 0.5
                          ? Colors.green
                          : (w < 0.5 ? Colors.red : Colors.grey))),
            ],
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: w.clamp(0.0, 1.0),
              minHeight: 3,
              backgroundColor: Colors.grey.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(w > 0.5
                  ? Colors.green
                  : (w < 0.5 ? Colors.red : Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String val, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(val,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
