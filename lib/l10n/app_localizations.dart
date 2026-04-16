import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'TechAna'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In de, this message translates to:
  /// **'Systemsprache'**
  String get systemLanguage;

  /// No description provided for @navAnalysis.
  ///
  /// In de, this message translates to:
  /// **'Analyse'**
  String get navAnalysis;

  /// No description provided for @navAutoBot.
  ///
  /// In de, this message translates to:
  /// **'AutoBot'**
  String get navAutoBot;

  /// No description provided for @navSettings.
  ///
  /// In de, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @searchHint.
  ///
  /// In de, this message translates to:
  /// **'Symbol suchen (z.B. AAPL.US)'**
  String get searchHint;

  /// No description provided for @noAnalysis.
  ///
  /// In de, this message translates to:
  /// **'Keine Analyse'**
  String get noAnalysis;

  /// No description provided for @tradingScore.
  ///
  /// In de, this message translates to:
  /// **'Trading Score'**
  String get tradingScore;

  /// No description provided for @noPattern.
  ///
  /// In de, this message translates to:
  /// **'Kein Muster'**
  String get noPattern;

  /// No description provided for @bullishDivergence.
  ///
  /// In de, this message translates to:
  /// **'Bullish Divergenz'**
  String get bullishDivergence;

  /// No description provided for @bearishDivergence.
  ///
  /// In de, this message translates to:
  /// **'Bearish Divergenz'**
  String get bearishDivergence;

  /// No description provided for @unknown.
  ///
  /// In de, this message translates to:
  /// **'Unbekannt'**
  String get unknown;

  /// No description provided for @errorPrefix.
  ///
  /// In de, this message translates to:
  /// **'Fehler: {error}'**
  String errorPrefix(String error);

  /// No description provided for @retryButton.
  ///
  /// In de, this message translates to:
  /// **'Erneut versuchen'**
  String get retryButton;

  /// No description provided for @fundamentals.
  ///
  /// In de, this message translates to:
  /// **'Fundamentals'**
  String get fundamentals;

  /// No description provided for @newsYahoo.
  ///
  /// In de, this message translates to:
  /// **'News (Yahoo)'**
  String get newsYahoo;

  /// No description provided for @monteCarlo.
  ///
  /// In de, this message translates to:
  /// **'Monte Carlo'**
  String get monteCarlo;

  /// No description provided for @kronosAi.
  ///
  /// In de, this message translates to:
  /// **'Kronos KI'**
  String get kronosAi;

  /// No description provided for @close.
  ///
  /// In de, this message translates to:
  /// **'Schließen'**
  String get close;

  /// No description provided for @currentValue.
  ///
  /// In de, this message translates to:
  /// **'Aktueller Wert: {value}'**
  String currentValue(String value);

  /// No description provided for @rsiOverbought.
  ///
  /// In de, this message translates to:
  /// **'Überkauft'**
  String get rsiOverbought;

  /// No description provided for @rsiOversold.
  ///
  /// In de, this message translates to:
  /// **'Überverkauft'**
  String get rsiOversold;

  /// No description provided for @rsiNeutral.
  ///
  /// In de, this message translates to:
  /// **'Neutral'**
  String get rsiNeutral;

  /// No description provided for @macdPositive.
  ///
  /// In de, this message translates to:
  /// **'Positiv'**
  String get macdPositive;

  /// No description provided for @macdNegative.
  ///
  /// In de, this message translates to:
  /// **'Negativ'**
  String get macdNegative;

  /// No description provided for @mcBullish.
  ///
  /// In de, this message translates to:
  /// **'Bullish'**
  String get mcBullish;

  /// No description provided for @mcSlightlyBullish.
  ///
  /// In de, this message translates to:
  /// **'Leicht Bullish'**
  String get mcSlightlyBullish;

  /// No description provided for @mcBearish.
  ///
  /// In de, this message translates to:
  /// **'Bearish'**
  String get mcBearish;

  /// No description provided for @mcSlightlyBearish.
  ///
  /// In de, this message translates to:
  /// **'Leicht Bearish'**
  String get mcSlightlyBearish;

  /// No description provided for @mcNeutral.
  ///
  /// In de, this message translates to:
  /// **'Neutral'**
  String get mcNeutral;

  /// No description provided for @mtcBullishConfirmed.
  ///
  /// In de, this message translates to:
  /// **'MTC: Bullish Bestätigt (H1, H4, D1)'**
  String get mtcBullishConfirmed;

  /// No description provided for @mtcBearishConfirmed.
  ///
  /// In de, this message translates to:
  /// **'MTC: Bearish Bestätigt (H1, H4, D1)'**
  String get mtcBearishConfirmed;

  /// No description provided for @mtcNeutral.
  ///
  /// In de, this message translates to:
  /// **'MTC: Neutral'**
  String get mtcNeutral;

  /// No description provided for @kronosAiAnalysis.
  ///
  /// In de, this message translates to:
  /// **'Kronos KI Analyse'**
  String get kronosAiAnalysis;

  /// No description provided for @modelCalculatingForecast.
  ///
  /// In de, this message translates to:
  /// **'Modell berechnet Vorhersage...'**
  String get modelCalculatingForecast;

  /// No description provided for @tp1HitChance.
  ///
  /// In de, this message translates to:
  /// **'TP1 Hit Chance'**
  String get tp1HitChance;

  /// No description provided for @tp2HitChance.
  ///
  /// In de, this message translates to:
  /// **'TP2 Hit Chance'**
  String get tp2HitChance;

  /// No description provided for @slHitChance.
  ///
  /// In de, this message translates to:
  /// **'SL Hit Chance'**
  String get slHitChance;

  /// No description provided for @volume.
  ///
  /// In de, this message translates to:
  /// **'Volumen'**
  String get volume;

  /// No description provided for @adxTrendStrength.
  ///
  /// In de, this message translates to:
  /// **'ADX (Trendstärke)'**
  String get adxTrendStrength;

  /// No description provided for @tabView.
  ///
  /// In de, this message translates to:
  /// **'Ansicht'**
  String get tabView;

  /// No description provided for @tabChart.
  ///
  /// In de, this message translates to:
  /// **'Chart'**
  String get tabChart;

  /// No description provided for @tabStrategy.
  ///
  /// In de, this message translates to:
  /// **'Strategie'**
  String get tabStrategy;

  /// No description provided for @tabData.
  ///
  /// In de, this message translates to:
  /// **'Daten'**
  String get tabData;

  /// No description provided for @viewAndGeneral.
  ///
  /// In de, this message translates to:
  /// **'Ansicht & Allgemein'**
  String get viewAndGeneral;

  /// No description provided for @darkTheme.
  ///
  /// In de, this message translates to:
  /// **'Dunkles Design'**
  String get darkTheme;

  /// No description provided for @showCandlesticks.
  ///
  /// In de, this message translates to:
  /// **'Candlesticks anzeigen'**
  String get showCandlesticks;

  /// No description provided for @showCandlesticksSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Zeigt Kerzen statt Linie'**
  String get showCandlesticksSubtitle;

  /// No description provided for @patternMarkers.
  ///
  /// In de, this message translates to:
  /// **'Muster-Marker'**
  String get patternMarkers;

  /// No description provided for @tradingLines.
  ///
  /// In de, this message translates to:
  /// **'Trading-Linien (TP/SL)'**
  String get tradingLines;

  /// No description provided for @chartIndicators.
  ///
  /// In de, this message translates to:
  /// **'Indikatoren im Chart'**
  String get chartIndicators;

  /// No description provided for @ema20Line.
  ///
  /// In de, this message translates to:
  /// **'EMA 20 Linie'**
  String get ema20Line;

  /// No description provided for @bollingerBands.
  ///
  /// In de, this message translates to:
  /// **'Bollinger Bands'**
  String get bollingerBands;

  /// No description provided for @projectionDays.
  ///
  /// In de, this message translates to:
  /// **'Projektion (Tage)'**
  String get projectionDays;

  /// No description provided for @additionalCharts.
  ///
  /// In de, this message translates to:
  /// **'Zusatz-Graphen (unten)'**
  String get additionalCharts;

  /// No description provided for @volumeChart.
  ///
  /// In de, this message translates to:
  /// **'Volumen Chart'**
  String get volumeChart;

  /// No description provided for @rsiIndicator.
  ///
  /// In de, this message translates to:
  /// **'RSI Indikator'**
  String get rsiIndicator;

  /// No description provided for @macdIndicator.
  ///
  /// In de, this message translates to:
  /// **'MACD Indikator'**
  String get macdIndicator;

  /// No description provided for @stochasticOscillator.
  ///
  /// In de, this message translates to:
  /// **'Stochastic Oszillator'**
  String get stochasticOscillator;

  /// No description provided for @obvIndicator.
  ///
  /// In de, this message translates to:
  /// **'On-Balance Volume (OBV)'**
  String get obvIndicator;

  /// No description provided for @adxIndicator.
  ///
  /// In de, this message translates to:
  /// **'ADX (Trendstärke)'**
  String get adxIndicator;

  /// No description provided for @manualAnalysisStrategy.
  ///
  /// In de, this message translates to:
  /// **'Manuelle Analyse Strategie'**
  String get manualAnalysisStrategy;

  /// No description provided for @entryStrategy.
  ///
  /// In de, this message translates to:
  /// **'Entry Strategie'**
  String get entryStrategy;

  /// No description provided for @marketImmediate.
  ///
  /// In de, this message translates to:
  /// **'Market (Sofort)'**
  String get marketImmediate;

  /// No description provided for @pullbackLimit.
  ///
  /// In de, this message translates to:
  /// **'Pullback (Limit)'**
  String get pullbackLimit;

  /// No description provided for @breakoutStop.
  ///
  /// In de, this message translates to:
  /// **'Breakout (Stop)'**
  String get breakoutStop;

  /// No description provided for @entryStrategyDesc.
  ///
  /// In de, this message translates to:
  /// **'Wann einsteigen? \'Market\' kauft sofort. \'Pullback\' wartet auf günstigeren Preis. \'Breakout\' kauft bei Ausbruch nach oben (teurer). Empfohlen: Market oder Pullback.'**
  String get entryStrategyDesc;

  /// No description provided for @entryPaddingType.
  ///
  /// In de, this message translates to:
  /// **'Entry Padding Typ'**
  String get entryPaddingType;

  /// No description provided for @percentual.
  ///
  /// In de, this message translates to:
  /// **'Prozentual (%)'**
  String get percentual;

  /// No description provided for @atrFactor.
  ///
  /// In de, this message translates to:
  /// **'ATR Faktor'**
  String get atrFactor;

  /// No description provided for @entryPaddingPercent.
  ///
  /// In de, this message translates to:
  /// **'Entry Padding %'**
  String get entryPaddingPercent;

  /// No description provided for @entryPaddingAtr.
  ///
  /// In de, this message translates to:
  /// **'Entry Padding (x ATR)'**
  String get entryPaddingAtr;

  /// No description provided for @entryPaddingDesc.
  ///
  /// In de, this message translates to:
  /// **'Abstand zum aktuellen Kurs für die Order. Standard: 0.2% oder 0.5x ATR.'**
  String get entryPaddingDesc;

  /// No description provided for @stopLossMethod.
  ///
  /// In de, this message translates to:
  /// **'Stop Loss Methode'**
  String get stopLossMethod;

  /// No description provided for @donchianLow.
  ///
  /// In de, this message translates to:
  /// **'Donchian Low'**
  String get donchianLow;

  /// No description provided for @percentualMethod.
  ///
  /// In de, this message translates to:
  /// **'Prozentual'**
  String get percentualMethod;

  /// No description provided for @atrVolatility.
  ///
  /// In de, this message translates to:
  /// **'ATR (Volatilität)'**
  String get atrVolatility;

  /// No description provided for @swingLowHigh.
  ///
  /// In de, this message translates to:
  /// **'Swing-Low/High'**
  String get swingLowHigh;

  /// No description provided for @stopLossDesc.
  ///
  /// In de, this message translates to:
  /// **'Wie wird der Stop Loss gesetzt? ATR passt sich der Marktschwankung an (Profi-Standard). Swing nutzt das letzte signifikante Tief/Hoch.'**
  String get stopLossDesc;

  /// No description provided for @stopLossPercent.
  ///
  /// In de, this message translates to:
  /// **'Stop Loss %'**
  String get stopLossPercent;

  /// No description provided for @stopLossPercentDesc.
  ///
  /// In de, this message translates to:
  /// **'Fester prozentualer Abstand. Standard: 5-8%.'**
  String get stopLossPercentDesc;

  /// No description provided for @atrMultiplier.
  ///
  /// In de, this message translates to:
  /// **'ATR Multiplikator'**
  String get atrMultiplier;

  /// No description provided for @atrMultiplierDesc.
  ///
  /// In de, this message translates to:
  /// **'Wie viel \'Luft\' hat der Trade? 2.0x ATR ist Standard für Swing-Trading. Kleiner = engerer Stop.'**
  String get atrMultiplierDesc;

  /// No description provided for @swingLookbackCandles.
  ///
  /// In de, this message translates to:
  /// **'Swing Lookback (Kerzen)'**
  String get swingLookbackCandles;

  /// No description provided for @swingLookbackDesc.
  ///
  /// In de, this message translates to:
  /// **'Wie viele Kerzen zurückschauen um das letzte Swing-Tief/Hoch zu finden. Standard: 20.'**
  String get swingLookbackDesc;

  /// No description provided for @takeProfitMethod.
  ///
  /// In de, this message translates to:
  /// **'Take Profit Methode'**
  String get takeProfitMethod;

  /// No description provided for @riskRewardCrv.
  ///
  /// In de, this message translates to:
  /// **'Risk/Reward (CRV)'**
  String get riskRewardCrv;

  /// No description provided for @atrTarget.
  ///
  /// In de, this message translates to:
  /// **'ATR-Ziel'**
  String get atrTarget;

  /// No description provided for @pivotPoints.
  ///
  /// In de, this message translates to:
  /// **'Pivot Points'**
  String get pivotPoints;

  /// No description provided for @takeProfitDesc.
  ///
  /// In de, this message translates to:
  /// **'Wann Gewinne mitnehmen? Pivot Points nutzt klassische Floor-Pivot-Levels als Ziele. CRV empfohlen für Anfänger.'**
  String get takeProfitDesc;

  /// No description provided for @tp1Factor.
  ///
  /// In de, this message translates to:
  /// **'TP1 Faktor'**
  String get tp1Factor;

  /// No description provided for @tp1FactorDesc.
  ///
  /// In de, this message translates to:
  /// **'Erstes Ziel: Vielfaches des Risikos. Standard: 1.5x (bei 100€ Risiko -> 150€ Gewinn).'**
  String get tp1FactorDesc;

  /// No description provided for @tp2Factor.
  ///
  /// In de, this message translates to:
  /// **'TP2 Faktor'**
  String get tp2Factor;

  /// No description provided for @tp2FactorDesc.
  ///
  /// In de, this message translates to:
  /// **'Zweites Ziel (Moonbag). Standard: 3.0x.'**
  String get tp2FactorDesc;

  /// No description provided for @tp1Percent.
  ///
  /// In de, this message translates to:
  /// **'TP1 %'**
  String get tp1Percent;

  /// No description provided for @tp1PercentDesc.
  ///
  /// In de, this message translates to:
  /// **'Fester Gewinn in %. Standard: 5-10%.'**
  String get tp1PercentDesc;

  /// No description provided for @tp2Percent.
  ///
  /// In de, this message translates to:
  /// **'TP2 %'**
  String get tp2Percent;

  /// No description provided for @tp2PercentDesc.
  ///
  /// In de, this message translates to:
  /// **'Fernes Ziel in %. Standard: 10-20%.'**
  String get tp2PercentDesc;

  /// No description provided for @mcSimulations.
  ///
  /// In de, this message translates to:
  /// **'MC Simulationen'**
  String get mcSimulations;

  /// No description provided for @mcSimulationsDesc.
  ///
  /// In de, this message translates to:
  /// **'Anzahl der Szenarien für das Scoring. Höher = genauer, aber langsamer. Standard: 200.'**
  String get mcSimulationsDesc;

  /// No description provided for @resetToDefaults.
  ///
  /// In de, this message translates to:
  /// **'Auf Standardwerte zurücksetzen'**
  String get resetToDefaults;

  /// No description provided for @expertFeaturesAi.
  ///
  /// In de, this message translates to:
  /// **'Experten Features (AI/Algo)'**
  String get expertFeaturesAi;

  /// No description provided for @marketRegimeFilter.
  ///
  /// In de, this message translates to:
  /// **'Markt-Regime Filter'**
  String get marketRegimeFilter;

  /// No description provided for @marketRegimeSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Anpassung an Trend/Range/Volatilität'**
  String get marketRegimeSubtitle;

  /// No description provided for @aiProbabilityScoring.
  ///
  /// In de, this message translates to:
  /// **'AI Probability Scoring'**
  String get aiProbabilityScoring;

  /// No description provided for @aiProbabilitySubtitle.
  ///
  /// In de, this message translates to:
  /// **'Gewichtung nach hist. Trefferrate'**
  String get aiProbabilitySubtitle;

  /// No description provided for @multiTimeframeMtc.
  ///
  /// In de, this message translates to:
  /// **'Multi-Timeframe (MTC)'**
  String get multiTimeframeMtc;

  /// No description provided for @mtcSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Bestätigung auf höheren Zeitebenen'**
  String get mtcSubtitle;

  /// No description provided for @strategyOptimizer.
  ///
  /// In de, this message translates to:
  /// **'Strategy Optimizer'**
  String get strategyOptimizer;

  /// No description provided for @strategyOptimizerSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Sucht ideale Indikator-Parameter'**
  String get strategyOptimizerSubtitle;

  /// No description provided for @dataSources.
  ///
  /// In de, this message translates to:
  /// **'Datenquellen'**
  String get dataSources;

  /// No description provided for @chartDataSource.
  ///
  /// In de, this message translates to:
  /// **'Chart: Stooq.com (Frei)'**
  String get chartDataSource;

  /// No description provided for @alphaVantageLabel.
  ///
  /// In de, this message translates to:
  /// **'Alpha Vantage API Key (für Fundamentals)'**
  String get alphaVantageLabel;

  /// No description provided for @alphaVantageHint.
  ///
  /// In de, this message translates to:
  /// **'Hier Key eingeben (optional)'**
  String get alphaVantageHint;

  /// No description provided for @fmpLabel.
  ///
  /// In de, this message translates to:
  /// **'FMP API Key (Financial Modeling Prep)'**
  String get fmpLabel;

  /// No description provided for @fmpHint.
  ///
  /// In de, this message translates to:
  /// **'Key eingeben'**
  String get fmpHint;

  /// No description provided for @hfTokenLabel.
  ///
  /// In de, this message translates to:
  /// **'HuggingFace Token (Kronos AI)'**
  String get hfTokenLabel;

  /// No description provided for @kronosServerUrl.
  ///
  /// In de, this message translates to:
  /// **'Kronos Server URL'**
  String get kronosServerUrl;

  /// No description provided for @kronosServerHint.
  ///
  /// In de, this message translates to:
  /// **'z.B. http://192.168.178.139:8000'**
  String get kronosServerHint;

  /// No description provided for @kronosServerHelper.
  ///
  /// In de, this message translates to:
  /// **'Leer = lokales Backend auf Desktop. Für Android/iOS: IP des PCs eingeben.'**
  String get kronosServerHelper;

  /// No description provided for @version.
  ///
  /// In de, this message translates to:
  /// **'Version {ver}+{build}'**
  String version(String ver, String build);

  /// No description provided for @botDashboard.
  ///
  /// In de, this message translates to:
  /// **'Bot Dashboard'**
  String get botDashboard;

  /// No description provided for @cancelScan.
  ///
  /// In de, this message translates to:
  /// **'Scan abbrechen'**
  String get cancelScan;

  /// No description provided for @startScan.
  ///
  /// In de, this message translates to:
  /// **'Scan starten'**
  String get startScan;

  /// No description provided for @topMoversScan.
  ///
  /// In de, this message translates to:
  /// **'Top Movers Scan'**
  String get topMoversScan;

  /// No description provided for @botSettings.
  ///
  /// In de, this message translates to:
  /// **'Bot Einstellungen'**
  String get botSettings;

  /// No description provided for @editWatchlist.
  ///
  /// In de, this message translates to:
  /// **'Watchlist bearbeiten'**
  String get editWatchlist;

  /// No description provided for @portfolioReset.
  ///
  /// In de, this message translates to:
  /// **'Portfolio Reset'**
  String get portfolioReset;

  /// No description provided for @openDetailedAnalysis.
  ///
  /// In de, this message translates to:
  /// **'Detaillierte Bot Analyse öffnen'**
  String get openDetailedAnalysis;

  /// No description provided for @positionsByCategory.
  ///
  /// In de, this message translates to:
  /// **'Positionen nach Kategorie'**
  String get positionsByCategory;

  /// No description provided for @allPositionsRaw.
  ///
  /// In de, this message translates to:
  /// **'Alle Positionen (Rohdaten)'**
  String get allPositionsRaw;

  /// No description provided for @tradesTotal.
  ///
  /// In de, this message translates to:
  /// **'{count} Trades gesamt'**
  String tradesTotal(int count);

  /// No description provided for @filterAll.
  ///
  /// In de, this message translates to:
  /// **'Alle'**
  String get filterAll;

  /// No description provided for @filterOpen.
  ///
  /// In de, this message translates to:
  /// **'Offen'**
  String get filterOpen;

  /// No description provided for @filterOpenPositive.
  ///
  /// In de, this message translates to:
  /// **'Offen +'**
  String get filterOpenPositive;

  /// No description provided for @filterOpenNegative.
  ///
  /// In de, this message translates to:
  /// **'Offen -'**
  String get filterOpenNegative;

  /// No description provided for @filterPending.
  ///
  /// In de, this message translates to:
  /// **'Pending'**
  String get filterPending;

  /// No description provided for @filterClosed.
  ///
  /// In de, this message translates to:
  /// **'Geschlossen'**
  String get filterClosed;

  /// No description provided for @filterClosedPositive.
  ///
  /// In de, this message translates to:
  /// **'Geschlossen +'**
  String get filterClosedPositive;

  /// No description provided for @filterClosedNegative.
  ///
  /// In de, this message translates to:
  /// **'Geschlossen -'**
  String get filterClosedNegative;

  /// No description provided for @noTrades.
  ///
  /// In de, this message translates to:
  /// **'Keine Trades vorhanden.'**
  String get noTrades;

  /// No description provided for @otherCategory.
  ///
  /// In de, this message translates to:
  /// **'Sonstige'**
  String get otherCategory;

  /// No description provided for @noCategorizedTrades.
  ///
  /// In de, this message translates to:
  /// **'Keine kategorisierten Trades vorhanden.'**
  String get noCategorizedTrades;

  /// No description provided for @resetPortfolioTitle.
  ///
  /// In de, this message translates to:
  /// **'Portfolio zurücksetzen?'**
  String get resetPortfolioTitle;

  /// No description provided for @resetPortfolioContent.
  ///
  /// In de, this message translates to:
  /// **'Dies löscht ALLE Trades und setzt das investierte Kapital auf 0 zurück. Bist du sicher?'**
  String get resetPortfolioContent;

  /// No description provided for @cancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cancel;

  /// No description provided for @deleteAll.
  ///
  /// In de, this message translates to:
  /// **'Alles Löschen'**
  String get deleteAll;

  /// No description provided for @botWatchlist.
  ///
  /// In de, this message translates to:
  /// **'Bot Watchlist'**
  String get botWatchlist;

  /// No description provided for @symbolHint.
  ///
  /// In de, this message translates to:
  /// **'Symbol (z.B. BTC-USD)'**
  String get symbolHint;

  /// No description provided for @selectAll.
  ///
  /// In de, this message translates to:
  /// **'Alle'**
  String get selectAll;

  /// No description provided for @selectNone.
  ///
  /// In de, this message translates to:
  /// **'Keine'**
  String get selectNone;

  /// No description provided for @done.
  ///
  /// In de, this message translates to:
  /// **'Fertig'**
  String get done;

  /// No description provided for @portfolioPerformance.
  ///
  /// In de, this message translates to:
  /// **'Portfolio Performance (PnL)'**
  String get portfolioPerformance;

  /// No description provided for @currentPnlTemplate.
  ///
  /// In de, this message translates to:
  /// **'Aktuell: {value} €'**
  String currentPnlTemplate(String value);

  /// No description provided for @invested.
  ///
  /// In de, this message translates to:
  /// **'Investiert'**
  String get invested;

  /// No description provided for @unrealizedPnl.
  ///
  /// In de, this message translates to:
  /// **'Unreal. PnL'**
  String get unrealizedPnl;

  /// No description provided for @realizedPnl.
  ///
  /// In de, this message translates to:
  /// **'Realisiert PnL'**
  String get realizedPnl;

  /// No description provided for @open.
  ///
  /// In de, this message translates to:
  /// **'Offen'**
  String get open;

  /// No description provided for @closed.
  ///
  /// In de, this message translates to:
  /// **'Geschlossen'**
  String get closed;

  /// No description provided for @total.
  ///
  /// In de, this message translates to:
  /// **'Gesamt'**
  String get total;

  /// No description provided for @totalLabel.
  ///
  /// In de, this message translates to:
  /// **'Gesamt: {count}'**
  String totalLabel(int count);

  /// No description provided for @trades.
  ///
  /// In de, this message translates to:
  /// **'Trades: {count}'**
  String trades(int count);

  /// No description provided for @posCount.
  ///
  /// In de, this message translates to:
  /// **'{count} Pos.'**
  String posCount(int count);

  /// No description provided for @checkPending.
  ///
  /// In de, this message translates to:
  /// **'Check Pending'**
  String get checkPending;

  /// No description provided for @checkOpen.
  ///
  /// In de, this message translates to:
  /// **'Check Open'**
  String get checkOpen;

  /// No description provided for @marketScan.
  ///
  /// In de, this message translates to:
  /// **'Markt Scan'**
  String get marketScan;

  /// No description provided for @botConfiguration.
  ///
  /// In de, this message translates to:
  /// **'Bot Konfiguration'**
  String get botConfiguration;

  /// No description provided for @tabGeneral.
  ///
  /// In de, this message translates to:
  /// **'Allgemein'**
  String get tabGeneral;

  /// No description provided for @botActive.
  ///
  /// In de, this message translates to:
  /// **'Bot Aktiv (Auto-Run)'**
  String get botActive;

  /// No description provided for @runningInBackground.
  ///
  /// In de, this message translates to:
  /// **'Läuft im Hintergrund (Alle {minutes} Min)'**
  String runningInBackground(int minutes);

  /// No description provided for @paused.
  ///
  /// In de, this message translates to:
  /// **'Pausiert'**
  String get paused;

  /// No description provided for @cancelRunningScan.
  ///
  /// In de, this message translates to:
  /// **'Laufenden Scan sofort abbrechen'**
  String get cancelRunningScan;

  /// No description provided for @routineScope.
  ///
  /// In de, this message translates to:
  /// **'Routine Umfang'**
  String get routineScope;

  /// No description provided for @checkPendingOrders.
  ///
  /// In de, this message translates to:
  /// **'Pending Orders prüfen'**
  String get checkPendingOrders;

  /// No description provided for @checkPendingSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Prüft Limit/Stop Orders (Entry).'**
  String get checkPendingSubtitle;

  /// No description provided for @checkOpenPositions.
  ///
  /// In de, this message translates to:
  /// **'Offene Positionen prüfen'**
  String get checkOpenPositions;

  /// No description provided for @checkOpenSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Prüft SL/TP und aktualisiert PnL.'**
  String get checkOpenSubtitle;

  /// No description provided for @scanForNewTrades.
  ///
  /// In de, this message translates to:
  /// **'Nach neuen Trades suchen'**
  String get scanForNewTrades;

  /// No description provided for @scanForNewSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Scannt Watchlist nach Signalen.'**
  String get scanForNewSubtitle;

  /// No description provided for @moneyManagement.
  ///
  /// In de, this message translates to:
  /// **'Money Management'**
  String get moneyManagement;

  /// No description provided for @investPerTrade.
  ///
  /// In de, this message translates to:
  /// **'Invest pro Trade (€)'**
  String get investPerTrade;

  /// No description provided for @investPerTradeDesc.
  ///
  /// In de, this message translates to:
  /// **'Basis-Investition pro Position.'**
  String get investPerTradeDesc;

  /// No description provided for @unlimitedPositions.
  ///
  /// In de, this message translates to:
  /// **'Unbegrenzte Positionen'**
  String get unlimitedPositions;

  /// No description provided for @maxOpenPositions.
  ///
  /// In de, this message translates to:
  /// **'Max. offene Positionen'**
  String get maxOpenPositions;

  /// No description provided for @automation.
  ///
  /// In de, this message translates to:
  /// **'Automatisierung'**
  String get automation;

  /// No description provided for @scanInterval.
  ///
  /// In de, this message translates to:
  /// **'Scan Intervall (Min)'**
  String get scanInterval;

  /// No description provided for @scanIntervalDesc.
  ///
  /// In de, this message translates to:
  /// **'Häufigkeit der automatischen Prüfung.'**
  String get scanIntervalDesc;

  /// No description provided for @mcSimulationsScoring.
  ///
  /// In de, this message translates to:
  /// **'MC Simulationen (Scoring)'**
  String get mcSimulationsScoring;

  /// No description provided for @mcSimulationsScoringDesc.
  ///
  /// In de, this message translates to:
  /// **'Anzahl Szenarien für das Bot-Scoring. Standard: 200.'**
  String get mcSimulationsScoringDesc;

  /// No description provided for @mcStrictMode.
  ///
  /// In de, this message translates to:
  /// **'MC Strict Mode'**
  String get mcStrictMode;

  /// No description provided for @mcStrictModeSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Nur Trades eröffnen, wenn MC Treffer-Wahrscheinlichkeit für TP > SL ist.'**
  String get mcStrictModeSubtitle;

  /// No description provided for @tradeManagement.
  ///
  /// In de, this message translates to:
  /// **'Trade Management'**
  String get tradeManagement;

  /// No description provided for @trailingStopAtr.
  ///
  /// In de, this message translates to:
  /// **'Trailing Stop (x ATR)'**
  String get trailingStopAtr;

  /// No description provided for @trailingStopDesc.
  ///
  /// In de, this message translates to:
  /// **'Stop Loss automatisch nachziehen.'**
  String get trailingStopDesc;

  /// No description provided for @dynamicPositionSize.
  ///
  /// In de, this message translates to:
  /// **'Dynamische Positionsgröße'**
  String get dynamicPositionSize;

  /// No description provided for @dynamicPositionSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Invest verdoppeln bei hohem Score (>80).'**
  String get dynamicPositionSubtitle;

  /// No description provided for @aiAndAnalysis.
  ///
  /// In de, this message translates to:
  /// **'KI & Analyse'**
  String get aiAndAnalysis;

  /// No description provided for @kronosAiAnalysisTitle.
  ///
  /// In de, this message translates to:
  /// **'Kronos KI Analyse'**
  String get kronosAiAnalysisTitle;

  /// No description provided for @kronosAiSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Nutzt Foundation Model für Kursvorhersage pro Symbol.'**
  String get kronosAiSubtitle;

  /// No description provided for @kronosStrictMode.
  ///
  /// In de, this message translates to:
  /// **'Kronos Strict Mode'**
  String get kronosStrictMode;

  /// No description provided for @kronosStrictSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Nur Trades eröffnen, wenn Kronos TP1 VOR SL vorhersagt.'**
  String get kronosStrictSubtitle;

  /// No description provided for @resetAllSettings.
  ///
  /// In de, this message translates to:
  /// **'Alle Einstellungen zurücksetzen'**
  String get resetAllSettings;

  /// No description provided for @settingsNote.
  ///
  /// In de, this message translates to:
  /// **'Hinweis: Änderungen werden sofort gespeichert und beim nächsten Scan angewendet.'**
  String get settingsNote;

  /// No description provided for @generalAndTimeframe.
  ///
  /// In de, this message translates to:
  /// **'Allgemein & Zeitrahmen'**
  String get generalAndTimeframe;

  /// No description provided for @alternatingStrategies.
  ///
  /// In de, this message translates to:
  /// **'Wechselnde Strategien'**
  String get alternatingStrategies;

  /// No description provided for @alternatingStrategiesSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Für jeden Scan zufällige Werte testen'**
  String get alternatingStrategiesSubtitle;

  /// No description provided for @analysisInterval.
  ///
  /// In de, this message translates to:
  /// **'Analyse Interval'**
  String get analysisInterval;

  /// No description provided for @entrySection.
  ///
  /// In de, this message translates to:
  /// **'Entry (Einstieg)'**
  String get entrySection;

  /// No description provided for @strategyType.
  ///
  /// In de, this message translates to:
  /// **'Strategie Typ'**
  String get strategyType;

  /// No description provided for @paddingType.
  ///
  /// In de, this message translates to:
  /// **'Padding Typ'**
  String get paddingType;

  /// No description provided for @paddingPercent.
  ///
  /// In de, this message translates to:
  /// **'Padding %'**
  String get paddingPercent;

  /// No description provided for @paddingAtr.
  ///
  /// In de, this message translates to:
  /// **'Padding (x ATR)'**
  String get paddingAtr;

  /// No description provided for @stopLossRisk.
  ///
  /// In de, this message translates to:
  /// **'Stop Loss (Risiko)'**
  String get stopLossRisk;

  /// No description provided for @method.
  ///
  /// In de, this message translates to:
  /// **'Methode'**
  String get method;

  /// No description provided for @donchianLowHigh.
  ///
  /// In de, this message translates to:
  /// **'Donchian Low/High'**
  String get donchianLowHigh;

  /// No description provided for @stopDistance.
  ///
  /// In de, this message translates to:
  /// **'Stop Abstand %'**
  String get stopDistance;

  /// No description provided for @takeProfitTargets.
  ///
  /// In de, this message translates to:
  /// **'Take Profit (Ziele)'**
  String get takeProfitTargets;

  /// No description provided for @sellAtTp1.
  ///
  /// In de, this message translates to:
  /// **'Verkauf bei TP1 (%)'**
  String get sellAtTp1;

  /// No description provided for @tp1FactorR.
  ///
  /// In de, this message translates to:
  /// **'TP1 Faktor (R)'**
  String get tp1FactorR;

  /// No description provided for @tp2FactorR.
  ///
  /// In de, this message translates to:
  /// **'TP2 Faktor (R)'**
  String get tp2FactorR;

  /// No description provided for @marketRegimeSubtitleBot.
  ///
  /// In de, this message translates to:
  /// **'Anpassung an Trend/Range/Volatilität.'**
  String get marketRegimeSubtitleBot;

  /// No description provided for @aiProbabilitySubtitleBot.
  ///
  /// In de, this message translates to:
  /// **'Gewichtung nach hist. Trefferrate.'**
  String get aiProbabilitySubtitleBot;

  /// No description provided for @mtcSubtitleBot.
  ///
  /// In de, this message translates to:
  /// **'Trendbestätigung auf höheren Zeitebenen.'**
  String get mtcSubtitleBot;

  /// No description provided for @strategyOptimizerSubtitleBot.
  ///
  /// In de, this message translates to:
  /// **'Sucht ideale Indikator-Parameter.'**
  String get strategyOptimizerSubtitleBot;

  /// No description provided for @timeframe15min.
  ///
  /// In de, this message translates to:
  /// **'15 Min'**
  String get timeframe15min;

  /// No description provided for @timeframe1h.
  ///
  /// In de, this message translates to:
  /// **'1 Std'**
  String get timeframe1h;

  /// No description provided for @timeframe4h.
  ///
  /// In de, this message translates to:
  /// **'4 Std'**
  String get timeframe4h;

  /// No description provided for @timeframeDay.
  ///
  /// In de, this message translates to:
  /// **'Tag'**
  String get timeframeDay;

  /// No description provided for @timeframeWeek.
  ///
  /// In de, this message translates to:
  /// **'Woche'**
  String get timeframeWeek;

  /// No description provided for @regimeTrendingBull.
  ///
  /// In de, this message translates to:
  /// **'Bullischer Trend'**
  String get regimeTrendingBull;

  /// No description provided for @regimeTrendingBear.
  ///
  /// In de, this message translates to:
  /// **'Bearischer Trend'**
  String get regimeTrendingBear;

  /// No description provided for @regimeRanging.
  ///
  /// In de, this message translates to:
  /// **'Seitwärts (Range)'**
  String get regimeRanging;

  /// No description provided for @regimeVolatile.
  ///
  /// In de, this message translates to:
  /// **'Volatil (Choppy)'**
  String get regimeVolatile;

  /// No description provided for @regimeUnknown.
  ///
  /// In de, this message translates to:
  /// **'Unbekannt'**
  String get regimeUnknown;

  /// No description provided for @noData.
  ///
  /// In de, this message translates to:
  /// **'Keine Daten verfügbar'**
  String get noData;

  /// No description provided for @analysisDetails.
  ///
  /// In de, this message translates to:
  /// **'Analyse Details'**
  String get analysisDetails;

  /// No description provided for @strategySettings.
  ///
  /// In de, this message translates to:
  /// **'Strategie-Einstellungen'**
  String get strategySettings;

  /// No description provided for @alreadyInWatchlist.
  ///
  /// In de, this message translates to:
  /// **'Bereits in Bot Watchlist'**
  String get alreadyInWatchlist;

  /// No description provided for @addToWatchlist.
  ///
  /// In de, this message translates to:
  /// **'Zur Bot Watchlist hinzufügen'**
  String get addToWatchlist;

  /// No description provided for @addedToWatchlist.
  ///
  /// In de, this message translates to:
  /// **'{symbol} zur Bot-Watchlist hinzugefügt!'**
  String addedToWatchlist(String symbol);

  /// No description provided for @regimePrefix.
  ///
  /// In de, this message translates to:
  /// **'Regime: {label}'**
  String regimePrefix(String label);

  /// No description provided for @avgConfidence.
  ///
  /// In de, this message translates to:
  /// **'Durchschnittliche Konfidenz'**
  String get avgConfidence;

  /// No description provided for @indicatorWeighting.
  ///
  /// In de, this message translates to:
  /// **'Indikator-Gewichtung (Erfolgsrate letzte 50 Bars):'**
  String get indicatorWeighting;

  /// No description provided for @scoreBreakdown.
  ///
  /// In de, this message translates to:
  /// **'Score-Aufschlüsselung (Tippbar für Details):'**
  String get scoreBreakdown;

  /// No description provided for @tapForDetails.
  ///
  /// In de, this message translates to:
  /// **'Tippen für Details'**
  String get tapForDetails;

  /// No description provided for @tapForIndicators.
  ///
  /// In de, this message translates to:
  /// **'Tippen für Details'**
  String get tapForIndicators;

  /// No description provided for @catTrend.
  ///
  /// In de, this message translates to:
  /// **'Trend'**
  String get catTrend;

  /// No description provided for @catMomentum.
  ///
  /// In de, this message translates to:
  /// **'Momentum'**
  String get catMomentum;

  /// No description provided for @catVolume.
  ///
  /// In de, this message translates to:
  /// **'Volumen'**
  String get catVolume;

  /// No description provided for @catPattern.
  ///
  /// In de, this message translates to:
  /// **'Muster'**
  String get catPattern;

  /// No description provided for @catVolatility.
  ///
  /// In de, this message translates to:
  /// **'Volatilität'**
  String get catVolatility;

  /// No description provided for @stDesc.
  ///
  /// In de, this message translates to:
  /// **'Trendfolgender Indikator basierend auf der ATR.'**
  String get stDesc;

  /// No description provided for @emaDesc.
  ///
  /// In de, this message translates to:
  /// **'Gleitende Durchschnitte zeigen die Trendrichtung.'**
  String get emaDesc;

  /// No description provided for @psarDesc.
  ///
  /// In de, this message translates to:
  /// **'Identifiziert Trendwenden und potenzielle Ausstiege.'**
  String get psarDesc;

  /// No description provided for @ichimokuDesc.
  ///
  /// In de, this message translates to:
  /// **'Komplexe Cloud-Analyse für Trend und Support.'**
  String get ichimokuDesc;

  /// No description provided for @vortexChopDesc.
  ///
  /// In de, this message translates to:
  /// **'VX misst Trendstärke; CHOP zeigt Range vs Trend.'**
  String get vortexChopDesc;

  /// No description provided for @rsiDesc.
  ///
  /// In de, this message translates to:
  /// **'Misst Geschwindigkeit und Dynamik von Preisbewegungen.'**
  String get rsiDesc;

  /// No description provided for @macdDesc.
  ///
  /// In de, this message translates to:
  /// **'Zeigt das Verhältnis zweier gleitender Durchschnitte.'**
  String get macdDesc;

  /// No description provided for @adxDesc.
  ///
  /// In de, this message translates to:
  /// **'Misst die allgemeine Stärke eines Trends.'**
  String get adxDesc;

  /// No description provided for @cciDesc.
  ///
  /// In de, this message translates to:
  /// **'Identifiziert zyklische Trends und Extrembereiche.'**
  String get cciDesc;

  /// No description provided for @stochDesc.
  ///
  /// In de, this message translates to:
  /// **'Vergleicht Schlusskurs mit Preisspanne über Zeit.'**
  String get stochDesc;

  /// No description provided for @aoDesc.
  ///
  /// In de, this message translates to:
  /// **'Indikator für das Marktmomentum (AO).'**
  String get aoDesc;

  /// No description provided for @obvDesc.
  ///
  /// In de, this message translates to:
  /// **'Nutzt den Volumenfluss zur Kursprognose.'**
  String get obvDesc;

  /// No description provided for @cmfDesc.
  ///
  /// In de, this message translates to:
  /// **'Misst den volumengewichteten Geldfluss.'**
  String get cmfDesc;

  /// No description provided for @mfiDesc.
  ///
  /// In de, this message translates to:
  /// **'RSI kombiniert mit Volumen für Geldfluss.'**
  String get mfiDesc;

  /// No description provided for @divDesc.
  ///
  /// In de, this message translates to:
  /// **'Divergenz-Signal zwischen Preis und Momentum.'**
  String get divDesc;

  /// No description provided for @squeezeDesc.
  ///
  /// In de, this message translates to:
  /// **'Volatilitätskompression vor Ausbruch.'**
  String get squeezeDesc;

  /// No description provided for @bbPctDesc.
  ///
  /// In de, this message translates to:
  /// **'Position des Preises relativ zu Bollinger Bändern.'**
  String get bbPctDesc;

  /// No description provided for @indicatorValue.
  ///
  /// In de, this message translates to:
  /// **'Wert: {value}'**
  String indicatorValue(String value);

  /// No description provided for @entryPrice.
  ///
  /// In de, this message translates to:
  /// **'Entry Preis'**
  String get entryPrice;

  /// No description provided for @stopLoss.
  ///
  /// In de, this message translates to:
  /// **'Stop Loss'**
  String get stopLoss;

  /// No description provided for @takeProfit1.
  ///
  /// In de, this message translates to:
  /// **'Take Profit 1'**
  String get takeProfit1;

  /// No description provided for @takeProfit2.
  ///
  /// In de, this message translates to:
  /// **'Take Profit 2'**
  String get takeProfit2;

  /// No description provided for @riskRewardShort.
  ///
  /// In de, this message translates to:
  /// **'Risk/Reward (CRV)'**
  String get riskRewardShort;

  /// No description provided for @entry.
  ///
  /// In de, this message translates to:
  /// **'Entry'**
  String get entry;

  /// No description provided for @stopLossShort.
  ///
  /// In de, this message translates to:
  /// **'SL'**
  String get stopLossShort;

  /// No description provided for @takeProfit1Short.
  ///
  /// In de, this message translates to:
  /// **'TP1'**
  String get takeProfit1Short;

  /// No description provided for @takeProfit2Short.
  ///
  /// In de, this message translates to:
  /// **'TP2'**
  String get takeProfit2Short;

  /// No description provided for @aiConfidence.
  ///
  /// In de, this message translates to:
  /// **'AI-Konf.'**
  String get aiConfidence;

  /// No description provided for @positive.
  ///
  /// In de, this message translates to:
  /// **'Pos'**
  String get positive;

  /// No description provided for @negative.
  ///
  /// In de, this message translates to:
  /// **'Neg'**
  String get negative;

  /// No description provided for @overbought.
  ///
  /// In de, this message translates to:
  /// **'Überkauft'**
  String get overbought;

  /// No description provided for @oversold.
  ///
  /// In de, this message translates to:
  /// **'Überverkauft'**
  String get oversold;

  /// No description provided for @neutral.
  ///
  /// In de, this message translates to:
  /// **'Neutral'**
  String get neutral;

  /// No description provided for @optimizedLabel.
  ///
  /// In de, this message translates to:
  /// **'OPT'**
  String get optimizedLabel;

  /// No description provided for @explanation.
  ///
  /// In de, this message translates to:
  /// **'Erklärung'**
  String get explanation;

  /// No description provided for @patternBullishDivergence.
  ///
  /// In de, this message translates to:
  /// **'Bullish Divergenz'**
  String get patternBullishDivergence;

  /// No description provided for @patternBearishDivergence.
  ///
  /// In de, this message translates to:
  /// **'Bearish Divergenz'**
  String get patternBearishDivergence;

  /// No description provided for @patternDoji.
  ///
  /// In de, this message translates to:
  /// **'Doji'**
  String get patternDoji;

  /// No description provided for @patternLongLeggedDoji.
  ///
  /// In de, this message translates to:
  /// **'Long-Legged Doji'**
  String get patternLongLeggedDoji;

  /// No description provided for @patternSpinningTop.
  ///
  /// In de, this message translates to:
  /// **'Spinning Top'**
  String get patternSpinningTop;

  /// No description provided for @patternMarubozuBullish.
  ///
  /// In de, this message translates to:
  /// **'Marubozu Bullish'**
  String get patternMarubozuBullish;

  /// No description provided for @patternMarubozuBearish.
  ///
  /// In de, this message translates to:
  /// **'Marubozu Bearish'**
  String get patternMarubozuBearish;

  /// No description provided for @patternHammer.
  ///
  /// In de, this message translates to:
  /// **'Hammer'**
  String get patternHammer;

  /// No description provided for @patternInvertedHammer.
  ///
  /// In de, this message translates to:
  /// **'Inverted Hammer'**
  String get patternInvertedHammer;

  /// No description provided for @patternShootingStar.
  ///
  /// In de, this message translates to:
  /// **'Shooting Star'**
  String get patternShootingStar;

  /// No description provided for @patternHangingMan.
  ///
  /// In de, this message translates to:
  /// **'Hanging Man'**
  String get patternHangingMan;

  /// No description provided for @patternBullishEngulfing.
  ///
  /// In de, this message translates to:
  /// **'Bullish Engulfing'**
  String get patternBullishEngulfing;

  /// No description provided for @patternBearishEngulfing.
  ///
  /// In de, this message translates to:
  /// **'Bearish Engulfing'**
  String get patternBearishEngulfing;

  /// No description provided for @patternPiercingLine.
  ///
  /// In de, this message translates to:
  /// **'Piercing Line'**
  String get patternPiercingLine;

  /// No description provided for @patternDarkCloudCover.
  ///
  /// In de, this message translates to:
  /// **'Dark Cloud Cover'**
  String get patternDarkCloudCover;

  /// No description provided for @patternBullishHarami.
  ///
  /// In de, this message translates to:
  /// **'Bullish Harami'**
  String get patternBullishHarami;

  /// No description provided for @patternBearishHarami.
  ///
  /// In de, this message translates to:
  /// **'Bearish Harami'**
  String get patternBearishHarami;

  /// No description provided for @patternTweezersBottom.
  ///
  /// In de, this message translates to:
  /// **'Tweezers Bottom'**
  String get patternTweezersBottom;

  /// No description provided for @patternTweezersTop.
  ///
  /// In de, this message translates to:
  /// **'Tweezers Top'**
  String get patternTweezersTop;

  /// No description provided for @patternKickingBullish.
  ///
  /// In de, this message translates to:
  /// **'Kicking Bullish'**
  String get patternKickingBullish;

  /// No description provided for @patternMorningStar.
  ///
  /// In de, this message translates to:
  /// **'Morning Star'**
  String get patternMorningStar;

  /// No description provided for @patternEveningStar.
  ///
  /// In de, this message translates to:
  /// **'Evening Star'**
  String get patternEveningStar;

  /// No description provided for @pattern3WhiteSoldiers.
  ///
  /// In de, this message translates to:
  /// **'3 White Soldiers'**
  String get pattern3WhiteSoldiers;

  /// No description provided for @pattern3BlackCrows.
  ///
  /// In de, this message translates to:
  /// **'3 Black Crows'**
  String get pattern3BlackCrows;

  /// No description provided for @patternBullishDivergenceDesc.
  ///
  /// In de, this message translates to:
  /// **'Eine Bullish Divergenz tritt auf, wenn der Preis ein neues Tief macht, der RSI aber ein HÖHERES Tief bildet. Dies zeigt, dass der Verkaufsdruck nachlässt — obwohl der Kurs fällt, verliert die Abwärtsbewegung an Kraft. Oft ein starkes Warnsignal für eine bevorstehende Umkehr nach oben. Besonders zuverlässig in überverkauften Zonen (RSI < 30).'**
  String get patternBullishDivergenceDesc;

  /// No description provided for @patternBearishDivergenceDesc.
  ///
  /// In de, this message translates to:
  /// **'Eine Bearish Divergenz tritt auf, wenn der Preis ein neues Hoch macht, der RSI aber ein NIEDRIGERES Hoch bildet. Dies zeigt, dass der Kaufdruck nachlässt — die Rally verliert intern an Kraft, auch wenn der Kurs noch steigt. Ein Frühwarnsignal für eine mögliche Trendwende nach unten. Besonders zuverlässig in überkauften Zonen (RSI > 70).'**
  String get patternBearishDivergenceDesc;

  /// No description provided for @patternDojiDesc.
  ///
  /// In de, this message translates to:
  /// **'Ein Doji hat fast den gleichen Eröffnungs- und Schlusskurs und sieht aus wie ein Kreuz. Er signalisiert Unentschlossenheit im Markt — weder Käufer noch Verkäufer hatten die Kontrolle. Oft ein Vorbote einer Trendumkehr, besonders nach einem starken Trend.'**
  String get patternDojiDesc;

  /// No description provided for @patternLongLeggedDojiDesc.
  ///
  /// In de, this message translates to:
  /// **'Ein Long-Legged Doji hat besonders lange obere und untere Schatten, fast kein Körper. Er zeigt extreme Unentschlossenheit — der Kurs schwankte stark in beide Richtungen, schloss aber fast unverändert. Ein starkes Signal für eine bevorstehende Richtungsentscheidung.'**
  String get patternLongLeggedDojiDesc;

  /// No description provided for @patternSpinningTopDesc.
  ///
  /// In de, this message translates to:
  /// **'Ein Spinning Top hat einen kleinen Körper in der Mitte und moderate Schatten auf beiden Seiten. Er zeigt Gleichgewicht zwischen Käufern und Verkäufern. Im Kontext eines bestehenden Trends kann er eine Erschöpfung und bevorstehende Korrektur ankündigen.'**
  String get patternSpinningTopDesc;

  /// No description provided for @patternMarubozuBullishDesc.
  ///
  /// In de, this message translates to:
  /// **'Ein Bullischer Marubozu ist eine große grüne Kerze ohne oder fast ohne Schatten. Der Kurs eröffnete auf dem Tief und schloss auf dem Hoch — absolutes Käufer-Dominanz durch die gesamte Periode. Ein sehr starkes Kaufsignal, besonders nach einem Rückgang.'**
  String get patternMarubozuBullishDesc;

  /// No description provided for @patternMarubozuBearishDesc.
  ///
  /// In de, this message translates to:
  /// **'Ein Bärischer Marubozu ist eine große rote Kerze ohne oder fast ohne Schatten. Der Kurs eröffnete auf dem Hoch und schloss auf dem Tief — absolute Verkäufer-Dominanz. Ein sehr starkes Verkaufssignal, besonders nach einem Aufwärtstrend.'**
  String get patternMarubozuBearishDesc;

  /// No description provided for @patternHammerDesc.
  ///
  /// In de, this message translates to:
  /// **'Ein Hammer tritt nach einem Abwärtstrend auf. Er hat einen kleinen Körper am oberen Ende und einen langen unteren Schatten (Lunte). Dies zeigt, dass Verkäufer den Preis stark drückten, aber Käufer ihn wieder hochkauften. Ein klassisches Umkehrsignal für eine mögliche Bodenbildung.'**
  String get patternHammerDesc;

  /// No description provided for @patternInvertedHammerDesc.
  ///
  /// In de, this message translates to:
  /// **'Der Inverted Hammer (umgekehrter Hammer) hat einen kleinen Körper unten und einen langen oberen Schatten. Er erscheint nach einem Abwärtstrend und zeigt, dass Käufer versuchten, den Kurs hochzutreiben — auch wenn sie es nicht ganz schafften. Bestätigung durch die nächste Kerze wichtig.'**
  String get patternInvertedHammerDesc;

  /// No description provided for @patternShootingStarDesc.
  ///
  /// In de, this message translates to:
  /// **'Der Shooting Star ist das Pendant zum Inverted Hammer, aber nach einem Aufwärtstrend. Er hat einen langen oberen Schatten und einen kleinen Körper unten. Käufer trieben den Kurs hoch, aber Verkäufer übernahmen die Kontrolle und drückten ihn wieder runter. Ein Warnsignal für eine bevorstehende Korrektur.'**
  String get patternShootingStarDesc;

  /// No description provided for @patternHangingManDesc.
  ///
  /// In de, this message translates to:
  /// **'Der Hanging Man sieht aus wie ein Hammer, erscheint aber nach einem Aufwärtstrend. Der lange untere Schatten zeigt, dass Verkäufer kurzfristig die Kontrolle hatten — ein Warnsignal, dass der Aufwärtstrend nachlassen könnte. Bestätigung durch eine rote Kerze am nächsten Tag verstärkt das Signal.'**
  String get patternHangingManDesc;

  /// No description provided for @patternBullishEngulfingDesc.
  ///
  /// In de, this message translates to:
  /// **'Eine große grüne Kerze umschließt die vorherige rote Kerze komplett. Dies zeigt massive Kaufkraftübernahme — Käufer haben alle Verluste des Vortages wettgemacht und mehr. Eines der zuverlässigsten bullishen Umkehrsignale.'**
  String get patternBullishEngulfingDesc;

  /// No description provided for @patternBearishEngulfingDesc.
  ///
  /// In de, this message translates to:
  /// **'Eine große rote Kerze umschließt die vorherige grüne Kerze komplett. Die Verkäufer haben alle Gewinne des Vortages vernichtet und treiben den Kurs tiefer. Eines der zuverlässigsten bärischen Umkehrsignale, besonders auf Widerstandsniveaus.'**
  String get patternBearishEngulfingDesc;

  /// No description provided for @patternPiercingLineDesc.
  ///
  /// In de, this message translates to:
  /// **'Die Piercing Line ist ein 2-Kerzen-Umkehrmuster. Nach einer langen roten Kerze eröffnete die grüne Kerze tiefer (Gap Down), schließt aber über der Mitte der vorigen roten Kerze. Dies zeigt, dass Käufer die Kontrolle übernehmen. Ein bullishes Signal nach einem Abwärtstrend.'**
  String get patternPiercingLineDesc;

  /// No description provided for @patternDarkCloudCoverDesc.
  ///
  /// In de, this message translates to:
  /// **'Das Gegenteil der Piercing Line. Nach einer langen grünen Kerze eröffnet die rote Kerze höher (Gap Up), schließt aber unter der Mitte der vorigen grünen Kerze. Verkäufer übernehmen die Kontrolle. Ein bärisches Umkehrsignal nach einem Aufwärtstrend.'**
  String get patternDarkCloudCoverDesc;

  /// No description provided for @patternBullishHaramiDesc.
  ///
  /// In de, this message translates to:
  /// **'Beim Bullish Harami (japanisch: schwanger) wird eine kleine grüne Kerze komplett vom Körper der vorigen großen roten Kerze eingeschlossen. Dies signalisiert eine Verlangsamung des Abwärtsdrucks und eine mögliche Trendwende. Weniger stark als Engulfing, aber ein gutes Warnsignal.'**
  String get patternBullishHaramiDesc;

  /// No description provided for @patternBearishHaramiDesc.
  ///
  /// In de, this message translates to:
  /// **'Beim Bearish Harami wird eine kleine rote Kerze komplett vom Körper der vorigen großen grünen Kerze eingeschlossen. Dies signalisiert eine Verlangsamung des Aufwärtsdrucks. Der Markt verliert Momentum — ein erstes Warnsignal für eine mögliche Korrektur.'**
  String get patternBearishHaramiDesc;

  /// No description provided for @patternTweezersBottomDesc.
  ///
  /// In de, this message translates to:
  /// **'Tweezers Bottom (Pinzettenboden): Zwei Kerzen mit (fast) identischen Tiefs. Die erste ist rot (Abwärtsbewegung), die zweite grün (Erholung). Dies zeigt einen starken Unterstützungslevel — Käufer sind bereit, genau auf diesem Preisniveau zu kaufen. Ein bullishes Umkehrsignal.'**
  String get patternTweezersBottomDesc;

  /// No description provided for @patternTweezersTopDesc.
  ///
  /// In de, this message translates to:
  /// **'Tweezers Top (Pinzettenspitze): Zwei Kerzen mit (fast) identischen Hochs. Die erste ist grün (Aufwärtsbewegung), die zweite rot (Abgabe). Dies zeigt einen starken Widerstandslevel — Verkäufer treten genau auf diesem Niveau auf. Ein bärisches Umkehrsignal.'**
  String get patternTweezersTopDesc;

  /// No description provided for @patternKickingBullishDesc.
  ///
  /// In de, this message translates to:
  /// **'Das Kicking-Muster ist eines der stärksten Signale überhaupt. Eine bärische Marubozu-Kerze wird abrupt von einer bullischen Marubozu-Kerze gefolgt (Gap Up). Der komplette Richtungswechsel mit starkem Volumen zeigt einen massiven Stimmungsumschwung — von Panikverkauf zu starkem Kaufinteresse.'**
  String get patternKickingBullishDesc;

  /// No description provided for @patternMorningStarDesc.
  ///
  /// In de, this message translates to:
  /// **'Der Morning Star ist ein starkes 3-Kerzen-Umkehrmuster nach einem Abwärtstrend: 1) Große rote Kerze (starker Verkauf), 2) Kleine Kerze (Unentschlossenheit), 3) Große grüne Kerze die über die Mitte der ersten schließt. Einer der zuverlässigsten Bodenbildungs-Indikatoren.'**
  String get patternMorningStarDesc;

  /// No description provided for @patternEveningStarDesc.
  ///
  /// In de, this message translates to:
  /// **'Der Evening Star ist das Gegenstück zum Morning Star, nach einem Aufwärtstrend: 1) Große grüne Kerze (starker Kauf), 2) Kleine Kerze (Unentschlossenheit am Hoch), 3) Große rote Kerze die unter die Mitte der ersten schließt. Ein zuverlässiges Topping-Signal.'**
  String get patternEveningStarDesc;

  /// No description provided for @pattern3WhiteSoldiersDesc.
  ///
  /// In de, this message translates to:
  /// **'Drei aufeinanderfolgende grüne Kerzen mit höheren Hochs und höheren Schlusskursen. Jede Kerze eröffnet innerhalb oder knapp unter dem vorherigen Körper. Zeigt nachhaltiges Kaufinteresse und anhaltenden Aufwärtstrend — eines der stärksten Trendfortsetzungs- oder Umkehrsignale.'**
  String get pattern3WhiteSoldiersDesc;

  /// No description provided for @pattern3BlackCrowsDesc.
  ///
  /// In de, this message translates to:
  /// **'Drei aufeinanderfolgende rote Kerzen mit tieferen Tiefs und tieferen Schlusskursen. Das Gegenstück zu den 3 White Soldiers. Zeigt nachhaltigen Verkaufsdruck — oft ein Signal für den Beginn eines stärkeren Abwärtstrends oder das Ende einer Aufwärtsbewegung.'**
  String get pattern3BlackCrowsDesc;

  /// No description provided for @fundamentalAnalysis.
  ///
  /// In de, this message translates to:
  /// **'Fundamentalanalyse: {symbol}'**
  String fundamentalAnalysis(String symbol);

  /// No description provided for @noFmpKeyError.
  ///
  /// In de, this message translates to:
  /// **'Kein FMP API Key in den Einstellungen gefunden.'**
  String get noFmpKeyError;

  /// No description provided for @loadFmpDataError.
  ///
  /// In de, this message translates to:
  /// **'Konnte Daten für {symbol} nicht laden (Limit erreicht oder Symbol falsch).'**
  String loadFmpDataError(String symbol);

  /// No description provided for @companyProfile.
  ///
  /// In de, this message translates to:
  /// **'Unternehmensprofil'**
  String get companyProfile;

  /// No description provided for @ceo.
  ///
  /// In de, this message translates to:
  /// **'CEO'**
  String get ceo;

  /// No description provided for @sector.
  ///
  /// In de, this message translates to:
  /// **'Sektor'**
  String get sector;

  /// No description provided for @industry.
  ///
  /// In de, this message translates to:
  /// **'Industrie'**
  String get industry;

  /// No description provided for @country.
  ///
  /// In de, this message translates to:
  /// **'Land'**
  String get country;

  /// No description provided for @employees.
  ///
  /// In de, this message translates to:
  /// **'Mitarbeiter'**
  String get employees;

  /// No description provided for @ipoDate.
  ///
  /// In de, this message translates to:
  /// **'IPO Datum'**
  String get ipoDate;

  /// No description provided for @website.
  ///
  /// In de, this message translates to:
  /// **'Webseite'**
  String get website;

  /// No description provided for @marketData.
  ///
  /// In de, this message translates to:
  /// **'Marktdaten'**
  String get marketData;

  /// No description provided for @marketCap.
  ///
  /// In de, this message translates to:
  /// **'Marktkap.'**
  String get marketCap;

  /// No description provided for @volAvg.
  ///
  /// In de, this message translates to:
  /// **'Volumen (Avg)'**
  String get volAvg;

  /// No description provided for @beta.
  ///
  /// In de, this message translates to:
  /// **'Beta (Vola)'**
  String get beta;

  /// No description provided for @fiftyTwoWeekRange.
  ///
  /// In de, this message translates to:
  /// **'52W Range'**
  String get fiftyTwoWeekRange;

  /// No description provided for @lastDiv.
  ///
  /// In de, this message translates to:
  /// **'Letzte Div.'**
  String get lastDiv;

  /// No description provided for @isEtf.
  ///
  /// In de, this message translates to:
  /// **'ETF?'**
  String get isEtf;

  /// No description provided for @analystTargets.
  ///
  /// In de, this message translates to:
  /// **'Analysten-Ziele (Gegenwart)'**
  String get analystTargets;

  /// No description provided for @targetConsensus.
  ///
  /// In de, this message translates to:
  /// **'Konsens (Mittel)'**
  String get targetConsensus;

  /// No description provided for @targetHigh.
  ///
  /// In de, this message translates to:
  /// **'High'**
  String get targetHigh;

  /// No description provided for @targetLow.
  ///
  /// In de, this message translates to:
  /// **'Low'**
  String get targetLow;

  /// No description provided for @nextEarningsDate.
  ///
  /// In de, this message translates to:
  /// **'Nächste Quartalszahlen'**
  String get nextEarningsDate;

  /// No description provided for @recentInsiderTrades.
  ///
  /// In de, this message translates to:
  /// **'Letzte Insider-Trades'**
  String get recentInsiderTrades;

  /// No description provided for @moreInfoOnAktienGuide.
  ///
  /// In de, this message translates to:
  /// **'Mehr Infos auf Aktien.guide'**
  String get moreInfoOnAktienGuide;

  /// No description provided for @dataProvidedByFmp.
  ///
  /// In de, this message translates to:
  /// **'Daten bereitgestellt von Financial Modeling Prep'**
  String get dataProvidedByFmp;

  /// No description provided for @billionShort.
  ///
  /// In de, this message translates to:
  /// **'Mrd.'**
  String get billionShort;

  /// No description provided for @thousandBillionShort.
  ///
  /// In de, this message translates to:
  /// **'Bio.'**
  String get thousandBillionShort;

  /// No description provided for @millionShort.
  ///
  /// In de, this message translates to:
  /// **'Mio.'**
  String get millionShort;

  /// No description provided for @newsTitle.
  ///
  /// In de, this message translates to:
  /// **'News: {symbol}'**
  String newsTitle(String symbol);

  /// No description provided for @noNewsFound.
  ///
  /// In de, this message translates to:
  /// **'Keine aktuellen Nachrichten gefunden.'**
  String get noNewsFound;

  /// No description provided for @monteCarloSimulation.
  ///
  /// In de, this message translates to:
  /// **'Monte Carlo Simulation'**
  String get monteCarloSimulation;

  /// No description provided for @daysCount.
  ///
  /// In de, this message translates to:
  /// **'{count} T'**
  String daysCount(int count);

  /// No description provided for @recalculate.
  ///
  /// In de, this message translates to:
  /// **'Neu berechnen'**
  String get recalculate;

  /// No description provided for @simulationRunning.
  ///
  /// In de, this message translates to:
  /// **'Simulation läuft... ({count} Szenarien)'**
  String simulationRunning(int count);

  /// No description provided for @simulatedPricePaths.
  ///
  /// In de, this message translates to:
  /// **'Simulierte Preispfade ({count} von {total})'**
  String simulatedPricePaths(int count, int total);

  /// No description provided for @current.
  ///
  /// In de, this message translates to:
  /// **'Aktuell'**
  String get current;

  /// No description provided for @expected.
  ///
  /// In de, this message translates to:
  /// **'Erwartet'**
  String get expected;

  /// No description provided for @delta.
  ///
  /// In de, this message translates to:
  /// **'Δ'**
  String get delta;

  /// No description provided for @low95.
  ///
  /// In de, this message translates to:
  /// **'95% Low'**
  String get low95;

  /// No description provided for @high95.
  ///
  /// In de, this message translates to:
  /// **'95% High'**
  String get high95;

  /// No description provided for @simulationAnalysis.
  ///
  /// In de, this message translates to:
  /// **'Analyse der Simulation'**
  String get simulationAnalysis;

  /// No description provided for @outlook.
  ///
  /// In de, this message translates to:
  /// **'Ausblick'**
  String get outlook;

  /// No description provided for @expectedDelta.
  ///
  /// In de, this message translates to:
  /// **'Erwartete Δ'**
  String get expectedDelta;

  /// No description provided for @probabilityDistribution.
  ///
  /// In de, this message translates to:
  /// **'Wahrscheinlichkeitsverteilung'**
  String get probabilityDistribution;

  /// No description provided for @volatilityAnn.
  ///
  /// In de, this message translates to:
  /// **'Volatilität (p.a.)'**
  String get volatilityAnn;

  /// No description provided for @riskLevel.
  ///
  /// In de, this message translates to:
  /// **'Risiko-Level'**
  String get riskLevel;

  /// No description provided for @span95.
  ///
  /// In de, this message translates to:
  /// **'95% Spanne'**
  String get span95;

  /// No description provided for @riskReward.
  ///
  /// In de, this message translates to:
  /// **'Risk/Reward'**
  String get riskReward;

  /// No description provided for @targetProbabilities.
  ///
  /// In de, this message translates to:
  /// **'Target Wahrscheinlichkeiten'**
  String get targetProbabilities;

  /// No description provided for @hitTp.
  ///
  /// In de, this message translates to:
  /// **'Hit TP'**
  String get hitTp;

  /// No description provided for @hitSl.
  ///
  /// In de, this message translates to:
  /// **'Hit SL'**
  String get hitSl;

  /// No description provided for @upside.
  ///
  /// In de, this message translates to:
  /// **'Upside'**
  String get upside;

  /// No description provided for @downside.
  ///
  /// In de, this message translates to:
  /// **'Downside'**
  String get downside;

  /// No description provided for @strongBullish.
  ///
  /// In de, this message translates to:
  /// **'Stark Bullish'**
  String get strongBullish;

  /// No description provided for @lightBullish.
  ///
  /// In de, this message translates to:
  /// **'Leicht Bullish'**
  String get lightBullish;

  /// No description provided for @strongBearish.
  ///
  /// In de, this message translates to:
  /// **'Stark Bearish'**
  String get strongBearish;

  /// No description provided for @lightBearish.
  ///
  /// In de, this message translates to:
  /// **'Leicht Bearish'**
  String get lightBearish;

  /// No description provided for @neutralSideways.
  ///
  /// In de, this message translates to:
  /// **'Neutral / Seitwärts'**
  String get neutralSideways;

  /// No description provided for @riskLow.
  ///
  /// In de, this message translates to:
  /// **'Niedrig'**
  String get riskLow;

  /// No description provided for @riskModerate.
  ///
  /// In de, this message translates to:
  /// **'Moderat'**
  String get riskModerate;

  /// No description provided for @riskHigh.
  ///
  /// In de, this message translates to:
  /// **'Hoch'**
  String get riskHigh;

  /// No description provided for @riskVeryHigh.
  ///
  /// In de, this message translates to:
  /// **'Sehr Hoch'**
  String get riskVeryHigh;

  /// No description provided for @hitChance.
  ///
  /// In de, this message translates to:
  /// **'Treffer-Chance'**
  String get hitChance;

  /// No description provided for @mcRecStrongBullish.
  ///
  /// In de, this message translates to:
  /// **'Starkes bullishes Setup: {bullPct}% der Szenarien steigen in {days} Tagen. Risk/Reward von {rr} spricht für eine Position.'**
  String mcRecStrongBullish(String bullPct, int days, String rr);

  /// No description provided for @mcRecLightBullish.
  ///
  /// In de, this message translates to:
  /// **'Leicht bullishes Umfeld mit akzeptablem Risk/Reward. Ein moderater Einstieg könnte in Betracht gezogen werden.'**
  String get mcRecLightBullish;

  /// No description provided for @mcRecBearish.
  ///
  /// In de, this message translates to:
  /// **'Bearishes Szenario: Nur {bullPct}% der Simulationen zeigen steigende Kurse. Vorsicht ist geboten, ggf. Absicherung empfohlen.'**
  String mcRecBearish(String bullPct);

  /// No description provided for @mcRecHighVol.
  ///
  /// In de, this message translates to:
  /// **'Extrem hohe Volatilität ({vol}% p.a.) — die Preisspanne ist sehr breit. Kleinere Positionen und weite Stop-Loss Levels empfohlen.'**
  String mcRecHighVol(String vol);

  /// No description provided for @mcRecBadRR.
  ///
  /// In de, this message translates to:
  /// **'Ungünstiges Risk/Reward-Verhältnis ({rr}). Das Abwärtsrisiko überwiegt das Aufwärtspotenzial deutlich.'**
  String mcRecBadRR(String rr);

  /// No description provided for @mcRecNeutral.
  ///
  /// In de, this message translates to:
  /// **'Neutrales Umfeld: Die Simulation zeigt keine klare Richtung. Abwarten oder Range-Strategien könnten sinnvoll sein.'**
  String get mcRecNeutral;

  /// No description provided for @kronosKiPrognose.
  ///
  /// In de, this message translates to:
  /// **'Kronos KI Prognose'**
  String get kronosKiPrognose;

  /// No description provided for @miniModel.
  ///
  /// In de, this message translates to:
  /// **'Mini Modell'**
  String get miniModel;

  /// No description provided for @smallModel.
  ///
  /// In de, this message translates to:
  /// **'Small Modell'**
  String get smallModel;

  /// No description provided for @baseModel.
  ///
  /// In de, this message translates to:
  /// **'Base Modell'**
  String get baseModel;

  /// No description provided for @prognoseStarten.
  ///
  /// In de, this message translates to:
  /// **'Prognose starten'**
  String get prognoseStarten;

  /// No description provided for @erweiterteEinstellungen.
  ///
  /// In de, this message translates to:
  /// **'Erweiterte Einstellungen'**
  String get erweiterteEinstellungen;

  /// No description provided for @prognoseTage.
  ///
  /// In de, this message translates to:
  /// **'Prognose (Tage)'**
  String get prognoseTage;

  /// No description provided for @modellKontext.
  ///
  /// In de, this message translates to:
  /// **'Modell Kontext / Vorlauf (Tage)'**
  String get modellKontext;

  /// No description provided for @chartHistorieAnzeige.
  ///
  /// In de, this message translates to:
  /// **'Chart Historie Anzeige (Tage)'**
  String get chartHistorieAnzeige;

  /// No description provided for @calculatingPrognose.
  ///
  /// In de, this message translates to:
  /// **'Berechne Prognose... {percent}%'**
  String calculatingPrognose(int percent);

  /// No description provided for @kronosGenerating.
  ///
  /// In de, this message translates to:
  /// **'Kronos Modell generiert Prognose...'**
  String get kronosGenerating;

  /// No description provided for @firstStartWarning.
  ///
  /// In de, this message translates to:
  /// **'Erster Start kann wegen Model-Download länger dauern.'**
  String get firstStartWarning;

  /// No description provided for @expectedPriceCourse.
  ///
  /// In de, this message translates to:
  /// **'Voraussichtlicher Preisverlauf'**
  String get expectedPriceCourse;

  /// No description provided for @today.
  ///
  /// In de, this message translates to:
  /// **'Heute'**
  String get today;

  /// No description provided for @targetTPlus.
  ///
  /// In de, this message translates to:
  /// **'Ziel (T+{days})'**
  String targetTPlus(int days);

  /// No description provided for @maxHigh.
  ///
  /// In de, this message translates to:
  /// **'Max Hoch'**
  String get maxHigh;

  /// No description provided for @minLow.
  ///
  /// In de, this message translates to:
  /// **'Min Tief'**
  String get minLow;

  /// No description provided for @pressStartForPrognose.
  ///
  /// In de, this message translates to:
  /// **'Drücke den Start-Button für eine Prognose'**
  String get pressStartForPrognose;

  /// No description provided for @viewScanHistory.
  ///
  /// In de, this message translates to:
  /// **'Scan-Historie anzeigen'**
  String get viewScanHistory;

  /// No description provided for @readyToScan.
  ///
  /// In de, this message translates to:
  /// **'Bereit zum Scannen.'**
  String get readyToScan;

  /// No description provided for @initializing.
  ///
  /// In de, this message translates to:
  /// **'Initialisiere...'**
  String get initializing;

  /// No description provided for @scanningSymbol.
  ///
  /// In de, this message translates to:
  /// **'({count}/{total}) Scanne {symbol}...'**
  String scanningSymbol(int count, int total, String symbol);

  /// No description provided for @scanCompleted.
  ///
  /// In de, this message translates to:
  /// **'Scan abgeschlossen. {count} Signale gefunden.'**
  String scanCompleted(int count);

  /// No description provided for @longCandidates.
  ///
  /// In de, this message translates to:
  /// **'Top 5 Long-Kandidaten'**
  String get longCandidates;

  /// No description provided for @shortCandidates.
  ///
  /// In de, this message translates to:
  /// **'Top 5 Short-Kandidaten'**
  String get shortCandidates;

  /// No description provided for @noCandidatesFound.
  ///
  /// In de, this message translates to:
  /// **'Keine Kandidaten gefunden'**
  String get noCandidatesFound;

  /// No description provided for @adjustStrategyHint.
  ///
  /// In de, this message translates to:
  /// **'Passe die Strategie an oder erweitere die Watchlist.'**
  String get adjustStrategyHint;

  /// No description provided for @tradeDetails.
  ///
  /// In de, this message translates to:
  /// **'Trade Details'**
  String get tradeDetails;

  /// No description provided for @tradePrice.
  ///
  /// In de, this message translates to:
  /// **'Preis: {value}'**
  String tradePrice(String value);

  /// No description provided for @tradeQuantity.
  ///
  /// In de, this message translates to:
  /// **'Menge: {value}'**
  String tradeQuantity(String value);

  /// No description provided for @tradeDate.
  ///
  /// In de, this message translates to:
  /// **'Datum: {value}'**
  String tradeDate(String value);

  /// No description provided for @tradeStatus.
  ///
  /// In de, this message translates to:
  /// **'Status: {value}'**
  String tradeStatus(String value);

  /// No description provided for @tradePnl.
  ///
  /// In de, this message translates to:
  /// **'PnL: {value}'**
  String tradePnl(String value);

  /// No description provided for @chartSettings.
  ///
  /// In de, this message translates to:
  /// **'Chart & Analyse Einstellungen'**
  String get chartSettings;

  /// No description provided for @indicatorVisibility.
  ///
  /// In de, this message translates to:
  /// **'Indikatoren Sichtbarkeit'**
  String get indicatorVisibility;

  /// No description provided for @oscillators.
  ///
  /// In de, this message translates to:
  /// **'Oszillatoren (unter Chart)'**
  String get oscillators;

  /// No description provided for @chartRangeDays.
  ///
  /// In de, this message translates to:
  /// **'Chart Zeitraum (Tage)'**
  String get chartRangeDays;

  /// No description provided for @save.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get save;

  /// No description provided for @buySuccess.
  ///
  /// In de, this message translates to:
  /// **'Kauf erfolgreich: {quantity} {symbol}'**
  String buySuccess(double quantity, String symbol);

  /// No description provided for @phaseLabel.
  ///
  /// In de, this message translates to:
  /// **'Phase {phase}/3: {name}'**
  String phaseLabel(int phase, String name);

  /// No description provided for @estimatedTime.
  ///
  /// In de, this message translates to:
  /// **'Schätzung: {time}'**
  String estimatedTime(String time);

  /// No description provided for @itemsCount.
  ///
  /// In de, this message translates to:
  /// **'{current} / {total} Elemente'**
  String itemsCount(int current, int total);

  /// No description provided for @openStatus.
  ///
  /// In de, this message translates to:
  /// **'OFFEN'**
  String get openStatus;

  /// No description provided for @closedStatus.
  ///
  /// In de, this message translates to:
  /// **'GESCHLOSSEN'**
  String get closedStatus;

  /// No description provided for @openTp1Hit.
  ///
  /// In de, this message translates to:
  /// **'OFFEN (TP1 Erreicht)'**
  String get openTp1Hit;

  /// No description provided for @pendingStop.
  ///
  /// In de, this message translates to:
  /// **'WARTEND (Stop)'**
  String get pendingStop;

  /// No description provided for @pendingLimit.
  ///
  /// In de, this message translates to:
  /// **'WARTEND (Limit)'**
  String get pendingLimit;

  /// No description provided for @entryPriceLabel.
  ///
  /// In de, this message translates to:
  /// **'Einstieg'**
  String get entryPriceLabel;

  /// No description provided for @deepDiveAnalysis.
  ///
  /// In de, this message translates to:
  /// **'Deep Dive Analyse'**
  String get deepDiveAnalysis;

  /// No description provided for @tabOverview.
  ///
  /// In de, this message translates to:
  /// **'Übersicht'**
  String get tabOverview;

  /// No description provided for @tabDetails.
  ///
  /// In de, this message translates to:
  /// **'Details'**
  String get tabDetails;

  /// No description provided for @tabTopCombos.
  ///
  /// In de, this message translates to:
  /// **'Top Kombis'**
  String get tabTopCombos;

  /// No description provided for @noClosedTradesForAnalysis.
  ///
  /// In de, this message translates to:
  /// **'Noch keine geschlossenen Trades für eine Analyse vorhanden.'**
  String get noClosedTradesForAnalysis;

  /// No description provided for @waitingForBotActivity.
  ///
  /// In de, this message translates to:
  /// **'Warte auf erste Bot-Aktivitäten.'**
  String get waitingForBotActivity;

  /// No description provided for @noTradesInPeriod.
  ///
  /// In de, this message translates to:
  /// **'Keine Trades in diesem Zeitraum gefunden.'**
  String get noTradesInPeriod;

  /// No description provided for @equityCurveTitle.
  ///
  /// In de, this message translates to:
  /// **'Equity Kurve (Kapitalverlauf)'**
  String get equityCurveTitle;

  /// No description provided for @streaksAndDuration.
  ///
  /// In de, this message translates to:
  /// **'Streaks & Dauer'**
  String get streaksAndDuration;

  /// No description provided for @maxWinningStreak.
  ///
  /// In de, this message translates to:
  /// **'Max Winning Streak'**
  String get maxWinningStreak;

  /// No description provided for @maxLosingStreak.
  ///
  /// In de, this message translates to:
  /// **'Max Losing Streak'**
  String get maxLosingStreak;

  /// No description provided for @avgHoldTime.
  ///
  /// In de, this message translates to:
  /// **'Ø Hold Time'**
  String get avgHoldTime;

  /// No description provided for @winLossProfile.
  ///
  /// In de, this message translates to:
  /// **'Win / Loss Profile'**
  String get winLossProfile;

  /// No description provided for @winRate.
  ///
  /// In de, this message translates to:
  /// **'Win Rate'**
  String get winRate;

  /// No description provided for @avgWinner.
  ///
  /// In de, this message translates to:
  /// **'Ø Winner'**
  String get avgWinner;

  /// No description provided for @avgLoser.
  ///
  /// In de, this message translates to:
  /// **'Ø Loser'**
  String get avgLoser;

  /// No description provided for @topFlopAssets.
  ///
  /// In de, this message translates to:
  /// **'Top / Flop Assets'**
  String get topFlopAssets;

  /// No description provided for @topWinners.
  ///
  /// In de, this message translates to:
  /// **'Top Gewinner'**
  String get topWinners;

  /// No description provided for @topLosers.
  ///
  /// In de, this message translates to:
  /// **'Top Verlierer'**
  String get topLosers;

  /// No description provided for @noDataSmall.
  ///
  /// In de, this message translates to:
  /// **'Keine Daten'**
  String get noDataSmall;

  /// No description provided for @performanceByTimeFrame.
  ///
  /// In de, this message translates to:
  /// **'Performance nach TimeFrame'**
  String get performanceByTimeFrame;

  /// No description provided for @performanceByStrategy.
  ///
  /// In de, this message translates to:
  /// **'Performance nach Strategie'**
  String get performanceByStrategy;

  /// No description provided for @performanceBySl.
  ///
  /// In de, this message translates to:
  /// **'Performance nach Stop-Loss'**
  String get performanceBySl;

  /// No description provided for @performanceByTp.
  ///
  /// In de, this message translates to:
  /// **'Performance nach Take-Profit'**
  String get performanceByTp;

  /// No description provided for @tooLittleDataForCombos.
  ///
  /// In de, this message translates to:
  /// **'Zu wenig Daten für Kombinationen.'**
  String get tooLittleDataForCombos;

  /// No description provided for @combinationNumber.
  ///
  /// In de, this message translates to:
  /// **'Kombination #{number}'**
  String combinationNumber(int number);

  /// No description provided for @expectancyVal.
  ///
  /// In de, this message translates to:
  /// **'Erwartungswert (EV)'**
  String get expectancyVal;

  /// No description provided for @expectancyUnit.
  ///
  /// In de, this message translates to:
  /// **'{value}/Trade'**
  String expectancyUnit(String value);

  /// No description provided for @filterAllTime.
  ///
  /// In de, this message translates to:
  /// **'Gesamte Zeit'**
  String get filterAllTime;

  /// No description provided for @filter30Days.
  ///
  /// In de, this message translates to:
  /// **'30 Tage'**
  String get filter30Days;

  /// No description provided for @filter7Days.
  ///
  /// In de, this message translates to:
  /// **'7 Tage'**
  String get filter7Days;

  /// No description provided for @filterYtd.
  ///
  /// In de, this message translates to:
  /// **'YTD'**
  String get filterYtd;

  /// No description provided for @shares.
  ///
  /// In de, this message translates to:
  /// **'Aktien'**
  String get shares;

  /// No description provided for @dayShort.
  ///
  /// In de, this message translates to:
  /// **'T{days}'**
  String dayShort(int days);

  /// No description provided for @averageShort.
  ///
  /// In de, this message translates to:
  /// **'Ø'**
  String get averageShort;

  /// No description provided for @indicatorEMA.
  ///
  /// In de, this message translates to:
  /// **'EMA Trend'**
  String get indicatorEMA;

  /// No description provided for @indicatorRSI.
  ///
  /// In de, this message translates to:
  /// **'RSI Momentum'**
  String get indicatorRSI;

  /// No description provided for @indicatorMACD.
  ///
  /// In de, this message translates to:
  /// **'MACD Volumen'**
  String get indicatorMACD;

  /// No description provided for @indicatorBB.
  ///
  /// In de, this message translates to:
  /// **'Bollinger Bänder'**
  String get indicatorBB;

  /// No description provided for @indicatorStoch.
  ///
  /// In de, this message translates to:
  /// **'Stochastik'**
  String get indicatorStoch;

  /// No description provided for @indicatorSupertrend.
  ///
  /// In de, this message translates to:
  /// **'Supertrend'**
  String get indicatorSupertrend;

  /// No description provided for @indicatorSAR.
  ///
  /// In de, this message translates to:
  /// **'Parabolic SAR'**
  String get indicatorSAR;

  /// No description provided for @indicatorIchimoku.
  ///
  /// In de, this message translates to:
  /// **'Ichimoku Analyse'**
  String get indicatorIchimoku;

  /// No description provided for @indicatorVortexChoppiness.
  ///
  /// In de, this message translates to:
  /// **'Vortex + Choppiness'**
  String get indicatorVortexChoppiness;

  /// No description provided for @indicatorMACDHist.
  ///
  /// In de, this message translates to:
  /// **'MACD Histogramm'**
  String get indicatorMACDHist;

  /// No description provided for @indicatorADX.
  ///
  /// In de, this message translates to:
  /// **'ADX (Trendstärke)'**
  String get indicatorADX;

  /// No description provided for @indicatorCCI.
  ///
  /// In de, this message translates to:
  /// **'CCI (Commodity Channel)'**
  String get indicatorCCI;

  /// No description provided for @indicatorAO.
  ///
  /// In de, this message translates to:
  /// **'Awesome Oscillator'**
  String get indicatorAO;

  /// No description provided for @indicatorOBV.
  ///
  /// In de, this message translates to:
  /// **'On-Balance Volume'**
  String get indicatorOBV;

  /// No description provided for @indicatorCMF.
  ///
  /// In de, this message translates to:
  /// **'CMF (Chaikin Money Flow)'**
  String get indicatorCMF;

  /// No description provided for @indicatorMFI.
  ///
  /// In de, this message translates to:
  /// **'MFI (Money Flow Index)'**
  String get indicatorMFI;

  /// No description provided for @indicatorDiv.
  ///
  /// In de, this message translates to:
  /// **'RSI Divergenz'**
  String get indicatorDiv;

  /// No description provided for @indicatorSqueeze.
  ///
  /// In de, this message translates to:
  /// **'TTM Squeeze'**
  String get indicatorSqueeze;

  /// No description provided for @indicatorBBPercent.
  ///
  /// In de, this message translates to:
  /// **'BB %B (Bollinger)'**
  String get indicatorBBPercent;

  /// No description provided for @posMomentum.
  ///
  /// In de, this message translates to:
  /// **'Positives Momentum'**
  String get posMomentum;

  /// No description provided for @negMomentum.
  ///
  /// In de, this message translates to:
  /// **'Negatives Momentum'**
  String get negMomentum;

  /// No description provided for @strongTrend.
  ///
  /// In de, this message translates to:
  /// **'Starker Trend'**
  String get strongTrend;

  /// No description provided for @sideways.
  ///
  /// In de, this message translates to:
  /// **'Seitwärts'**
  String get sideways;

  /// No description provided for @trending.
  ///
  /// In de, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @posMoneyFlow.
  ///
  /// In de, this message translates to:
  /// **'Positiver Geldfluss'**
  String get posMoneyFlow;

  /// No description provided for @negMoneyFlow.
  ///
  /// In de, this message translates to:
  /// **'Negativer Geldfluss'**
  String get negMoneyFlow;

  /// No description provided for @bullishDetected.
  ///
  /// In de, this message translates to:
  /// **'Bullish erkannt'**
  String get bullishDetected;

  /// No description provided for @bearishDetected.
  ///
  /// In de, this message translates to:
  /// **'Bearish erkannt'**
  String get bearishDetected;

  /// No description provided for @strongReversal.
  ///
  /// In de, this message translates to:
  /// **'Starkes Umkehrsignal'**
  String get strongReversal;

  /// No description provided for @active.
  ///
  /// In de, this message translates to:
  /// **'Aktiv'**
  String get active;

  /// No description provided for @breakoutPending.
  ///
  /// In de, this message translates to:
  /// **'Ausbruch steht bevor'**
  String get breakoutPending;

  /// No description provided for @midRange.
  ///
  /// In de, this message translates to:
  /// **'Mittlerer Bereich'**
  String get midRange;

  /// No description provided for @aboveCloud.
  ///
  /// In de, this message translates to:
  /// **'Über der Wolke'**
  String get aboveCloud;

  /// No description provided for @belowCloud.
  ///
  /// In de, this message translates to:
  /// **'Unter der Wolke'**
  String get belowCloud;

  /// No description provided for @trendUp.
  ///
  /// In de, this message translates to:
  /// **'Trend Aufwärts'**
  String get trendUp;

  /// No description provided for @trendDown.
  ///
  /// In de, this message translates to:
  /// **'Trend Abwärts'**
  String get trendDown;

  /// No description provided for @tenkanAboveKijun.
  ///
  /// In de, this message translates to:
  /// **'Tenkan > Kijun'**
  String get tenkanAboveKijun;

  /// No description provided for @tenkanBelowKijun.
  ///
  /// In de, this message translates to:
  /// **'Tenkan < Kijun'**
  String get tenkanBelowKijun;

  /// No description provided for @volMomentum.
  ///
  /// In de, this message translates to:
  /// **'Volumen-Momentum'**
  String get volMomentum;

  /// No description provided for @details.
  ///
  /// In de, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @scoreDetails.
  ///
  /// In de, this message translates to:
  /// **'Analyse Details'**
  String get scoreDetails;

  /// No description provided for @range1W.
  ///
  /// In de, this message translates to:
  /// **'1W'**
  String get range1W;

  /// No description provided for @range1M.
  ///
  /// In de, this message translates to:
  /// **'1M'**
  String get range1M;

  /// No description provided for @range3M.
  ///
  /// In de, this message translates to:
  /// **'3M'**
  String get range3M;

  /// No description provided for @range1Y.
  ///
  /// In de, this message translates to:
  /// **'1Y'**
  String get range1Y;

  /// No description provided for @range2Y.
  ///
  /// In de, this message translates to:
  /// **'2Y'**
  String get range2Y;

  /// No description provided for @range3Y.
  ///
  /// In de, this message translates to:
  /// **'3Y'**
  String get range3Y;

  /// No description provided for @range5Y.
  ///
  /// In de, this message translates to:
  /// **'5Y'**
  String get range5Y;

  /// No description provided for @bullish.
  ///
  /// In de, this message translates to:
  /// **'Bullish'**
  String get bullish;

  /// No description provided for @bearish.
  ///
  /// In de, this message translates to:
  /// **'Bearish'**
  String get bearish;

  /// No description provided for @netPnL.
  ///
  /// In de, this message translates to:
  /// **'Netto G&V'**
  String get netPnL;

  /// No description provided for @profitFactor.
  ///
  /// In de, this message translates to:
  /// **'Profitfaktor'**
  String get profitFactor;

  /// No description provided for @updateAvailable.
  ///
  /// In de, this message translates to:
  /// **'Update verfügbar: v{version}'**
  String updateAvailable(String version);

  /// No description provided for @chooseVersionDownload.
  ///
  /// In de, this message translates to:
  /// **'Wähle deine Version zum Download:'**
  String get chooseVersionDownload;

  /// No description provided for @toGithubReleasePage.
  ///
  /// In de, this message translates to:
  /// **'Zur GitHub Release Seite'**
  String get toGithubReleasePage;

  /// No description provided for @later.
  ///
  /// In de, this message translates to:
  /// **'Später'**
  String get later;

  /// No description provided for @androidApk.
  ///
  /// In de, this message translates to:
  /// **'🤖 Android (.apk)'**
  String get androidApk;

  /// No description provided for @windowsZip.
  ///
  /// In de, this message translates to:
  /// **'🪟 Windows (.zip)'**
  String get windowsZip;

  /// No description provided for @macosZip.
  ///
  /// In de, this message translates to:
  /// **'🍏 macOS (.zip)'**
  String get macosZip;

  /// No description provided for @linuxZip.
  ///
  /// In de, this message translates to:
  /// **'🐧 Linux (.zip)'**
  String get linuxZip;

  /// No description provided for @iosIpa.
  ///
  /// In de, this message translates to:
  /// **'📱 iOS (.ipa)'**
  String get iosIpa;

  /// No description provided for @openError.
  ///
  /// In de, this message translates to:
  /// **'Konnte {url} nicht öffnen'**
  String openError(String url);

  /// No description provided for @noChartData.
  ///
  /// In de, this message translates to:
  /// **'Keine Daten für Chart'**
  String get noChartData;

  /// No description provided for @supertrend.
  ///
  /// In de, this message translates to:
  /// **'Supertrend'**
  String get supertrend;

  /// No description provided for @donchianChannel.
  ///
  /// In de, this message translates to:
  /// **'Donchian Kanal'**
  String get donchianChannel;

  /// No description provided for @statusInitializing.
  ///
  /// In de, this message translates to:
  /// **'Initialisiere...'**
  String get statusInitializing;

  /// No description provided for @statusCheckingPending.
  ///
  /// In de, this message translates to:
  /// **'Prüfe Pending Orders...'**
  String get statusCheckingPending;

  /// No description provided for @statusManagingOpen.
  ///
  /// In de, this message translates to:
  /// **'Manage offene Positionen...'**
  String get statusManagingOpen;

  /// No description provided for @statusScanningMarkets.
  ///
  /// In de, this message translates to:
  /// **'Scanne Märkte nach Signalen...'**
  String get statusScanningMarkets;

  /// No description provided for @statusDone.
  ///
  /// In de, this message translates to:
  /// **'Fertig.'**
  String get statusDone;

  /// No description provided for @statusError.
  ///
  /// In de, this message translates to:
  /// **'Fehler: {error}'**
  String statusError(String error);

  /// No description provided for @statusCancelRequested.
  ///
  /// In de, this message translates to:
  /// **'Abbruch angefordert...'**
  String get statusCancelRequested;

  /// No description provided for @realizedLabel.
  ///
  /// In de, this message translates to:
  /// **'Real'**
  String get realizedLabel;

  /// No description provided for @currencyValue.
  ///
  /// In de, this message translates to:
  /// **'{value} €'**
  String currencyValue(String value);

  /// No description provided for @tradeDetailsSymbol.
  ///
  /// In de, this message translates to:
  /// **'Details: {symbol}'**
  String tradeDetailsSymbol(String symbol);

  /// No description provided for @entryScore.
  ///
  /// In de, this message translates to:
  /// **'Einstiegs-Score'**
  String get entryScore;

  /// No description provided for @patternLabel.
  ///
  /// In de, this message translates to:
  /// **'Muster'**
  String get patternLabel;

  /// No description provided for @tradeData.
  ///
  /// In de, this message translates to:
  /// **'Handelsdaten'**
  String get tradeData;

  /// No description provided for @statusLabel.
  ///
  /// In de, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @signalDate.
  ///
  /// In de, this message translates to:
  /// **'Signal-Datum'**
  String get signalDate;

  /// No description provided for @indicatorsAtPurchase.
  ///
  /// In de, this message translates to:
  /// **'Indikatoren beim Kauf'**
  String get indicatorsAtPurchase;

  /// No description provided for @noDetailDataSaved.
  ///
  /// In de, this message translates to:
  /// **'Keine Detaildaten gespeichert'**
  String get noDetailDataSaved;

  /// No description provided for @deleteTradeConfirmTitle.
  ///
  /// In de, this message translates to:
  /// **'Trade löschen?'**
  String get deleteTradeConfirmTitle;

  /// No description provided for @deleteTradeConfirmContent.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du diesen Trade wirklich aus der Historie löschen?'**
  String get deleteTradeConfirmContent;

  /// No description provided for @delete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get delete;

  /// No description provided for @maxDrawdown.
  ///
  /// In de, this message translates to:
  /// **'Max. Drawdown'**
  String get maxDrawdown;

  /// No description provided for @yes.
  ///
  /// In de, this message translates to:
  /// **'Ja'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In de, this message translates to:
  /// **'Nein'**
  String get no;

  /// No description provided for @errorLabel.
  ///
  /// In de, this message translates to:
  /// **'Fehler'**
  String get errorLabel;

  /// No description provided for @aiProbabilityInsights.
  ///
  /// In de, this message translates to:
  /// **'KI-Wahrscheinlichkeiten & Insights'**
  String get aiProbabilityInsights;

  /// No description provided for @priceAboveEma.
  ///
  /// In de, this message translates to:
  /// **'Preis über EMA'**
  String get priceAboveEma;

  /// No description provided for @priceBelowEma.
  ///
  /// In de, this message translates to:
  /// **'Preis unter EMA'**
  String get priceBelowEma;

  /// No description provided for @topMoversHistory.
  ///
  /// In de, this message translates to:
  /// **'Top Movers Historie'**
  String get topMoversHistory;

  /// No description provided for @refreshPrices.
  ///
  /// In de, this message translates to:
  /// **'Preise aktualisieren'**
  String get refreshPrices;

  /// No description provided for @noScanHistory.
  ///
  /// In de, this message translates to:
  /// **'Keine Scan-Historie vorhanden.'**
  String get noScanHistory;

  /// No description provided for @scanFrom.
  ///
  /// In de, this message translates to:
  /// **'Scan vom'**
  String get scanFrom;

  /// No description provided for @intervalLabel.
  ///
  /// In de, this message translates to:
  /// **'Intervall'**
  String get intervalLabel;

  /// No description provided for @priceThen.
  ///
  /// In de, this message translates to:
  /// **'Preis damals'**
  String get priceThen;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
