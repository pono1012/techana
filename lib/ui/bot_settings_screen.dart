import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/portfolio_service.dart';
import '../services/bot_settings_service.dart';
import '../services/trade_execution_service.dart';
import '../services/watchlist_service.dart';
import '../models/models.dart';
import '../l10n/l10n_extension.dart';
import '../l10n/enum_localizations.dart';

class BotSettingsScreen extends StatelessWidget {
  const BotSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.botConfiguration),
          bottom: TabBar(
            tabs: [
              Tab(text: context.l10n.tabGeneral, icon: const Icon(Icons.tune)),
              Tab(text: context.l10n.tabStrategy, icon: const Icon(Icons.trending_up)),
            ],
          ),
        ),
        body: Consumer4<BotSettingsService, TradeExecutionService,
            PortfolioService, WatchlistService>(
          builder: (context, settings, exec, portfolio, watchlist, child) {
            return TabBarView(
              children: [
                _buildGeneralTab(context, settings, exec, portfolio, watchlist),
                _buildStrategyTab(context, settings),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- TAB 1: Allgemein (Start/Stop, Umfang, Money Management, Erweitert) ---
  Widget _buildGeneralTab(
      BuildContext context,
      BotSettingsService settings,
      TradeExecutionService exec,
      PortfolioService portfolio,
      WatchlistService watchlist) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Status
        Card(
          color: exec.autoRun
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          child: Column(
            children: [
              SwitchListTile(
                title: Text(context.l10n.botActive),
                subtitle: Text(exec.autoRun
                    ? context.l10n.runningInBackground(settings.autoIntervalMinutes)
                    : context.l10n.paused),
                value: exec.autoRun,
                onChanged: (v) =>
                    exec.toggleAutoRun(v, settings, portfolio, watchlist),
                secondary: Icon(
                    exec.autoRun
                        ? Icons.play_circle_fill
                        : Icons.pause_circle_filled,
                    color: exec.autoRun ? Colors.green : Colors.red),
              ),
              if (exec.isScanning)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => exec.cancelRoutine(),
                      icon: const Icon(Icons.stop),
                      label: Text(context.l10n.cancelRunningScan),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader(context, context.l10n.routineScope),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: Text(context.l10n.checkPendingOrders),
                subtitle: Text(context.l10n.checkPendingSubtitle),
                value: settings.enableCheckPending,
                onChanged: (v) => settings.updateRoutineFlags(pending: v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: Text(context.l10n.checkOpenPositions),
                subtitle: Text(context.l10n.checkOpenSubtitle),
                value: settings.enableCheckOpen,
                onChanged: (v) => settings.updateRoutineFlags(open: v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: Text(context.l10n.scanForNewTrades),
                subtitle: Text(context.l10n.scanForNewSubtitle),
                value: settings.enableScanNew,
                onChanged: (v) => settings.updateRoutineFlags(scan: v),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader(context, context.l10n.moneyManagement),
        Card(
          child: Column(
            children: [
              _sliderTile(
                  context.l10n.investPerTrade,
                  settings.botBaseInvest,
                  10,
                  2000,
                  (v) => settings.updateBotSettings(v,
                      settings.maxOpenPositions, settings.unlimitedPositions),
                  desc: context.l10n.investPerTradeDesc),
              SwitchListTile(
                title: Text(context.l10n.unlimitedPositions),
                value: settings.unlimitedPositions,
                onChanged: (v) => settings.updateBotSettings(
                    settings.botBaseInvest, settings.maxOpenPositions, v),
              ),
              if (!settings.unlimitedPositions)
                _sliderTile(
                  context.l10n.maxOpenPositions,
                  settings.maxOpenPositions.toDouble(),
                  1,
                  50,
                  (v) => settings.updateBotSettings(
                      settings.botBaseInvest, v.toInt(), false),
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        // --- Merge Advanced Items Here ---
        _buildSectionHeader(context, context.l10n.automation),
        Card(
          child: Column(
            children: [
              _sliderTile(
                  context.l10n.scanInterval,
                  settings.autoIntervalMinutes.toDouble(),
                  15,
                  240,
                  (v) => settings.updateAdvancedSettings(
                      v.toInt(), settings.trailingMult, settings.dynamicSizing),
                  desc: context.l10n.scanIntervalDesc),
              _sliderTile(
                  context.l10n.mcSimulationsScoring,
                  settings.mcSimulations.toDouble(),
                  50,
                  1000,
                  (v) => settings.setMcSimulations(v.toInt()),
                  desc: context.l10n.mcSimulationsScoringDesc),
              SwitchListTile(
                title: Text(context.l10n.mcStrictMode),
                subtitle: Text(context.l10n.mcStrictModeSubtitle),
                value: settings.mcStrictMode,
                onChanged: (v) => settings.setMcStrictMode(v),
                activeThumbColor: Colors.deepPurple,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader(context, context.l10n.tradeManagement),
        Card(
          child: Column(
            children: [
              _sliderTile(
                  context.l10n.trailingStopAtr,
                  settings.trailingMult,
                  0.5,
                  4.0,
                  (v) => settings.updateAdvancedSettings(
                      settings.autoIntervalMinutes, v, settings.dynamicSizing),
                  desc: context.l10n.trailingStopDesc),
              SwitchListTile(
                title: Text(context.l10n.dynamicPositionSize),
                subtitle: Text(context.l10n.dynamicPositionSubtitle),
                value: settings.dynamicSizing,
                onChanged: (v) => settings.updateAdvancedSettings(
                    settings.autoIntervalMinutes, settings.trailingMult, v),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader(context, context.l10n.aiAndAnalysis),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: Text(context.l10n.kronosAiAnalysisTitle),
                subtitle: Text(context.l10n.kronosAiSubtitle),
                value: settings.useKronos,
                onChanged: (v) => settings.setUseKronos(v),
                activeThumbColor: Colors.blueAccent,
              ),
              if (settings.useKronos)
                SwitchListTile(
                  title: Text(context.l10n.kronosStrictMode),
                  subtitle: Text(context.l10n.kronosStrictSubtitle),
                  value: settings.kronosStrictMode,
                  onChanged: (v) => settings.setKronosStrictMode(v),
                  activeThumbColor: Colors.deepPurple,
                ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Center(
            child: TextButton.icon(
          icon: const Icon(Icons.restore, size: 16),
          label: Text(context.l10n.resetAllSettings,
              style: const TextStyle(fontSize: 12)),
          onPressed: () => settings.resetBotSettings(),
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
        )),

        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            context.l10n.settingsNote,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ],
    );
  }

  // --- TAB 2: Strategie (Entry, Exit, SL, TP) ---
  Widget _buildStrategyTab(BuildContext context, BotSettingsService settings) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(context, context.l10n.generalAndTimeframe),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: Text(context.l10n.alternatingStrategies),
                subtitle: Text(context.l10n.alternatingStrategiesSubtitle),
                value: settings.autoRandomizeStrategy,
                onChanged: (v) => settings.setAutoRandomizeStrategy(v),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.l10n.analysisInterval,
                        style: TextStyle(fontSize: 13)),
                    Wrap(
                      spacing: 4.0,
                      children: TimeFrame.values.map((tf) {
                        return ChoiceChip(
                          label: Text(tf.label(context),
                              style: const TextStyle(fontSize: 10)),
                          selected: settings.botTimeFrame == tf,
                          onSelected: (selected) =>
                              settings.setBotTimeFrame(tf),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader(context, context.l10n.entrySection),
        Card(
          child: Column(
            children: [
              _dropdownTile<int>(
                context.l10n.strategyType,
                settings.entryStrategy,
                {
                  0: context.l10n.marketImmediate,
                  1: context.l10n.pullbackLimit,
                  2: context.l10n.breakoutStop
                },
                (v) => settings.updateStrategySettings(
                  entryStrategy: v!,
                  entryPadding: settings.entryPadding,
                  entryPaddingType: settings.entryPaddingType,
                  stopMethod: settings.stopMethod,
                  stopPercent: settings.stopPercent,
                  atrMult: settings.atrMult,
                  tpMethod: settings.tpMethod,
                  rrTp1: settings.rrTp1,
                  rrTp2: settings.rrTp2,
                  tpPercent1: settings.tpPercent1,
                  tpPercent2: settings.tpPercent2,
                  tp1SellFraction: settings.tp1SellFraction,
                ),
              ),
              if (settings.entryStrategy != 0) ...[
                const Divider(height: 1),
                _dropdownTile<int>(
                  context.l10n.paddingType,
                  settings.entryPaddingType,
                  {0: context.l10n.percentual, 1: context.l10n.atrFactor},
                  (v) => settings.updateStrategySettings(
                    entryStrategy: settings.entryStrategy,
                    entryPadding: settings.entryPadding,
                    entryPaddingType: v!,
                    stopMethod: settings.stopMethod,
                    stopPercent: settings.stopPercent,
                    atrMult: settings.atrMult,
                    tpMethod: settings.tpMethod,
                    rrTp1: settings.rrTp1,
                    rrTp2: settings.rrTp2,
                    tpPercent1: settings.tpPercent1,
                    tpPercent2: settings.tpPercent2,
                    tp1SellFraction: settings.tp1SellFraction,
                  ),
                ),
                _sliderTile(
                  settings.entryPaddingType == 0
                      ? context.l10n.paddingPercent
                      : context.l10n.paddingAtr,
                  settings.entryPadding,
                  0.1,
                  settings.entryPaddingType == 0 ? 2.0 : 5.0,
                  (v) => settings.updateStrategySettings(
                    entryPadding: v,
                    entryStrategy: settings.entryStrategy,
                    entryPaddingType: settings.entryPaddingType,
                    stopMethod: settings.stopMethod,
                    stopPercent: settings.stopPercent,
                    atrMult: settings.atrMult,
                    tpMethod: settings.tpMethod,
                    rrTp1: settings.rrTp1,
                    rrTp2: settings.rrTp2,
                    tpPercent1: settings.tpPercent1,
                    tpPercent2: settings.tpPercent2,
                    tp1SellFraction: settings.tp1SellFraction,
                  ),
                ),
              ]
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader(context, context.l10n.stopLossRisk),
        Card(
          child: Column(
            children: [
              _dropdownTile<int>(
                context.l10n.method,
                settings.stopMethod,
                {
                  0: context.l10n.donchianLowHigh,
                  1: context.l10n.percentualMethod,
                  2: context.l10n.atrVolatility,
                  3: context.l10n.swingLowHigh,
                },
                (v) => settings.updateStrategySettings(
                  stopMethod: v!,
                  stopPercent: settings.stopPercent,
                  atrMult: settings.atrMult,
                  tpMethod: settings.tpMethod,
                  rrTp1: settings.rrTp1,
                  rrTp2: settings.rrTp2,
                  tpPercent1: settings.tpPercent1,
                  tpPercent2: settings.tpPercent2,
                  tp1SellFraction: settings.tp1SellFraction,
                  entryStrategy: settings.entryStrategy,
                  entryPadding: settings.entryPadding,
                  entryPaddingType: settings.entryPaddingType,
                ),
              ),
              if (settings.stopMethod == 1)
                _sliderTile(
                    context.l10n.stopDistance,
                    settings.stopPercent,
                    1,
                    20,
                    (v) => settings.updateStrategySettings(
                          stopMethod: settings.stopMethod,
                          stopPercent: v,
                          atrMult: settings.atrMult,
                          tpMethod: settings.tpMethod,
                          rrTp1: settings.rrTp1,
                          rrTp2: settings.rrTp2,
                          tpPercent1: settings.tpPercent1,
                          tpPercent2: settings.tpPercent2,
                          tp1SellFraction: settings.tp1SellFraction,
                          entryStrategy: settings.entryStrategy,
                          entryPadding: settings.entryPadding,
                          entryPaddingType: settings.entryPaddingType,
                        )),
              if (settings.stopMethod == 2)
                _sliderTile(
                    context.l10n.atrMultiplier,
                    settings.atrMult,
                    1,
                    5,
                    (v) => settings.updateStrategySettings(
                          stopMethod: settings.stopMethod,
                          stopPercent: settings.stopPercent,
                          atrMult: v,
                          tpMethod: settings.tpMethod,
                          rrTp1: settings.rrTp1,
                          rrTp2: settings.rrTp2,
                          tpPercent1: settings.tpPercent1,
                          tpPercent2: settings.tpPercent2,
                          tp1SellFraction: settings.tp1SellFraction,
                          entryStrategy: settings.entryStrategy,
                          entryPadding: settings.entryPadding,
                          entryPaddingType: settings.entryPaddingType,
                        )),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader(context, context.l10n.takeProfitTargets),
        Card(
          child: Column(
            children: [
              _dropdownTile<int>(
                context.l10n.method,
                settings.tpMethod,
                {
                  0: context.l10n.riskRewardCrv,
                  1: context.l10n.percentualMethod,
                  2: context.l10n.atrTarget,
                  3: context.l10n.pivotPoints,
                },
                (v) => settings.updateStrategySettings(
                  tpMethod: v!,
                  stopMethod: settings.stopMethod,
                  stopPercent: settings.stopPercent,
                  atrMult: settings.atrMult,
                  rrTp1: settings.rrTp1,
                  rrTp2: settings.rrTp2,
                  tpPercent1: settings.tpPercent1,
                  tpPercent2: settings.tpPercent2,
                  tp1SellFraction: settings.tp1SellFraction,
                  entryStrategy: settings.entryStrategy,
                  entryPadding: settings.entryPadding,
                  entryPaddingType: settings.entryPaddingType,
                ),
              ),
              const Divider(height: 1),
              _sliderTile(
                context.l10n.sellAtTp1,
                settings.tp1SellFraction * 100,
                10,
                100,
                (v) => settings.updateStrategySettings(
                  tp1SellFraction: v / 100.0,
                  stopMethod: settings.stopMethod,
                  stopPercent: settings.stopPercent,
                  atrMult: settings.atrMult,
                  tpMethod: settings.tpMethod,
                  rrTp1: settings.rrTp1,
                  rrTp2: settings.rrTp2,
                  tpPercent1: settings.tpPercent1,
                  tpPercent2: settings.tpPercent2,
                  entryStrategy: settings.entryStrategy,
                  entryPadding: settings.entryPadding,
                  entryPaddingType: settings.entryPaddingType,
                ),
              ),
              if (settings.tpMethod == 0 || settings.tpMethod == 2) ...[
                _sliderTile(
                    context.l10n.tp1FactorR,
                    settings.rrTp1,
                    1,
                    5,
                    (v) => settings.updateStrategySettings(
                          rrTp1: v,
                          stopMethod: settings.stopMethod,
                          stopPercent: settings.stopPercent,
                          atrMult: settings.atrMult,
                          tpMethod: settings.tpMethod,
                          rrTp2: settings.rrTp2,
                          tpPercent1: settings.tpPercent1,
                          tpPercent2: settings.tpPercent2,
                          tp1SellFraction: settings.tp1SellFraction,
                          entryStrategy: settings.entryStrategy,
                          entryPadding: settings.entryPadding,
                          entryPaddingType: settings.entryPaddingType,
                        )),
                _sliderTile(
                    context.l10n.tp2FactorR,
                    settings.rrTp2,
                    2,
                    10,
                    (v) => settings.updateStrategySettings(
                          rrTp2: v,
                          stopMethod: settings.stopMethod,
                          stopPercent: settings.stopPercent,
                          atrMult: settings.atrMult,
                          tpMethod: settings.tpMethod,
                          rrTp1: settings.rrTp1,
                          tpPercent1: settings.tpPercent1,
                          tpPercent2: settings.tpPercent2,
                          tp1SellFraction: settings.tp1SellFraction,
                          entryStrategy: settings.entryStrategy,
                          entryPadding: settings.entryPadding,
                          entryPaddingType: settings.entryPaddingType,
                        )),
              ],
              if (settings.tpMethod == 1) ...[
                _sliderTile(
                    "TP1 %",
                    settings.tpPercent1,
                    1,
                    20,
                    (v) => settings.updateStrategySettings(
                          tpPercent1: v,
                          stopMethod: settings.stopMethod,
                          stopPercent: settings.stopPercent,
                          atrMult: settings.atrMult,
                          tpMethod: settings.tpMethod,
                          rrTp1: settings.rrTp1,
                          rrTp2: settings.rrTp2,
                          tpPercent2: settings.tpPercent2,
                          tp1SellFraction: settings.tp1SellFraction,
                          entryStrategy: settings.entryStrategy,
                          entryPadding: settings.entryPadding,
                          entryPaddingType: settings.entryPaddingType,
                        )),
                _sliderTile(
                    "TP2 %",
                    settings.tpPercent2,
                    2,
                    50,
                    (v) => settings.updateStrategySettings(
                          tpPercent2: v,
                          stopMethod: settings.stopMethod,
                          stopPercent: settings.stopPercent,
                          atrMult: settings.atrMult,
                          tpMethod: settings.tpMethod,
                          rrTp1: settings.rrTp1,
                          rrTp2: settings.rrTp2,
                          tpPercent1: settings.tpPercent1,
                          tp1SellFraction: settings.tp1SellFraction,
                          entryStrategy: settings.entryStrategy,
                          entryPadding: settings.entryPadding,
                          entryPaddingType: settings.entryPaddingType,
                        )),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader(context, context.l10n.expertFeaturesAi),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: Text(context.l10n.marketRegimeFilter),
                subtitle: Text(context.l10n.marketRegimeSubtitleBot),
                value: settings.useMarketRegime,
                onChanged: (v) => settings.setUseMarketRegime(v),
              ),
              SwitchListTile(
                title: Text(context.l10n.aiProbabilityScoring),
                subtitle: Text(context.l10n.aiProbabilitySubtitleBot),
                value: settings.useAiProbability,
                onChanged: (v) => settings.setUseAiProbability(v),
              ),
              SwitchListTile(
                title: Text(context.l10n.multiTimeframeMtc),
                subtitle:
                    Text(context.l10n.mtcSubtitleBot),
                value: settings.useMtc,
                onChanged: (v) => settings.setUseMtc(v),
              ),
              SwitchListTile(
                title: Text(context.l10n.strategyOptimizer),
                subtitle: Text(context.l10n.strategyOptimizerSubtitleBot),
                value: settings.useStrategyOptimizer,
                onChanged: (v) => settings.setUseStrategyOptimizer(v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(title,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16)),
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
            children: [
              Text(label, style: const TextStyle(fontSize: 13)),
              Text(value.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ],
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
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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
      title: Text(title, style: const TextStyle(fontSize: 13)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 11))
          : null,
      trailing: DropdownButton<T>(
        value: value,
        onChanged: onChanged,
        underline: Container(),
        items: items.entries
            .map((e) => DropdownMenuItem(
                value: e.key,
                child: Text(e.value, style: const TextStyle(fontSize: 13))))
            .toList(),
      ),
    );
  }
}
