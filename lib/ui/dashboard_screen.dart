import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../l10n/l10n_extension.dart';
import '../l10n/enum_localizations.dart';
import 'chart_widget.dart';
import 'score_details_screen.dart';
import 'settings_screen.dart';
import 'pattern_details_screen.dart';
import 'fundamental_analysis_screen.dart';
import 'news_screen.dart';
import 'bot_dashboard_screen.dart';
import 'monte_carlo_screen.dart';
import 'kronos_forecast_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchCtrl = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final p = context.read<AppProvider>();
    _searchCtrl.text = p.symbol;

    Future.microtask(() => p.fetchData());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final data = provider.computedData;

    // Wir nutzen ein Scaffold für die Hauptnavigation.
    // Wenn wir im "Analyse" Tab sind (Index 0), zeigen wir die AppBar hier.
    // Bei Bot (1) und Settings (2) lassen wir die Child-Widgets ihre eigene AppBar/Scaffold haben.
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const Text(""),
              elevation: 0,
              scrolledUnderElevation: 2,
            )
          : null, // Kein AppBar für Bot/Settings hier, die haben eigene
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Tab 0: Analyse Dashboard
          _buildAnalyseTab(context, provider, data),
          // Tab 1: AutoTrader Bot
          const BotDashboardScreen(),
          // Tab 2: Einstellungen
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.analytics_outlined),
              selectedIcon: const Icon(Icons.analytics),
              label: context.l10n.navAnalysis),
          NavigationDestination(
              icon: const Icon(Icons.smart_toy_outlined),
              selectedIcon: const Icon(Icons.smart_toy),
              label: context.l10n.navAutoBot),
          NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: context.l10n.navSettings),
        ],
      ),
    );
  }

  Widget _buildAnalyseTab(
      BuildContext context, AppProvider provider, ComputedData? data) {
    return SafeArea(
      child: Column(
        children: [
          // Suche & Zeitraum
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor ??
                  Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.1))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                            hintText: context.l10n.searchHint,
                            prefixIcon: const Icon(Icons.search),
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)))),
                        onSubmitted: (v) {
                          provider.setSymbol(v);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // NEU: Intervall- und Range-Auswahl
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Intervall-Auswahl
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 6.0,
                        children: TimeFrame.values.map((interval) {
                          final isSelected =
                              provider.selectedTimeFrame == interval;
                          return ChoiceChip(
                            label: Text(interval.label(context)),
                            labelStyle: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : null),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              if (selected) {
                                provider.setTimeFrame(interval);
                              }
                            },
                            selectedColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                      ),
                    ),
                    // Chart-Range Dropdown
                    DropdownButton<ChartRange>(
                      underline: Container(),
                      icon: const Icon(Icons.date_range),
                      value: provider.selectedChartRange,
                      onChanged: (v) => provider.setChartRange(v!),
                      items: [
                        DropdownMenuItem(
                            value: ChartRange.week1, child: Text(context.l10n.range1W)),
                        DropdownMenuItem(
                            value: ChartRange.month1, child: Text(context.l10n.range1M)),
                        DropdownMenuItem(
                            value: ChartRange.quarter1, child: Text(context.l10n.range3M)),
                        DropdownMenuItem(
                            value: ChartRange.year1, child: Text(context.l10n.range1Y)),
                        DropdownMenuItem(
                            value: ChartRange.year2, child: Text(context.l10n.range2Y)),
                        DropdownMenuItem(
                            value: ChartRange.year3, child: Text(context.l10n.range3Y)),
                        DropdownMenuItem(
                            value: ChartRange.year5, child: Text(context.l10n.range5Y)),
                      ],
                    )
                  ],
                ),
                // History Chips
                if (provider.searchHistory.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: 30,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.searchHistory.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final sym = provider.searchHistory[index];
                          return ActionChip(
                            label:
                                Text(sym, style: const TextStyle(fontSize: 10)),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              _searchCtrl.text = sym;
                              provider.setSymbol(sym);
                            },
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),

          if (provider.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (provider.error != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: SingleChildScrollView(
                          child: Text(context.l10n.errorPrefix(provider.error!),
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchData(),
                      child: Text(context.l10n.retryButton),
                    )
                  ],
                ),
              ),
            )
          else ...[
            // --- Hauptchart ---
            const Expanded(flex: 5, child: ChartWidget()),

            // --- Fundamentalanalyse Button ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FundamentalAnalysisScreen(
                                    symbol: provider.yahooSymbol,
                                    apiKey: provider.settings.fmpKey ?? "")));
                      },
                      icon: const Icon(Icons.analytics_outlined, size: 18),
                      label: Text(context.l10n.fundamentals),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    NewsScreen(symbol: provider.yahooSymbol)));
                      },
                      icon: const Icon(Icons.newspaper, size: 18),
                      label: Text(context.l10n.newsYahoo),
                    ),
                  ),
                ],
              ),
            ),

            // --- Monte Carlo & Kronos Prognose ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () => showMonteCarloSheet(context, provider.symbol),
                      icon: const Icon(Icons.query_stats, size: 18),
                      label: FittedBox(child: Text(context.l10n.monteCarlo)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () => showKronosForecastSheet(context, provider.symbol),
                      icon: const Icon(Icons.blur_linear, size: 18),
                      label: FittedBox(child: Text(context.l10n.kronosAi)),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blueAccent.withOpacity(0.2),
                        foregroundColor: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Scoreboard ---
            SizedBox(
              height: 120,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ],
                  border: Border.all(
                      color: Theme.of(context).dividerColor.withOpacity(0.1)),
                ),
                child: data?.latestSignal == null
                    ? Center(child: Text(context.l10n.noAnalysis))
                    : Row(
                        children: [
                          // Linke Seite: Score & Typ
                          Expanded(
                            flex: 4,
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const ScoreDetailsScreen())),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.layers_outlined,
                                          size: 12, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                          data!.latestSignal!.marketRegime
                                                  ?.label(context) ??
                                              context.l10n.unknown,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600])),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(context.l10n.tradingScore,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  // Fix für RenderFlex Overflow: FittedBox skaliert den Inhalt herunter, wenn er zu breit ist
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text("${data.latestSignal!.score}",
                                            style: const TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold)),
                                        const Text("/100",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                height: 2)),
                                        const SizedBox(width: 8),
                                        if (data.latestSignal!.aiConfidence !=
                                            null)
                                          Column(
                                            children: [
                                              Text(context.l10n.aiConfidence,
                                                  style: const TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.blueGrey)),
                                              Text(
                                                  "${(data.latestSignal!.aiConfidence! * 100).toStringAsFixed(0)}%",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.blueAccent)),
                                            ],
                                          ),
                                        const SizedBox(width: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                              color: (data.latestSignal!.type
                                                          .contains("Buy")
                                                      ? Colors.green
                                                      : (data.latestSignal!.type
                                                              .contains("Sell")
                                                          ? Colors.red
                                                          : Colors.grey))
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Text(
                                              data.latestSignal!.type
                                                  .replaceAll(" ", "\n"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.1,
                                                  color: data.latestSignal!.type
                                                          .contains("Buy")
                                                      ? Colors.green
                                                      : (data.latestSignal!.type
                                                              .contains("Sell")
                                                          ? Colors.red
                                                          : Colors.grey))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Mitte: Trade Levels (Entry, SL, TP)
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildCompactRow(
                                      context.l10n.entry,
                                      data.latestSignal!.entryPrice,
                                      Colors.blue),
                                  _buildCompactRow(context.l10n.stopLossShort,
                                      data.latestSignal!.stopLoss, Colors.red,
                                      isOptimized:
                                          data.latestSignal!.optimizedParams !=
                                              null),
                                  _buildCompactRow(
                                      context.l10n.takeProfit1Short,
                                      data.latestSignal!.takeProfit1,
                                      Colors.green,
                                      isOptimized:
                                          data.latestSignal!.optimizedParams !=
                                              null),
                                  _buildCompactRow(
                                      context.l10n.takeProfit2Short,
                                      data.latestSignal!.takeProfit2,
                                      Colors.green.withOpacity(0.7),
                                      isOptimized:
                                          data.latestSignal!.optimizedParams !=
                                              null),
                                ],
                              ),
                            ),
                          ),
                          // Rechte Seite: Muster (Klickbar für Erklärung)
                          Builder(builder: (context) {
                            // Kerzenmuster hat Vorrang, sonst Divergenz anzeigen
                            String pattern = data.latestSignal!.chartPattern;
                            final divType = data.latestSignal!
                                        .indicatorValues?['divergence']
                                    as String? ??
                                'none';
                            final hasCandlePattern =
                                pattern.isNotEmpty && pattern != 'Kein Muster' && pattern != context.l10n.noPattern;
                            if (!hasCandlePattern && divType != 'none') {
                              pattern = divType == 'bullish'
                                  ? context.l10n.bullishDivergence
                                  : context.l10n.bearishDivergence;
                            }
                            final hasPattern =
                                pattern.isNotEmpty && pattern != 'Kein Muster' && pattern != 'No Pattern' && pattern != context.l10n.noPattern;
                            final bullishKeywords = [
                              'Bullish',
                              'Hammer',
                              'Morning',
                              'Soldier',
                              'Piercing',
                              'Doji'
                            ];
                            final isBullish = bullishKeywords
                                .any((kw) => pattern.contains(kw));
                            final patternColor = !hasPattern
                                ? Colors.grey
                                : (isBullish ? Colors.green : Colors.red);
                            return InkWell(
                              onTap: hasPattern
                                  ? () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => PatternDetailsScreen(
                                              patternName: pattern)))
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 100,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: patternColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: patternColor.withOpacity(0.3),
                                        width: 0.5)),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        hasPattern
                                            ? Icons.candlestick_chart
                                            : Icons.candlestick_chart_outlined,
                                        size: 24,
                                        color: patternColor,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(hasPattern ? pattern : context.l10n.noPattern,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: hasPattern
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: patternColor),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
              ),
            ),

            // --- MC Outlook Bar ---
            if (data?.latestSignal?.indicatorValues != null)
              Builder(builder: (context) {
                final mcBull = (data!.latestSignal!
                            .indicatorValues?['mc_bull_pct'] as num?)
                        ?.toDouble() ??
                    50;
                final mcBear = 100 - mcBull;
                String mcLabel;
                Color mcColor;
                IconData mcIcon;
                if (mcBull >= 65) {
                  mcLabel = context.l10n.mcBullish;
                  mcColor = Colors.green;
                  mcIcon = Icons.trending_up;
                } else if (mcBull >= 55) {
                  mcLabel = context.l10n.mcSlightlyBullish;
                  mcColor = Colors.lightGreen;
                  mcIcon = Icons.trending_up;
                } else if (mcBear >= 65) {
                  mcLabel = context.l10n.mcBearish;
                  mcColor = Colors.red;
                  mcIcon = Icons.trending_down;
                } else if (mcBear >= 55) {
                  mcLabel = context.l10n.mcSlightlyBearish;
                  mcColor = Colors.orange;
                  mcIcon = Icons.trending_down;
                } else {
                  mcLabel = context.l10n.mcNeutral;
                  mcColor = Colors.amber;
                  mcIcon = Icons.trending_flat;
                }
                return GestureDetector(
                  onTap: () => showMonteCarloSheet(context, provider.symbol),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: mcColor.withOpacity(0.1),
                      border: Border.all(
                          color: mcColor.withOpacity(0.3), width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Icon(mcIcon, color: mcColor, size: 16),
                        const SizedBox(width: 6),
                        Text("MC: ${mcLabel}",
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: mcColor)),
                        const Spacer(),
                        // Mini Bull/Bear bar
                        SizedBox(
                          width: 80,
                          height: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: mcBull.round().clamp(1, 99),
                                    child: Container(color: Colors.green)),
                                Expanded(
                                    flex: mcBear.round().clamp(1, 99),
                                    child: Container(color: Colors.red)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text("${mcBull.toStringAsFixed(0)}%",
                            style: TextStyle(
                                fontSize: 10,
                                color: mcColor,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        Icon(Icons.open_in_new,
                            size: 12, color: mcColor.withOpacity(0.6)),
                      ],
                    ),
                  ),
                );
              }),

            // --- MTC Status Bar ---
            if (data?.latestSignal?.indicatorValues != null &&
                (data!.latestSignal!.indicatorValues!['mtc_confirmed'] == true))
              Builder(builder: (context) {
                final sig = data.latestSignal!;
                final mtcTrend =
                    sig.indicatorValues!['mtc_trend'] as String? ?? "neutral";
                Color mtcColor = Colors.grey;
                IconData mtcIcon = Icons.unfold_more;
                String mtcText = context.l10n.mtcNeutral;

                if (mtcTrend == "bullish") {
                  mtcColor = Colors.cyanAccent;
                  mtcIcon = Icons.verified;
                  mtcText = context.l10n.mtcBullishConfirmed;
                } else if (mtcTrend == "bearish") {
                  mtcColor = Colors.orangeAccent;
                  mtcIcon = Icons.verified;
                  mtcText = context.l10n.mtcBearishConfirmed;
                }

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: mtcColor.withOpacity(0.1),
                    border: Border.all(
                        color: mtcColor.withOpacity(0.3), width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Icon(mtcIcon, color: mtcColor, size: 14),
                      const SizedBox(width: 6),
                      Text(mtcText,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: mtcColor)),
                      const Spacer(),
                      const Icon(Icons.info_outline,
                          color: Colors.white24, size: 12),
                    ],
                  ),
                );
              }),

            // --- Kronos AI Forecast Block ---
            if (provider.isKronosLoading || provider.kronosResult != null)
              _buildKronosBlock(context, provider),

            // --- Indikator Charts ---
            if (data != null) ...[
              // Volumen
              if (provider.settings.showVolume)
                Expanded(
                    flex: 2,
                    child: _buildIndicatorWrapper(
                        context,
                        context.l10n.volume,
                        _formatVolume(data.bars.last.volume),
                        _buildVolumeChart(data))),

              // RSI
              if (provider.settings.showRSI)
                Expanded(
                    flex: 2,
                    child: _buildIndicatorWrapper(context, "RSI (14)",
                        _formatRsi(context, data.rsi.last), _buildRSIChart(data))),

              // MACD
              if (provider.settings.showMACD)
                Expanded(
                    flex: 2,
                    child: _buildIndicatorWrapper(
                        context,
                        "MACD",
                        _formatMacd(context, data.macdHist.last),
                        _buildMACDChart(data))),

              // Stochastic
              if (provider.settings.showStochastic)
                Expanded(
                    flex: 2,
                    child: _buildIndicatorWrapper(
                        context,
                        "Stochastic",
                        _formatStochastic(context, data.stochK.last),
                        _buildStochasticChart(data))),

              // OBV
              if (provider.settings.showOBV)
                Expanded(
                    flex: 2,
                    child: _buildIndicatorWrapper(context, "On-Balance Volume",
                        _formatObv(data.obv.last), _buildOBVChart(data))),

              // ADX (Neu)
              if (provider.settings.showAdx)
                Expanded(
                    flex: 2,
                    child: _buildIndicatorWrapper(
                        context,
                        context.l10n.adxTrendStrength,
                        "${data.adx.last?.toStringAsFixed(1)}",
                        _buildADXChart(data))),
            ],
          ],
        ],
      ),
    );
  }

  String _formatVolume(int v) {
    if (v > 1000000) return "${(v / 1000000).toStringAsFixed(2)}M";
    if (v > 1000) return "${(v / 1000).toStringAsFixed(1)}k";
    return "$v";
  }

  String _formatRsi(BuildContext context, double? rsi) {
    if (rsi == null) return "-";
    String status = context.l10n.neutral;
    if (rsi > 70) status = context.l10n.overbought;
    if (rsi < 30) status = context.l10n.oversold;
    return "${rsi.toStringAsFixed(1)} ($status)";
  }

  String _formatMacd(BuildContext context, double? hist) {
    if (hist == null) return "-";
    String status = hist > 0 ? context.l10n.positive : context.l10n.negative;
    return "${hist.toStringAsFixed(4)} ($status)";
  }

  String _formatStochastic(BuildContext context, double? k) {
    if (k == null) return "-";
    String status = context.l10n.neutral;
    if (k > 80) status = context.l10n.overbought;
    if (k < 20) status = context.l10n.oversold;
    return "${k.toStringAsFixed(1)} ($status)";
  }

  String _formatObv(double? v) {
    if (v == null) return "-";
    if (v.abs() > 1000000) return "${(v / 1000000).toStringAsFixed(2)}M";
    if (v.abs() > 1000) return "${(v / 1000).toStringAsFixed(1)}k";
    return v.toStringAsFixed(0);
  }

  Widget _buildProbabilityBar(String label, double prob, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: prob,
                backgroundColor: color.withOpacity(0.1),
                color: color,
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text("${(prob * 100).toInt()}%", textAlign: TextAlign.right, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildKronosBlock(BuildContext context, AppProvider provider) {
    if (!provider.isKronosLoading && provider.kronosResult == null) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () => showKronosForecastSheet(context, provider.symbol),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blueAccent.withOpacity(0.05),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.2), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.blur_linear, color: Colors.blueAccent, size: 16),
                const SizedBox(width: 6),
                Text(context.l10n.kronosAiAnalysis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                const Spacer(),
                const Icon(Icons.open_in_new, size: 12, color: Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 8),
            if (provider.isKronosLoading) ...[
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: provider.kronosProgress > 0 ? provider.kronosProgress : null,
                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                      color: Colors.blueAccent,
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text("${(provider.kronosProgress * 100).toInt()}%", style: const TextStyle(fontSize: 10, color: Colors.blueAccent)),
                ],
              ),
              const SizedBox(height: 4),
              Text(context.l10n.modelCalculatingForecast, style: const TextStyle(fontSize: 9, color: Colors.grey)),
            ] else if (provider.kronosResult != null) ...[
              _buildProbabilityBar(context.l10n.tp1HitChance, provider.kronosResult!.tp1Probability, Colors.green),
              _buildProbabilityBar(context.l10n.tp2HitChance, provider.kronosResult!.tp2Probability, Colors.greenAccent),
              _buildProbabilityBar(context.l10n.slHitChance, provider.kronosResult!.slProbability, Colors.red),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactRow(String label, double val, Color color,
      {bool isOptimized = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 10, color: Colors.grey)),
              if (isOptimized)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(context.l10n.optimizedLabel,
                      style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent.withOpacity(0.8))),
                ),
            ],
          ),
          Text(val.toStringAsFixed(2),
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildIndicatorWrapper(
      BuildContext context, String title, String value, Widget chart) {
    return GestureDetector(
      onTap: () {
        // Fullscreen Chart Dialog
        showDialog(
          context: context,
          builder: (ctx) => Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 400,
              child: Column(
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("${context.l10n.currentValue(value)}",
                      style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 16),
                  Expanded(child: chart),
                  const SizedBox(height: 16),
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(context.l10n.close))
                ],
              ),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Row(children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
              const SizedBox(width: 8),
              Text(value,
                  style: const TextStyle(
                      fontSize: 12,
                      fontFamily: "monospace",
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.fullscreen, size: 14, color: Colors.grey),
            ]),
          ),
          Expanded(child: chart),
        ],
      ),
    );
  }

  Widget _buildVolumeChart(ComputedData data) {
    final bars = data.bars;
    // Wir nehmen nicht das absolute Max, um Ausreißer abzufedern, oder wir cappen es.
    double maxV = 0;
    for (var b in bars) if (b.volume > maxV) maxV = b.volume.toDouble();
    if (maxV == 0) maxV = 100;

    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.black12,
      child: BarChart(
        BarChartData(
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(bars.length, (i) {
            final isUp = bars[i].close >= bars[i].open;
            return BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                toY: bars[i].volume.toDouble(),
                color: isUp
                    ? Colors.green.withOpacity(0.5)
                    : Colors.red.withOpacity(0.5),
                width: 2,
              )
            ]);
          }),
          maxY: maxV,
        ),
      ),
    );
  }

  Widget _buildRSIChart(ComputedData data) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.black12,
      child: LineChart(
        LineChartData(
            titlesData: const FlTitlesData(show: false),
            gridData: const FlGridData(
                show: true, drawVerticalLine: false, horizontalInterval: 30),
            borderData: FlBorderData(
                show: true, border: Border.all(color: Colors.white10)),
            minY: 0,
            maxY: 100,
            lineBarsData: [
              LineChartBarData(
                  spots: List.generate(data.rsi.length,
                      (i) => FlSpot(i.toDouble(), data.rsi[i] ?? 50)),
                  color: Colors.purpleAccent,
                  dotData: const FlDotData(show: false),
                  barWidth: 1)
            ],
            extraLinesData: ExtraLinesData(horizontalLines: [
              HorizontalLine(
                  y: 70,
                  color: Colors.red.withOpacity(0.5),
                  strokeWidth: 1,
                  dashArray: [5, 5]),
              HorizontalLine(
                  y: 30,
                  color: Colors.green.withOpacity(0.5),
                  strokeWidth: 1,
                  dashArray: [5, 5]),
            ])),
      ),
    );
  }

  Widget _buildMACDChart(ComputedData data) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.black12,
      child: LineChart(
        LineChartData(
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(
              show: true, border: Border.all(color: Colors.white10)),
          lineBarsData: [
            LineChartBarData(
                spots: List.generate(data.macd.length,
                    (i) => FlSpot(i.toDouble(), data.macd[i] ?? 0)),
                color: Colors.blue,
                dotData: const FlDotData(show: false),
                barWidth: 1),
            LineChartBarData(
                spots: List.generate(data.macdSignal.length,
                    (i) => FlSpot(i.toDouble(), data.macdSignal[i] ?? 0)),
                color: Colors.orange,
                dotData: const FlDotData(show: false),
                barWidth: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildStochasticChart(ComputedData data) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.black12,
      child: LineChart(
        LineChartData(
            titlesData: const FlTitlesData(show: false),
            gridData: const FlGridData(
                show: true, drawVerticalLine: false, horizontalInterval: 40),
            borderData: FlBorderData(
                show: true, border: Border.all(color: Colors.white10)),
            minY: 0,
            maxY: 100,
            lineBarsData: [
              // %K line
              LineChartBarData(
                  spots: List.generate(data.stochK.length,
                      (i) => FlSpot(i.toDouble(), data.stochK[i] ?? 50)),
                  color: Colors.cyan,
                  dotData: const FlDotData(show: false),
                  barWidth: 1),
              // %D line
              LineChartBarData(
                  spots: List.generate(data.stochD.length,
                      (i) => FlSpot(i.toDouble(), data.stochD[i] ?? 50)),
                  color: Colors.amber,
                  dotData: const FlDotData(show: false),
                  barWidth: 1),
            ],
            extraLinesData: ExtraLinesData(horizontalLines: [
              HorizontalLine(
                  y: 80,
                  color: Colors.red.withOpacity(0.5),
                  strokeWidth: 1,
                  dashArray: [5, 5]),
              HorizontalLine(
                  y: 20,
                  color: Colors.green.withOpacity(0.5),
                  strokeWidth: 1,
                  dashArray: [5, 5]),
            ])),
      ),
    );
  }

  Widget _buildOBVChart(ComputedData data) {
    // OBV can have large values, so we don't set min/max Y
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.black12,
      child: LineChart(
        LineChartData(
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(
              show: true, border: Border.all(color: Colors.white10)),
          lineBarsData: [
            LineChartBarData(
                spots: List.generate(data.obv.length,
                    (i) => FlSpot(i.toDouble(), data.obv[i] ?? 0)),
                color: Colors.lightGreenAccent,
                dotData: const FlDotData(show: false),
                barWidth: 1)
          ],
        ),
      ),
    );
  }

  Widget _buildADXChart(ComputedData data) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.black12,
      child: LineChart(
        LineChartData(
            titlesData: const FlTitlesData(show: false),
            gridData: const FlGridData(
                show: true, drawVerticalLine: false, horizontalInterval: 25),
            borderData: FlBorderData(
                show: true, border: Border.all(color: Colors.white10)),
            minY: 0,
            maxY: 60, // ADX geht selten über 60
            lineBarsData: [
              LineChartBarData(
                  spots: List.generate(data.adx.length,
                      (i) => FlSpot(i.toDouble(), data.adx[i] ?? 0)),
                  color: Colors.blueAccent,
                  dotData: const FlDotData(show: false),
                  barWidth: 2)
            ],
            extraLinesData: ExtraLinesData(horizontalLines: [
              HorizontalLine(
                  y: 25,
                  color: Colors.white54,
                  strokeWidth: 1,
                  dashArray: [5, 5]), // Trend-Schwelle
            ])),
      ),
    );
  }
}
