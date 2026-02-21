import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/data_service.dart';
import '../services/ta_indicators.dart';
import '../services/ta_extended.dart';

class AppProvider extends ChangeNotifier {
  final DataService _ds = DataService();
  ThemeMode _themeMode = ThemeMode.dark;
  String _symbol = 'DAX';
  String _yahooSymbol = '^GDAXI'; // Separater Ticker für Yahoo
  TimeFrame _selectedTimeFrame = TimeFrame.d1; // NEU: Kerzen-Intervall
  ChartRange _selectedChartRange = ChartRange.year1; // ALT: Anzeige-Zeitraum
  AppSettings _settings = AppSettings(); // Default Settings
  List<String> _searchHistory = [];

  List<PriceBar> _fullBars = [];
  FundamentalData? _fundamentalData;
  ComputedData? _computedData;
  bool _isLoading = false;
  String? _error;

  // Einzel-Aktien Strategie Einstellungen entfernt (nur noch im Bot)

  ThemeMode get themeMode => _themeMode;
  String get symbol => _symbol;
  String get yahooSymbol => _yahooSymbol;
  TimeFrame get selectedTimeFrame => _selectedTimeFrame; // NEU
  ChartRange get selectedChartRange => _selectedChartRange; // ALT
  ComputedData? get computedData => _computedData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  AppSettings get settings => _settings;
  List<String> get searchHistory => _searchHistory;

  AppProvider() {
    _loadSettings();
  }

  void setSymbol(String s) {
    _symbol = s.toUpperCase();

    // Auto-Konvertierung: .US und .DEF entfernen für Yahoo/FMP
    String ySym = _symbol;
    if (ySym.endsWith(".US")) ySym = ySym.replaceAll(".US", "");
    if (ySym.endsWith(".DEF")) ySym = ySym.replaceAll(".DEF", ".DE");
    // if (ySym == '^DAX') ySym = '^GDAXI'; // DAX Mapping Stooq -> Yahoo

    _yahooSymbol = ySym;
    fetchData();
    _addToHistory(_symbol);
    _saveState();
  }

  void setYahooSymbol(String s) {
    _yahooSymbol = s.toUpperCase();
    fetchData(); // Lädt Daten neu (inkl. Fundamentals mit neuem Ticker)
  }

  // NEU: Setzt das Kerzen-Intervall und lädt die Daten neu
  void setTimeFrame(TimeFrame tf) {
    if (_selectedTimeFrame == tf) return;
    _selectedTimeFrame = tf;
    fetchData(); // Daten müssen mit neuem Intervall von der API geholt werden
    _saveState();
  }

  void setChartRange(ChartRange range) {
    _selectedChartRange = range;
    _recalculate();
    _saveState();
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    _saveSettings();
  }

  void updateSettings(AppSettings newSettings) {
    _settings = newSettings;
    _recalculate(); // Neuberechnung triggern (für Strategie/Charts)
  }

  Future<void> fetchData() async {
    _isLoading = true;
    _error = null;
    _fundamentalData = null; // Reset alter Daten
    notifyListeners();

    try {
      // 1. Chart-Daten laden (Priorität) - mit dem ausgewählten Intervall
      _fullBars = await _ds.fetchBars(_symbol, interval: _selectedTimeFrame);
      if (_fullBars.isEmpty) throw Exception("Keine Daten");

      // Chart sofort anzeigen
      _recalculate();
      _isLoading = false;
      notifyListeners();

      // 2. Fundamentals im Hintergrund laden
      // Hier nutzen wir jetzt das separate Yahoo Symbol
      // UPDATE: User möchte KEIN ständiges Laden im Hintergrund für FMP.
      // Wir deaktivieren das automatische Laden hier komplett, um API Calls zu sparen.
      // Die Daten werden erst geladen, wenn der User auf das "Info"-Icon klickt.
      _fundamentalData = null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    } finally {
      // finally Block entfernt, da wir oben granular steuern
    }
  }

