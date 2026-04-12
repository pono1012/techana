import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../services/kronos_backend_service.dart';
import '../services/data_service.dart';
import 'dart:async';

void showKronosForecastSheet(BuildContext context, String symbol) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _KronosForecastSheet(symbol: symbol),
  );
}

class _KronosForecastSheet extends StatefulWidget {
  final String symbol;
  const _KronosForecastSheet({required this.symbol});

  @override
  State<_KronosForecastSheet> createState() => _KronosForecastSheetState();
}

class _KronosForecastSheetState extends State<_KronosForecastSheet> {
  final DataService _dataService = DataService();
  bool _isLoading = false;
  String _errorMsg = '';
  
  List<PriceBar> _historicalBars = [];
  List<PriceBar> _forecastBars = [];
  
  String _selectedModel = "small";
  int _predLen = 60;
  int _lookback = 400;
  int _chartHistory = 60;
  
  double _progress = 0.0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final p = context.read<AppProvider>();
      if (p.symbol == widget.symbol && p.kronosResult != null && !p.isKronosLoading) {
        // Cached Daten direkt laden
        setState(() {
          final computed = p.computedData;
          if (computed != null) {
            int startIdx = computed.bars.length > _lookback ? computed.bars.length - _lookback : 0;
            _historicalBars = computed.bars.sublist(startIdx);
          }
          _forecastBars = p.kronosResult!.forecastBars;
        });
      } else {
        _runForecast();
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void _runForecast() async {
    if (widget.symbol.isEmpty) return;

    setState(() {
      _isLoading = true;
      _progress = 0.0;
      _errorMsg = '';
      _forecastBars.clear();
    });

    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) async {
      final appUrl = context.read<AppProvider>().settings.kronosRemoteUrl;
      final progress = await KronosBackendService.getProgress(
        remoteUrl: appUrl.isNotEmpty ? appUrl : null,
      );
      if (mounted) {
        setState(() {
          _progress = progress;
        });
      }
    });

