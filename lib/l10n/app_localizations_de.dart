// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'TechAna';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get systemLanguage => 'Systemsprache';

  @override
  String get navAnalysis => 'Analyse';

  @override
  String get navAutoBot => 'AutoBot';

  @override
  String get navSettings => 'Settings';

  @override
  String get searchHint => 'Symbol suchen (z.B. AAPL.US)';

  @override
  String get noAnalysis => 'Keine Analyse';

  @override
  String get tradingScore => 'Trading Score';

  @override
  String get noPattern => 'Kein Muster';

  @override
  String get bullishDivergence => 'Bullish Divergenz';

  @override
  String get bearishDivergence => 'Bearish Divergenz';

  @override
  String get unknown => 'Unbekannt';

  @override
  String errorPrefix(String error) {
    return 'Fehler: $error';
  }

  @override
  String get retryButton => 'Erneut versuchen';

  @override
  String get fundamentals => 'Fundamentals';

  @override
  String get newsYahoo => 'News (Yahoo)';

  @override
  String get monteCarlo => 'Monte Carlo';

  @override
  String get kronosAi => 'Kronos KI';

  @override
  String get close => 'Schließen';

  @override
  String currentValue(String value) {
    return 'Aktueller Wert: $value';
  }

  @override
  String get rsiOverbought => 'Überkauft';

  @override
  String get rsiOversold => 'Überverkauft';

  @override
  String get rsiNeutral => 'Neutral';

  @override
  String get macdPositive => 'Positiv';

  @override
  String get macdNegative => 'Negativ';

  @override
  String get mcBullish => 'Bullish';

  @override
  String get mcSlightlyBullish => 'Leicht Bullish';

  @override
  String get mcBearish => 'Bearish';

  @override
  String get mcSlightlyBearish => 'Leicht Bearish';

  @override
  String get mcNeutral => 'Neutral';

  @override
  String get mtcBullishConfirmed => 'MTC: Bullish Bestätigt (H1, H4, D1)';

  @override
  String get mtcBearishConfirmed => 'MTC: Bearish Bestätigt (H1, H4, D1)';

  @override
  String get mtcNeutral => 'MTC: Neutral';

  @override
  String get kronosAiAnalysis => 'Kronos KI Analyse';

  @override
  String get modelCalculatingForecast => 'Modell berechnet Vorhersage...';

  @override
  String get tp1HitChance => 'TP1 Hit Chance';

  @override
  String get tp2HitChance => 'TP2 Hit Chance';

  @override
  String get slHitChance => 'SL Hit Chance';

  @override
  String get volume => 'Volumen';

  @override
  String get adxTrendStrength => 'ADX (Trendstärke)';

  @override
  String get tabView => 'Ansicht';

  @override
  String get tabChart => 'Chart';

  @override
  String get tabStrategy => 'Strategie';

  @override
  String get tabData => 'Daten';

  @override
  String get viewAndGeneral => 'Ansicht & Allgemein';

  @override
  String get darkTheme => 'Dunkles Design';

  @override
  String get showCandlesticks => 'Candlesticks anzeigen';

  @override
  String get showCandlesticksSubtitle => 'Zeigt Kerzen statt Linie';

  @override
  String get patternMarkers => 'Muster-Marker';

  @override
  String get tradingLines => 'Trading-Linien (TP/SL)';

  @override
  String get chartIndicators => 'Indikatoren im Chart';

  @override
  String get ema20Line => 'EMA 20 Linie';

  @override
  String get bollingerBands => 'Bollinger Bands';

  @override
  String get projectionDays => 'Projektion (Tage)';

  @override
  String get additionalCharts => 'Zusatz-Graphen (unten)';

  @override
  String get volumeChart => 'Volumen Chart';

  @override
  String get rsiIndicator => 'RSI Indikator';

  @override
  String get macdIndicator => 'MACD Indikator';

  @override
  String get stochasticOscillator => 'Stochastic Oszillator';

  @override
  String get obvIndicator => 'On-Balance Volume (OBV)';

  @override
  String get adxIndicator => 'ADX (Trendstärke)';

  @override
  String get manualAnalysisStrategy => 'Manuelle Analyse Strategie';

  @override
  String get entryStrategy => 'Entry Strategie';

  @override
  String get marketImmediate => 'Market (Sofort)';

  @override
  String get pullbackLimit => 'Pullback (Limit)';

  @override
  String get breakoutStop => 'Breakout (Stop)';

  @override
  String get entryStrategyDesc =>
      'Wann einsteigen? \'Market\' kauft sofort. \'Pullback\' wartet auf günstigeren Preis. \'Breakout\' kauft bei Ausbruch nach oben (teurer). Empfohlen: Market oder Pullback.';

  @override
  String get entryPaddingType => 'Entry Padding Typ';

  @override
  String get percentual => 'Prozentual (%)';

  @override
  String get atrFactor => 'ATR Faktor';

  @override
  String get entryPaddingPercent => 'Entry Padding %';

  @override
  String get entryPaddingAtr => 'Entry Padding (x ATR)';

  @override
  String get entryPaddingDesc =>
      'Abstand zum aktuellen Kurs für die Order. Standard: 0.2% oder 0.5x ATR.';

  @override
  String get stopLossMethod => 'Stop Loss Methode';

  @override
  String get donchianLow => 'Donchian Low';

  @override
  String get percentualMethod => 'Prozentual';

  @override
  String get atrVolatility => 'ATR (Volatilität)';

  @override
  String get swingLowHigh => 'Swing-Low/High';

  @override
  String get stopLossDesc =>
      'Wie wird der Stop Loss gesetzt? ATR passt sich der Marktschwankung an (Profi-Standard). Swing nutzt das letzte signifikante Tief/Hoch.';

  @override
  String get stopLossPercent => 'Stop Loss %';

  @override
  String get stopLossPercentDesc =>
      'Fester prozentualer Abstand. Standard: 5-8%.';

  @override
  String get atrMultiplier => 'ATR Multiplikator';

  @override
  String get atrMultiplierDesc =>
      'Wie viel \'Luft\' hat der Trade? 2.0x ATR ist Standard für Swing-Trading. Kleiner = engerer Stop.';

  @override
  String get swingLookbackCandles => 'Swing Lookback (Kerzen)';

  @override
  String get swingLookbackDesc =>
      'Wie viele Kerzen zurückschauen um das letzte Swing-Tief/Hoch zu finden. Standard: 20.';

  @override
  String get takeProfitMethod => 'Take Profit Methode';

  @override
  String get riskRewardCrv => 'Risk/Reward (CRV)';

  @override
  String get atrTarget => 'ATR-Ziel';

  @override
  String get pivotPoints => 'Pivot Points';

  @override
  String get takeProfitDesc =>
      'Wann Gewinne mitnehmen? Pivot Points nutzt klassische Floor-Pivot-Levels als Ziele. CRV empfohlen für Anfänger.';

  @override
  String get tp1Factor => 'TP1 Faktor';

  @override
  String get tp1FactorDesc =>
      'Erstes Ziel: Vielfaches des Risikos. Standard: 1.5x (bei 100€ Risiko -> 150€ Gewinn).';

  @override
  String get tp2Factor => 'TP2 Faktor';

  @override
  String get tp2FactorDesc => 'Zweites Ziel (Moonbag). Standard: 3.0x.';

  @override
  String get tp1Percent => 'TP1 %';

  @override
  String get tp1PercentDesc => 'Fester Gewinn in %. Standard: 5-10%.';

  @override
  String get tp2Percent => 'TP2 %';

  @override
  String get tp2PercentDesc => 'Fernes Ziel in %. Standard: 10-20%.';

  @override
  String get mcSimulations => 'MC Simulationen';

  @override
  String get mcSimulationsDesc =>
      'Anzahl der Szenarien für das Scoring. Höher = genauer, aber langsamer. Standard: 200.';

  @override
  String get resetToDefaults => 'Auf Standardwerte zurücksetzen';

  @override
  String get expertFeaturesAi => 'Experten Features (AI/Algo)';

  @override
  String get marketRegimeFilter => 'Markt-Regime Filter';

  @override
  String get marketRegimeSubtitle => 'Anpassung an Trend/Range/Volatilität';

  @override
  String get aiProbabilityScoring => 'AI Probability Scoring';

  @override
  String get aiProbabilitySubtitle => 'Gewichtung nach hist. Trefferrate';

  @override
  String get multiTimeframeMtc => 'Multi-Timeframe (MTC)';

  @override
  String get mtcSubtitle => 'Bestätigung auf höheren Zeitebenen';

  @override
  String get strategyOptimizer => 'Strategy Optimizer';

  @override
  String get strategyOptimizerSubtitle => 'Sucht ideale Indikator-Parameter';

  @override
  String get dataSources => 'Datenquellen';

  @override
  String get chartDataSource => 'Chart: Stooq.com (Frei)';

  @override
  String get alphaVantageLabel => 'Alpha Vantage API Key (für Fundamentals)';

  @override
  String get alphaVantageHint => 'Hier Key eingeben (optional)';

  @override
  String get fmpLabel => 'FMP API Key (Financial Modeling Prep)';

  @override
  String get fmpHint => 'Key eingeben';

  @override
  String get hfTokenLabel => 'HuggingFace Token (Kronos AI)';

  @override
  String get kronosServerUrl => 'Kronos Server URL';

  @override
  String get kronosServerHint => 'z.B. http://192.168.178.139:8000';

  @override
  String get kronosServerHelper =>
      'Leer = lokales Backend auf Desktop. Für Android/iOS: IP des PCs eingeben.';

  @override
  String version(String ver, String build) {
    return 'Version $ver+$build';
  }

  @override
  String get botDashboard => 'Bot Dashboard';

  @override
  String get cancelScan => 'Scan abbrechen';

  @override
  String get startScan => 'Scan starten';

  @override
  String get topMoversScan => 'Top Movers Scan';

  @override
  String get botSettings => 'Bot Einstellungen';

  @override
  String get editWatchlist => 'Watchlist bearbeiten';

  @override
  String get portfolioReset => 'Portfolio Reset';

  @override
  String get openDetailedAnalysis => 'Detaillierte Bot Analyse öffnen';

  @override
  String get positionsByCategory => 'Positionen nach Kategorie';

  @override
  String get allPositionsRaw => 'Alle Positionen (Rohdaten)';

  @override
  String tradesTotal(int count) {
    return '$count Trades gesamt';
  }

  @override
  String get filterAll => 'Alle';

  @override
  String get filterOpen => 'Offen';

  @override
  String get filterOpenPositive => 'Offen +';

  @override
  String get filterOpenNegative => 'Offen -';

  @override
  String get filterPending => 'Pending';

  @override
  String get filterClosed => 'Geschlossen';

  @override
  String get filterClosedPositive => 'Geschlossen +';

  @override
  String get filterClosedNegative => 'Geschlossen -';

  @override
  String get noTrades => 'Keine Trades vorhanden.';

  @override
  String get otherCategory => 'Sonstige';

  @override
  String get noCategorizedTrades => 'Keine kategorisierten Trades vorhanden.';

  @override
  String get resetPortfolioTitle => 'Portfolio zurücksetzen?';

  @override
  String get resetPortfolioContent =>
      'Dies löscht ALLE Trades und setzt das investierte Kapital auf 0 zurück. Bist du sicher?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get deleteAll => 'Alles Löschen';

  @override
  String get botWatchlist => 'Bot Watchlist';

  @override
  String get symbolHint => 'Symbol (z.B. BTC-USD)';

  @override
  String get selectAll => 'Alle';

  @override
  String get selectNone => 'Keine';

  @override
  String get done => 'Fertig';

  @override
  String get portfolioPerformance => 'Portfolio Performance (PnL)';

  @override
  String currentPnlTemplate(String value) {
    return 'Aktuell: $value €';
  }

  @override
  String get invested => 'Investiert';

  @override
  String get unrealizedPnl => 'Unreal. PnL';

  @override
  String get realizedPnl => 'Realisiert PnL';

  @override
  String get open => 'Offen';

  @override
  String get closed => 'Geschlossen';

  @override
  String get total => 'Gesamt';

  @override
  String totalLabel(int count) {
    return 'Gesamt: $count';
  }

  @override
  String trades(int count) {
    return 'Trades: $count';
  }

  @override
  String posCount(int count) {
    return '$count Pos.';
  }

  @override
  String get checkPending => 'Check Pending';

  @override
  String get checkOpen => 'Check Open';

  @override
  String get marketScan => 'Markt Scan';

  @override
  String get botConfiguration => 'Bot Konfiguration';

  @override
  String get tabGeneral => 'Allgemein';

  @override
  String get botActive => 'Bot Aktiv (Auto-Run)';

  @override
  String runningInBackground(int minutes) {
    return 'Läuft im Hintergrund (Alle $minutes Min)';
  }

  @override
  String get paused => 'Pausiert';

  @override
  String get cancelRunningScan => 'Laufenden Scan sofort abbrechen';

  @override
  String get routineScope => 'Routine Umfang';

  @override
  String get checkPendingOrders => 'Pending Orders prüfen';

  @override
  String get checkPendingSubtitle => 'Prüft Limit/Stop Orders (Entry).';

  @override
  String get checkOpenPositions => 'Offene Positionen prüfen';

  @override
  String get checkOpenSubtitle => 'Prüft SL/TP und aktualisiert PnL.';

  @override
  String get scanForNewTrades => 'Nach neuen Trades suchen';

  @override
  String get scanForNewSubtitle => 'Scannt Watchlist nach Signalen.';

  @override
  String get moneyManagement => 'Money Management';

  @override
  String get investPerTrade => 'Invest pro Trade (€)';

  @override
  String get investPerTradeDesc => 'Basis-Investition pro Position.';

  @override
  String get unlimitedPositions => 'Unbegrenzte Positionen';

  @override
  String get maxOpenPositions => 'Max. offene Positionen';

  @override
  String get automation => 'Automatisierung';

  @override
  String get scanInterval => 'Scan Intervall (Min)';

  @override
  String get scanIntervalDesc => 'Häufigkeit der automatischen Prüfung.';

  @override
  String get mcSimulationsScoring => 'MC Simulationen (Scoring)';

  @override
  String get mcSimulationsScoringDesc =>
      'Anzahl Szenarien für das Bot-Scoring. Standard: 200.';

  @override
  String get mcStrictMode => 'MC Strict Mode';

  @override
  String get mcStrictModeSubtitle =>
      'Nur Trades eröffnen, wenn MC Treffer-Wahrscheinlichkeit für TP > SL ist.';

  @override
  String get tradeManagement => 'Trade Management';

  @override
  String get trailingStopAtr => 'Trailing Stop (x ATR)';

  @override
  String get trailingStopDesc => 'Stop Loss automatisch nachziehen.';

  @override
  String get dynamicPositionSize => 'Dynamische Positionsgröße';

  @override
  String get dynamicPositionSubtitle =>
      'Invest verdoppeln bei hohem Score (>80).';

  @override
  String get aiAndAnalysis => 'KI & Analyse';

  @override
  String get kronosAiAnalysisTitle => 'Kronos KI Analyse';

  @override
  String get kronosAiSubtitle =>
      'Nutzt Foundation Model für Kursvorhersage pro Symbol.';

  @override
  String get kronosStrictMode => 'Kronos Strict Mode';

  @override
  String get kronosStrictSubtitle =>
      'Nur Trades eröffnen, wenn Kronos TP1 VOR SL vorhersagt.';

  @override
  String get resetAllSettings => 'Alle Einstellungen zurücksetzen';

  @override
  String get settingsNote =>
      'Hinweis: Änderungen werden sofort gespeichert und beim nächsten Scan angewendet.';

  @override
  String get generalAndTimeframe => 'Allgemein & Zeitrahmen';

  @override
  String get alternatingStrategies => 'Wechselnde Strategien';

  @override
  String get alternatingStrategiesSubtitle =>
      'Für jeden Scan zufällige Werte testen';

  @override
  String get analysisInterval => 'Analyse Interval';

  @override
  String get entrySection => 'Entry (Einstieg)';

  @override
  String get strategyType => 'Strategie Typ';

  @override
  String get paddingType => 'Padding Typ';

  @override
  String get paddingPercent => 'Padding %';

  @override
  String get paddingAtr => 'Padding (x ATR)';

  @override
  String get stopLossRisk => 'Stop Loss (Risiko)';

  @override
  String get method => 'Methode';

  @override
  String get donchianLowHigh => 'Donchian Low/High';

  @override
  String get stopDistance => 'Stop Abstand %';

  @override
  String get takeProfitTargets => 'Take Profit (Ziele)';

  @override
  String get sellAtTp1 => 'Verkauf bei TP1 (%)';

  @override
  String get tp1FactorR => 'TP1 Faktor (R)';

  @override
  String get tp2FactorR => 'TP2 Faktor (R)';

  @override
  String get marketRegimeSubtitleBot => 'Anpassung an Trend/Range/Volatilität.';

  @override
  String get aiProbabilitySubtitleBot => 'Gewichtung nach hist. Trefferrate.';

  @override
  String get mtcSubtitleBot => 'Trendbestätigung auf höheren Zeitebenen.';

  @override
  String get strategyOptimizerSubtitleBot =>
      'Sucht ideale Indikator-Parameter.';

  @override
  String get timeframe15min => '15 Min';

  @override
  String get timeframe1h => '1 Std';

  @override
  String get timeframe4h => '4 Std';

  @override
  String get timeframeDay => 'Tag';

  @override
  String get timeframeWeek => 'Woche';

  @override
  String get regimeTrendingBull => 'Bullischer Trend';

  @override
  String get regimeTrendingBear => 'Bearischer Trend';

  @override
  String get regimeRanging => 'Seitwärts (Range)';

  @override
  String get regimeVolatile => 'Volatil (Choppy)';

  @override
  String get regimeUnknown => 'Unbekannt';

  @override
  String get noData => 'Keine Daten verfügbar';

  @override
  String get analysisDetails => 'Analyse Details';

  @override
  String get strategySettings => 'Strategie-Einstellungen';

  @override
  String get alreadyInWatchlist => 'Bereits in Bot Watchlist';

  @override
  String get addToWatchlist => 'Zur Bot Watchlist hinzufügen';

  @override
  String addedToWatchlist(String symbol) {
    return '$symbol zur Bot-Watchlist hinzugefügt!';
  }

  @override
  String regimePrefix(String label) {
    return 'Regime: $label';
  }

  @override
  String get avgConfidence => 'Durchschnittliche Konfidenz';

  @override
  String get indicatorWeighting =>
      'Indikator-Gewichtung (Erfolgsrate letzte 50 Bars):';

  @override
  String get scoreBreakdown => 'Score-Aufschlüsselung (Tippbar für Details):';

  @override
  String get tapForDetails => 'Tippen für Details';

  @override
  String get tapForIndicators => 'Tippen für Details';

  @override
  String get catTrend => 'Trend';

  @override
  String get catMomentum => 'Momentum';

  @override
  String get catVolume => 'Volumen';

  @override
  String get catPattern => 'Muster';

  @override
  String get catVolatility => 'Volatilität';

  @override
  String get stDesc => 'Trendfolgender Indikator basierend auf der ATR.';

  @override
  String get emaDesc => 'Gleitende Durchschnitte zeigen die Trendrichtung.';

  @override
  String get psarDesc => 'Identifiziert Trendwenden und potenzielle Ausstiege.';

  @override
  String get ichimokuDesc => 'Komplexe Cloud-Analyse für Trend und Support.';

  @override
  String get vortexChopDesc =>
      'VX misst Trendstärke; CHOP zeigt Range vs Trend.';

  @override
  String get rsiDesc =>
      'Misst Geschwindigkeit und Dynamik von Preisbewegungen.';

  @override
  String get macdDesc =>
      'Zeigt das Verhältnis zweier gleitender Durchschnitte.';

  @override
  String get adxDesc => 'Misst die allgemeine Stärke eines Trends.';

  @override
  String get cciDesc => 'Identifiziert zyklische Trends und Extrembereiche.';

  @override
  String get stochDesc => 'Vergleicht Schlusskurs mit Preisspanne über Zeit.';

  @override
  String get aoDesc => 'Indikator für das Marktmomentum (AO).';

  @override
  String get obvDesc => 'Nutzt den Volumenfluss zur Kursprognose.';

  @override
  String get cmfDesc => 'Misst den volumengewichteten Geldfluss.';

  @override
  String get mfiDesc => 'RSI kombiniert mit Volumen für Geldfluss.';

  @override
  String get divDesc => 'Divergenz-Signal zwischen Preis und Momentum.';

  @override
  String get squeezeDesc => 'Volatilitätskompression vor Ausbruch.';

  @override
  String get bbPctDesc => 'Position des Preises relativ zu Bollinger Bändern.';

  @override
  String indicatorValue(String value) {
    return 'Wert: $value';
  }

  @override
  String get entryPrice => 'Entry Preis';

  @override
  String get stopLoss => 'Stop Loss';

  @override
  String get takeProfit1 => 'Take Profit 1';

  @override
  String get takeProfit2 => 'Take Profit 2';

  @override
  String get riskRewardShort => 'Risk/Reward (CRV)';

  @override
  String get entry => 'Entry';

  @override
  String get stopLossShort => 'SL';

  @override
  String get takeProfit1Short => 'TP1';

  @override
  String get takeProfit2Short => 'TP2';

  @override
  String get aiConfidence => 'AI-Konf.';

  @override
  String get positive => 'Pos';

  @override
  String get negative => 'Neg';

  @override
  String get overbought => 'Überkauft';

  @override
  String get oversold => 'Überverkauft';

  @override
  String get neutral => 'Neutral';

  @override
  String get optimizedLabel => 'OPT';

  @override
  String get explanation => 'Erklärung';

  @override
  String get patternBullishDivergence => 'Bullish Divergenz';

  @override
  String get patternBearishDivergence => 'Bearish Divergenz';

  @override
  String get patternDoji => 'Doji';

  @override
  String get patternLongLeggedDoji => 'Long-Legged Doji';

  @override
  String get patternSpinningTop => 'Spinning Top';

  @override
  String get patternMarubozuBullish => 'Marubozu Bullish';

  @override
  String get patternMarubozuBearish => 'Marubozu Bearish';

  @override
  String get patternHammer => 'Hammer';

  @override
  String get patternInvertedHammer => 'Inverted Hammer';

  @override
  String get patternShootingStar => 'Shooting Star';

  @override
  String get patternHangingMan => 'Hanging Man';

  @override
  String get patternBullishEngulfing => 'Bullish Engulfing';

  @override
  String get patternBearishEngulfing => 'Bearish Engulfing';

  @override
  String get patternPiercingLine => 'Piercing Line';

  @override
  String get patternDarkCloudCover => 'Dark Cloud Cover';

  @override
  String get patternBullishHarami => 'Bullish Harami';

  @override
  String get patternBearishHarami => 'Bearish Harami';

  @override
  String get patternTweezersBottom => 'Tweezers Bottom';

  @override
  String get patternTweezersTop => 'Tweezers Top';

  @override
  String get patternKickingBullish => 'Kicking Bullish';

  @override
  String get patternMorningStar => 'Morning Star';

  @override
  String get patternEveningStar => 'Evening Star';

  @override
  String get pattern3WhiteSoldiers => '3 White Soldiers';

  @override
  String get pattern3BlackCrows => '3 Black Crows';

  @override
  String get patternBullishDivergenceDesc =>
      'Eine Bullish Divergenz tritt auf, wenn der Preis ein neues Tief macht, der RSI aber ein HÖHERES Tief bildet. Dies zeigt, dass der Verkaufsdruck nachlässt — obwohl der Kurs fällt, verliert die Abwärtsbewegung an Kraft. Oft ein starkes Warnsignal für eine bevorstehende Umkehr nach oben. Besonders zuverlässig in überverkauften Zonen (RSI < 30).';

  @override
  String get patternBearishDivergenceDesc =>
      'Eine Bearish Divergenz tritt auf, wenn der Preis ein neues Hoch macht, der RSI aber ein NIEDRIGERES Hoch bildet. Dies zeigt, dass der Kaufdruck nachlässt — die Rally verliert intern an Kraft, auch wenn der Kurs noch steigt. Ein Frühwarnsignal für eine mögliche Trendwende nach unten. Besonders zuverlässig in überkauften Zonen (RSI > 70).';

  @override
  String get patternDojiDesc =>
      'Ein Doji hat fast den gleichen Eröffnungs- und Schlusskurs und sieht aus wie ein Kreuz. Er signalisiert Unentschlossenheit im Markt — weder Käufer noch Verkäufer hatten die Kontrolle. Oft ein Vorbote einer Trendumkehr, besonders nach einem starken Trend.';

  @override
  String get patternLongLeggedDojiDesc =>
      'Ein Long-Legged Doji hat besonders lange obere und untere Schatten, fast kein Körper. Er zeigt extreme Unentschlossenheit — der Kurs schwankte stark in beide Richtungen, schloss aber fast unverändert. Ein starkes Signal für eine bevorstehende Richtungsentscheidung.';

  @override
  String get patternSpinningTopDesc =>
      'Ein Spinning Top hat einen kleinen Körper in der Mitte und moderate Schatten auf beiden Seiten. Er zeigt Gleichgewicht zwischen Käufern und Verkäufern. Im Kontext eines bestehenden Trends kann er eine Erschöpfung und bevorstehende Korrektur ankündigen.';

  @override
  String get patternMarubozuBullishDesc =>
      'Ein Bullischer Marubozu ist eine große grüne Kerze ohne oder fast ohne Schatten. Der Kurs eröffnete auf dem Tief und schloss auf dem Hoch — absolutes Käufer-Dominanz durch die gesamte Periode. Ein sehr starkes Kaufsignal, besonders nach einem Rückgang.';

  @override
  String get patternMarubozuBearishDesc =>
      'Ein Bärischer Marubozu ist eine große rote Kerze ohne oder fast ohne Schatten. Der Kurs eröffnete auf dem Hoch und schloss auf dem Tief — absolute Verkäufer-Dominanz. Ein sehr starkes Verkaufssignal, besonders nach einem Aufwärtstrend.';

  @override
  String get patternHammerDesc =>
      'Ein Hammer tritt nach einem Abwärtstrend auf. Er hat einen kleinen Körper am oberen Ende und einen langen unteren Schatten (Lunte). Dies zeigt, dass Verkäufer den Preis stark drückten, aber Käufer ihn wieder hochkauften. Ein klassisches Umkehrsignal für eine mögliche Bodenbildung.';

  @override
  String get patternInvertedHammerDesc =>
      'Der Inverted Hammer (umgekehrter Hammer) hat einen kleinen Körper unten und einen langen oberen Schatten. Er erscheint nach einem Abwärtstrend und zeigt, dass Käufer versuchten, den Kurs hochzutreiben — auch wenn sie es nicht ganz schafften. Bestätigung durch die nächste Kerze wichtig.';

  @override
  String get patternShootingStarDesc =>
      'Der Shooting Star ist das Pendant zum Inverted Hammer, aber nach einem Aufwärtstrend. Er hat einen langen oberen Schatten und einen kleinen Körper unten. Käufer trieben den Kurs hoch, aber Verkäufer übernahmen die Kontrolle und drückten ihn wieder runter. Ein Warnsignal für eine bevorstehende Korrektur.';

  @override
  String get patternHangingManDesc =>
      'Der Hanging Man sieht aus wie ein Hammer, erscheint aber nach einem Aufwärtstrend. Der lange untere Schatten zeigt, dass Verkäufer kurzfristig die Kontrolle hatten — ein Warnsignal, dass der Aufwärtstrend nachlassen könnte. Bestätigung durch eine rote Kerze am nächsten Tag verstärkt das Signal.';

  @override
  String get patternBullishEngulfingDesc =>
      'Eine große grüne Kerze umschließt die vorherige rote Kerze komplett. Dies zeigt massive Kaufkraftübernahme — Käufer haben alle Verluste des Vortages wettgemacht und mehr. Eines der zuverlässigsten bullishen Umkehrsignale.';

  @override
  String get patternBearishEngulfingDesc =>
      'Eine große rote Kerze umschließt die vorherige grüne Kerze komplett. Die Verkäufer haben alle Gewinne des Vortages vernichtet und treiben den Kurs tiefer. Eines der zuverlässigsten bärischen Umkehrsignale, besonders auf Widerstandsniveaus.';

  @override
  String get patternPiercingLineDesc =>
      'Die Piercing Line ist ein 2-Kerzen-Umkehrmuster. Nach einer langen roten Kerze eröffnete die grüne Kerze tiefer (Gap Down), schließt aber über der Mitte der vorigen roten Kerze. Dies zeigt, dass Käufer die Kontrolle übernehmen. Ein bullishes Signal nach einem Abwärtstrend.';

  @override
  String get patternDarkCloudCoverDesc =>
      'Das Gegenteil der Piercing Line. Nach einer langen grünen Kerze eröffnet die rote Kerze höher (Gap Up), schließt aber unter der Mitte der vorigen grünen Kerze. Verkäufer übernehmen die Kontrolle. Ein bärisches Umkehrsignal nach einem Aufwärtstrend.';

  @override
  String get patternBullishHaramiDesc =>
      'Beim Bullish Harami (japanisch: schwanger) wird eine kleine grüne Kerze komplett vom Körper der vorigen großen roten Kerze eingeschlossen. Dies signalisiert eine Verlangsamung des Abwärtsdrucks und eine mögliche Trendwende. Weniger stark als Engulfing, aber ein gutes Warnsignal.';

  @override
  String get patternBearishHaramiDesc =>
      'Beim Bearish Harami wird eine kleine rote Kerze komplett vom Körper der vorigen großen grünen Kerze eingeschlossen. Dies signalisiert eine Verlangsamung des Aufwärtsdrucks. Der Markt verliert Momentum — ein erstes Warnsignal für eine mögliche Korrektur.';

  @override
  String get patternTweezersBottomDesc =>
      'Tweezers Bottom (Pinzettenboden): Zwei Kerzen mit (fast) identischen Tiefs. Die erste ist rot (Abwärtsbewegung), die zweite grün (Erholung). Dies zeigt einen starken Unterstützungslevel — Käufer sind bereit, genau auf diesem Preisniveau zu kaufen. Ein bullishes Umkehrsignal.';

  @override
  String get patternTweezersTopDesc =>
      'Tweezers Top (Pinzettenspitze): Zwei Kerzen mit (fast) identischen Hochs. Die erste ist grün (Aufwärtsbewegung), die zweite rot (Abgabe). Dies zeigt einen starken Widerstandslevel — Verkäufer treten genau auf diesem Niveau auf. Ein bärisches Umkehrsignal.';

  @override
  String get patternKickingBullishDesc =>
      'Das Kicking-Muster ist eines der stärksten Signale überhaupt. Eine bärische Marubozu-Kerze wird abrupt von einer bullischen Marubozu-Kerze gefolgt (Gap Up). Der komplette Richtungswechsel mit starkem Volumen zeigt einen massiven Stimmungsumschwung — von Panikverkauf zu starkem Kaufinteresse.';

  @override
  String get patternMorningStarDesc =>
      'Der Morning Star ist ein starkes 3-Kerzen-Umkehrmuster nach einem Abwärtstrend: 1) Große rote Kerze (starker Verkauf), 2) Kleine Kerze (Unentschlossenheit), 3) Große grüne Kerze die über die Mitte der ersten schließt. Einer der zuverlässigsten Bodenbildungs-Indikatoren.';

  @override
  String get patternEveningStarDesc =>
      'Der Evening Star ist das Gegenstück zum Morning Star, nach einem Aufwärtstrend: 1) Große grüne Kerze (starker Kauf), 2) Kleine Kerze (Unentschlossenheit am Hoch), 3) Große rote Kerze die unter die Mitte der ersten schließt. Ein zuverlässiges Topping-Signal.';

  @override
  String get pattern3WhiteSoldiersDesc =>
      'Drei aufeinanderfolgende grüne Kerzen mit höheren Hochs und höheren Schlusskursen. Jede Kerze eröffnet innerhalb oder knapp unter dem vorherigen Körper. Zeigt nachhaltiges Kaufinteresse und anhaltenden Aufwärtstrend — eines der stärksten Trendfortsetzungs- oder Umkehrsignale.';

  @override
  String get pattern3BlackCrowsDesc =>
      'Drei aufeinanderfolgende rote Kerzen mit tieferen Tiefs und tieferen Schlusskursen. Das Gegenstück zu den 3 White Soldiers. Zeigt nachhaltigen Verkaufsdruck — oft ein Signal für den Beginn eines stärkeren Abwärtstrends oder das Ende einer Aufwärtsbewegung.';

  @override
  String fundamentalAnalysis(String symbol) {
    return 'Fundamentalanalyse: $symbol';
  }

  @override
  String get noFmpKeyError => 'Kein FMP API Key in den Einstellungen gefunden.';

  @override
  String loadFmpDataError(String symbol) {
    return 'Konnte Daten für $symbol nicht laden (Limit erreicht oder Symbol falsch).';
  }

  @override
  String get companyProfile => 'Unternehmensprofil';

  @override
  String get ceo => 'CEO';

  @override
  String get sector => 'Sektor';

  @override
  String get industry => 'Industrie';

  @override
  String get country => 'Land';

  @override
  String get employees => 'Mitarbeiter';

  @override
  String get ipoDate => 'IPO Datum';

  @override
  String get website => 'Webseite';

  @override
  String get marketData => 'Marktdaten';

  @override
  String get marketCap => 'Marktkap.';

  @override
  String get volAvg => 'Volumen (Avg)';

  @override
  String get beta => 'Beta (Vola)';

  @override
  String get fiftyTwoWeekRange => '52W Range';

  @override
  String get lastDiv => 'Letzte Div.';

  @override
  String get isEtf => 'ETF?';

  @override
  String get analystTargets => 'Analysten-Ziele (Gegenwart)';

  @override
  String get targetConsensus => 'Konsens (Mittel)';

  @override
  String get targetHigh => 'High';

  @override
  String get targetLow => 'Low';

  @override
  String get nextEarningsDate => 'Nächste Quartalszahlen';

  @override
  String get recentInsiderTrades => 'Letzte Insider-Trades';

  @override
  String get moreInfoOnAktienGuide => 'Mehr Infos auf Aktien.guide';

  @override
  String get dataProvidedByFmp =>
      'Daten bereitgestellt von Financial Modeling Prep';

  @override
  String get billionShort => 'Mrd.';

  @override
  String get thousandBillionShort => 'Bio.';

  @override
  String get millionShort => 'Mio.';

  @override
  String newsTitle(String symbol) {
    return 'News: $symbol';
  }

  @override
  String get noNewsFound => 'Keine aktuellen Nachrichten gefunden.';

  @override
  String get monteCarloSimulation => 'Monte Carlo Simulation';

  @override
  String daysCount(int count) {
    return '$count T';
  }

  @override
  String get recalculate => 'Neu berechnen';

  @override
  String simulationRunning(int count) {
    return 'Simulation läuft... ($count Szenarien)';
  }

  @override
  String simulatedPricePaths(int count, int total) {
    return 'Simulierte Preispfade ($count von $total)';
  }

  @override
  String get current => 'Aktuell';

  @override
  String get expected => 'Erwartet';

  @override
  String get delta => 'Δ';

  @override
  String get low95 => '95% Low';

  @override
  String get high95 => '95% High';

  @override
  String get simulationAnalysis => 'Analyse der Simulation';

  @override
  String get outlook => 'Ausblick';

  @override
  String get expectedDelta => 'Erwartete Δ';

  @override
  String get probabilityDistribution => 'Wahrscheinlichkeitsverteilung';

  @override
  String get volatilityAnn => 'Volatilität (p.a.)';

  @override
  String get riskLevel => 'Risiko-Level';

  @override
  String get span95 => '95% Spanne';

  @override
  String get riskReward => 'Risk/Reward';

  @override
  String get targetProbabilities => 'Target Wahrscheinlichkeiten';

  @override
  String get hitTp => 'Hit TP';

  @override
  String get hitSl => 'Hit SL';

  @override
  String get upside => 'Upside';

  @override
  String get downside => 'Downside';

  @override
  String get strongBullish => 'Stark Bullish';

  @override
  String get lightBullish => 'Leicht Bullish';

  @override
  String get strongBearish => 'Stark Bearish';

  @override
  String get lightBearish => 'Leicht Bearish';

  @override
  String get neutralSideways => 'Neutral / Seitwärts';

  @override
  String get riskLow => 'Niedrig';

  @override
  String get riskModerate => 'Moderat';

  @override
  String get riskHigh => 'Hoch';

  @override
  String get riskVeryHigh => 'Sehr Hoch';

  @override
  String get hitChance => 'Treffer-Chance';

  @override
  String mcRecStrongBullish(String bullPct, int days, String rr) {
    return 'Starkes bullishes Setup: $bullPct% der Szenarien steigen in $days Tagen. Risk/Reward von $rr spricht für eine Position.';
  }

  @override
  String get mcRecLightBullish =>
      'Leicht bullishes Umfeld mit akzeptablem Risk/Reward. Ein moderater Einstieg könnte in Betracht gezogen werden.';

  @override
  String mcRecBearish(String bullPct) {
    return 'Bearishes Szenario: Nur $bullPct% der Simulationen zeigen steigende Kurse. Vorsicht ist geboten, ggf. Absicherung empfohlen.';
  }

  @override
  String mcRecHighVol(String vol) {
    return 'Extrem hohe Volatilität ($vol% p.a.) — die Preisspanne ist sehr breit. Kleinere Positionen und weite Stop-Loss Levels empfohlen.';
  }

  @override
  String mcRecBadRR(String rr) {
    return 'Ungünstiges Risk/Reward-Verhältnis ($rr). Das Abwärtsrisiko überwiegt das Aufwärtspotenzial deutlich.';
  }

  @override
  String get mcRecNeutral =>
      'Neutrales Umfeld: Die Simulation zeigt keine klare Richtung. Abwarten oder Range-Strategien könnten sinnvoll sein.';

  @override
  String get kronosKiPrognose => 'Kronos KI Prognose';

  @override
  String get miniModel => 'Mini Modell';

  @override
  String get smallModel => 'Small Modell';

  @override
  String get baseModel => 'Base Modell';

  @override
  String get prognoseStarten => 'Prognose starten';

  @override
  String get erweiterteEinstellungen => 'Erweiterte Einstellungen';

  @override
  String get prognoseTage => 'Prognose (Tage)';

  @override
  String get modellKontext => 'Modell Kontext / Vorlauf (Tage)';

  @override
  String get chartHistorieAnzeige => 'Chart Historie Anzeige (Tage)';

  @override
  String calculatingPrognose(int percent) {
    return 'Berechne Prognose... $percent%';
  }

  @override
  String get kronosGenerating => 'Kronos Modell generiert Prognose...';

  @override
  String get firstStartWarning =>
      'Erster Start kann wegen Model-Download länger dauern.';

  @override
  String get expectedPriceCourse => 'Voraussichtlicher Preisverlauf';

  @override
  String get today => 'Heute';

  @override
  String targetTPlus(int days) {
    return 'Ziel (T+$days)';
  }

  @override
  String get maxHigh => 'Max Hoch';

  @override
  String get minLow => 'Min Tief';

  @override
  String get pressStartForPrognose =>
      'Drücke den Start-Button für eine Prognose';

  @override
  String get viewScanHistory => 'Scan-Historie anzeigen';

  @override
  String get readyToScan => 'Bereit zum Scannen.';

  @override
  String get initializing => 'Initialisiere...';

  @override
  String scanningSymbol(int count, int total, String symbol) {
    return '($count/$total) Scanne $symbol...';
  }

  @override
  String scanCompleted(int count) {
    return 'Scan abgeschlossen. $count Signale gefunden.';
  }

  @override
  String get longCandidates => 'Top 5 Long-Kandidaten';

  @override
  String get shortCandidates => 'Top 5 Short-Kandidaten';

  @override
  String get noCandidatesFound => 'Keine Kandidaten gefunden';

  @override
  String get adjustStrategyHint =>
      'Passe die Strategie an oder erweitere die Watchlist.';

  @override
  String get tradeDetails => 'Trade Details';

  @override
  String tradePrice(String value) {
    return 'Preis: $value';
  }

  @override
  String tradeQuantity(String value) {
    return 'Menge: $value';
  }

  @override
  String tradeDate(String value) {
    return 'Datum: $value';
  }

  @override
  String tradeStatus(String value) {
    return 'Status: $value';
  }

  @override
  String tradePnl(String value) {
    return 'PnL: $value';
  }

  @override
  String get chartSettings => 'Chart & Analyse Einstellungen';

  @override
  String get indicatorVisibility => 'Indikatoren Sichtbarkeit';

  @override
  String get oscillators => 'Oszillatoren (unter Chart)';

  @override
  String get chartRangeDays => 'Chart Zeitraum (Tage)';

  @override
  String get save => 'Speichern';

  @override
  String buySuccess(double quantity, String symbol) {
    return 'Kauf erfolgreich: $quantity $symbol';
  }

  @override
  String phaseLabel(int phase, String name) {
    return 'Phase $phase/3: $name';
  }

  @override
  String estimatedTime(String time) {
    return 'Schätzung: $time';
  }

  @override
  String itemsCount(int current, int total) {
    return '$current / $total Elemente';
  }

  @override
  String get openStatus => 'OFFEN';

  @override
  String get closedStatus => 'GESCHLOSSEN';

  @override
  String get openTp1Hit => 'OFFEN (TP1 Erreicht)';

  @override
  String get pendingStop => 'WARTEND (Stop)';

  @override
  String get pendingLimit => 'WARTEND (Limit)';

  @override
  String get entryPriceLabel => 'Einstieg';

  @override
  String get deepDiveAnalysis => 'Deep Dive Analyse';

  @override
  String get tabOverview => 'Übersicht';

  @override
  String get tabDetails => 'Details';

  @override
  String get tabTopCombos => 'Top Kombis';

  @override
  String get noClosedTradesForAnalysis =>
      'Noch keine geschlossenen Trades für eine Analyse vorhanden.';

  @override
  String get waitingForBotActivity => 'Warte auf erste Bot-Aktivitäten.';

  @override
  String get noTradesInPeriod => 'Keine Trades in diesem Zeitraum gefunden.';

  @override
  String get equityCurveTitle => 'Equity Kurve (Kapitalverlauf)';

  @override
  String get streaksAndDuration => 'Streaks & Dauer';

  @override
  String get maxWinningStreak => 'Max Winning Streak';

  @override
  String get maxLosingStreak => 'Max Losing Streak';

  @override
  String get avgHoldTime => 'Ø Hold Time';

  @override
  String get winLossProfile => 'Win / Loss Profile';

  @override
  String get winRate => 'Win Rate';

  @override
  String get avgWinner => 'Ø Winner';

  @override
  String get avgLoser => 'Ø Loser';

  @override
  String get topFlopAssets => 'Top / Flop Assets';

  @override
  String get topWinners => 'Top Gewinner';

  @override
  String get topLosers => 'Top Verlierer';

  @override
  String get noDataSmall => 'Keine Daten';

  @override
  String get performanceByTimeFrame => 'Performance nach TimeFrame';

  @override
  String get performanceByStrategy => 'Performance nach Strategie';

  @override
  String get performanceBySl => 'Performance nach Stop-Loss';

  @override
  String get performanceByTp => 'Performance nach Take-Profit';

  @override
  String get tooLittleDataForCombos => 'Zu wenig Daten für Kombinationen.';

  @override
  String combinationNumber(int number) {
    return 'Kombination #$number';
  }

  @override
  String get expectancyVal => 'Erwartungswert (EV)';

  @override
  String expectancyUnit(String value) {
    return '$value/Trade';
  }

  @override
  String get filterAllTime => 'Gesamte Zeit';

  @override
  String get filter30Days => '30 Tage';

  @override
  String get filter7Days => '7 Tage';

  @override
  String get filterYtd => 'YTD';

  @override
  String get shares => 'Aktien';

  @override
  String dayShort(int days) {
    return 'T$days';
  }

  @override
  String get averageShort => 'Ø';

  @override
  String get indicatorEMA => 'EMA Trend';

  @override
  String get indicatorRSI => 'RSI Momentum';

  @override
  String get indicatorMACD => 'MACD Volumen';

  @override
  String get indicatorBB => 'Bollinger Bänder';

  @override
  String get indicatorStoch => 'Stochastik';

  @override
  String get indicatorSupertrend => 'Supertrend';

  @override
  String get indicatorSAR => 'Parabolic SAR';

  @override
  String get indicatorIchimoku => 'Ichimoku Analyse';

  @override
  String get indicatorVortexChoppiness => 'Vortex + Choppiness';

  @override
  String get indicatorMACDHist => 'MACD Histogramm';

  @override
  String get indicatorADX => 'ADX (Trendstärke)';

  @override
  String get indicatorCCI => 'CCI (Commodity Channel)';

  @override
  String get indicatorAO => 'Awesome Oscillator';

  @override
  String get indicatorOBV => 'On-Balance Volume';

  @override
  String get indicatorCMF => 'CMF (Chaikin Money Flow)';

  @override
  String get indicatorMFI => 'MFI (Money Flow Index)';

  @override
  String get indicatorDiv => 'RSI Divergenz';

  @override
  String get indicatorSqueeze => 'TTM Squeeze';

  @override
  String get indicatorBBPercent => 'BB %B (Bollinger)';

  @override
  String get posMomentum => 'Positives Momentum';

  @override
  String get negMomentum => 'Negatives Momentum';

  @override
  String get strongTrend => 'Starker Trend';

  @override
  String get sideways => 'Seitwärts';

  @override
  String get trending => 'Trending';

  @override
  String get posMoneyFlow => 'Positiver Geldfluss';

  @override
  String get negMoneyFlow => 'Negativer Geldfluss';

  @override
  String get bullishDetected => 'Bullish erkannt';

  @override
  String get bearishDetected => 'Bearish erkannt';

  @override
  String get strongReversal => 'Starkes Umkehrsignal';

  @override
  String get active => 'Aktiv';

  @override
  String get breakoutPending => 'Ausbruch steht bevor';

  @override
  String get midRange => 'Mittlerer Bereich';

  @override
  String get aboveCloud => 'Über der Wolke';

  @override
  String get belowCloud => 'Unter der Wolke';

  @override
  String get trendUp => 'Trend Aufwärts';

  @override
  String get trendDown => 'Trend Abwärts';

  @override
  String get tenkanAboveKijun => 'Tenkan > Kijun';

  @override
  String get tenkanBelowKijun => 'Tenkan < Kijun';

  @override
  String get volMomentum => 'Volumen-Momentum';

  @override
  String get details => 'Details';

  @override
  String get scoreDetails => 'Analyse Details';

  @override
  String get range1W => '1W';

  @override
  String get range1M => '1M';

  @override
  String get range3M => '3M';

  @override
  String get range1Y => '1Y';

  @override
  String get range2Y => '2Y';

  @override
  String get range3Y => '3Y';

  @override
  String get range5Y => '5Y';

  @override
  String get bullish => 'Bullish';

  @override
  String get bearish => 'Bearish';

  @override
  String get netPnL => 'Netto G&V';

  @override
  String get profitFactor => 'Profitfaktor';

  @override
  String updateAvailable(String version) {
    return 'Update verfügbar: v$version';
  }

  @override
  String get chooseVersionDownload => 'Wähle deine Version zum Download:';

  @override
  String get toGithubReleasePage => 'Zur GitHub Release Seite';

  @override
  String get later => 'Später';

  @override
  String get androidApk => '🤖 Android (.apk)';

  @override
  String get windowsZip => '🪟 Windows (.zip)';

  @override
  String get macosZip => '🍏 macOS (.zip)';

  @override
  String get linuxZip => '🐧 Linux (.zip)';

  @override
  String get iosIpa => '📱 iOS (.ipa)';

  @override
  String openError(String url) {
    return 'Konnte $url nicht öffnen';
  }

  @override
  String get noChartData => 'Keine Daten für Chart';

  @override
  String get supertrend => 'Supertrend';

  @override
  String get donchianChannel => 'Donchian Kanal';

  @override
  String get statusInitializing => 'Initialisiere...';

  @override
  String get statusCheckingPending => 'Prüfe Pending Orders...';

  @override
  String get statusManagingOpen => 'Manage offene Positionen...';

  @override
  String get statusScanningMarkets => 'Scanne Märkte nach Signalen...';

  @override
  String get statusDone => 'Fertig.';

  @override
  String statusError(String error) {
    return 'Fehler: $error';
  }

  @override
  String get statusCancelRequested => 'Abbruch angefordert...';

  @override
  String get realizedLabel => 'Real';

  @override
  String currencyValue(String value) {
    return '$value €';
  }

  @override
  String tradeDetailsSymbol(String symbol) {
    return 'Details: $symbol';
  }

  @override
  String get entryScore => 'Einstiegs-Score';

  @override
  String get patternLabel => 'Muster';

  @override
  String get tradeData => 'Handelsdaten';

  @override
  String get statusLabel => 'Status';

  @override
  String get signalDate => 'Signal-Datum';

  @override
  String get indicatorsAtPurchase => 'Indikatoren beim Kauf';

  @override
  String get noDetailDataSaved => 'Keine Detaildaten gespeichert';

  @override
  String get deleteTradeConfirmTitle => 'Trade löschen?';

  @override
  String get deleteTradeConfirmContent =>
      'Möchtest du diesen Trade wirklich aus der Historie löschen?';

  @override
  String get delete => 'Löschen';

  @override
  String get maxDrawdown => 'Max. Drawdown';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get errorLabel => 'Fehler';

  @override
  String get aiProbabilityInsights => 'KI-Wahrscheinlichkeiten & Insights';

  @override
  String get priceAboveEma => 'Preis über EMA';

  @override
  String get priceBelowEma => 'Preis unter EMA';

  @override
  String get topMoversHistory => 'Top Movers Historie';

  @override
  String get refreshPrices => 'Preise aktualisieren';

  @override
  String get noScanHistory => 'Keine Scan-Historie vorhanden.';

  @override
  String get scanFrom => 'Scan vom';

  @override
  String get intervalLabel => 'Intervall';

  @override
  String get priceThen => 'Preis damals';
}
