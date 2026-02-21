import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/watchlist_service.dart';
import '../models/models.dart';
import 'analysis_settings_dialog.dart'; // Import hinzufügen

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
      return const Scaffold(body: Center(child: Text("Keine Daten")));
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analyse Details"),
        actions: [
          // NEU: Einstellungen Button
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: "Strategie Einstellungen",
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
                  ? "Bereits in Bot Watchlist"
                  : "Zur Bot Watchlist hinzufügen",
              onPressed: isInWatchlist
                  ? null
                  : () {
                      watchlist.addWatchlistSymbol(symbol);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("$symbol zur Bot-Watchlist hinzugefügt!")));
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
                Text("Trading Score",
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
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Kategorie-Scoring Aufschlüsselung
          const Text("Score-Aufschlüsselung (Forschungsbasiert):",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          _buildCategoryBar(context, "🔴 Trend", scoreTrend, 35, Colors.blue),
          _buildCategoryBar(
              context, "🟡 Momentum", scoreMomentum, 25, Colors.orange),
          _buildCategoryBar(
              context, "🟢 Volumen", scoreVolume, 20, Colors.teal),
          _buildCategoryBar(
              context, "🟣 Muster", scorePattern, 15, Colors.purple),
          _buildCategoryBar(
              context, "⚪ Volatilität", scoreVolatility, 5, Colors.grey),
          const SizedBox(height: 20),

          const Text("Indikatoren Analyse:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),

          // ---- TREND ----
          _buildIndicatorCard(
              context,
              "Supertrend",
              lastStBull ? "Grün" : "Rot",
              lastStBull ? "Bullish" : "Bearish",
              "Der Supertrend zeigt die Hauptrichtung basierend auf ATR-Volatilität.",
              lastStBull ? Colors.green : Colors.red),
          _buildIndicatorCard(
              context,
              "EMA 20 / EMA 50",
              "${lastEma20.toStringAsFixed(2)} / ${lastEma50.toStringAsFixed(2)}",
              lastPrice > lastEma20 ? "Kurs über EMA" : "Kurs unter EMA",
              "Kurzfristiger und mittelfristiger Trendfilter.",
              lastPrice > lastEma20 ? Colors.green : Colors.red),
          _buildIndicatorCard(
              context,
              "Parabolic SAR",
              lastPsarBull ? "Bullish" : "Bearish",
              lastPsarBull ? "Trend aufwärts" : "Trend abwärts",
              "PSAR platziert Punkte unter/über dem Preis. Preisüberschreitung = Trendwechsel.",
              lastPsarBull ? Colors.green : Colors.red),
          _buildIndicatorCard(
              context,
              "Ichimoku Analyse",
              isCrossBullish ? "Tenkan > Kijun" : "Tenkan < Kijun",
              isCloudBullish ? "Über der Wolke" : "Unter der Wolke",
              "Wolke = dynamische S/R Zone. Tenkan/Kijun-Cross = Momentumsignal.",
              isCloudBullish ? Colors.green : Colors.red),
          _buildIndicatorCard(
              context,
              "Vortex + Choppiness",
              "VX: ${lastVortex.toStringAsFixed(3)} | CHOP: ${lastChop.toStringAsFixed(1)}",
              isTrending ? "Trending (< 61.8)" : "Seitwärts (> 61.8)",
              "Vortex misst Trendbewegungen. Choppiness Index: < 61.8 = Trend, > 61.8 = Range.",
              isTrending ? Colors.blue : Colors.grey),

          // ---- MOMENTUM ----
          _buildIndicatorCard(
              context,
              "RSI (${lastRsi.toStringAsFixed(1)})",
              lastRsi.toStringAsFixed(1),
              lastRsi < 30
                  ? "Überverkauft"
                  : (lastRsi > 70 ? "Überkauft" : "Neutral"),
              "RSI misst Überverkauft (<30) / Überkauft (>70). Im starken Trend (ADX>25) ist RSI>70 kein Warnsignal.",
              lastRsi < 30
                  ? Colors.green
                  : (lastRsi > 70 ? Colors.red : Colors.grey)),
          _buildIndicatorCard(
              context,
              "MACD Histogramm",
              lastMacdHist.toStringAsFixed(4),
              lastMacdHist > 0 ? "Positives Momentum" : "Negatives Momentum",
              "Histogramm > 0 = bullisches Momentum. Steigende Balken = stärker werdendes Signal.",
              lastMacdHist > 0 ? Colors.green : Colors.red),
          _buildIndicatorCard(
              context,
              "ADX (Trendstärke)",
              lastAdx.toStringAsFixed(1),
              lastAdx > 25 ? "Starker Trend" : "Seitwärts",
              "ADX > 25 = etablierter Trend. Verstärkt andere Momentum-Signale.",
              lastAdx > 25 ? Colors.blue : Colors.grey),
          _buildIndicatorCard(
              context,
              "CCI (Commodity Channel)",
              lastCci.toStringAsFixed(1),
              lastCci < -100
                  ? "Überverkauft"
                  : (lastCci > 100 ? "Überkauft" : "Neutral"),
              "CCI < -100 = stark überverkauft (Kaufgelegenheit). CCI > 100 = überkauft.",
              lastCci < -100
                  ? Colors.green
                  : (lastCci > 100 ? Colors.red : Colors.grey)),
          _buildIndicatorCard(
              context,
              "Stochastic (${lastStochK.toStringAsFixed(1)})",
              lastStochK.toStringAsFixed(1),
              lastStochK > 80
                  ? "Überkauft"
                  : (lastStochK < 20 ? "Überverkauft" : "Neutral"),
              "Stochastic vergleicht Schlusskurs mit Preisspanne. <20 = oversold, >80 = overbought.",
              lastStochK > 80
                  ? Colors.red
                  : (lastStochK < 20 ? Colors.green : Colors.grey)),
          _buildIndicatorCard(
              context,
              "Awesome Oscillator",
              lastAo.toStringAsFixed(4),
              lastAo > 0 ? "Bullish" : "Bearish",
              "AO = SMA(5) - SMA(34) der Mittelpunkte. Zeigt Marktmomentum.",
              lastAo > 0 ? Colors.green : Colors.red),

          // ---- VOLUMEN ----
          _buildIndicatorCard(
              context,
              "On-Balance Volume",
              _formatObv(lastObv),
              "Volumen-Momentum",
              "OBV steigt = Kaufdruck. Divergenz mit Preis = mögliche Umkehr.",
              Colors.teal),
          _buildIndicatorCard(
              context,
              "CMF (Chaikin Money Flow)",
              lastCmf.toStringAsFixed(3),
              lastCmf > 0.05
                  ? "Positiver Geldfluss"
                  : (lastCmf < -0.05 ? "Negativer Geldfluss" : "Neutral"),
              "CMF > 0.05 = Kaufdruck über 20 Tage. CMF < -0.05 = Verkaufsdruck.",
              lastCmf > 0.05
                  ? Colors.green
                  : (lastCmf < -0.05 ? Colors.red : Colors.grey)),
          _buildIndicatorCard(
              context,
              "MFI (Money Flow Index)",
              lastMfi.toStringAsFixed(1),
              lastMfi < 20
                  ? "Überverkauft"
                  : (lastMfi > 80 ? "Überkauft" : "Neutral"),
              "MFI = volumengewichteter RSI. < 20 = stark überverkauft (Kaufsignal).",
              lastMfi < 20
                  ? Colors.green
                  : (lastMfi > 80 ? Colors.red : Colors.grey)),

          // ---- MUSTER ----
          if (divergenceType != 'none')
            _buildIndicatorCard(
                context,
                "RSI Divergenz",
                divergenceType == 'bullish'
                    ? "Bullish erkannt"
                    : "Bearish erkannt",
                "Starkes Umkehrsignal",
                "Preis und RSI bewegen sich in entgegengesetzte Richtungen = bevorstehende Trendumkehr.",
                divergenceType == 'bullish' ? Colors.green : Colors.red),
          if (squeeze)
            _buildIndicatorCard(
                context,
                "TTM Squeeze",
                "Aktiv",
                "Ausbruch steht bevor",
                "Bollinger Bands innerhalb Keltner Channels = Energie wird aufgebaut vor Ausbruch.",
                Colors.orange),
          _buildIndicatorCard(
              context,
              "BB %B (Bollinger)",
              lastBbPct.toStringAsFixed(2),
              lastBbPct < 0.1
                  ? "Oversold"
                  : (lastBbPct > 0.9 ? "Overbought" : "Mid Range"),
              "%B zeigt Position innerhalb der Bollinger Bands. <0.1 = unteres Band (Kaufgelegenheit).",
              lastBbPct < 0.1
                  ? Colors.green
                  : (lastBbPct > 0.9 ? Colors.red : Colors.grey)),

          const Divider(),
          const SizedBox(height: 16),

          // Setup Daten
          _buildRow(
              "Entry Preis", sig.entryPrice.toStringAsFixed(2), Colors.blue),
          _buildRow("Stop Loss", sig.stopLoss.toStringAsFixed(2), Colors.red),
          _buildRow(
              "Take Profit 1",
              "${sig.takeProfit1.toStringAsFixed(2)} (+${sig.tp1Percent?.toStringAsFixed(1)}%)",
              Colors.green),
          _buildRow(
              "Take Profit 2",
              "${sig.takeProfit2.toStringAsFixed(2)} (+${sig.tp2Percent?.toStringAsFixed(1)}%)",
              Colors.green),
          const SizedBox(height: 8),
          _buildRow("Risk/Reward (CRV)", sig.riskRewardRatio.toStringAsFixed(2),
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

  String _formatLarge(double? v) {
    if (v == null) return "-";
    if (v > 1e9) return "${(v / 1e9).toStringAsFixed(2)} Mrd.";
    if (v > 1e6) return "${(v / 1e6).toStringAsFixed(2)} Mio.";
    return v.toStringAsFixed(0);
  }

  Widget _buildCategoryBar(BuildContext context, String label, double score,
      double maxScore, Color color) {
    final pct = ((score + maxScore) / (2 * maxScore)).clamp(0.0, 1.0);
    final displaySign =
        score > 0 ? "+${score.toStringAsFixed(1)}" : score.toStringAsFixed(1);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
        ],
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
            Text("Wert: $value",
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

  Color _getColorForVal(double? val, double low, double high,
      {bool invert = false}) {
    if (val == null) return Colors.white;
    if (invert) {
      return val < low
          ? Colors.green
          : (val > high ? Colors.red : Colors.orange);
    }
    return val > high ? Colors.green : (val < low ? Colors.red : Colors.orange);
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
