import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/portfolio_service.dart';
import '../services/bot_settings_service.dart';
import '../services/trade_execution_service.dart';
import '../services/watchlist_service.dart';
import '../models/models.dart';

class BotSettingsScreen extends StatelessWidget {
  const BotSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Bot Konfiguration"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Allgemein", icon: Icon(Icons.tune)),
              Tab(text: "Strategie", icon: Icon(Icons.trending_up)),
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
                title: const Text("Bot Aktiv (Auto-Run)"),
                subtitle: Text(exec.autoRun
                    ? "Läuft im Hintergrund (Alle ${settings.autoIntervalMinutes} Min)"
                    : "Pausiert"),
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
                      label: const Text("Laufenden Scan sofort abbrechen"),
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
        _buildSectionHeader(context, "Routine Umfang"),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text("Pending Orders prüfen"),
                subtitle: const Text("Prüft Limit/Stop Orders (Entry)."),
                value: settings.enableCheckPending,
                onChanged: (v) => settings.updateRoutineFlags(pending: v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text("Offene Positionen prüfen"),
                subtitle: const Text("Prüft SL/TP und aktualisiert PnL."),
                value: settings.enableCheckOpen,
                onChanged: (v) => settings.updateRoutineFlags(open: v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text("Nach neuen Trades suchen"),
                subtitle: const Text("Scannt Watchlist nach Signalen."),
                value: settings.enableScanNew,
                onChanged: (v) => settings.updateRoutineFlags(scan: v),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader(context, "Money Management"),
        Card(
          child: Column(
            children: [
              _sliderTile(
                  "Invest pro Trade (€)",
                  settings.botBaseInvest,
                  10,
                  2000,
                  (v) => settings.updateBotSettings(v,
                      settings.maxOpenPositions, settings.unlimitedPositions),
                  desc: "Basis-Investition pro Position."),
              SwitchListTile(
                title: const Text("Unbegrenzte Positionen"),
                value: settings.unlimitedPositions,
                onChanged: (v) => settings.updateBotSettings(
                    settings.botBaseInvest, settings.maxOpenPositions, v),
              ),
              if (!settings.unlimitedPositions)
                _sliderTile(
                  "Max. offene Positionen",
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
        _buildSectionHeader(context, "Automatisierung"),
        Card(
          child: Column(
            children: [
              _sliderTile(
                  "Scan Intervall (Min)",
                  settings.autoIntervalMinutes.toDouble(),
                  15,
                  240,
                  (v) => settings.updateAdvancedSettings(
                      v.toInt(), settings.trailingMult, settings.dynamicSizing),
                  desc: "Häufigkeit der automatischen Prüfung."),
            ],
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionHeader(context, "Trade Management"),
        Card(
          child: Column(
            children: [
              _sliderTile(
                  "Trailing Stop (x ATR)",
                  settings.trailingMult,
                  0.5,
                  4.0,
                  (v) => settings.updateAdvancedSettings(
                      settings.autoIntervalMinutes, v, settings.dynamicSizing),
                  desc: "Stop Loss automatisch nachziehen."),
              SwitchListTile(
                title: const Text("Dynamische Positionsgröße"),
                subtitle:
                    const Text("Invest verdoppeln bei hohem Score (>80)."),
                value: settings.dynamicSizing,
                onChanged: (v) => settings.updateAdvancedSettings(
                    settings.autoIntervalMinutes, settings.trailingMult, v),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Center(
            child: TextButton.icon(
          icon: const Icon(Icons.restore, size: 16),
          label: const Text("Alle Einstellungen zurücksetzen",
              style: TextStyle(fontSize: 12)),
          onPressed: () => settings.resetBotSettings(),
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
        )),

        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Hinweis: Änderungen werden sofort gespeichert und beim nächsten Scan angewendet.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
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
        _buildSectionHeader(context, "Allgemein & Zeitrahmen"),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text("Wechselnde Strategien"),
                subtitle: const Text("Für jeden Scan zufällige Werte testen"),
                value: settings.autoRandomizeStrategy,
                onChanged: (v) => settings.setAutoRandomizeStrategy(v),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Analyse Interval",
                        style: TextStyle(fontSize: 13)),
                    Wrap(
                      spacing: 4.0,
                      children: TimeFrame.values.map((tf) {
                        return ChoiceChip(
                          label: Text(tf.label,
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
        _buildSectionHeader(context, "Entry (Einstieg)"),
        Card(
          child: Column(
            children: [
              _dropdownTile<int>(
                "Strategie Typ",
                settings.entryStrategy,
                const {
                  0: "Market (Sofort)",
                  1: "Pullback (Limit)",
                  2: "Breakout (Stop)"
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
                  "Padding Typ",
                  settings.entryPaddingType,
                  const {0: "Prozentual (%)", 1: "ATR Faktor"},
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
                      ? "Padding %"
                      : "Padding (x ATR)",
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
        _buildSectionHeader(context, "Stop Loss (Risiko)"),
        Card(
          child: Column(
            children: [
              _dropdownTile<int>(
                "Methode",
                settings.stopMethod,
                const {
                  0: "Donchian Low/High",
                  1: "Prozentual",
                  2: "ATR (Volatilität)",
                  3: "Swing-Low/High",
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
                    "Stop Abstand %",
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
                    "ATR Multiplikator",
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
        _buildSectionHeader(context, "Take Profit (Ziele)"),
        Card(
          child: Column(
            children: [
              _dropdownTile<int>(
                "Methode",
                settings.tpMethod,
                const {
                  0: "Risk/Reward (CRV)",
                  1: "Prozentual",
                  2: "ATR-Ziel",
                  3: "Pivot Points",
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
                "Verkauf bei TP1 (%)",
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
                    "TP1 Faktor (R)",
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
                    "TP2 Faktor (R)",
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