  void _recalculate() {
    if (_fullBars.isEmpty) return;

    try {
      final closes = _fullBars.map((b) => b.close).toList();
      final int len = _fullBars.length;

      // Helper für sichere Berechnung (Smart Catching)
      // Wenn ein Indikator fehlschlägt, wird eine leere Liste zurückgegeben,
      // damit der Rest der App weiterläuft.
      List<T> safeCalc<T>(List<T> Function() func, T fallback) {
        try {
          final res = func();
          if (res.length != len) {
            return List.filled(len, fallback);
          }
          return res;
        } catch (e) {
          debugPrint("Indikator Fehler (ignoriert): $e");
          return List.filled(len, fallback);
        }
      }

      // 1. Indikatoren berechnen (Robust)
      final sma50 = safeCalc(() => TA.sma(closes, 50), null);
      final ema20 = safeCalc(() => TA.ema(closes, 20), null);
      final rsi = safeCalc(() => TA.rsi(closes), null);
      final atr = safeCalc(() => TA.atr(_fullBars), null);
      final bb = TA.bollinger(closes); // Returns object, safe inside?
      // Wir wrappen die komplexen Objekte manuell

      // MACD
      List<double?> macd, macdSignal, macdHist;
      try {
        final m = TA.macd(closes);
        macd = m.macd;
        macdSignal = m.signal;
        macdHist = m.hist;
      } catch (e) {
        macd = List.filled(len, null);
        macdSignal = List.filled(len, null);
        macdHist = List.filled(len, null);
      }

      // Bollinger
      List<double?> bbUp, bbMid, bbLo;
      try {
        final b = TA.bollinger(closes);
        bbUp = b.up;
        bbMid = b.mid;
        bbLo = b.lo;
      } catch (e) {
        bbUp = List.filled(len, null);
        bbMid = List.filled(len, null);
        bbLo = List.filled(len, null);
      }

      // Donchian
      List<double?> donUp, donMid, donLo;
      try {
        final d = TA.donchian(_fullBars);
        donUp = d.up;
        donMid = d.mid;
        donLo = d.lo;
      } catch (e) {
        donUp = List.filled(len, null);
        donMid = List.filled(len, null);
        donLo = List.filled(len, null);
      }

      // Supertrend
      List<double?> stLine;
      List<bool> stBull;
      try {
        final s = TA.supertrend(_fullBars);
        stLine = s.line;
        stBull = s.bull;
      } catch (e) {
        stLine = List.filled(len, null);
        stBull = List.filled(len, false);
      }

      // ADX
      List<double?> adx;
      try {
        adx = TA.calcAdx(_fullBars).adx;
      } catch (e) {
        adx = List.filled(len, null);
      }

      // Squeeze
      List<bool> squeeze;
      try {
        squeeze = TA.squeezeFlags(_fullBars);
      } catch (e) {
        squeeze = List.filled(len, false);
      }

      // Stochastic
      List<double?> stochK, stochD;
      try {
        final s = TA.stochastic(_fullBars);
        stochK = s.k;
        stochD = s.d;
      } catch (e) {
        stochK = List.filled(len, null);
        stochD = List.filled(len, null);
      }

      // OBV
      final obv = safeCalc(() => TA.obv(_fullBars), null);

      // Projection
      ProjectionResult? proj;
      try {
        proj = TA.projectCone(closes, _settings.projectionDays);
      } catch (e) {
        proj = null;
      }

      // NEU: TAX Indikatoren
      List<double?> cciVals, psarSar, cmfVals, mfiVals, aoVals, bbPctVals;
      List<bool> psarBull;
      try {
        cciVals = TAX.cci(_fullBars);
        final p = TAX.psar(_fullBars);
        psarSar = p.sar;
        psarBull = p.bull;
        cmfVals = TAX.cmf(_fullBars);
        mfiVals = TAX.mfi(_fullBars);
        aoVals = TAX.ao(_fullBars);
        final bbE = TAX.bbExtended(closes);
        bbPctVals = bbE.pct;
      } catch (e) {
        cciVals = List.filled(len, null);
        psarSar = List.filled(len, null);
        psarBull = List.filled(len, false);
        cmfVals = List.filled(len, null);
        mfiVals = List.filled(len, null);
        aoVals = List.filled(len, null);
        bbPctVals = List.filled(len, null);
      }

      // Ichimoku
      List<double?> ichTenkan, ichKijun, ichSpanA, ichSpanB;
      try {
        final ich = TA.ichimoku(_fullBars);
        ichTenkan = ich.tenkan;
        ichKijun = ich.kijun;
        ichSpanA = ich.spanA;
        ichSpanB = ich.spanB;
      } catch (_) {
        ichTenkan = List.filled(len, null);
        ichKijun = List.filled(len, null);
        ichSpanA = List.filled(len, null);
        ichSpanB = List.filled(len, null);
      }

      // Vortex, Chop
      double lastVipVim = 0, lastChop = 61.8;
      bool isTrending = false;
      try {
        final vx = TAX.vortex(_fullBars);
        final vip = vx.vip.isNotEmpty ? (vx.vip.last ?? 1.0) : 1.0;
        final vim = vx.vim.isNotEmpty ? (vx.vim.last ?? 1.0) : 1.0;
        lastVipVim = vip - vim;
        final ch = TAX.chop(_fullBars);
        lastChop = ch.isNotEmpty ? (ch.last ?? 61.8) : 61.8;
        isTrending = lastChop < 61.8;
      } catch (_) {}

      // 2. Score & Strategie Logik
      final lastPrice = closes.last;
      final lastRsi = rsi.last ?? 50;
      final lastMacdHist = macdHist.last ?? 0;
      final lastEma20 = ema20.last ?? lastPrice;
      final lastEma50 = sma50.last ?? lastPrice;
      final lastAtr = atr.last ?? (lastPrice * 0.02);
      final lastStBull = stBull.isNotEmpty ? stBull.last : false;
      final lastStochK = stochK.last ?? 50;
      final lastObv = obv.last ?? 0;
      final lastAdx = adx.last ?? 0;
      final lastCci = cciVals.isNotEmpty ? (cciVals.last ?? 0) : 0.0;
      final lastPsarBull = psarBull.isNotEmpty ? psarBull.last : false;
      final lastPsar =
          psarSar.isNotEmpty ? (psarSar.last ?? lastPrice) : lastPrice;
      final lastCmf = cmfVals.isNotEmpty ? (cmfVals.last ?? 0) : 0.0;
      final lastMfi = mfiVals.isNotEmpty ? (mfiVals.last ?? 50) : 50.0;
      final lastAo = aoVals.isNotEmpty ? (aoVals.last ?? 0) : 0.0;
      final lastBbPct = bbPctVals.isNotEmpty ? (bbPctVals.last ?? 0.5) : 0.5;

      // Sichere Extraktion Donchian
      double lastDonchianLo = lastPrice * 0.95;
      if (donLo.isNotEmpty) {
        for (final v in donLo.reversed) {
          if (v != null) {
            lastDonchianLo = v;
            break;
          }
        }
      }
      double lastDonchianUp = lastPrice * 1.05;
      if (donUp.isNotEmpty) {
        for (final v in donUp.reversed) {
          if (v != null) {
            lastDonchianUp = v;
            break;
          }
        }
      }

      // Ichimoku letzte Werte
      final lastTenkan = ichTenkan.isNotEmpty ? ichTenkan.last : null;
      final lastKijun = ichKijun.isNotEmpty ? ichKijun.last : null;
      const int spanOffset = 26;
      final relevantSpanA = _fullBars.length > spanOffset
          ? ichSpanA[_fullBars.length - 1 - spanOffset]
          : null;
      final relevantSpanB = _fullBars.length > spanOffset
          ? ichSpanB[_fullBars.length - 1 - spanOffset]
          : null;

      // Pattern
      String pattern = "Kein Muster";
      try {
        final cps = TAX.detectAllPatterns(_fullBars);
        pattern = cps.isNotEmpty ? cps.first.name : "Kein Muster";
      } catch (_) {}

      // Divergenzen
      String divergenceType = "none";
      try {
        final divRes = TA.detectDivergences(closes, rsi);
        for (int i = 1; i <= 3; i++) {
          final idx = _fullBars.length - i;
          if (divRes.bullishIndices.contains(idx)) {
            divergenceType = "bullish";
            break;
          }
          if (divRes.bearishIndices.contains(idx)) {
            divergenceType = "bearish";
            break;
          }
        }
      } catch (_) {}

      // Kategorie-Budget-Scoring
      double trendScore = 0, momentumScore = 0, volumeScore = 0;
      double patternScore = 0, volatilityScore = 0;
      List<String> reasons = [];

      bool strongTrend = lastAdx > 25 && isTrending;

      // === TREND (max 35) ===
      if (lastStBull) {
        trendScore += 10;
        reasons.add("Supertrend Bullish");
      } else
        trendScore -= 10;
      if (lastPrice > lastEma20) {
        trendScore += 7;
        reasons.add("Kurs > EMA20");
      } else
        trendScore -= 7;
      if (lastPrice > lastEma50) {
        trendScore += 4;
        reasons.add("Kurs > EMA50");
      } else
        trendScore -= 4;
      if (lastPsarBull) {
        trendScore += 5;
        reasons.add("PSAR Bullish");
      } else
        trendScore -= 5;
      bool isCloudBullish = false;
      if (relevantSpanA != null && relevantSpanB != null) {
        if (lastPrice > relevantSpanA && lastPrice > relevantSpanB) {
          trendScore += 6;
          reasons.add("Kurs über Wolke");
          isCloudBullish = true;
        } else if (lastPrice < relevantSpanA && lastPrice < relevantSpanB) {
          trendScore -= 6;
        }
      }
      bool isCrossBullish = false;
      if (lastTenkan != null && lastKijun != null) {
        if (lastTenkan > lastKijun) {
          trendScore += 3;
          reasons.add("Tenkan > Kijun");
          isCrossBullish = true;
        } else
          trendScore -= 3;
      }
      if (lastVipVim > 0.1) {
        trendScore = (trendScore + 3).clamp(-35, 35);
        reasons.add("Vortex Bullish");
      } else if (lastVipVim < -0.1)
        trendScore = (trendScore - 3).clamp(-35, 35);
      trendScore = trendScore.clamp(-35, 35);

      // === MOMENTUM (max 25) ===
      if (strongTrend) {
        if (lastRsi > 50 && lastRsi < 80) {
          momentumScore += 8;
          reasons.add("RSI Momentum");
        } else if (lastRsi >= 80) {
          momentumScore -= 10;
          reasons.add("RSI Überhitzt");
        } else if (lastRsi < 40) momentumScore -= 5;
      } else {
        if (lastRsi > 70) {
          momentumScore -= 12;
          reasons.add("RSI Überkauft");
        } else if (lastRsi < 30) {
          momentumScore += 12;
          reasons.add("RSI Überverkauft");
        } else if (lastRsi > 55) momentumScore += 4;
      }
      if (lastMacdHist > 0) {
        momentumScore += 5;
        reasons.add("MACD positiv");
      } else
        momentumScore -= 5;
      if (lastAdx > 30) {
        momentumScore += 4;
        reasons.add("ADX Stark");
      } else if (lastAdx < 20) momentumScore -= 2;
      if (lastCci < -100) {
        momentumScore += 5;
        reasons.add("CCI Überverkauft");
      } else if (lastCci > 100) {
        momentumScore -= 5;
        reasons.add("CCI Überkauft");
      }
      if (lastAo > 0)
        momentumScore += 3;
      else
        momentumScore -= 3;
      momentumScore = momentumScore.clamp(-25, 25);

      // === VOLUMEN (max 20) ===
      double prevObv5 = obv.length > 5 ? (obv[obv.length - 5] ?? 0) : 0;
      if (lastObv > prevObv5) {
        volumeScore += 8;
        reasons.add("OBV Steigend");
      } else
        volumeScore -= 8;
      if (lastCmf > 0.05) {
        volumeScore += 6;
        reasons.add("CMF Positiv");
      } else if (lastCmf < -0.05) {
        volumeScore -= 6;
        reasons.add("CMF Negativ");
      }
      if (lastMfi < 20) {
        volumeScore += 6;
        reasons.add("MFI Überverkauft");
      } else if (lastMfi > 80) {
        volumeScore -= 6;
        reasons.add("MFI Überkauft");
      }
      volumeScore = volumeScore.clamp(-20, 20);

      // === MUSTER (max 15) ===
      if (pattern.contains("Bullish") ||
          pattern.contains("Hammer") ||
          pattern.contains("Morning") ||
          pattern.contains("Piercing") ||
          pattern.contains("White") ||
          pattern.contains("Tweezers Bottom")) {
        patternScore += 8;
        reasons.add("Muster: $pattern");
      } else if (pattern.contains("Bearish") ||
          pattern.contains("Shooting") ||
          pattern.contains("Evening") ||
          pattern.contains("Dark") ||
          pattern.contains("Crows") ||
          pattern.contains("Tweezers Top")) {
        patternScore -= 8;
        reasons.add("Muster: $pattern");
      }
      if (divergenceType == "bullish") {
        patternScore += 7;
        reasons.add("Bullish Divergenz");
      } else if (divergenceType == "bearish") {
        patternScore -= 7;
        reasons.add("Bearish Divergenz");
      }
      patternScore = patternScore.clamp(-15, 15);

      // === VOLATILITÄT (max 5) ===
      if (squeeze.isNotEmpty && squeeze.last) {
        volatilityScore += 3;
        reasons.add("Squeeze Aktiv");
      }
      if (lastBbPct < 0.1) {
        volatilityScore += 2;
        reasons.add("BB Oversold");
      } else if (lastBbPct > 0.9) volatilityScore -= 2;
      volatilityScore = volatilityScore.clamp(-5, 5);

      // Gesamt-Score
      final double rawScore = 50 +
          trendScore +
          momentumScore +
          volumeScore +
          patternScore +
          volatilityScore;
      int score = rawScore.round().clamp(0, 100);

      String type = "Neutral";
      if (score >= 80)
        type = "Strong Buy";
      else if (score >= 60)
        type = "Buy";
      else if (score <= 20)
        type = "Strong Sell";
      else if (score <= 40) type = "Sell";

      // 3. Entry / SL / TP
      bool isLong = score >= 50;
      double entry = lastPrice;

      double paddingVal = 0.0;
      if (_settings.entryPaddingType == 0) {
        paddingVal = lastPrice * (_settings.entryPadding / 100);
      } else {
        paddingVal = lastAtr * _settings.entryPadding;
      }

      if (_settings.entryStrategy == 1) {
        if (isLong)
          entry = lastPrice - paddingVal;
        else
          entry = lastPrice + paddingVal;
      } else if (_settings.entryStrategy == 2) {
        if (isLong)
          entry = _fullBars.last.high + paddingVal;
        else
          entry = _fullBars.last.low - paddingVal;
      }

      double sl, tp1, tp2;
      if (isLong) {
        if (_settings.stopMethod == 0)
          sl = lastDonchianLo;
        else if (_settings.stopMethod == 1)
          sl = lastPrice * (1 - _settings.stopPercent / 100);
        else
          sl = lastPrice - (_settings.atrMult * lastAtr);
        if (sl >= entry) sl = entry * 0.99;
      } else {
        if (_settings.stopMethod == 0)
          sl = lastDonchianUp;
        else if (_settings.stopMethod == 1)
          sl = lastPrice * (1 + _settings.stopPercent / 100);
        else
          sl = lastPrice + (_settings.atrMult * lastAtr);
        if (sl <= entry) sl = entry * 1.01;
      }

      final risk = (entry - sl).abs();
      if (isLong) {
        if (_settings.tpMethod == 1) {
          tp1 = entry * (1 + _settings.tpPercent1 / 100);
          tp2 = entry * (1 + _settings.tpPercent2 / 100);
        } else if (_settings.tpMethod == 2) {
          final atrRisk = lastAtr * _settings.atrMult;
          tp1 = entry + (atrRisk * _settings.rrTp1);
          tp2 = entry + (atrRisk * _settings.rrTp2);
        } else {
          tp1 = entry + (risk * _settings.rrTp1);
          tp2 = entry + (risk * _settings.rrTp2);
        }
      } else {
        tp1 = entry - (risk * _settings.rrTp1);
        tp2 = entry - (risk * _settings.rrTp2);
      }

      double crvRisk = (entry - sl).abs();
      double reward = (tp2 - entry).abs();
      double crv = crvRisk == 0 ? 0 : reward / crvRisk;

      final signal = TradeSignal(
        type: type,
        entryPrice: entry,
        stopLoss: sl,
        takeProfit1: tp1,
        takeProfit2: tp2,
        riskRewardRatio: crv,
        score: score,
        reasons: reasons,
        chartPattern: pattern,
        tp1Percent: ((tp1 - entry) / entry * 100).abs(),
        tp2Percent: ((tp2 - entry) / entry * 100).abs(),
        indicatorValues: {
          'rsi': lastRsi,
          'ema20': lastEma20,
          'ema50': lastEma50,
          'price': lastPrice,
          'macdHist': lastMacdHist,
          'stBull': lastStBull,
          'stochK': lastStochK,
          'obv': lastObv,
          'adx': lastAdx,
          'squeeze': squeeze.isNotEmpty && squeeze.last,
          'cci': lastCci,
          'cmf': lastCmf,
          'mfi': lastMfi,
          'ao': lastAo,
          'bbPct': lastBbPct,
          'psarBull': lastPsarBull,
          'psar': lastPsar,
          'vortex': lastVipVim,
          'chop': lastChop,
          'isTrending': isTrending,
          'ichimoku_cloud_bull': isCloudBullish,
          'ichimoku_cross_bull': isCrossBullish,
          'divergence': divergenceType,
          'score_trend': trendScore,
          'score_momentum': momentumScore,
          'score_volume': volumeScore,
          'score_pattern': patternScore,
          'score_volatility': volatilityScore,
        },
      );

      // 4. Slicing für Chart
      int days = _settings.chartRangeDays;
      if (_selectedChartRange == ChartRange.week1) days = 14;
      if (_selectedChartRange == ChartRange.month1) days = 30;
      if (_selectedChartRange == ChartRange.quarter1) days = 90;
      if (_selectedChartRange == ChartRange.year1) days = 365;
      if (_selectedChartRange == ChartRange.year2) days = 365 * 2;
      if (_selectedChartRange == ChartRange.year3) days = 365 * 3;
      if (_selectedChartRange == ChartRange.year5) days = 365 * 5;

      int start = (_fullBars.length - days).clamp(0, _fullBars.length);
      List<T> slice<T>(List<T> l) => l.sublist(start);

      _computedData = ComputedData(
        bars: slice(_fullBars),
        sma50: slice(sma50),
        ema20: slice(ema20),
        rsi: slice(rsi),
        macd: slice(macd),
        macdSignal: slice(macdSignal),
        macdHist: slice(macdHist),
        atr: slice(atr),
        bbUp: slice(bbUp),
        bbMid: slice(bbMid),
        bbLo: slice(bbLo),
        donchianUp: slice(donUp),
        donchianMid: slice(donMid),
        donchianLo: slice(donLo),
        stLine: slice(stLine),
        stBull: slice(stBull),
        squeezeFlags: slice(squeeze),
        adx: slice(adx),
        stochK: slice(stochK),
        stochD: slice(stochD),
        obv: slice(obv),
        proj: proj,
        fundamentals: _fundamentalData,
        latestSignal: signal,
      );
      notifyListeners();
    } catch (e, stack) {
      debugPrint("Kritischer Fehler in _recalculate: $e\n$stack");
      // Fallback: Zeige zumindest den Chart ohne Indikatoren
      // Damit der User nicht vor einem leeren Screen sitzt.
      try {
        int days = _settings.chartRangeDays;
        int start = (_fullBars.length - days).clamp(0, _fullBars.length);
        final slicedBars = _fullBars.sublist(start);
        final len = slicedBars.length;

        _computedData = ComputedData(
          bars: slicedBars,
          sma50: List.filled(len, null),
          ema20: List.filled(len, null),
          rsi: List.filled(len, null),
          macd: List.filled(len, null),
          macdSignal: List.filled(len, null),
          macdHist: List.filled(len, null),
          atr: List.filled(len, null),
          bbUp: List.filled(len, null),
          bbMid: List.filled(len, null),
          bbLo: List.filled(len, null),
          donchianUp: List.filled(len, null),
          donchianMid: List.filled(len, null),
          donchianLo: List.filled(len, null),
          stLine: List.filled(len, null),
          stBull: List.filled(len, false),
          squeezeFlags: List.filled(len, false),
          adx: List.filled(len, null),
          stochK: List.filled(len, null),
          stochD: List.filled(len, null),
          obv: List.filled(len, null),
          proj: null,
          fundamentals: _fundamentalData,
          latestSignal: null,
        );
        notifyListeners();
      } catch (e2) {
        debugPrint("Selbst Fallback fehlgeschlagen: $e2");
        _error = "Datenfehler: $e";
        notifyListeners();
      }
    }
  }