    try {
      final bars = await _dataService.fetchBars(widget.symbol, interval: TimeFrame.d1);
      int startIdx = bars.length > _lookback ? bars.length - _lookback : 0;
      _historicalBars = bars.sublist(startIdx);

      final appSettings = context.read<AppProvider>().settings;

      final result = await KronosBackendService.getForecast(
        historicalCandles: _historicalBars, 
        modelSize: _selectedModel,
        lookback: _historicalBars.length,
        predLen: _predLen,
        hfToken: appSettings.hfToken,
        remoteUrl: appSettings.kronosRemoteUrl.isNotEmpty ? appSettings.kronosRemoteUrl : null,
      );

      if (mounted) {
        setState(() {
          _forecastBars = result;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _errorMsg = e.toString());
    } finally {
      _progressTimer?.cancel();
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
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    const Icon(Icons.blur_linear, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Kronos KI Prognose",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(widget.symbol,
                              style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    DropdownButton<String>(
                      value: _selectedModel,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: "mini", child: Text("Mini Modell", style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: "small", child: Text("Small Modell", style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: "base", child: Text("Base Modell", style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedModel = val);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _isLoading ? null : _runForecast,
                      icon: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.play_arrow, color: Colors.green),
                      tooltip: "Prognose starten",
                    ),
                  ],
                ),
              ),
              ExpansionTile(
                title: const Text("Erweiterte Einstellungen", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                children: [
                  _buildSliderRow("Prognose (Tage)", _predLen.toDouble(), 10, 180, (v) => setState(() => _predLen = v.toInt())),
                  _buildSliderRow("Modell Kontext / Vorlauf (Tage)", _lookback.toDouble(), 30, 512, (v) => setState(() => _lookback = v.toInt())),
                  _buildSliderRow("Chart Historie Anzeige (Tage)", _chartHistory.toDouble(), 10, 365, (v) => setState(() => _chartHistory = v.toInt())),
                ],
              ),
              const Divider(),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(value: _progress > 0 ? _progress : null),
                          const SizedBox(height: 16),
                          Text(_progress > 0 ? "Berechne Prognose... ${(_progress * 100).toInt()}%" : "Kronos Modell generiert Prognose...", style: const TextStyle(color: Colors.grey)),
                          const Text("Erster Start kann wegen Model-Download länger dauern.", style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ))
                    : _errorMsg.isNotEmpty
                        ? Center(child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("Fehler: $_errorMsg", style: const TextStyle(color: Colors.red)),
                          ))
                        : _forecastBars.isNotEmpty
                            ? ListView(
                                controller: scrollCtrl,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                children: [
                                  const SizedBox(height: 16),
                                  const Text("Voraussichtlicher Preisverlauf", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    height: 350,
                                    child: _buildChart(),
                                  ),
                                  const SizedBox(height: 24),
                                  _buildSummaryCards(),
                                ])
                            : const Center(child: Text("Drücke den Start-Button für eine Prognose")),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChart() {
    if (_historicalBars.isEmpty || _forecastBars.isEmpty) return const SizedBox();

    final displayHistory = _historicalBars.sublist(_historicalBars.length > _chartHistory ? _historicalBars.length - _chartHistory : 0);
    
    double minY = displayHistory.first.low;
    double maxY = displayHistory.first.high;
    for (var c in displayHistory) {
      if (c.low < minY) minY = c.low;
      if (c.high > maxY) maxY = c.high;
    }
    for (var c in _forecastBars) {
      if (c.low < minY) minY = c.low;
      if (c.high > maxY) maxY = c.high;
    }
    
    double padding = (maxY - minY) * 0.1;
    minY -= padding;
    maxY += padding;

    List<FlSpot> histSpots = [];
    for (int i = 0; i < displayHistory.length; i++) {
      histSpots.add(FlSpot(i.toDouble(), displayHistory[i].close));
    }

    List<FlSpot> forecastSpots = [];
    List<FlSpot> forecastUpperSpots = [];
    List<FlSpot> forecastLowerSpots = [];
    
    int offset = displayHistory.length;
    forecastSpots.add(FlSpot((offset - 1).toDouble(), displayHistory.last.close));
    forecastUpperSpots.add(FlSpot((offset - 1).toDouble(), displayHistory.last.close));
    forecastLowerSpots.add(FlSpot((offset - 1).toDouble(), displayHistory.last.close));
    
    for (int i = 0; i < _forecastBars.length; i++) {
      forecastSpots.add(FlSpot((offset + i).toDouble(), _forecastBars[i].close));
      forecastUpperSpots.add(FlSpot((offset + i).toDouble(), _forecastBars[i].high));
      forecastLowerSpots.add(FlSpot((offset + i).toDouble(), _forecastBars[i].low));
    }

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 9)),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: 10,
              getTitlesWidget: (value, meta) {
                if (value == offset - 1) return const Text("Heute", style: TextStyle(fontSize: 9, color: Colors.blueAccent));
                return Text("T+${(value - offset + 1).toInt()}", style: const TextStyle(fontSize: 9));
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.white10)),
        betweenBarsData: [
          BetweenBarsData(
            fromIndex: 1, 
            toIndex: 2, 
            color: Colors.blueAccent.withOpacity(0.15),
          ),
        ],
        lineBarsData: [
          LineChartBarData(
            spots: histSpots,
            isCurved: true,
            color: Colors.white70,
            barWidth: 2,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: forecastUpperSpots,
            isCurved: true,
            color: Colors.transparent,
            barWidth: 0,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: forecastLowerSpots,
            isCurved: true,
            color: Colors.transparent,
            barWidth: 0,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: forecastSpots,
            isCurved: true,
            color: Colors.blueAccent,
            barWidth: 2,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    double startPrice = _historicalBars.last.close;
    double endPrice = _forecastBars.last.close;
    double change = ((endPrice - startPrice) / startPrice) * 100;
    
    double maxTarget = _forecastBars.map((e) => e.high).reduce((a, b) => a > b ? a : b);
    double minTarget = _forecastBars.map((e) => e.low).reduce((a, b) => a < b ? a : b);

    return Row(
      children: [
        _statCard("Aktuell", _fmt(startPrice), Colors.white70),
        _statCard("Ziel (T+${_predLen})", _fmt(endPrice), change >= 0 ? Colors.green : Colors.red),
        _statCard("Δ", "${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}%", change >= 0 ? Colors.green : Colors.red),
        _statCard("Max Hoch", _fmt(maxTarget), Colors.green),
        _statCard("Min Tief", _fmt(minTarget), Colors.red),
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
              Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
              const SizedBox(height: 2),
              FittedBox(
                child: Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmt(double val) {
    if (val >= 1000) return "${(val).toStringAsFixed(1)}";
    return val.toStringAsFixed(2);
  }

  Widget _buildSliderRow(String label, double val, double min, double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            Text("${val.toInt()}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        Slider(
          value: val,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
