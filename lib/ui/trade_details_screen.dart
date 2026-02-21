import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../models/trade_record.dart';
import '../services/portfolio_service.dart';

class TradeDetailsScreen extends StatelessWidget {
  final TradeRecord trade;

  const TradeDetailsScreen({super.key, required this.trade});

  @override
  Widget build(BuildContext context) {
    final snap = trade.aiAnalysisSnapshot;
    final hasSnap = snap.isNotEmpty;
    final df = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text("${trade.symbol} Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _confirmDelete(context);
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Header Score ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (trade.entryScore >= 60 ? Colors.green : Colors.red)
                  .withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: trade.entryScore >= 60 ? Colors.green : Colors.red),
            ),
            child: Column(
              children: [
                const Text("Entry Score", style: TextStyle(fontSize: 16)),
                Text("${trade.entryScore}",
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold)),
                if (trade.entryPattern.isNotEmpty)
                  Text("Muster: ${trade.entryPattern}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // --- Trade Stats ---
          _buildSectionTitle("Trade Daten"),
          _buildInfoRow("Status", _formatStatus(trade)),
          if (trade.botTimeFrame != null)
            _buildInfoRow("Analyse Intervall", trade.botTimeFrame!.label),
          _buildInfoRow("Signal Datum", df.format(trade.entryDate)),
          if (trade.status != TradeStatus.pending &&
              trade.entryExecutionDate != null)
            _buildInfoRow(
                "Ausgeführt am", df.format(trade.entryExecutionDate!)),
          if (trade.executionPrice != null)
            _buildInfoRow("Ausführungskurs",
                "${trade.executionPrice!.toStringAsFixed(2)}"),
          if (trade.lastScanDate != null)
            _buildInfoRow("Zuletzt geprüft", df.format(trade.lastScanDate!)),
          _buildInfoRow(
              "Entry Preis", "${trade.entryPrice.toStringAsFixed(2)}"),
          _buildInfoRow("Menge", "${trade.quantity.toStringAsFixed(4)}"),
          _buildInfoRow("Investiert",
              "${(trade.entryPrice * trade.quantity).toStringAsFixed(2)} €"),
          const Divider(),
          _buildInfoRow("Stop Loss", "${trade.stopLoss.toStringAsFixed(2)}"),
          _buildInfoRow(
              "Take Profit 1", "${trade.takeProfit1.toStringAsFixed(2)}"),
          _buildInfoRow(
              "Take Profit 2", "${trade.takeProfit2.toStringAsFixed(2)}"),
          if (trade.exitPrice != null) ...[
            const Divider(),
            _buildInfoRow(
                "Exit Preis", "${trade.exitPrice!.toStringAsFixed(2)}"),
            if (trade.closeExecutionDate != null)
              _buildInfoRow(
                  "Geschlossen am", df.format(trade.closeExecutionDate!)),
            _buildInfoRow(
                "Realisiert PnL", "${trade.realizedPnL.toStringAsFixed(2)} €",
                color: trade.realizedPnL >= 0 ? Colors.green : Colors.red),
          ],

          const SizedBox(height: 20),

          // --- Indikatoren Snapshot ---
          _buildSectionTitle("Indikatoren zum Kaufzeitpunkt"),
          if (!hasSnap)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Keine Detail-Daten für diesen Trade gespeichert.",
                  style: TextStyle(color: Colors.grey)),
            )
          else ...[
            // --- Kategorie-Scores ---
            if (snap.containsKey('score_trend')) ...[
              const SizedBox(height: 4),
              _buildCategoryBar(
                  "Trend",
                  (snap['score_trend'] as num?)?.toDouble() ?? 0,
                  35,
                  Colors.blue),
              _buildCategoryBar(
                  "Momentum",
                  (snap['score_momentum'] as num?)?.toDouble() ?? 0,
                  25,
                  Colors.orange),
              _buildCategoryBar(
                  "Volumen",
                  (snap['score_volume'] as num?)?.toDouble() ?? 0,
                  20,
                  Colors.teal),
              _buildCategoryBar(
                  "Muster",
                  (snap['score_pattern'] as num?)?.toDouble() ?? 0,
                  15,
                  Colors.purple),
              _buildCategoryBar(
                  "Volatilität",
                  (snap['score_volatility'] as num?)?.toDouble() ?? 0,
                  5,
                  Colors.grey),
              const SizedBox(height: 8),
            ],
            // --- Trend ---
            _buildIndicatorCard(
              "Supertrend",
              (snap['stBull'] == true) ? "Bullish" : "Bearish",
              (snap['stBull'] == true) ? "Trend aufwärts" : "Trend abwärts",
            ),
            if (snap.containsKey('psarBull'))
              _buildIndicatorCard(
                "Parabolic SAR",
                (snap['psarBull'] == true) ? "Bullish" : "Bearish",
                "",
              ),
            _buildIndicatorCard(
              "EMA 20 / 50",
              "${(snap['ema20'] as num?)?.toStringAsFixed(2) ?? "-"} / ${(snap['ema50'] as num?)?.toStringAsFixed(2) ?? "-"}",
              _getEmaStatus(snap['price'] as num?, snap['ema20'] as num?),
            ),
            _buildIndicatorCard(
              "Ichimoku",
              (snap['ichimoku_cloud_bull'] == true) ? "Bullish" : "Bearish",
              (snap['ichimoku_cloud_bull'] == true)
                  ? "Über Wolke"
                  : "Unter Wolke",
            ),
            if (snap.containsKey('vortex') && snap.containsKey('chop')) ...[
              _buildIndicatorCard(
                "Vortex",
                (snap['vortex'] as num?)?.toStringAsFixed(3) ?? "-",
                (snap['isTrending'] == true) ? "Trending" : "Seitwärts",
              ),
              _buildIndicatorCard(
                "Choppiness",
                (snap['chop'] as num?)?.toStringAsFixed(1) ?? "-",
                ((snap['chop'] as num? ?? 100) < 61.8)
                    ? "Trend < 61.8"
                    : "Range > 61.8",
              ),
            ],
            // --- Momentum ---
            _buildIndicatorCard(
              "RSI",
              (snap['rsi'] as num?)?.toStringAsFixed(1) ?? "-",
              _getRsiStatus(snap['rsi'] as num?),
            ),
            _buildIndicatorCard(
              "MACD Hist",
              (snap['macdHist'] as num?)?.toStringAsFixed(4) ?? "-",
              (snap['macdHist'] as num? ?? 0) > 0 ? "Positiv" : "Negativ",
            ),
            _buildIndicatorCard(
              "ADX",
              (snap['adx'] as num?)?.toStringAsFixed(1) ?? "-",
              ((snap['adx'] as num? ?? 0) > 25) ? "Starker Trend" : "Seitwärts",
            ),
            if (snap.containsKey('cci'))
              _buildIndicatorCard(
                "CCI",
                (snap['cci'] as num?)?.toStringAsFixed(1) ?? "-",
                ((snap['cci'] as num? ?? 0) < -100)
                    ? "Überverkauft"
                    : (((snap['cci'] as num? ?? 0) > 100)
                        ? "Überkauft"
                        : "Neutral"),
              ),
            _buildIndicatorCard(
              "Stochastic",
              (snap['stochK'] as num?)?.toStringAsFixed(1) ?? "-",
              ((snap['stochK'] as num? ?? 50) > 80)
                  ? "Überkauft"
                  : (((snap['stochK'] as num? ?? 50) < 20)
                      ? "Überverkauft"
                      : "Neutral"),
            ),
            if (snap.containsKey('ao'))
              _buildIndicatorCard(
                "Awesome Oscillator",
                (snap['ao'] as num?)?.toStringAsFixed(4) ?? "-",
                ((snap['ao'] as num? ?? 0) > 0) ? "Bullish" : "Bearish",
              ),
            // --- Volumen ---
            _buildIndicatorCard(
              "OBV",
              _formatObv((snap['obv'] as num?)?.toDouble() ?? 0),
              "Volumen-Momentum",
            ),
            if (snap.containsKey('cmf'))
              _buildIndicatorCard(
                "CMF",
                (snap['cmf'] as num?)?.toStringAsFixed(3) ?? "-",
                ((snap['cmf'] as num? ?? 0) > 0.05)
                    ? "Positiver Fluss"
                    : (((snap['cmf'] as num? ?? 0) < -0.05)
                        ? "Negativer Fluss"
                        : "Neutral"),
              ),
            if (snap.containsKey('mfi'))
              _buildIndicatorCard(
                "MFI",
                (snap['mfi'] as num?)?.toStringAsFixed(1) ?? "-",
                ((snap['mfi'] as num? ?? 50) < 20)
                    ? "Überverkauft"
                    : (((snap['mfi'] as num? ?? 50) > 80)
                        ? "Überkauft"
                        : "Neutral"),
              ),
            // --- Volatility / Muster ---
            _buildIndicatorCard(
              "Squeeze",
              (snap['squeeze'] == true) ? "AKTIV" : "Inaktiv",
              (snap['squeeze'] == true) ? "Ausbruch erwartet" : "",
            ),
            if (snap.containsKey('bbPct'))
              _buildIndicatorCard(
                "BB %B",
                (snap['bbPct'] as num?)?.toStringAsFixed(2) ?? "-",
                ((snap['bbPct'] as num? ?? 0.5) < 0.1)
                    ? "Oversold"
                    : (((snap['bbPct'] as num? ?? 0.5) > 0.9)
                        ? "Overbought"
                        : "Mid"),
              ),
            if (snap.containsKey('divergence') && snap['divergence'] != 'none')
              _buildIndicatorCard(
                "Divergenz",
                (snap['divergence'] as String).toUpperCase(),
                "Starkes Umkehrsignal",
              ),
          ],

