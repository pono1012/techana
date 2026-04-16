import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../providers/app_provider.dart';
import '../l10n/l10n_extension.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final s = provider.settings;
    final l = context.l10n;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.settings),
          bottom: TabBar(
            tabs: [
              Tab(text: l.tabView, icon: const Icon(Icons.visibility)),
              Tab(text: l.tabChart, icon: const Icon(Icons.show_chart)),
              Tab(text: l.tabStrategy, icon: const Icon(Icons.settings_applications)),
              Tab(text: l.tabData, icon: const Icon(Icons.data_usage)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: View & General
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildGroupCard(context, l.viewAndGeneral, [
                  SwitchListTile(
                    title: Text(l.darkTheme),
                    value: provider.themeMode == ThemeMode.dark,
                    onChanged: (_) => provider.toggleTheme(),
                  ),
                  SwitchListTile(
                    title: Text(l.showCandlesticks),
                    subtitle: Text(l.showCandlesticksSubtitle),
                    value: s.showCandles,
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(showCandles: v)),
                  ),
                  SwitchListTile(
                    title: Text(l.patternMarkers),
                    value: s.showPatternMarkers,
                    onChanged: (v) => provider
                        .updateSettings(s.copyWith(showPatternMarkers: v)),
                  ),
                  SwitchListTile(
                    title: Text(l.tradingLines),
                    value: s.showTradeLines,
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(showTradeLines: v)),
                  ),
                ]),
                const SizedBox(height: 16),
                _buildGroupCard(context, l.language, [
                  ListTile(
                    title: Text(l.language),
                    trailing: DropdownButton<String>(
                      value: s.languageCode,
                      onChanged: (v) {
                        if (v != null) {
                          provider.updateSettings(s.copyWith(languageCode: v));
                        }
                      },
                      underline: Container(),
                      items: [
                        DropdownMenuItem(value: 'system', child: Text(l.systemLanguage)),
                        const DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                        const DropdownMenuItem(value: 'en', child: Text('English')),
                      ],
                    ),
                  ),
                ]),
              ],
            ),

            // Tab 2: Chart (Indicators)
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildGroupCard(context, l.chartIndicators, [
                  SwitchListTile(
                    title: Text(l.ema20Line),
                    value: s.showEMA,
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(showEMA: v)),
                  ),
                  SwitchListTile(
                    title: Text(l.bollingerBands),
                    value: s.showBB,
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(showBB: v)),
                  ),
                  _sliderTile(
                      l.projectionDays,
                      s.projectionDays.toDouble(),
                      5,
                      90,
                      (v) => provider.updateSettings(
                          s.copyWith(projectionDays: v.toInt()))),
                ]),
                const SizedBox(height: 16),
                _buildGroupCard(context, l.additionalCharts, [
                  SwitchListTile(
                    title: Text(l.volumeChart),
                    value: s.showVolume,
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(showVolume: v)),
                  ),
                  SwitchListTile(
                    title: Text(l.rsiIndicator),
                    value: s.showRSI,
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(showRSI: v)),
                  ),
                  SwitchListTile(
                    title: Text(l.macdIndicator),
                    value: s.showMACD,
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(showMACD: v)),
                  ),
                  SwitchListTile(
                    title: Text(l.stochasticOscillator),
                    value: s.showStochastic,
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(showStochastic: v)),
                  ),
                  SwitchListTile(
                    title: Text(l.obvIndicator),
                    value: s.showOBV,
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(showOBV: v)),
                  ),
                  SwitchListTile(
                    title: Text(l.adxIndicator),
                    value: s.showAdx,
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(showAdx: v)),
                  ),
                ]),
              ],
            ),

            // Tab 3: Strategy
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildGroupCard(context, l.manualAnalysisStrategy, [
                  _dropdownTile<int>(
                    l.entryStrategy,
                    s.entryStrategy,
                    {
                      0: l.marketImmediate,
                      1: l.pullbackLimit,
                      2: l.breakoutStop,
                    },
                    (v) =>
                        provider.updateSettings(s.copyWith(entryStrategy: v)),
                    subtitle: l.entryStrategyDesc,
                  ),
                  if (s.entryStrategy != 0) ...[
                    _dropdownTile<int>(
                      l.entryPaddingType,
                      s.entryPaddingType,
                      {0: l.percentual, 1: l.atrFactor},
                      (v) => provider
                          .updateSettings(s.copyWith(entryPaddingType: v)),
                    ),
                    _sliderTile(
                      s.entryPaddingType == 0
                          ? l.entryPaddingPercent
                          : l.entryPaddingAtr,
                      s.entryPadding,
                      0.1,
                      s.entryPaddingType == 0 ? 2.0 : 5.0,
                      (v) =>
                          provider.updateSettings(s.copyWith(entryPadding: v)),
                      desc: l.entryPaddingDesc,
                    ),
                  ],
                  const Divider(),
                  _dropdownTile<int>(
                    l.stopLossMethod,
                    s.stopMethod,
                    {
                      0: l.donchianLow,
                      1: l.percentualMethod,
                      2: l.atrVolatility,
                      3: l.swingLowHigh,
                    },
                    (v) => provider.updateSettings(s.copyWith(stopMethod: v)),
                    subtitle: l.stopLossDesc,
                  ),
                  if (s.stopMethod == 1)
                    _sliderTile(
                        l.stopLossPercent,
                        s.stopPercent,
                        1,
                        20,
                        (v) =>
                            provider.updateSettings(s.copyWith(stopPercent: v)),
                        desc: l.stopLossPercentDesc),
                  if (s.stopMethod == 2 || s.tpMethod == 2)
                    _sliderTile(l.atrMultiplier, s.atrMult, 1, 5,
                        (v) => provider.updateSettings(s.copyWith(atrMult: v)),
                        desc: l.atrMultiplierDesc),
                  if (s.stopMethod == 3)
                    _sliderTile(
                        l.swingLookbackCandles,
                        s.swingLookback.toDouble(),
                        5,
                        50,
                        (v) => provider.updateSettings(
                            s.copyWith(swingLookback: v.toInt())),
                        desc: l.swingLookbackDesc),
                  const Divider(),
                  _dropdownTile<int>(
                    l.takeProfitMethod,
                    s.tpMethod,
                    {
                      0: l.riskRewardCrv,
                      1: l.percentualMethod,
                      2: l.atrTarget,
                      3: l.pivotPoints,
                    },
                    (v) => provider.updateSettings(s.copyWith(tpMethod: v)),
                    subtitle: l.takeProfitDesc,
                  ),
                  if (s.tpMethod == 0 || s.tpMethod == 2) ...[
                    _sliderTile(l.tp1Factor, s.rrTp1, 1, 5,
                        (v) => provider.updateSettings(s.copyWith(rrTp1: v)),
                        desc: l.tp1FactorDesc),
                    _sliderTile(l.tp2Factor, s.rrTp2, 2, 10,
                        (v) => provider.updateSettings(s.copyWith(rrTp2: v)),
                        desc: l.tp2FactorDesc),
                  ],
                  if (s.tpMethod == 1) ...[
                    _sliderTile(
                        l.tp1Percent,
                        s.tpPercent1,
                        1,
                        20,
                        (v) =>
                            provider.updateSettings(s.copyWith(tpPercent1: v)),
                        desc: l.tp1PercentDesc),
                    _sliderTile(
                        l.tp2Percent,
                        s.tpPercent2,
                        2,
                        50,
                        (v) =>
                            provider.updateSettings(s.copyWith(tpPercent2: v)),
                        desc: l.tp2PercentDesc),
                  ],
                  const Divider(),
                  _sliderTile(
                      l.mcSimulations,
                      s.mcSimulations.toDouble(),
                      50,
                      1000,
                      (v) => provider
                          .updateSettings(s.copyWith(mcSimulations: v.toInt())),
                      desc: l.mcSimulationsDesc),
                  const SizedBox(height: 12),
                  Center(
                      child: TextButton.icon(
                    icon: const Icon(Icons.restore),
                    label: Text(l.resetToDefaults),
                    onPressed: () => provider.resetStrategySettings(),
                  )),
                ]),
                const SizedBox(height: 16),
                _buildGroupCard(context, l.expertFeaturesAi, [
                  SwitchListTile(
                    title: Text(l.marketRegimeFilter),
                    subtitle: Text(l.marketRegimeSubtitle),
                    value: s.useMarketRegime,
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(useMarketRegime: v)),
                  ),
                  SwitchListTile(
                    title: Text(l.aiProbabilityScoring),
                    subtitle: Text(l.aiProbabilitySubtitle),
                    value: s.useAiProbability,
                    onChanged: (v) => provider
                        .updateSettings(s.copyWith(useAiProbability: v)),
                  ),
                  SwitchListTile(
                    title: Text(l.multiTimeframeMtc),
                    subtitle: Text(l.mtcSubtitle),
                    value: s.useMtc,
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(useMtc: v)),
                  ),
                  SwitchListTile(
                    title: Text(l.strategyOptimizer),
                    subtitle: Text(l.strategyOptimizerSubtitle),
                    value: s.useStrategyOptimizer,
                    onChanged: (v) => provider
                        .updateSettings(s.copyWith(useStrategyOptimizer: v)),
                  ),
                ]),
              ],
            ),

            // Tab 4: Data & Info
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildGroupCard(context, l.dataSources, [
                  Text(l.chartDataSource),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      labelText: l.alphaVantageLabel,
                      hintText: l.alphaVantageHint,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(alphaVantageKey: v)),
                    controller: TextEditingController(text: s.alphaVantageKey),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      labelText: l.fmpLabel,
                      hintText: l.fmpHint,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(fmpKey: v)),
                    controller: TextEditingController(text: s.fmpKey),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      labelText: l.hfTokenLabel,
                      hintText: "hf_...",
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(hfToken: v)),
                    controller: TextEditingController(text: s.hfToken),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      labelText: l.kronosServerUrl,
                      hintText: l.kronosServerHint,
                      helperText: l.kronosServerHelper,
                      helperMaxLines: 2,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.cloud_outlined),
                      suffixIcon: s.kronosRemoteUrl.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => provider.updateSettings(s.copyWith(kronosRemoteUrl: '')),
                          )
                        : null,
                    ),
                    onChanged: (v) =>
                        provider.updateSettings(s.copyWith(kronosRemoteUrl: v.trim())),
                    controller: TextEditingController(text: s.kronosRemoteUrl),
                  ),
                ]),
                const SizedBox(height: 20),
                Center(
                  child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final ver = snapshot.data?.version ?? "1.0.0";
                      final build = snapshot.data?.buildNumber ?? "0";
                      return Text(l.version(ver, build),
                          style: const TextStyle(color: Colors.grey));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard(
      BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Text(title,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
            ...children
          ],
        ),
      ),
    );
  }

  Widget _sliderTile(String label, double value, double min, double max,
      Function(double) onChanged,
      {String? desc}) {
    int divisions = 100;
    if (max - min <= 10) {
      divisions = ((max - min) * 10).toInt();
    } else if (max - min <= 100) {
      divisions = (max - min).toInt();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(label), Text(value.toStringAsFixed(1))],
          ),
        ),
        Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions > 0 ? divisions : 1,
            onChanged: onChanged),
        if (desc != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(desc,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ),
      ],
    );
  }

  Widget _dropdownTile<T>(
      String title, T value, Map<T, String> items, Function(T?) onChanged,
      {String? subtitle}) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12))
          : null,
      trailing: DropdownButton<T>(
        value: value,
        onChanged: onChanged,
        underline: Container(),
        items: items.entries
            .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
            .toList(),
      ),
    );
  }
}
