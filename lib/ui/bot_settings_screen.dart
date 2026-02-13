import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/portfolio_service.dart';

class BotSettingsScreen extends StatelessWidget {
  const BotSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine Tab Count
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
        body: Consumer<PortfolioService>(
          builder: (context, bot, child) {
            return TabBarView(
              children: [
                _buildGeneralTab(context, bot),
                _buildStrategyTab(context, bot),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- TAB 1: Allgemein (Start/Stop, Umfang, Money Management, Erweitert) ---
  Widget _buildGeneralTab(BuildContext context, PortfolioService bot) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Status
        Card(
          color: bot.autoRun
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text("Bot Aktiv (Auto-Run)"),
                subtitle: Text(bot.autoRun
                    ? "Läuft im Hintergrund (Alle ${bot.autoIntervalMinutes} Min)"
                    : "Pausiert"),
                value: bot.autoRun,
                onChanged: (v) => bot.toggleAutoRun(v),
                secondary: Icon(
                    bot.autoRun
                        ? Icons.play_circle_fill
                        : Icons.pause_circle_filled,
                    color: bot.autoRun ? Colors.green : Colors.red),
              ),
              if (bot.isScanning)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => bot.cancelRoutine(),
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
                value: bot.enableCheckPending,
                onChanged: (v) => bot.updateRoutineFlags(pending: v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text("Offene Positionen prüfen"),
                subtitle: const Text("Prüft SL/TP und aktualisiert PnL."),
                value: bot.enableCheckOpen,
                onChanged: (v) => bot.updateRoutineFlags(open: v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text("Nach neuen Trades suchen"),
                subtitle: const Text("Scannt Watchlist nach Signalen."),
                value: bot.enableScanNew,
                onChanged: (v) => bot.updateRoutineFlags(scan: v),
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
                  bot.botBaseInvest,
                  10,
                  2000,
                  (v) => bot.updateBotSettings(
                      v, bot.maxOpenPositions, bot.unlimitedPositions),
                  desc: "Basis-Investition pro Position."),
              SwitchListTile(
                title: const Text("Unbegrenzte Positionen"),
                value: bot.unlimitedPositions,
                onChanged: (v) => bot.updateBotSettings(
                    bot.botBaseInvest, bot.maxOpenPositions, v),
              ),
              if (!bot.unlimitedPositions)
                _sliderTile(
                  "Max. offene Positionen",
                  bot.maxOpenPositions.toDouble(),
                  1,
                  50,
                  (v) => bot.updateBotSettings(
                      bot.botBaseInvest, v.toInt(), false),
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
                  bot.autoIntervalMinutes.toDouble(),
                  15,
                  240,
                  (v) => bot.updateAdvancedSettings(
                      v.toInt(), bot.trailingMult, bot.dynamicSizing),
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
                  bot.trailingMult,
                  0.5,
                  4.0,
                  (v) => bot.updateAdvancedSettings(
                      bot.autoIntervalMinutes, v, bot.dynamicSizing),
                  desc: "Stop Loss automatisch nachziehen."),
              SwitchListTile(
                title: const Text("Dynamische Positionsgröße"),
                subtitle:
                    const Text("Invest verdoppeln bei hohem Score (>80)."),
                value: bot.dynamicSizing,
                onChanged: (v) => bot.updateAdvancedSettings(
                    bot.autoIntervalMinutes, bot.trailingMult, v),
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
          onPressed: () => bot.resetBotSettings(),
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
  Widget _buildStrategyTab(BuildContext context, PortfolioService bot) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(context, "Entry (Einstieg)"),
        Card(
          child: Column(
            children: [
              _dropdownTile<int>(
                "Strategie Typ",
                bot.entryStrategy,
                const {
                  0: "Market (Sofort)",
                  1: "Pullback (Limit)",
                  2: "Breakout (Stop)"
                },
                (v) => bot.updateStrategySettings(
                  entryStrategy: v!,
                  entryPadding: bot.entryPadding,
                  entryPaddingType: bot.entryPaddingType,
                  stopMethod: bot.stopMethod,
                  stopPercent: bot.stopPercent,
                  atrMult: bot.atrMult,
                  tpMethod: bot.tpMethod,
                  rrTp1: bot.rrTp1,
                  rrTp2: bot.rrTp2,
                  tpPercent1: bot.tpPercent1,
                  tpPercent2: bot.tpPercent2,
                  tp1SellFraction: bot.tp1SellFraction,
                ),
              ),
              if (bot.entryStrategy != 0) ...[
                const Divider(height: 1),
                _dropdownTile<int>(
                  "Padding Typ",
                  bot.entryPaddingType,
                  const {0: "Prozentual (%)", 1: "ATR Faktor"},
                  (v) => bot.updateStrategySettings(
                    entryStrategy: bot.entryStrategy,
                    entryPadding: bot.entryPadding,
                    entryPaddingType: v!,
                    stopMethod: bot.stopMethod,
                    stopPercent: bot.stopPercent,
                    atrMult: bot.atrMult,
                    tpMethod: bot.tpMethod,
                    rrTp1: bot.rrTp1,
                    rrTp2: bot.rrTp2,
                    tpPercent1: bot.tpPercent1,
                    tpPercent2: bot.tpPercent2,
                    tp1SellFraction: bot.tp1SellFraction,
                  ),
                ),
                _sliderTile(
                  bot.entryPaddingType == 0 ? "Padding %" : "Padding (x ATR)",
                  bot.entryPadding,
                  0.1,
                  bot.entryPaddingType == 0 ? 2.0 : 5.0,
                  (v) => bot.updateStrategySettings(
                    entryPadding: v,
                    entryStrategy: bot.entryStrategy,
                    entryPaddingType: bot.entryPaddingType,
                    stopMethod: bot.stopMethod,
                    stopPercent: bot.stopPercent,
                    atrMult: bot.atrMult,
                    tpMethod: bot.tpMethod,
                    rrTp1: bot.rrTp1,
                    rrTp2: bot.rrTp2,
                    tpPercent1: bot.tpPercent1,
                    tpPercent2: bot.tpPercent2,
                    tp1SellFraction: bot.tp1SellFraction,
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
                bot.stopMethod,
                const {
                  0: "Donchian Low",
                  1: "Prozentual",
                  2: "ATR (Volatilität)"
                },
                (v) => bot.updateStrategySettings(
                  stopMethod: v!,
                  stopPercent: bot.stopPercent,
                  atrMult: bot.atrMult,
                  tpMethod: bot.tpMethod,
                  rrTp1: bot.rrTp1,
                  rrTp2: bot.rrTp2,
                  tpPercent1: bot.tpPercent1,
                  tpPercent2: bot.tpPercent2,
                  tp1SellFraction: bot.tp1SellFraction,
                  entryStrategy: bot.entryStrategy,
                  entryPadding: bot.entryPadding,
                  entryPaddingType: bot.entryPaddingType,
                ),
              ),
              if (bot.stopMethod == 1)
                _sliderTile(
                    "Stop Abstand %",
                    bot.stopPercent,
                    1,
                    20,
                    (v) => bot.updateStrategySettings(
                          stopMethod: bot.stopMethod,
                          stopPercent: v,
                          atrMult: bot.atrMult,
                          tpMethod: bot.tpMethod,
                          rrTp1: bot.rrTp1,
                          rrTp2: bot.rrTp2,
                          tpPercent1: bot.tpPercent1,
                          tpPercent2: bot.tpPercent2,
                          tp1SellFraction: bot.tp1SellFraction,
                          entryStrategy: bot.entryStrategy,
                          entryPadding: bot.entryPadding,
                          entryPaddingType: bot.entryPaddingType,
                        )),
              if (bot.stopMethod == 2)
                _sliderTile(
                    "ATR Multiplikator",
                    bot.atrMult,
                    1,
                    5,
                    (v) => bot.updateStrategySettings(
                          stopMethod: bot.stopMethod,
                          stopPercent: bot.stopPercent,
                          atrMult: v,
                          tpMethod: bot.tpMethod,
                          rrTp1: bot.rrTp1,
                          rrTp2: bot.rrTp2,
                          tpPercent1: bot.tpPercent1,
                          tpPercent2: bot.tpPercent2,
                          tp1SellFraction: bot.tp1SellFraction,
                          entryStrategy: bot.entryStrategy,
                          entryPadding: bot.entryPadding,
                          entryPaddingType: bot.entryPaddingType,
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
                bot.tpMethod,
                const {0: "Risk/Reward (CRV)", 1: "Prozentual", 2: "ATR-Ziel"},
                (v) => bot.updateStrategySettings(
                  tpMethod: v!,
                  stopMethod: bot.stopMethod,
                  stopPercent: bot.stopPercent,
                  atrMult: bot.atrMult,
                  rrTp1: bot.rrTp1,
                  rrTp2: bot.rrTp2,
                  tpPercent1: bot.tpPercent1,
                  tpPercent2: bot.tpPercent2,
                  tp1SellFraction: bot.tp1SellFraction,
                  entryStrategy: bot.entryStrategy,
                  entryPadding: bot.entryPadding,
                  entryPaddingType: bot.entryPaddingType,
                ),
              ),
              const Divider(height: 1),
              _sliderTile(
                "Verkauf bei TP1 (%)",
                bot.tp1SellFraction * 100,
                10,
                100,
                (v) => bot.updateStrategySettings(
                  tp1SellFraction: v / 100.0,
                  stopMethod: bot.stopMethod,
                  stopPercent: bot.stopPercent,
                  atrMult: bot.atrMult,
                  tpMethod: bot.tpMethod,
                  rrTp1: bot.rrTp1,
                  rrTp2: bot.rrTp2,
                  tpPercent1: bot.tpPercent1,
                  tpPercent2: bot.tpPercent2,
                  entryStrategy: bot.entryStrategy,
                  entryPadding: bot.entryPadding,
                  entryPaddingType: bot.entryPaddingType,
                ),
              ),
              if (bot.tpMethod == 0 || bot.tpMethod == 2) ...[
                _sliderTile(
                    "TP1 Faktor (R)",
                    bot.rrTp1,
                    1,
                    5,
                    (v) => bot.updateStrategySettings(
                          rrTp1: v,
                          stopMethod: bot.stopMethod,
                          stopPercent: bot.stopPercent,
                          atrMult: bot.atrMult,
                          tpMethod: bot.tpMethod,
                          rrTp2: bot.rrTp2,
                          tpPercent1: bot.tpPercent1,
                          tpPercent2: bot.tpPercent2,
                          tp1SellFraction: bot.tp1SellFraction,
                          entryStrategy: bot.entryStrategy,
                          entryPadding: bot.entryPadding,
                          entryPaddingType: bot.entryPaddingType,
                        )),
                _sliderTile(
                    "TP2 Faktor (R)",
                    bot.rrTp2,
                    2,
                    10,
                    (v) => bot.updateStrategySettings(
                          rrTp2: v,
                          stopMethod: bot.stopMethod,
                          stopPercent: bot.stopPercent,
                          atrMult: bot.atrMult,
                          tpMethod: bot.tpMethod,
                          rrTp1: bot.rrTp1,
                          tpPercent1: bot.tpPercent1,
                          tpPercent2: bot.tpPercent2,
                          tp1SellFraction: bot.tp1SellFraction,
                          entryStrategy: bot.entryStrategy,
                          entryPadding: bot.entryPadding,
                          entryPaddingType: bot.entryPaddingType,
                        )),
              ],
              if (bot.tpMethod == 1) ...[
                _sliderTile(
                    "TP1 %",
                    bot.tpPercent1,
                    1,
                    20,
                    (v) => bot.updateStrategySettings(
                          tpPercent1: v,
                          stopMethod: bot.stopMethod,
                          stopPercent: bot.stopPercent,
                          atrMult: bot.atrMult,
                          tpMethod: bot.tpMethod,
                          rrTp1: bot.rrTp1,
                          rrTp2: bot.rrTp2,
                          tpPercent2: bot.tpPercent2,
                          tp1SellFraction: bot.tp1SellFraction,
                          entryStrategy: bot.entryStrategy,
                          entryPadding: bot.entryPadding,
                          entryPaddingType: bot.entryPaddingType,
                        )),
                _sliderTile(
                    "TP2 %",
                    bot.tpPercent2,
                    2,
                    50,
                    (v) => bot.updateStrategySettings(
                          tpPercent2: v,
                          stopMethod: bot.stopMethod,
                          stopPercent: bot.stopPercent,
                          atrMult: bot.atrMult,
                          tpMethod: bot.tpMethod,
                          rrTp1: bot.rrTp1,
                          rrTp2: bot.rrTp2,
                          tpPercent1: bot.tpPercent1,
                          tp1SellFraction: bot.tp1SellFraction,
                          entryStrategy: bot.entryStrategy,
                          entryPadding: bot.entryPadding,
                          entryPaddingType: bot.entryPaddingType,
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
