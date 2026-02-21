import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class BotSettingsService extends ChangeNotifier {
  // Bot Einstellungen
  double _botBaseInvest = 100.0; // Standard Invest pro Trade
  int _maxOpenPositions = 5; // Max gleichzeitige Trades
  bool _unlimitedPositions = false;

  // Strategie Einstellungen
  int _stopMethod = 2; // 0=Donchian, 1=Percent, 2=ATR
  double _stopPercent = 5.0;
  int _entryStrategy = 0; // 0=Market, 1=Pullback (Limit), 2=Breakout (Stop)
  double _entryPadding = 0.2; // Wert für Abstand
  int _entryPaddingType = 0; // 0=Prozent, 1=ATR-Faktor
  double _atrMult = 2.0;
  int _tpMethod = 0; // 0=RR, 1=Percent, 2=ATR
  double _rrTp1 = 1.5;
  double _rrTp2 = 3.0;
  double _tpPercent1 = 5.0;
  double _tpPercent2 = 10.0;
  double _tp1SellFraction = 0.5;

  // Advanced Automation
  int _autoIntervalMinutes = 60; // Wie oft scannen?
  double _trailingMult = 1.5; // Wie eng nachziehen?
  bool _dynamicSizing = true; // Einsatz erhöhen bei hohem Score?

  // Routine Scope Settings
  bool _enableCheckPending = true;
  bool _enableCheckOpen = true;
  bool _enableScanNew = true;

  TimeFrame _botTimeFrame = TimeFrame.d1;

  // Getters
  double get botBaseInvest => _botBaseInvest;
  int get maxOpenPositions => _maxOpenPositions;
  bool get unlimitedPositions => _unlimitedPositions;

  int get stopMethod => _stopMethod;
  double get stopPercent => _stopPercent;
  int get entryStrategy => _entryStrategy;
  double get entryPadding => _entryPadding;
  int get entryPaddingType => _entryPaddingType;
  double get atrMult => _atrMult;
  int get tpMethod => _tpMethod;
  double get rrTp1 => _rrTp1;
  double get rrTp2 => _rrTp2;
  double get tpPercent1 => _tpPercent1;
  double get tpPercent2 => _tpPercent2;
  double get tp1SellFraction => _tp1SellFraction;
  TimeFrame get botTimeFrame => _botTimeFrame;

  int get autoIntervalMinutes => _autoIntervalMinutes;
  double get trailingMult => _trailingMult;
  bool get dynamicSizing => _dynamicSizing;

  bool get enableCheckPending => _enableCheckPending;
  bool get enableCheckOpen => _enableCheckOpen;
  bool get enableScanNew => _enableScanNew;

  BotSettingsService() {
    _loadSettings();
  }

  void updateBotSettings(double invest, int maxPos, bool unlimited) {
    _botBaseInvest = invest;
    _maxOpenPositions = maxPos;
    _unlimitedPositions = unlimited;
    _saveSettings();
    notifyListeners();
  }

  void updateStrategySettings({
    required int stopMethod,
    required double stopPercent,
    required int entryStrategy,
    required double entryPadding,
    required int entryPaddingType,
    required double atrMult,
    required int tpMethod,
    required double rrTp1,
    required double rrTp2,
    required double tpPercent1,
    required double tpPercent2,
    required double tp1SellFraction,
  }) {
    _stopMethod = stopMethod;
    _stopPercent = stopPercent;
    _entryStrategy = entryStrategy;
    _entryPadding = entryPadding;
    _entryPaddingType = entryPaddingType;
    _atrMult = atrMult;
    _tpMethod = tpMethod;
    _rrTp1 = rrTp1;
    _rrTp2 = rrTp2;
    _tpPercent1 = tpPercent1;
    _tpPercent2 = tpPercent2;
    _tp1SellFraction = tp1SellFraction;
    _saveSettings();
    notifyListeners();
  }

  void updateAdvancedSettings(int interval, double trailMult, bool dynSize) {
    _autoIntervalMinutes = interval;
    _trailingMult = trailMult;
    _dynamicSizing = dynSize;
    _saveSettings();
    notifyListeners();
  }

  void updateRoutineFlags({bool? pending, bool? open, bool? scan}) {
    if (pending != null) _enableCheckPending = pending;
    if (open != null) _enableCheckOpen = open;
    if (scan != null) _enableScanNew = scan;
    _saveSettings();
    notifyListeners();
  }

  void setBotTimeFrame(TimeFrame tf) {
    _botTimeFrame = tf;
    _saveSettings();
    notifyListeners();
  }

  void resetBotSettings() {
    _botBaseInvest = 100.0;
    _maxOpenPositions = 5;
    _unlimitedPositions = false;

    _stopMethod = 2; // ATR
    _stopPercent = 5.0;
    _entryStrategy = 0; // Market
    _entryPadding = 0.2;
    _entryPaddingType = 0;
    _atrMult = 2.0;
    _tpMethod = 0; // RR
    _rrTp1 = 1.5;
    _rrTp2 = 3.0;
    _tpPercent1 = 5.0;
    _tpPercent2 = 10.0;
    _tp1SellFraction = 0.5;

    _autoIntervalMinutes = 60;
    _trailingMult = 1.5;
    _dynamicSizing = true;

    _saveSettings();
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('bot_invest', _botBaseInvest);
    await prefs.setInt('bot_max_pos', _maxOpenPositions);
    await prefs.setBool('bot_unlimited', _unlimitedPositions);
    await prefs.setInt('bot_stop_method', _stopMethod);
    await prefs.setDouble('bot_stop_percent', _stopPercent);
    await prefs.setInt('bot_entry_strategy', _entryStrategy);
    await prefs.setDouble('bot_entry_padding', _entryPadding);
    await prefs.setInt('bot_entry_padding_type', _entryPaddingType);
    await prefs.setDouble('bot_atr_mult', _atrMult);
    await prefs.setInt('bot_tp_method', _tpMethod);
    await prefs.setDouble('bot_rr_tp1', _rrTp1);
    await prefs.setDouble('bot_rr_tp2', _rrTp2);
    await prefs.setDouble('bot_tp_percent1', _tpPercent1);
    await prefs.setDouble('bot_tp_percent2', _tpPercent2);
    await prefs.setDouble('bot_tp1_sell_fraction', _tp1SellFraction);
    await prefs.setInt('bot_timeframe', _botTimeFrame.index);
    await prefs.setInt('bot_auto_interval', _autoIntervalMinutes);
    await prefs.setDouble('bot_trailing_mult', _trailingMult);
    await prefs.setBool('bot_dynamic_sizing', _dynamicSizing);
    await prefs.setBool('bot_enable_pending', _enableCheckPending);
    await prefs.setBool('bot_enable_open', _enableCheckOpen);
    await prefs.setBool('bot_enable_scan', _enableScanNew);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _botBaseInvest = prefs.getDouble('bot_invest') ?? 100.0;
    _maxOpenPositions = prefs.getInt('bot_max_pos') ?? 5;
    _unlimitedPositions = prefs.getBool('bot_unlimited') ?? false;

    _stopMethod = prefs.getInt('bot_stop_method') ?? 2;
    _stopPercent = prefs.getDouble('bot_stop_percent') ?? 5.0;
    _entryStrategy = prefs.getInt('bot_entry_strategy') ?? 0;
    _entryPadding = prefs.getDouble('bot_entry_padding') ?? 0.2;
    _entryPaddingType = prefs.getInt('bot_entry_padding_type') ?? 0;
    _atrMult = prefs.getDouble('bot_atr_mult') ?? 2.0;
    _tpMethod = prefs.getInt('bot_tp_method') ?? 0;
    _rrTp1 = prefs.getDouble('bot_rr_tp1') ?? 1.5;
    _rrTp2 = prefs.getDouble('bot_rr_tp2') ?? 3.0;
    _tpPercent1 = prefs.getDouble('bot_tp_percent1') ?? 5.0;
    _tpPercent2 = prefs.getDouble('bot_tp_percent2') ?? 10.0;
    _tp1SellFraction = prefs.getDouble('bot_tp1_sell_fraction') ?? 0.5;
    _botTimeFrame =
        TimeFrame.values[prefs.getInt('bot_timeframe') ?? TimeFrame.d1.index];

    _autoIntervalMinutes = prefs.getInt('bot_auto_interval') ?? 60;
    _trailingMult = prefs.getDouble('bot_trailing_mult') ?? 1.5;
    _dynamicSizing = prefs.getBool('bot_dynamic_sizing') ?? true;
    _enableCheckPending = prefs.getBool('bot_enable_pending') ?? true;
    _enableCheckOpen = prefs.getBool('bot_enable_open') ?? true;
    _enableScanNew = prefs.getBool('bot_enable_scan') ?? true;
    notifyListeners();
  }
}
