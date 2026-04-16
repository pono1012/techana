import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../l10n/l10n_extension.dart';

class AnalysisSettingsDialog extends StatefulWidget {
  const AnalysisSettingsDialog({super.key});

  @override
  State<AnalysisSettingsDialog> createState() => _AnalysisSettingsDialogState();
}

class _AnalysisSettingsDialogState extends State<AnalysisSettingsDialog> {
  late AppSettings _tempSettings;

  @override
  void initState() {
    super.initState();
    final appProvider = context.read<AppProvider>();
    _tempSettings = appProvider.settings;
  }

  void _save() {
    final appProvider = context.read<AppProvider>();
    appProvider.updateSettings(_tempSettings);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.chartSettings),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.indicatorVisibility,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _switchTile(
                "EMA 20",
                _tempSettings.showEMA,
                (v) => setState(
                    () => _tempSettings = _tempSettings.copyWith(showEMA: v))),
            _switchTile(
                context.l10n.supertrend,
                _tempSettings.showSupertrend,
                (v) => setState(() =>
                    _tempSettings = _tempSettings.copyWith(showSupertrend: v))),
            _switchTile(
                context.l10n.donchianChannel,
                _tempSettings.showDonchian,
                (v) => setState(() =>
                    _tempSettings = _tempSettings.copyWith(showDonchian: v))),
            _switchTile(
                context.l10n.bollingerBands,
                _tempSettings.showBB,
                (v) => setState(
                    () => _tempSettings = _tempSettings.copyWith(showBB: v))),
            _switchTile(
                context.l10n.patternMarkers,
                _tempSettings.showPatternMarkers,
                (v) => setState(() => _tempSettings =
                    _tempSettings.copyWith(showPatternMarkers: v))),
            _switchTile(
                context.l10n.tradingLines,
                _tempSettings.showTradeLines,
                (v) => setState(() =>
                    _tempSettings = _tempSettings.copyWith(showTradeLines: v))),
            const Divider(),
            Text(context.l10n.oscillators,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            _switchTile(
                "RSI",
                _tempSettings.showRSI,
                (v) => setState(
                    () => _tempSettings = _tempSettings.copyWith(showRSI: v))),
            _switchTile(
                "MACD",
                _tempSettings.showMACD,
                (v) => setState(
                    () => _tempSettings = _tempSettings.copyWith(showMACD: v))),
            _switchTile(
                context.l10n.stochasticOscillator,
                _tempSettings.showStochastic,
                (v) => setState(() =>
                    _tempSettings = _tempSettings.copyWith(showStochastic: v))),
            _switchTile(
                context.l10n.volume,
                _tempSettings.showVolume,
                (v) => setState(() =>
                    _tempSettings = _tempSettings.copyWith(showVolume: v))),
            _switchTile(
                "ADX",
                _tempSettings.showAdx,
                (v) => setState(
                    () => _tempSettings = _tempSettings.copyWith(showAdx: v))),
            _switchTile(
                "OBV",
                _tempSettings.showOBV,
                (v) => setState(
                    () => _tempSettings = _tempSettings.copyWith(showOBV: v))),
            const Divider(),
            _sliderTile(
                context.l10n.chartRangeDays,
                _tempSettings.chartRangeDays.toDouble(),
                30,
                1000,
                (v) => setState(() => _tempSettings =
                    _tempSettings.copyWith(chartRangeDays: v.toInt()))),
            _sliderTile(
                context.l10n.projectionDays,
                _tempSettings.projectionDays.toDouble(),
                0,
                60,
                (v) => setState(() => _tempSettings =
                    _tempSettings.copyWith(projectionDays: v.toInt()))),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancel)),
        FilledButton(onPressed: _save, child: Text(context.l10n.save)),
      ],
    );
  }

  Widget _switchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: value,
      onChanged: onChanged,
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _sliderTile(String label, double value, double min, double max,
      Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(value.toInt().toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
        Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min > 50) ? 50 : (max - min).toInt(),
            onChanged: onChanged),
      ],
    );
  }
}