          const SizedBox(height: 20),

          // --- Bot Settings Snapshot ---
          if (hasSnap && snap.containsKey('entryStrategy')) ...[
            _buildSectionTitle("Verwendete Bot-Strategie"),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    _buildCompactSettingRow("Entry Strategie",
                        _getEntryStratName(snap['entryStrategy'])),
                    if (snap['entryStrategy'] != 0)
                      _buildCompactSettingRow("Entry Padding",
                          "${snap['entryPadding']} (${snap['entryPaddingType'] == 0 ? '%' : 'x ATR'})"),
                    const Divider(),
                    _buildCompactSettingRow("Stop Loss Methode",
                        _getStopMethodName(snap['stopMethod'])),
                    if (snap['stopMethod'] == 1)
                      _buildCompactSettingRow(
                          "Stop %", "${snap['stopPercent']}%"),
                    if (snap['stopMethod'] == 2)
                      _buildCompactSettingRow(
                          "ATR Mult", "${snap['atrMult']}x"),
                    const Divider(),
                    _buildCompactSettingRow("Take Profit Methode",
                        _getTpMethodName(snap['tpMethod'])),
                    _buildCompactSettingRow("TP1", _formatTpVal(snap, 1)),
                    _buildCompactSettingRow("TP2", _formatTpVal(snap, 2)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Trade löschen?"),
        content: const Text(
            "Dieser Trade wird unwiderruflich aus der Historie entfernt."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Abbrechen")),
          TextButton(
            onPressed: () {
              context.read<PortfolioService>().deleteTrade(trade.id);
              Navigator.pop(ctx); // Dialog zu
              Navigator.pop(context); // Screen zu
            },
            child: const Text("Löschen", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCompactSettingRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(val,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String val, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(val,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildIndicatorCard(String title, String val, String status) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(status),
        trailing: Text(val,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  String _getRsiStatus(num? rsi) => (rsi ?? 50) < 30
      ? "Überverkauft"
      : ((rsi ?? 50) > 70 ? "Überkauft" : "Neutral");

  String _getEmaStatus(num? price, num? ema) {
    if (price == null || ema == null) return "-";
    return price > ema ? "Kurs > EMA (Bullish)" : "Kurs < EMA (Bearish)";
  }

  String _formatStatus(TradeRecord t) {
    if (t.status == TradeStatus.pending) {
      // 1. Check Snapshot for definitive strategy type
      final snap = t.aiAnalysisSnapshot;
      if (snap.containsKey('entryStrategy')) {
        final strat = snap['entryStrategy'];
        if (strat == 1) return "PENDING (LIMIT / PULLBACK)";
        if (strat == 2) return "PENDING (STOP / BREAKOUT)";
      }
      // 2. Fallback to reasons string
      if (t.entryReasons.contains("Pullback"))
        return "PENDING (LIMIT / PULLBACK)";
      if (t.entryReasons.contains("Breakout"))
        return "PENDING (STOP / BREAKOUT)";
      return "PENDING (LIMIT)";
    }
    return t.status.name.toUpperCase();
  }

  String _getEntryStratName(dynamic v) {
    if (v == 1) return "Pullback (Limit)";
    if (v == 2) return "Breakout (Stop)";
    return "Market (Sofort)";
  }

  String _getStopMethodName(dynamic v) {
    if (v == 0) return "Donchian Low/High";
    if (v == 1) return "Prozentual";
    if (v == 3) return "Swing-Low/High";
    return "ATR (Volatilität)";
  }

  String _getTpMethodName(dynamic v) {
    if (v == 1) return "Prozentual";
    if (v == 2) return "ATR-Ziel";
    if (v == 3) return "Pivot Points";
    return "Risk/Reward (CRV)";
  }

  String _formatTpVal(Map<String, dynamic> s, int num) {
    int method = s['tpMethod'] ?? 0;
    if (method == 1) {
      return num == 1 ? "${s['tpPercent1']}%" : "${s['tpPercent2']}%";
    } else if (method == 3) {
      return num == 1 ? "Pivot R1/S1" : "Pivot R2/S2";
    } else {
      return num == 1 ? "${s['rrTp1']} R" : "${s['rrTp2']} R";
    }
  }

  String _formatObv(double v) {
    if (v.abs() >= 1e9) return "${(v / 1e9).toStringAsFixed(2)}B";
    if (v.abs() >= 1e6) return "${(v / 1e6).toStringAsFixed(2)}M";
    if (v.abs() >= 1e3) return "${(v / 1e3).toStringAsFixed(1)}K";
    return v.toStringAsFixed(0);
  }

  Widget _buildCategoryBar(
      String label, double score, double maxScore, Color color) {
    final pct = ((score + maxScore) / (2 * maxScore)).clamp(0.0, 1.0);
    final sign =
        score > 0 ? "+${score.toStringAsFixed(1)}" : score.toStringAsFixed(1);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text("$sign / ${maxScore.toInt()}",
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: score >= 0 ? Colors.green : Colors.red)),
            ],
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: Colors.grey.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(
                  score >= 0 ? color : Colors.red.withOpacity(0.7)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