  void _addToHistory(String sym) {
    if (_searchHistory.contains(sym)) {
      _searchHistory.remove(sym);
    }
    _searchHistory.insert(0, sym);
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }
    _saveState();
  }

  void clearHistory() {
    _searchHistory.clear();
    _saveState();
    notifyListeners();
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_symbol', _symbol);
    await prefs.setInt('last_timeframe', _selectedTimeFrame.index); // NEU
    await prefs.setInt('last_chart_range', _selectedChartRange.index); // ALT
    await prefs.setStringList('search_history', _searchHistory);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    int idx = prefs.getInt('theme') ?? 1;
    String? avKey = prefs.getString('av_key');
    String? fmpKey = prefs.getString('fmp_key');

    // Load State
    String? lastSym = prefs.getString('last_symbol');
    if (lastSym != null && lastSym.isNotEmpty) {
      _symbol = lastSym;
      // Yahoo Symbol sync
      String ySym = _symbol;
      if (ySym.endsWith(".US")) ySym = ySym.replaceAll(".US", "");
      if (ySym.endsWith(".DEF")) ySym = ySym.replaceAll(".DEF", ".DE");
      if (ySym == '^DAX') ySym = '^GDAXI';
      _yahooSymbol = ySym;
    }
    // NEU: Lade das letzte Intervall
    int? tfIdx = prefs.getInt(
        'last_timeframe'); // 'last_timeframe' wird jetzt für das Intervall verwendet
    if (tfIdx != null && tfIdx >= 0 && tfIdx < TimeFrame.values.length) {
      _selectedTimeFrame = TimeFrame.values[tfIdx];
    }
    // ALT: Lade den letzten Chart-Range
    int? rangeIdx = prefs.getInt('last_chart_range');
    if (rangeIdx != null &&
        rangeIdx >= 0 &&
        rangeIdx < ChartRange.values.length) {
      _selectedChartRange = ChartRange.values[rangeIdx];
    }
    _searchHistory = prefs.getStringList('search_history') ?? [];

    _themeMode = idx == 0 ? ThemeMode.light : ThemeMode.dark;
    if (avKey != null) _settings = _settings.copyWith(alphaVantageKey: avKey);
    if (fmpKey != null) _settings = _settings.copyWith(fmpKey: fmpKey);

    // Load Strategy Settings
    _settings = _settings.copyWith(
      entryStrategy: prefs.getInt('man_entry_strat') ?? 0,
      entryPadding: prefs.getDouble('man_entry_pad') ?? 0.2,
      entryPaddingType: prefs.getInt('man_entry_pad_type') ?? 0,
      stopMethod: prefs.getInt('man_stop_method') ?? 2,
      stopPercent: prefs.getDouble('man_stop_pct') ?? 5.0,
      atrMult: prefs.getDouble('man_atr_mult') ?? 2.0,
      tpMethod: prefs.getInt('man_tp_method') ?? 0,
      rrTp1: prefs.getDouble('man_rr_tp1') ?? 1.5,
      rrTp2: prefs.getDouble('man_rr_tp2') ?? 3.0,
      tpPercent1: prefs.getDouble('man_tp_pct1') ?? 5.0,
      tpPercent2: prefs.getDouble('man_tp_pct2') ?? 10.0,
    );
    notifyListeners();
  }

  // Setzt die Strategie-Parameter auf empfohlene Standardwerte zurück
  void resetStrategySettings() {
    _settings = _settings.copyWith(
      entryStrategy: 0, // Market
      entryPadding: 0.2, // 0.2%
      entryPaddingType: 0, // Prozent
      stopMethod: 2, // ATR
      stopPercent: 5.0,
      atrMult: 2.0, // Standard Swing
      tpMethod: 0, // Risk/Reward
      rrTp1: 1.5,
      rrTp2: 3.0,
      tpPercent1: 5.0,
      tpPercent2: 10.0,
    );
    _saveSettings();
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('theme', _themeMode == ThemeMode.light ? 0 : 1);
    if (_settings.alphaVantageKey != null)
      prefs.setString('av_key', _settings.alphaVantageKey!);
    if (_settings.fmpKey != null) prefs.setString('fmp_key', _settings.fmpKey!);

    // Save Strategy Settings
    prefs.setInt('man_entry_strat', _settings.entryStrategy);
    prefs.setDouble('man_entry_pad', _settings.entryPadding);
    prefs.setInt('man_entry_pad_type', _settings.entryPaddingType);
    prefs.setInt('man_stop_method', _settings.stopMethod);
    prefs.setDouble('man_stop_pct', _settings.stopPercent);
    prefs.setDouble('man_atr_mult', _settings.atrMult);
    prefs.setInt('man_tp_method', _settings.tpMethod);
    prefs.setDouble('man_rr_tp1', _settings.rrTp1);
    prefs.setDouble('man_rr_tp2', _settings.rrTp2);
    prefs.setDouble('man_tp_pct1', _settings.tpPercent1);
    prefs.setDouble('man_tp_pct2', _settings.tpPercent2);
  }
}
