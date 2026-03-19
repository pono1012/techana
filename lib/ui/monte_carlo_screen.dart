import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/models.dart';
import '../services/monte_carlo_service.dart';
import '../services/data_service.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

/// Öffnet ein BottomSheet mit der Monte Carlo Simulation für das aktuelle Symbol
void showMonteCarloSheet(BuildContext context, String symbol) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _MonteCarloSheet(symbol: symbol),
  );
}

class _MonteCarloSheet extends StatefulWidget {
  final String symbol;
  const _MonteCarloSheet({required this.symbol});

  @override
  State<_MonteCarloSheet> createState() => _MonteCarloSheetState();
}

class _MonteCarloSheetState extends State<_MonteCarloSheet> {
  final MonteCarloService _mcService = MonteCarloService();
  final DataService _dataService = DataService();
  bool _isLoading = false;
  String _errorMsg = '';
  MonteCarloResult? _result;
  int _daysToSimulate = 30;

  @override
  void initState() {
    super.initState();
    // Auto-Start der Simulation
    Future.microtask(() => _runSimulation());
  }

  void _runSimulation() async {
    if (widget.symbol.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMsg = '';
      _result = null;
    });

    try {
      final bars =
          await _dataService.fetchBars(widget.symbol, interval: TimeFrame.d1);
      int startIdx = bars.length > 252 ? bars.length - 252 : 0;
      final recentBars = bars.sublist(startIdx);

      final provider = Provider.of<AppProvider>(context, listen: false);
      final signal = provider.computedData?.latestSignal;
      final double? tp = signal?.takeProfit1;
      final double? sl = signal?.stopLoss;

      final result = _mcService.runSimulation(
        historicalBars: recentBars,
        daysToSimulate: _daysToSimulate,
        numSimulations: 1000,
        tpPrice: tp,
        slPrice: sl,
      );

      if (mounted) setState(() => _result = result);
    } catch (e) {
      if (mounted) setState(() => _errorMsg = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    const Icon(Icons.query_stats, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Monte Carlo Simulation",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(widget.symbol,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    // Tage-Auswahl
                    DropdownButton<int>(
                      value: _daysToSimulate,
                      underline: const SizedBox(),
                      items: [10, 30, 90, 180, 365].map((d) {
                        return DropdownMenuItem(
                            value: d,
                            child: Text("$d T",
                                style: const TextStyle(fontSize: 12)));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _daysToSimulate = val);
                          _runSimulation();
                        }
                      },
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: _isLoading ? null : _runSimulation,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.refresh),
                      tooltip: "Neu berechnen",
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Body
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text("Simulation läuft... (1000 Szenarien)",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ))
                    : _errorMsg.isNotEmpty
                        ? Center(
                            child: Text("Fehler: $_errorMsg",
                                style: const TextStyle(color: Colors.red)))
                        : _result != null
                            ? ListView(
                                controller: scrollCtrl,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                children: [
                                    _buildStatsCards(_result!),
                                    const SizedBox(height: 16),
                                    _buildAnalysis(_result!),
                                    const SizedBox(height: 16),
                                    const Text(
                                        "Simulierte Preispfade (50 von 1000)",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                        height: 280,
                                        child: _buildChart(_result!)),
                                    const SizedBox(height: 24),
                                  ])
                            : const Center(child: Text("Keine Daten")),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsCards(MonteCarloResult res) {
    final change =
        ((res.expectedPrice - res.currentPrice) / res.currentPrice * 100);
    final changeColor = change >= 0 ? Colors.green : Colors.red;
    final changeSign = change >= 0 ? '+' : '';
    return Row(
      children: [
        _statCard("Aktuell", _fmtP(res.currentPrice), Colors.white70),
        _statCard("Erwartet", _fmtP(res.expectedPrice), Colors.blue),
        _statCard("Δ", "$changeSign${change.toStringAsFixed(1)}%", changeColor),
        _statCard("95% Low", _fmtP(res.lowerBound95), Colors.red),
        _statCard("95% High", _fmtP(res.upperBound95), Colors.green),
      ],
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 9, color: Colors.grey)),
              const SizedBox(height: 2),
              FittedBox(
                child: Text(value,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Automatische Analyse der Ergebnisse ───
  Widget _buildAnalysis(MonteCarloResult res) {
    final change =
        ((res.expectedPrice - res.currentPrice) / res.currentPrice * 100);
    final range95 =
        ((res.upperBound95 - res.lowerBound95) / res.currentPrice * 100);
    final upside =
        ((res.upperBound95 - res.currentPrice) / res.currentPrice * 100);
    final downside =
        ((res.currentPrice - res.lowerBound95) / res.currentPrice * 100);
    final riskReward = downside > 0 ? upside / downside : 0.0;
    final annualVol = (res.historicalVolatility * 100);

    // Bull/Bear-Wahrscheinlichkeit
    int bullCount = 0;
    for (var path in res.simulatedPaths) {
      if (path.last > res.currentPrice) bullCount++;
    }
    final bullPct = (bullCount / res.simulatedPaths.length * 100);
    final bearPct = 100 - bullPct;

    // Outlook bestimmen
    String outlook;
    Color outlookColor;
    IconData outlookIcon;
    if (bullPct >= 65) {
      outlook = "Stark Bullish";
      outlookColor = Colors.green;
      outlookIcon = Icons.trending_up;
    } else if (bullPct >= 55) {
      outlook = "Leicht Bullish";
      outlookColor = Colors.lightGreen;
      outlookIcon = Icons.trending_up;
    } else if (bearPct >= 65) {
      outlook = "Stark Bearish";
      outlookColor = Colors.red;
      outlookIcon = Icons.trending_down;
    } else if (bearPct >= 55) {
      outlook = "Leicht Bearish";
      outlookColor = Colors.orange;
      outlookIcon = Icons.trending_down;
    } else {
      outlook = "Neutral / Seitwärts";
      outlookColor = Colors.amber;
      outlookIcon = Icons.trending_flat;
    }

    // Risiko-Bewertung
    String riskLevel;
    Color riskColor;
    if (annualVol < 15) {
      riskLevel = "Niedrig";
      riskColor = Colors.green;
    } else if (annualVol < 30) {
      riskLevel = "Moderat";
      riskColor = Colors.orange;
    } else if (annualVol < 60) {
      riskLevel = "Hoch";
      riskColor = Colors.deepOrange;
    } else {
      riskLevel = "Sehr Hoch";
      riskColor = Colors.red;
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, size: 18, color: Colors.deepPurple),
                const SizedBox(width: 8),
                const Text("Analyse der Simulation",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const Divider(),

            // Outlook
            Row(
              children: [
                Icon(outlookIcon, color: outlookColor, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Ausblick",
                        style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text(outlook,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: outlookColor)),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Erwartete Δ",
                        style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text(
                        "${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: change >= 0 ? Colors.green : Colors.red)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Bull/Bear Bar
            const Text("Wahrscheinlichkeitsverteilung",
                style: TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Row(
                children: [
                  Expanded(
                    flex: bullPct.round(),
                    child: Container(
                      height: 28,
                      color: Colors.green.withOpacity(0.8),
                      alignment: Alignment.center,
                      child: Text("↑ ${bullPct.toStringAsFixed(0)}%",
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    flex: bearPct.round(),
                    child: Container(
                      height: 28,
                      color: Colors.red.withOpacity(0.8),
                      alignment: Alignment.center,
                      child: Text("↓ ${bearPct.toStringAsFixed(0)}%",
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Metrics Grid
            Row(
              children: [
                _metricTile("Volatilität (p.a.)",
                    "${annualVol.toStringAsFixed(1)}%", riskColor),
                _metricTile("Risiko-Level", riskLevel, riskColor),
                _metricTile("95% Spanne", "${range95.toStringAsFixed(1)}%",
                    Colors.blue),
                _metricTile("Risk/Reward", riskReward.toStringAsFixed(2),
                    riskReward >= 1.0 ? Colors.green : Colors.red),
              ],
            ),
            if (res.tpProbability != null || res.slProbability != null) ...[
              const SizedBox(height: 16),
              const Text("Target Wahrscheinlichkeiten",
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (res.tpProbability != null)
                    _probabilityTile("Hit TP", res.tpProbability!,
                        res.medianTpDay, Colors.green),
                  if (res.slProbability != null)
                    _probabilityTile("Hit SL", res.slProbability!,
                        res.medianSlDay, Colors.red),
                ],
              ),
            ],
            const SizedBox(height: 16),

            // Upside/Downside
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_upward,
                          color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      Text("Upside: +${upside.toStringAsFixed(1)}%",
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.arrow_downward,
                          color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text("Downside: -${downside.toStringAsFixed(1)}%",
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Empfehlung
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: outlookColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: outlookColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: outlookColor, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _generateRecommendation(bullPct, change, annualVol,
                          riskReward, _daysToSimulate),
                      style: TextStyle(fontSize: 12, color: outlookColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _probabilityTile(
      String label, double prob, int? medianDay, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 4),
            Text("${(prob * 100).toStringAsFixed(1)}%",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            if (medianDay != null)
              Text("~ T$medianDay Ø",
                  style:
                      TextStyle(fontSize: 10, color: color.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }

  Widget _metricTile(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(fontSize: 9, color: Colors.grey),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  String _generateRecommendation(
      double bullPct, double change, double vol, double rr, int days) {
    if (bullPct >= 65 && rr >= 1.5) {
      return "Starkes bullishes Setup: ${bullPct.toStringAsFixed(0)}% der Szenarien steigen in $days Tagen. Risk/Reward von ${rr.toStringAsFixed(1)} spricht für eine Position.";
    } else if (bullPct >= 55 && rr >= 1.0) {
      return "Leicht bullishes Umfeld mit akzeptablem Risk/Reward. Ein moderater Einstieg könnte in Betracht gezogen werden.";
    } else if (bullPct <= 35) {
      return "Bearishes Szenario: Nur ${bullPct.toStringAsFixed(0)}% der Simulationen zeigen steigende Kurse. Vorsicht ist geboten, ggf. Absicherung empfohlen.";
    } else if (vol > 50) {
      return "Extrem hohe Volatilität (${vol.toStringAsFixed(0)}% p.a.) — die Preisspanne ist sehr breit. Kleinere Positionen und weite Stop-Loss Levels empfohlen.";
    } else if (rr < 0.5) {
      return "Ungünstiges Risk/Reward-Verhältnis (${rr.toStringAsFixed(2)}). Das Abwärtsrisiko überwiegt das Aufwärtspotenzial deutlich.";
    } else {
      return "Neutrales Umfeld: Die Simulation zeigt keine klare Richtung. Abwarten oder Range-Strategien könnten sinnvoll sein.";
    }
  }

  Widget _buildChart(MonteCarloResult res) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) =>
                  Text(_fmtP(value), style: const TextStyle(fontSize: 9)),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: (_daysToSimulate / 5).ceilToDouble(),
              getTitlesWidget: (value, meta) => Text("T${value.toInt()}",
                  style: const TextStyle(fontSize: 9)),
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData:
            FlBorderData(show: true, border: Border.all(color: Colors.white10)),
        lineBarsData: _buildChartLines(res),
      ),
    );
  }

  List<LineChartBarData> _buildChartLines(MonteCarloResult res) {
    List<LineChartBarData> lines = [];
    int pathsToDraw =
        res.simulatedPaths.length > 50 ? 50 : res.simulatedPaths.length;

    for (int i = 0; i < pathsToDraw; i++) {
      List<FlSpot> spots = [];
      final path = res.simulatedPaths[i];
      for (int x = 0; x < path.length; x++) {
        spots.add(FlSpot(x.toDouble(), path[x]));
      }
      lines.add(LineChartBarData(
        spots: spots,
        isCurved: true,
        color: Colors.grey.withOpacity(0.2),
        barWidth: 1,
        dotData: const FlDotData(show: false),
      ));
    }

    // Erwartungswert (Mean)
    List<FlSpot> meanSpots = [];
    int pathLen = res.simulatedPaths[0].length;
    for (int d = 0; d < pathLen; d++) {
      double sum = 0;
      for (var path in res.simulatedPaths) sum += path[d];
      meanSpots.add(FlSpot(d.toDouble(), sum / res.simulatedPaths.length));
    }
    lines.add(LineChartBarData(
      spots: meanSpots,
      isCurved: true,
      color: Colors.deepPurple,
      barWidth: 2.5,
      dotData: const FlDotData(show: false),
    ));

    // TP/SL Linien
    final provider = Provider.of<AppProvider>(context, listen: false);
    final signal = provider.computedData?.latestSignal;
    if (signal != null) {
      if (signal.takeProfit1 > 0) {
        lines.add(_buildTargetLine(
            signal.takeProfit1, Colors.green.withOpacity(0.5)));
      }
      if (signal.stopLoss > 0) {
        lines.add(
            _buildTargetLine(signal.stopLoss, Colors.red.withOpacity(0.5)));
      }
    }

    return lines;
  }

  LineChartBarData _buildTargetLine(double price, Color color) {
    return LineChartBarData(
      spots: [
        FlSpot(0, price),
        FlSpot(_daysToSimulate.toDouble(), price),
      ],
      color: color,
      barWidth: 1,
      dashArray: [5, 5],
      dotData: const FlDotData(show: false),
    );
  }

  String _fmtP(double price) {
    if (price >= 10000) return "${(price / 1000).toStringAsFixed(1)}k";
    if (price >= 100) return price.toStringAsFixed(1);
    return price.toStringAsFixed(2);
  }
}
