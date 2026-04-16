// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TechAna';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'System Language';

  @override
  String get navAnalysis => 'Analysis';

  @override
  String get navAutoBot => 'AutoBot';

  @override
  String get navSettings => 'Settings';

  @override
  String get searchHint => 'Search symbol (e.g. AAPL.US)';

  @override
  String get noAnalysis => 'No Analysis';

  @override
  String get tradingScore => 'Trading Score';

  @override
  String get noPattern => 'No Pattern';

  @override
  String get bullishDivergence => 'Bullish Divergence';

  @override
  String get bearishDivergence => 'Bearish Divergence';

  @override
  String get unknown => 'Unknown';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get retryButton => 'Retry';

  @override
  String get fundamentals => 'Fundamentals';

  @override
  String get newsYahoo => 'News (Yahoo)';

  @override
  String get monteCarlo => 'Monte Carlo';

  @override
  String get kronosAi => 'Kronos AI';

  @override
  String get close => 'Close';

  @override
  String currentValue(String value) {
    return 'Current Value: $value';
  }

  @override
  String get rsiOverbought => 'Overbought';

  @override
  String get rsiOversold => 'Oversold';

  @override
  String get rsiNeutral => 'Neutral';

  @override
  String get macdPositive => 'Positive';

  @override
  String get macdNegative => 'Negative';

  @override
  String get mcBullish => 'Bullish';

  @override
  String get mcSlightlyBullish => 'Slightly Bullish';

  @override
  String get mcBearish => 'Bearish';

  @override
  String get mcSlightlyBearish => 'Slightly Bearish';

  @override
  String get mcNeutral => 'Neutral';

  @override
  String get mtcBullishConfirmed => 'MTC: Bullish Confirmed (H1, H4, D1)';

  @override
  String get mtcBearishConfirmed => 'MTC: Bearish Confirmed (H1, H4, D1)';

  @override
  String get mtcNeutral => 'MTC: Neutral';

  @override
  String get kronosAiAnalysis => 'Kronos AI Analysis';

  @override
  String get modelCalculatingForecast => 'Model calculating forecast...';

  @override
  String get tp1HitChance => 'TP1 Hit Chance';

  @override
  String get tp2HitChance => 'TP2 Hit Chance';

  @override
  String get slHitChance => 'SL Hit Chance';

  @override
  String get volume => 'Volume';

  @override
  String get adxTrendStrength => 'ADX (Trend Strength)';

  @override
  String get tabView => 'View';

  @override
  String get tabChart => 'Chart';

  @override
  String get tabStrategy => 'Strategy';

  @override
  String get tabData => 'Data';

  @override
  String get viewAndGeneral => 'View & General';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get showCandlesticks => 'Show Candlesticks';

  @override
  String get showCandlesticksSubtitle => 'Shows candles instead of line';

  @override
  String get patternMarkers => 'Pattern Markers';

  @override
  String get tradingLines => 'Trading Lines (TP/SL)';

  @override
  String get chartIndicators => 'Chart Indicators';

  @override
  String get ema20Line => 'EMA 20 Line';

  @override
  String get bollingerBands => 'Bollinger Bands';

  @override
  String get projectionDays => 'Projection (Days)';

  @override
  String get additionalCharts => 'Additional Charts (below)';

  @override
  String get volumeChart => 'Volume Chart';

  @override
  String get rsiIndicator => 'RSI Indicator';

  @override
  String get macdIndicator => 'MACD Indicator';

  @override
  String get stochasticOscillator => 'Stochastic Oscillator';

  @override
  String get obvIndicator => 'On-Balance Volume (OBV)';

  @override
  String get adxIndicator => 'ADX (Trend Strength)';

  @override
  String get manualAnalysisStrategy => 'Manual Analysis Strategy';

  @override
  String get entryStrategy => 'Entry Strategy';

  @override
  String get marketImmediate => 'Market (Immediate)';

  @override
  String get pullbackLimit => 'Pullback (Limit)';

  @override
  String get breakoutStop => 'Breakout (Stop)';

  @override
  String get entryStrategyDesc =>
      'When to enter? \'Market\' buys immediately. \'Pullback\' waits for a better price. \'Breakout\' buys on upward breakout (more expensive). Recommended: Market or Pullback.';

  @override
  String get entryPaddingType => 'Entry Padding Type';

  @override
  String get percentual => 'Percentage (%)';

  @override
  String get atrFactor => 'ATR Factor';

  @override
  String get entryPaddingPercent => 'Entry Padding %';

  @override
  String get entryPaddingAtr => 'Entry Padding (x ATR)';

  @override
  String get entryPaddingDesc =>
      'Distance from current price for the order. Default: 0.2% or 0.5x ATR.';

  @override
  String get stopLossMethod => 'Stop Loss Method';

  @override
  String get donchianLow => 'Donchian Low';

  @override
  String get percentualMethod => 'Percentage';

  @override
  String get atrVolatility => 'ATR (Volatility)';

  @override
  String get swingLowHigh => 'Swing-Low/High';

  @override
  String get stopLossDesc =>
      'How is the stop loss set? ATR adapts to market fluctuations (professional standard). Swing uses the last significant low/high.';

  @override
  String get stopLossPercent => 'Stop Loss %';

  @override
  String get stopLossPercentDesc => 'Fixed percentage distance. Default: 5-8%.';

  @override
  String get atrMultiplier => 'ATR Multiplier';

  @override
  String get atrMultiplierDesc =>
      'How much room does the trade have? 2.0x ATR is standard for swing trading. Smaller = tighter stop.';

  @override
  String get swingLookbackCandles => 'Swing Lookback (Candles)';

  @override
  String get swingLookbackDesc =>
      'How many candles to look back to find the last swing low/high. Default: 20.';

  @override
  String get takeProfitMethod => 'Take Profit Method';

  @override
  String get riskRewardCrv => 'Risk/Reward (RRR)';

  @override
  String get atrTarget => 'ATR Target';

  @override
  String get pivotPoints => 'Pivot Points';

  @override
  String get takeProfitDesc =>
      'When to take profits? Pivot Points uses classic floor pivot levels as targets. RRR recommended for beginners.';

  @override
  String get tp1Factor => 'TP1 Factor';

  @override
  String get tp1FactorDesc =>
      'First target: multiple of risk. Default: 1.5x (with 100€ risk -> 150€ profit).';

  @override
  String get tp2Factor => 'TP2 Factor';

  @override
  String get tp2FactorDesc => 'Second target (Moonbag). Default: 3.0x.';

  @override
  String get tp1Percent => 'TP1 %';

  @override
  String get tp1PercentDesc => 'Fixed profit in %. Default: 5-10%.';

  @override
  String get tp2Percent => 'TP2 %';

  @override
  String get tp2PercentDesc => 'Far target in %. Default: 10-20%.';

  @override
  String get mcSimulations => 'MC Simulations';

  @override
  String get mcSimulationsDesc =>
      'Number of scenarios for scoring. Higher = more accurate but slower. Default: 200.';

  @override
  String get resetToDefaults => 'Reset to Defaults';

  @override
  String get expertFeaturesAi => 'Expert Features (AI/Algo)';

  @override
  String get marketRegimeFilter => 'Market Regime Filter';

  @override
  String get marketRegimeSubtitle => 'Adaptation to trend/range/volatility';

  @override
  String get aiProbabilityScoring => 'AI Probability Scoring';

  @override
  String get aiProbabilitySubtitle => 'Weighting by historical hit rate';

  @override
  String get multiTimeframeMtc => 'Multi-Timeframe (MTC)';

  @override
  String get mtcSubtitle => 'Confirmation on higher timeframes';

  @override
  String get strategyOptimizer => 'Strategy Optimizer';

  @override
  String get strategyOptimizerSubtitle =>
      'Searches for optimal indicator parameters';

  @override
  String get dataSources => 'Data Sources';

  @override
  String get chartDataSource => 'Chart: Stooq.com (Free)';

  @override
  String get alphaVantageLabel => 'Alpha Vantage API Key (for Fundamentals)';

  @override
  String get alphaVantageHint => 'Enter key here (optional)';

  @override
  String get fmpLabel => 'FMP API Key (Financial Modeling Prep)';

  @override
  String get fmpHint => 'Enter key';

  @override
  String get hfTokenLabel => 'HuggingFace Token (Kronos AI)';

  @override
  String get kronosServerUrl => 'Kronos Server URL';

  @override
  String get kronosServerHint => 'e.g. http://192.168.178.139:8000';

  @override
  String get kronosServerHelper =>
      'Empty = local backend on desktop. For Android/iOS: enter PC\'s IP address.';

  @override
  String version(String ver, String build) {
    return 'Version $ver+$build';
  }

  @override
  String get botDashboard => 'Bot Dashboard';

  @override
  String get cancelScan => 'Cancel Scan';

  @override
  String get startScan => 'Start Scan';

  @override
  String get topMoversScan => 'Top Movers Scan';

  @override
  String get botSettings => 'Bot Settings';

  @override
  String get editWatchlist => 'Edit Watchlist';

  @override
  String get portfolioReset => 'Portfolio Reset';

  @override
  String get openDetailedAnalysis => 'Open Detailed Bot Analysis';

  @override
  String get positionsByCategory => 'Positions by Category';

  @override
  String get allPositionsRaw => 'All Positions (Raw Data)';

  @override
  String tradesTotal(int count) {
    return '$count trades total';
  }

  @override
  String get filterAll => 'All';

  @override
  String get filterOpen => 'Open';

  @override
  String get filterOpenPositive => 'Open +';

  @override
  String get filterOpenNegative => 'Open -';

  @override
  String get filterPending => 'Pending';

  @override
  String get filterClosed => 'Closed';

  @override
  String get filterClosedPositive => 'Closed +';

  @override
  String get filterClosedNegative => 'Closed -';

  @override
  String get noTrades => 'No trades available.';

  @override
  String get otherCategory => 'Other';

  @override
  String get noCategorizedTrades => 'No categorized trades available.';

  @override
  String get resetPortfolioTitle => 'Reset Portfolio?';

  @override
  String get resetPortfolioContent =>
      'This will delete ALL trades and reset invested capital to 0. Are you sure?';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get botWatchlist => 'Bot Watchlist';

  @override
  String get symbolHint => 'Symbol (e.g. BTC-USD)';

  @override
  String get selectAll => 'All';

  @override
  String get selectNone => 'None';

  @override
  String get done => 'Done';

  @override
  String get portfolioPerformance => 'Portfolio Performance (PnL)';

  @override
  String currentPnlTemplate(String value) {
    return 'Current: $value €';
  }

  @override
  String get invested => 'Invested';

  @override
  String get unrealizedPnl => 'Unreal. PnL';

  @override
  String get realizedPnl => 'Realized PnL';

  @override
  String get open => 'Open';

  @override
  String get closed => 'Closed';

  @override
  String get total => 'Total';

  @override
  String totalLabel(int count) {
    return 'Total: $count';
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
  String get marketScan => 'Market Scan';

  @override
  String get botConfiguration => 'Bot Configuration';

  @override
  String get tabGeneral => 'General';

  @override
  String get botActive => 'Bot Active (Auto-Run)';

  @override
  String runningInBackground(int minutes) {
    return 'Running in background (every $minutes min)';
  }

  @override
  String get paused => 'Paused';

  @override
  String get cancelRunningScan => 'Cancel Running Scan Immediately';

  @override
  String get routineScope => 'Routine Scope';

  @override
  String get checkPendingOrders => 'Check Pending Orders';

  @override
  String get checkPendingSubtitle => 'Checks Limit/Stop Orders (Entry).';

  @override
  String get checkOpenPositions => 'Check Open Positions';

  @override
  String get checkOpenSubtitle => 'Checks SL/TP and updates PnL.';

  @override
  String get scanForNewTrades => 'Scan for New Trades';

  @override
  String get scanForNewSubtitle => 'Scans watchlist for signals.';

  @override
  String get moneyManagement => 'Money Management';

  @override
  String get investPerTrade => 'Investment per Trade (€)';

  @override
  String get investPerTradeDesc => 'Base investment per position.';

  @override
  String get unlimitedPositions => 'Unlimited Positions';

  @override
  String get maxOpenPositions => 'Max. Open Positions';

  @override
  String get automation => 'Automation';

  @override
  String get scanInterval => 'Scan Interval (Min)';

  @override
  String get scanIntervalDesc => 'Frequency of automatic checks.';

  @override
  String get mcSimulationsScoring => 'MC Simulations (Scoring)';

  @override
  String get mcSimulationsScoringDesc =>
      'Number of scenarios for bot scoring. Default: 200.';

  @override
  String get mcStrictMode => 'MC Strict Mode';

  @override
  String get mcStrictModeSubtitle =>
      'Only open trades when MC hit probability for TP > SL.';

  @override
  String get tradeManagement => 'Trade Management';

  @override
  String get trailingStopAtr => 'Trailing Stop (x ATR)';

  @override
  String get trailingStopDesc => 'Automatically trail stop loss.';

  @override
  String get dynamicPositionSize => 'Dynamic Position Size';

  @override
  String get dynamicPositionSubtitle =>
      'Double investment for high score (>80).';

  @override
  String get aiAndAnalysis => 'AI & Analysis';

  @override
  String get kronosAiAnalysisTitle => 'Kronos AI Analysis';

  @override
  String get kronosAiSubtitle =>
      'Uses foundation model for price prediction per symbol.';

  @override
  String get kronosStrictMode => 'Kronos Strict Mode';

  @override
  String get kronosStrictSubtitle =>
      'Only open trades when Kronos predicts TP1 BEFORE SL.';

  @override
  String get resetAllSettings => 'Reset All Settings';

  @override
  String get settingsNote =>
      'Note: Changes are saved immediately and applied on the next scan.';

  @override
  String get generalAndTimeframe => 'General & Timeframe';

  @override
  String get alternatingStrategies => 'Alternating Strategies';

  @override
  String get alternatingStrategiesSubtitle =>
      'Test random values for each scan';

  @override
  String get analysisInterval => 'Analysis Interval';

  @override
  String get entrySection => 'Entry';

  @override
  String get strategyType => 'Strategy Type';

  @override
  String get paddingType => 'Padding Type';

  @override
  String get paddingPercent => 'Padding %';

  @override
  String get paddingAtr => 'Padding (x ATR)';

  @override
  String get stopLossRisk => 'Stop Loss (Risk)';

  @override
  String get method => 'Method';

  @override
  String get donchianLowHigh => 'Donchian Low/High';

  @override
  String get stopDistance => 'Stop Distance %';

  @override
  String get takeProfitTargets => 'Take Profit (Targets)';

  @override
  String get sellAtTp1 => 'Sell at TP1 (%)';

  @override
  String get tp1FactorR => 'TP1 Factor (R)';

  @override
  String get tp2FactorR => 'TP2 Factor (R)';

  @override
  String get marketRegimeSubtitleBot => 'Adaptation to trend/range/volatility.';

  @override
  String get aiProbabilitySubtitleBot => 'Weighting by historical hit rate.';

  @override
  String get mtcSubtitleBot => 'Trend confirmation on higher timeframes.';

  @override
  String get strategyOptimizerSubtitleBot =>
      'Searches for optimal indicator parameters.';

  @override
  String get timeframe15min => '15 Min';

  @override
  String get timeframe1h => '1 Hour';

  @override
  String get timeframe4h => '4 Hours';

  @override
  String get timeframeDay => 'Day';

  @override
  String get timeframeWeek => 'Week';

  @override
  String get regimeTrendingBull => 'Bullish Trend';

  @override
  String get regimeTrendingBear => 'Bearish Trend';

  @override
  String get regimeRanging => 'Sideways (Range)';

  @override
  String get regimeVolatile => 'Volatile (Choppy)';

  @override
  String get regimeUnknown => 'Unknown';

  @override
  String get noData => 'No Data';

  @override
  String get analysisDetails => 'Analysis Details';

  @override
  String get strategySettings => 'Strategy Settings';

  @override
  String get alreadyInWatchlist => 'Already in Bot Watchlist';

  @override
  String get addToWatchlist => 'Add to Bot Watchlist';

  @override
  String addedToWatchlist(String symbol) {
    return '$symbol added to Bot Watchlist!';
  }

  @override
  String regimePrefix(String label) {
    return 'Regime: $label';
  }

  @override
  String get avgConfidence => 'Average Confidence';

  @override
  String get indicatorWeighting =>
      'Indicator Weighting (Hit rate last 50 bars):';

  @override
  String get scoreBreakdown => 'Score Breakdown (Tap for details):';

  @override
  String get tapForDetails => 'Tap for details';

  @override
  String get tapForIndicators => 'Tap for indicators';

  @override
  String get catTrend => 'Trend';

  @override
  String get catMomentum => 'Momentum';

  @override
  String get catVolume => 'Volume';

  @override
  String get catPattern => 'Pattern';

  @override
  String get catVolatility => 'Volatility';

  @override
  String get stDesc => 'Trend following indicator based on ATR.';

  @override
  String get emaDesc => 'Moving averages show price trend direction.';

  @override
  String get psarDesc =>
      'Identifies potential trend reversals and exit points.';

  @override
  String get ichimokuDesc => 'Complex cloud-based trend and support analysis.';

  @override
  String get vortexChopDesc =>
      'VX measures trend strength; CHOP measures range vs trend.';

  @override
  String get rsiDesc => 'Measures speed and change of price movements.';

  @override
  String get macdDesc => 'Shows relationship between two moving averages.';

  @override
  String get adxDesc => 'Measures the overall strength of a trend.';

  @override
  String get cciDesc => 'Identifies cyclical trends and extreme levels.';

  @override
  String get stochDesc => 'Compares closing price to price range over time.';

  @override
  String get aoDesc => 'Market momentum indicator (AO).';

  @override
  String get obvDesc => 'Uses volume flow to predict price changes.';

  @override
  String get cmfDesc => 'Measures volume-weighted money flow.';

  @override
  String get mfiDesc => 'RSI combined with volume for money flow.';

  @override
  String get divDesc => 'Price vs Momentum divergence signal.';

  @override
  String get squeezeDesc => 'Volatility compression before break.';

  @override
  String get bbPctDesc => 'Position of price relative to Bollinger bands.';

  @override
  String indicatorValue(String value) {
    return 'Value: $value';
  }

  @override
  String get entryPrice => 'Entry Price';

  @override
  String get stopLoss => 'Stop Loss';

  @override
  String get takeProfit1 => 'Take Profit 1';

  @override
  String get takeProfit2 => 'Take Profit 2';

  @override
  String get riskRewardShort => 'Risk/Reward (RRR)';

  @override
  String get entry => 'Entry';

  @override
  String get stopLossShort => 'SL';

  @override
  String get takeProfit1Short => 'TP1';

  @override
  String get takeProfit2Short => 'TP2';

  @override
  String get aiConfidence => 'AI Conf.';

  @override
  String get positive => 'Pos';

  @override
  String get negative => 'Neg';

  @override
  String get overbought => 'Overbought';

  @override
  String get oversold => 'Oversold';

  @override
  String get neutral => 'Neutral';

  @override
  String get optimizedLabel => 'OPT';

  @override
  String get explanation => 'Explanation';

  @override
  String get patternBullishDivergence => 'Bullish Divergence';

  @override
  String get patternBearishDivergence => 'Bearish Divergence';

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
      'A Bullish Divergence occurs when the price makes a new low but the RSI forms a HIGHER low. This indicates that selling pressure is waning — although the price is falling, the downward movement is losing momentum. Often a strong warning signal for an imminent upward reversal. Especially reliable in oversold zones (RSI < 30).';

  @override
  String get patternBearishDivergenceDesc =>
      'A Bearish Divergence occurs when the price makes a new high but the RSI forms a LOWER high. This indicates that buying pressure is waning — the rally is losing internal strength even as the price still rises. An early warning signal for a possible downward reversal. Especially reliable in overbought zones (RSI > 70).';

  @override
  String get patternDojiDesc =>
      'A Doji has almost the same opening and closing price and looks like a cross. It signals indecision in the market — neither buyers nor sellers gained control. Often a precursor to a trend reversal, especially after a strong trend.';

  @override
  String get patternLongLeggedDojiDesc =>
      'A Long-Legged Doji has particularly long upper and lower shadows and almost no body. It shows extreme indecision — the price fluctuated wildly in both directions but closed almost unchanged. A strong signal for an imminent directional decision.';

  @override
  String get patternSpinningTopDesc =>
      'A Spinning Top has a small body in the middle and moderate shadows on both sides. It shows a balance between buyers and sellers. In the context of an existing trend, it can signal exhaustion and an impending correction.';

  @override
  String get patternMarubozuBullishDesc =>
      'A Bullish Marubozu is a large green candle with no or almost no shadows. The price opened at the low and closed at the high — absolute buyer dominance throughout the entire period. A very strong buy signal, especially after a decline.';

  @override
  String get patternMarubozuBearishDesc =>
      'A Bearish Marubozu is a large red candle with no or almost no shadows. The price opened at the high and closed at the low — absolute seller dominance. A very strong sell signal, especially after an uptrend.';

  @override
  String get patternHammerDesc =>
      'A Hammer occurs after a downtrend. It has a small body at the top and a long lower shadow (wick). This shows that sellers pushed the price down significantly, but buyers bought it back up. A classic reversal signal for a possible bottom formation.';

  @override
  String get patternInvertedHammerDesc =>
      'The Inverted Hammer has a small body at the bottom and a long upper shadow. It appears after a downtrend and shows that buyers tried to push the price up — even if they didn\'t quite succeed. Confirmation by the next candle is important.';

  @override
  String get patternShootingStarDesc =>
      'The Shooting Star is the counterpart to the Inverted Hammer but after an uptrend. It has a long upper shadow and a small body at the bottom. Buyers pushed the price high, but sellers took control and pushed it back down. A warning signal for an impending correction.';

  @override
  String get patternHangingManDesc =>
      'The Hanging Man looks like a Hammer but appears after an uptrend. The long lower shadow shows that sellers briefly had control — a warning signal that the uptrend might be weakening. Confirmation by a red candle the next day strengthens the signal.';

  @override
  String get patternBullishEngulfingDesc =>
      'A large green candle completely engulfs the previous red candle. This shows massive buying power takeover — buyers have overcome all of the previous day\'s losses and more. One of the most reliable bullish reversal signals.';

  @override
  String get patternBearishEngulfingDesc =>
      'A large red candle completely engulfs the previous green candle. Sellers have wiped out all of the previous day\'s gains and are pushing the price lower. One of the most reliable bearish reversal signals, especially at resistance levels.';

  @override
  String get patternPiercingLineDesc =>
      'The Piercing Line is a 2-candle reversal pattern. After a long red candle, the green candle opens lower (gap down) but closes above the middle of the previous red candle. This shows that buyers are taking control. A bullish signal after a downtrend.';

  @override
  String get patternDarkCloudCoverDesc =>
      'The opposite of the Piercing Line. After a long green candle, the red candle opens higher (gap up) but closes below the middle of the previous green candle. Sellers take control. A bearish reversal signal after an uptrend.';

  @override
  String get patternBullishHaramiDesc =>
      'In a Bullish Harami (Japanese for pregnant), a small green candle is completely enclosed by the body of the previous large red candle. This signals a slowing of downward pressure and a possible trend reversal. Less powerful than an engulfing pattern, but a good warning signal.';

  @override
  String get patternBearishHaramiDesc =>
      'In a Bearish Harami, a small red candle is completely enclosed by the body of the previous large green candle. This signals a slowing of upward pressure. The market is losing momentum — a first warning signal for a possible correction.';

  @override
  String get patternTweezersBottomDesc =>
      'Tweezers Bottom: Two candles with (almost) identical lows. The first is red (downward movement), the second green (recovery). This shows a strong support level — buyers are ready to buy exactly at this price level. A bullish reversal signal.';

  @override
  String get patternTweezersTopDesc =>
      'Tweezers Top: Two candles with (almost) identical highs. The first is green (upward movement), the second red (sell-off). This shows a strong resistance level — sellers appear exactly at this level. A bearish reversal signal.';

  @override
  String get patternKickingBullishDesc =>
      'The Kicking pattern is one of the strongest signals overall. A bearish Marubozu candle is abruptly followed by a bullish Marubozu candle (gap up). The complete change in direction with strong volume shows a massive shift in sentiment — from panic selling to strong buying interest.';

  @override
  String get patternMorningStarDesc =>
      'The Morning Star is a strong 3-candle reversal pattern after a downtrend: 1) Large red candle (strong selling), 2) Small candle (indecision), 3) Large green candle closing above the middle of the first. One of the most reliable bottoming indicators.';

  @override
  String get patternEveningStarDesc =>
      'The Evening Star is the counterpart to the Morning Star but after an uptrend: 1) Large green candle (strong buying), 2) Small candle (indecision at the high), 3) Large red candle closing below the middle of the first. A reliable topping signal.';

  @override
  String get pattern3WhiteSoldiersDesc =>
      'Three consecutive green candles with higher highs and higher closing prices. Each candle opens within or just below the previous body. Shows sustained buying interest and a continuing uptrend — one of the strongest trend continuation or reversal signals.';

  @override
  String get pattern3BlackCrowsDesc =>
      'Three consecutive red candles with lower lows and lower closing prices. The counterpart to the 3 White Soldiers. Shows sustained selling pressure — often a signal for the beginning of a stronger downtrend or the end of an upmove.';

  @override
  String fundamentalAnalysis(String symbol) {
    return 'Fundamental Analysis: $symbol';
  }

  @override
  String get noFmpKeyError => 'No FMP API Key found in settings.';

  @override
  String loadFmpDataError(String symbol) {
    return 'Could not load data for $symbol (limit reached or wrong symbol).';
  }

  @override
  String get companyProfile => 'Company Profile';

  @override
  String get ceo => 'CEO';

  @override
  String get sector => 'Sector';

  @override
  String get industry => 'Industry';

  @override
  String get country => 'Country';

  @override
  String get employees => 'Employees';

  @override
  String get ipoDate => 'IPO Date';

  @override
  String get website => 'Website';

  @override
  String get marketData => 'Market Data';

  @override
  String get marketCap => 'Market Cap.';

  @override
  String get volAvg => 'Volume (Avg)';

  @override
  String get beta => 'Beta (Vola)';

  @override
  String get fiftyTwoWeekRange => '52W Range';

  @override
  String get lastDiv => 'Last Div.';

  @override
  String get isEtf => 'ETF?';

  @override
  String get analystTargets => 'Analyst Targets (Current)';

  @override
  String get targetConsensus => 'Consensus (Mean)';

  @override
  String get targetHigh => 'High';

  @override
  String get targetLow => 'Low';

  @override
  String get nextEarningsDate => 'Next Earnings Date';

  @override
  String get recentInsiderTrades => 'Recent Insider Trades';

  @override
  String get moreInfoOnAktienGuide => 'More info on Aktien.guide';

  @override
  String get dataProvidedByFmp => 'Data provided by Financial Modeling Prep';

  @override
  String get billionShort => 'B.';

  @override
  String get thousandBillionShort => 'T.';

  @override
  String get millionShort => 'M.';

  @override
  String newsTitle(String symbol) {
    return 'News: $symbol';
  }

  @override
  String get noNewsFound => 'No recent news found.';

  @override
  String get monteCarloSimulation => 'Monte Carlo Simulation';

  @override
  String daysCount(int count) {
    return '$count d';
  }

  @override
  String get recalculate => 'Recalculate';

  @override
  String simulationRunning(int count) {
    return 'Simulation running... ($count scenarios)';
  }

  @override
  String simulatedPricePaths(int count, int total) {
    return 'Simulated Price Paths ($count of $total)';
  }

  @override
  String get current => 'Current';

  @override
  String get expected => 'Expected';

  @override
  String get delta => 'Δ';

  @override
  String get low95 => '95% Low';

  @override
  String get high95 => '95% High';

  @override
  String get simulationAnalysis => 'Simulation Analysis';

  @override
  String get outlook => 'Outlook';

  @override
  String get expectedDelta => 'Expected Δ';

  @override
  String get probabilityDistribution => 'Probability Distribution';

  @override
  String get volatilityAnn => 'Volatility (p.a.)';

  @override
  String get riskLevel => 'Risk Level';

  @override
  String get span95 => '95% Span';

  @override
  String get riskReward => 'Risk/Reward';

  @override
  String get targetProbabilities => 'Target Probabilities';

  @override
  String get hitTp => 'Hit TP';

  @override
  String get hitSl => 'Hit SL';

  @override
  String get upside => 'Upside';

  @override
  String get downside => 'Downside';

  @override
  String get strongBullish => 'Strong Bullish';

  @override
  String get lightBullish => 'Light Bullish';

  @override
  String get strongBearish => 'Strong Bearish';

  @override
  String get lightBearish => 'Light Bearish';

  @override
  String get neutralSideways => 'Neutral / Sideways';

  @override
  String get riskLow => 'Low';

  @override
  String get riskModerate => 'Moderate';

  @override
  String get riskHigh => 'High';

  @override
  String get riskVeryHigh => 'Very High';

  @override
  String get hitChance => 'Hit Chance';

  @override
  String mcRecStrongBullish(String bullPct, int days, String rr) {
    return 'Strong bullish setup: $bullPct% of scenarios rise in $days days. Risk/Reward of $rr favors a position.';
  }

  @override
  String get mcRecLightBullish =>
      'Slightly bullish environment with acceptable Risk/Reward. A moderate entry could be considered.';

  @override
  String mcRecBearish(String bullPct) {
    return 'Bearish scenario: Only $bullPct% of simulations show rising prices. Caution is advised, hedging may be recommended.';
  }

  @override
  String mcRecHighVol(String vol) {
    return 'Extrem high volatility ($vol% p.a.) — the price range is very wide. Smaller positions and wider stop-loss levels recommended.';
  }

  @override
  String mcRecBadRR(String rr) {
    return 'Unfavorable Risk/Reward ratio ($rr). Downside risk significantly outweighs upside potential.';
  }

  @override
  String get mcRecNeutral =>
      'Neutral environment: The simulation shows no clear direction. Waiting or range strategies might be appropriate.';

  @override
  String get kronosKiPrognose => 'Kronos AI Forecast';

  @override
  String get miniModel => 'Mini Model';

  @override
  String get smallModel => 'Small Model';

  @override
  String get baseModel => 'Base Model';

  @override
  String get prognoseStarten => 'Start Forecast';

  @override
  String get erweiterteEinstellungen => 'Advanced Settings';

  @override
  String get prognoseTage => 'Forecast (Days)';

  @override
  String get modellKontext => 'Model Context / Lookback (Days)';

  @override
  String get chartHistorieAnzeige => 'Chart History View (Days)';

  @override
  String calculatingPrognose(int percent) {
    return 'Calculating Forecast... $percent%';
  }

  @override
  String get kronosGenerating => 'Kronos model is generating forecast...';

  @override
  String get firstStartWarning =>
      'First start may take longer due to model download.';

  @override
  String get expectedPriceCourse => 'Expected Price Movement';

  @override
  String get today => 'Today';

  @override
  String targetTPlus(int days) {
    return 'Target (T+$days)';
  }

  @override
  String get maxHigh => 'Max High';

  @override
  String get minLow => 'Min Low';

  @override
  String get pressStartForPrognose => 'Press the start button for a forecast';

  @override
  String get viewScanHistory => 'View Scan History';

  @override
  String get readyToScan => 'Ready to scan.';

  @override
  String get initializing => 'Initializing...';

  @override
  String scanningSymbol(int count, int total, String symbol) {
    return '($count/$total) Scanning $symbol...';
  }

  @override
  String scanCompleted(int count) {
    return 'Scan completed. $count signals found.';
  }

  @override
  String get longCandidates => 'Top 5 Long Candidates';

  @override
  String get shortCandidates => 'Top 5 Short Candidates';

  @override
  String get noCandidatesFound => 'No candidates found';

  @override
  String get adjustStrategyHint =>
      'Adjust the strategy or expand the watchlist.';

  @override
  String get tradeDetails => 'Trade Details';

  @override
  String tradePrice(String value) {
    return 'Price: $value';
  }

  @override
  String tradeQuantity(String value) {
    return 'Qty: $value';
  }

  @override
  String tradeDate(String value) {
    return 'Date: $value';
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
  String get chartSettings => 'Chart & Analysis Settings';

  @override
  String get indicatorVisibility => 'Indicator Visibility';

  @override
  String get oscillators => 'Oscillators (below chart)';

  @override
  String get chartRangeDays => 'Chart Range (Days)';

  @override
  String get save => 'Save';

  @override
  String buySuccess(double quantity, String symbol) {
    return 'Buy success: $quantity $symbol';
  }

  @override
  String phaseLabel(int phase, String name) {
    return 'Phase $phase/3: $name';
  }

  @override
  String estimatedTime(String time) {
    return 'Est: $time';
  }

  @override
  String itemsCount(int current, int total) {
    return '$current / $total Items';
  }

  @override
  String get openStatus => 'OPEN';

  @override
  String get closedStatus => 'CLOSED';

  @override
  String get openTp1Hit => 'OPEN (TP1 Hit)';

  @override
  String get pendingStop => 'PENDING (Stop)';

  @override
  String get pendingLimit => 'PENDING (Limit)';

  @override
  String get entryPriceLabel => 'Entry';

  @override
  String get deepDiveAnalysis => 'Deep Dive Analysis';

  @override
  String get tabOverview => 'Overview';

  @override
  String get tabDetails => 'Details';

  @override
  String get tabTopCombos => 'Top Combos';

  @override
  String get noClosedTradesForAnalysis =>
      'No closed trades available for analysis yet.';

  @override
  String get waitingForBotActivity => 'Waiting for first bot activities.';

  @override
  String get noTradesInPeriod => 'No trades found in this period.';

  @override
  String get equityCurveTitle => 'Equity Curve (Capital Progress)';

  @override
  String get streaksAndDuration => 'Streaks & Duration';

  @override
  String get maxWinningStreak => 'Max Winning Streak';

  @override
  String get maxLosingStreak => 'Max Losing Streak';

  @override
  String get avgHoldTime => 'Avg Hold Time';

  @override
  String get winLossProfile => 'Win / Loss Profile';

  @override
  String get winRate => 'Win Rate';

  @override
  String get avgWinner => 'Avg Winner';

  @override
  String get avgLoser => 'Avg Loser';

  @override
  String get topFlopAssets => 'Top / Flop Assets';

  @override
  String get topWinners => 'Top Winners';

  @override
  String get topLosers => 'Top Losers';

  @override
  String get noDataSmall => 'No Data';

  @override
  String get performanceByTimeFrame => 'Performance by TimeFrame';

  @override
  String get performanceByStrategy => 'Performance by Strategy';

  @override
  String get performanceBySl => 'Performance by Stop-Loss';

  @override
  String get performanceByTp => 'Performance by Take-Profit';

  @override
  String get tooLittleDataForCombos => 'Too little data for combinations.';

  @override
  String combinationNumber(int number) {
    return 'Combination #$number';
  }

  @override
  String get expectancyVal => 'Expectancy (EV)';

  @override
  String expectancyUnit(String value) {
    return '$value/Trade';
  }

  @override
  String get filterAllTime => 'All Time';

  @override
  String get filter30Days => '30 Days';

  @override
  String get filter7Days => '7 Days';

  @override
  String get filterYtd => 'YTD';

  @override
  String get shares => 'Shares';

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
  String get indicatorMACD => 'MACD Volume';

  @override
  String get indicatorBB => 'Bollinger Bands';

  @override
  String get indicatorStoch => 'Stochastic';

  @override
  String get indicatorSupertrend => 'Supertrend';

  @override
  String get indicatorSAR => 'Parabolic SAR';

  @override
  String get indicatorIchimoku => 'Ichimoku Analysis';

  @override
  String get indicatorVortexChoppiness => 'Vortex + Choppiness';

  @override
  String get indicatorMACDHist => 'MACD Histogram';

  @override
  String get indicatorADX => 'ADX (Trend Strength)';

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
  String get indicatorDiv => 'RSI Divergence';

  @override
  String get indicatorSqueeze => 'TTM Squeeze';

  @override
  String get indicatorBBPercent => 'BB %B (Bollinger)';

  @override
  String get posMomentum => 'Positive Momentum';

  @override
  String get negMomentum => 'Negative Momentum';

  @override
  String get strongTrend => 'Strong Trend';

  @override
  String get sideways => 'Sideways';

  @override
  String get trending => 'Trending';

  @override
  String get posMoneyFlow => 'Positive Money Flow';

  @override
  String get negMoneyFlow => 'Negative Money Flow';

  @override
  String get bullishDetected => 'Bullish detected';

  @override
  String get bearishDetected => 'Bearish detected';

  @override
  String get strongReversal => 'Strong reversal signal';

  @override
  String get active => 'Active';

  @override
  String get breakoutPending => 'Breakout pending';

  @override
  String get midRange => 'Mid Range';

  @override
  String get aboveCloud => 'Above the cloud';

  @override
  String get belowCloud => 'Below the cloud';

  @override
  String get trendUp => 'Trend Up';

  @override
  String get trendDown => 'Trend Down';

  @override
  String get tenkanAboveKijun => 'Tenkan > Kijun';

  @override
  String get tenkanBelowKijun => 'Tenkan < Kijun';

  @override
  String get volMomentum => 'Volume Momentum';

  @override
  String get details => 'Details';

  @override
  String get scoreDetails => 'Analysis Details';

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
  String get netPnL => 'Net PnL';

  @override
  String get profitFactor => 'Profit Factor';

  @override
  String updateAvailable(String version) {
    return 'Update available: v$version';
  }

  @override
  String get chooseVersionDownload => 'Choose your version to download:';

  @override
  String get toGithubReleasePage => 'To GitHub Release Page';

  @override
  String get later => 'Later';

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
    return 'Could not open $url';
  }

  @override
  String get noChartData => 'No data for chart';

  @override
  String get supertrend => 'Supertrend';

  @override
  String get donchianChannel => 'Donchian Channel';

  @override
  String get statusInitializing => 'Initializing...';

  @override
  String get statusCheckingPending => 'Checking pending orders...';

  @override
  String get statusManagingOpen => 'Managing open positions...';

  @override
  String get statusScanningMarkets => 'Scanning markets for signals...';

  @override
  String get statusDone => 'Done.';

  @override
  String statusError(String error) {
    return 'Error: $error';
  }

  @override
  String get statusCancelRequested => 'Cancellation requested...';

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
  String get entryScore => 'Entry Score';

  @override
  String get patternLabel => 'Pattern';

  @override
  String get tradeData => 'Trade Data';

  @override
  String get statusLabel => 'Status';

  @override
  String get signalDate => 'Signal Date';

  @override
  String get indicatorsAtPurchase => 'Indicators at Purchase';

  @override
  String get noDetailDataSaved => 'No detail data saved';

  @override
  String get deleteTradeConfirmTitle => 'Delete trade?';

  @override
  String get deleteTradeConfirmContent =>
      'Do you really want to delete this trade from history?';

  @override
  String get delete => 'Delete';

  @override
  String get maxDrawdown => 'Max Drawdown';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get errorLabel => 'Error';

  @override
  String get aiProbabilityInsights => 'AI Probabilities & Insights';

  @override
  String get priceAboveEma => 'Price above EMA';

  @override
  String get priceBelowEma => 'Price below EMA';

  @override
  String get topMoversHistory => 'Top Movers History';

  @override
  String get refreshPrices => 'Refresh Prices';

  @override
  String get noScanHistory => 'No scan history available.';

  @override
  String get scanFrom => 'Scan from';

  @override
  String get intervalLabel => 'Interval';

  @override
  String get priceThen => 'Price then';
}
