import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../models/trade_record.dart';
import 'data_service.dart';
import 'ta_indicators.dart';
import 'ta_extended.dart';
import 'portfolio_service.dart';
import 'bot_settings_service.dart';
import 'watchlist_service.dart';

class TradeExecutionService extends ChangeNotifier {
  final DataService _dataService = DataService();

  bool _isScanning = false;
  bool get isScanning => _isScanning;
  String _scanStatus = "";
  String get scanStatus => _scanStatus;
  bool _cancelRequested = false;

  int _scanCurrent = 0;
  int _scanTotal = 0;
  int get scanCurrent => _scanCurrent;
  int get scanTotal => _scanTotal;

  int _taskPhase = 0; // 0=None, 1=Pending, 2=Open, 3=Scan
  int get taskPhase => _taskPhase;
  DateTime? _scanStartTime;

  Timer? _autoTimer;
  bool _autoRun = false;
  bool get autoRun => _autoRun;

  final Map<String, DateTime> _lastAnalysisTime = {};

  String get estimatedTimeRemaining {
    if (!_isScanning ||
        _scanStartTime == null ||
        _scanTotal == 0 ||
        _scanCurrent == 0) return "";

    final elapsed = DateTime.now().difference(_scanStartTime!);
    final msPerItem = elapsed.inMilliseconds / _scanCurrent;
    final remainingItems = _scanTotal - _scanCurrent;
    final remainingMs = msPerItem * remainingItems;

    if (remainingMs.isInfinite || remainingMs.isNaN || remainingMs < 0)
      return "";

    final duration = Duration(milliseconds: remainingMs.toInt());
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  void toggleAutoRun(
    bool enable,
    BotSettingsService settings,
    PortfolioService portfolio,
    WatchlistService watchlist,
  ) {
    _autoRun = enable;
    _autoTimer?.cancel();
    if (_autoRun) {
      runDailyRoutine(settings, portfolio, watchlist);
      _autoTimer =
          Timer.periodic(Duration(minutes: settings.autoIntervalMinutes), (
        timer,
      ) {
        runDailyRoutine(settings, portfolio, watchlist);
      });
    }
    notifyListeners();
  }

  void stopAutoRun() {
    _autoRun = false;
    _autoTimer?.cancel();
    notifyListeners();
  }

  Future<void> runDailyRoutine(
    BotSettingsService settings,
    PortfolioService portfolio,
    WatchlistService watchlist,
  ) async {
    if (_isScanning) return;
    _isScanning = true;
    _cancelRequested = false;
    _scanStatus = "Initialisiere...";
    _scanCurrent = 0;
    _scanTotal = 1; // avoid div by zero
    _taskPhase = 0;
    _scanStartTime = DateTime.now();
    notifyListeners();

    try {
      _taskPhase = 1;
      _scanStatus = "Prüfe Pending Orders...";
      notifyListeners();
      if (settings.enableCheckPending) {
        await _checkPendingOrders(settings, portfolio);
      }

      _taskPhase = 2;
      _scanStatus = "Manage offene Positionen...";
      notifyListeners();
      if (settings.enableCheckOpen) {
        await _checkOpenPositions(settings, portfolio);
      }

      _taskPhase = 3;
      _scanStatus = "Scanne Märkte nach Signalen...";
      _scanCurrent = 0;
      notifyListeners();

      if (settings.enableScanNew) {
        await _scanForNewTrades(settings, portfolio, watchlist);
      }

      _scanStatus = "Fertig.";
    } catch (e) {
      _scanStatus = "Fehler: $e";
      debugPrint("❌ [Bot] Critical Error: $e");
    } finally {
      if (_isScanning) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      _isScanning = false;
      _taskPhase = 0;
      portfolio.recordSnapshot();
      notifyListeners();
    }
  }

  void cancelRoutine() {
    if (_isScanning) {
      _cancelRequested = true;
      _scanStatus = "Abbruch angefordert...";
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> _fetchDataForSymbol(
    String symbol, {
    DateTime? lastScanDate,
  }) async {
    try {
      final results = await Future.wait([
        _dataService.fetchBars(symbol),
        _dataService.fetchLiveCandle(symbol),
      ]);
      return {
        'bars': results[0] as List<PriceBar>,
        'liveBar': results[1] as PriceBar?,
        'error': null,
      };
    } catch (e) {
      return {'bars': <PriceBar>[], 'liveBar': null, 'error': e};
    }
  }

  Future<void> _checkPendingOrders(
      BotSettingsService settings, PortfolioService portfolio) async {
    // Holen Kopie der Trades
    final List<TradeRecord> currentTrades = List.from(portfolio.trades);
    final pendingTrades =
        currentTrades.where((t) => t.status == TradeStatus.pending).toList();

    _scanTotal = pendingTrades.isEmpty ? 1 : pendingTrades.length;
    _scanCurrent = 0;
    _scanStatus = "Prüfe Pending Orders...";
    notifyListeners();

    if (pendingTrades.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 200));
      _scanCurrent = 1;
      notifyListeners();
      return;
    }

    const int chunkSize = 5;
    for (var i = 0; i < pendingTrades.length; i += chunkSize) {
      if (_cancelRequested) break;
      final end = (i + chunkSize < pendingTrades.length)
          ? i + chunkSize
          : pendingTrades.length;
      final batch = pendingTrades.sublist(i, end);

      final dataResults = await Future.wait(
        batch.map(
            (t) => _fetchDataForSymbol(t.symbol, lastScanDate: t.lastScanDate)),
      );

      for (var j = 0; j < batch.length; j++) {
        final trade = batch[j];
        final data = dataResults[j];

        _scanCurrent++;
        _scanStatus =
            "Prüfe Pending: ${trade.symbol} ($_scanCurrent/$_scanTotal)";
        notifyListeners();

        try {
          if (data['error'] != null) throw data['error'];

          final bars = data['bars'] as List<PriceBar>;
          final liveBar = data['liveBar'] as PriceBar?;

          final atrSeries = TA.atr(bars);

          final relevantBars = bars.where((b) {
            final bDate = DateTime(b.date.year, b.date.month, b.date.day);
            if (trade.lastScanDate != null) {
              final lsDate = DateTime(trade.lastScanDate!.year,
                  trade.lastScanDate!.month, trade.lastScanDate!.day);
              return bDate.isAfter(lsDate);
            }
            final eDate = DateTime(trade.entryDate.year, trade.entryDate.month,
                trade.entryDate.day);
            return bDate.isAfter(eDate);
          }).toList();

          TradeRecord currentTrade = trade;
          bool tradeUpdated = false;

          for (final bar in relevantBars) {
            if (currentTrade.status == TradeStatus.pending) {
              bool isLong = currentTrade.takeProfit1 > currentTrade.entryPrice;
              bool isBreakout = currentTrade.entryReasons.contains("Breakout");
              double? execPrice;

              if (isBreakout) {
                if (isLong) {
                  if (bar.high >= currentTrade.entryPrice) {
                    execPrice = bar.open > currentTrade.entryPrice
                        ? bar.open
                        : currentTrade.entryPrice;
                  }
                } else {
                  if (bar.low <= currentTrade.entryPrice) {
                    execPrice = bar.open < currentTrade.entryPrice
                        ? bar.open
                        : currentTrade.entryPrice;
                  }
                }
              } else {
                if (isLong) {
                  if (bar.low <= currentTrade.entryPrice) {
                    execPrice = bar.open < currentTrade.entryPrice
                        ? bar.open
                        : currentTrade.entryPrice;
                  }
                } else {
                  if (bar.high >= currentTrade.entryPrice) {
                    execPrice = bar.open > currentTrade.entryPrice
                        ? bar.open
                        : currentTrade.entryPrice;
                  }
                }
              }

              if (execPrice != null) {
                final diff = execPrice - currentTrade.entryPrice;
                double newSl = currentTrade.stopLoss + diff;
                final newTp1 = currentTrade.takeProfit1 + diff;
                final newTp2 = currentTrade.takeProfit2 + diff;

                if (isLong) {
                  if (newSl >= execPrice) newSl = execPrice * 0.99;
                } else {
                  if (newSl <= execPrice) newSl = execPrice * 1.01;
                }

                currentTrade = currentTrade.copyWith(
                  status: TradeStatus.open,
                  entryExecutionDate: bar.date,
                  executionPrice: execPrice,
                  entryPrice: execPrice,
                  stopLoss: newSl,
                  takeProfit1: newTp1,
                  takeProfit2: newTp2,
                  lastScanDate: bar.date,
                );
                tradeUpdated = true;
              }
            }

            if (currentTrade.status == TradeStatus.open) {
              final exitResult =
                  _checkExitConditions(currentTrade, bar, portfolio, settings);
              if (exitResult != null) {
                currentTrade = exitResult;
                tradeUpdated = true;
                if (currentTrade.status == TradeStatus.closed ||
                    currentTrade.status == TradeStatus.stoppedOut ||
                    currentTrade.status == TradeStatus.takeProfit) {
                  break;
                }
              }

              final barIndex = bars.indexOf(bar);
              final currentAtr = (barIndex != -1 && barIndex < atrSeries.length)
                  ? (atrSeries[barIndex] ?? bar.close * 0.02)
                  : bar.close * 0.02;

              double trailingDist = currentAtr * settings.trailingMult;
              bool isLong = currentTrade.takeProfit1 > currentTrade.entryPrice;

              if (isLong) {
                double newSl = bar.close - trailingDist;
                if (newSl > currentTrade.stopLoss) {
                  currentTrade = currentTrade.copyWith(stopLoss: newSl);
                  tradeUpdated = true;
                }
              } else {
                double newSl = bar.close + trailingDist;
                if (newSl < currentTrade.stopLoss) {
                  currentTrade = currentTrade.copyWith(stopLoss: newSl);
                  tradeUpdated = true;
                }
              }

              currentTrade = currentTrade.copyWith(lastScanDate: bar.date);
              tradeUpdated = true;
            }
          }

          if (currentTrade.status == TradeStatus.pending && liveBar != null) {
            bool isLong = currentTrade.takeProfit1 > currentTrade.entryPrice;
            bool isBreakout = currentTrade.entryReasons.contains("Breakout");
            bool shouldExecute = false;

            final price = liveBar.close;

            if (isBreakout) {
              if (isLong) {
                if (price >= currentTrade.entryPrice) shouldExecute = true;
              } else {
                if (price <= currentTrade.entryPrice) shouldExecute = true;
              }
            } else {
              if (isLong) {
                if (liveBar.low <= currentTrade.entryPrice)
                  shouldExecute = true;
              } else {
                if (liveBar.high >= currentTrade.entryPrice)
                  shouldExecute = true;
              }
            }

            if (shouldExecute) {
              double exP = price;
              if (!isBreakout) exP = currentTrade.entryPrice;

              final diff = exP - currentTrade.entryPrice;
              double newSl = currentTrade.stopLoss + diff;
              final newTp1 = currentTrade.takeProfit1 + diff;
              final newTp2 = currentTrade.takeProfit2 + diff;

              if (isLong) {
                if (newSl >= exP) newSl = exP * 0.99;
              } else {
                if (newSl <= exP) newSl = exP * 1.01;
              }

              currentTrade = currentTrade.copyWith(
                status: TradeStatus.open,
                entryExecutionDate: DateTime.now(),
                executionPrice: exP,
                entryPrice: exP,
                stopLoss: newSl,
                takeProfit1: newTp1,
                takeProfit2: newTp2,
                lastScanDate: DateTime.now(),
              );
              tradeUpdated = true;
            }
          }

          if (currentTrade.status == TradeStatus.open && liveBar != null) {
            bool safeToUseHighLow = true;
            if (currentTrade.entryExecutionDate != null) {
              final entryDay = DateTime(
                  currentTrade.entryExecutionDate!.year,
                  currentTrade.entryExecutionDate!.month,
                  currentTrade.entryExecutionDate!.day);
              final today = DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day);
              if (entryDay.isAtSameMomentAs(today)) {
                safeToUseHighLow = false;
              }
            }

            final checkBar = safeToUseHighLow
                ? liveBar
                : PriceBar(
                    date: DateTime.now(),
                    open: liveBar.close,
                    high: liveBar.close,
                    low: liveBar.close,
                    close: liveBar.close,
                    volume: 0);

            final exitResult = _checkExitConditions(
                currentTrade, checkBar, portfolio, settings);
            if (exitResult != null) {
              currentTrade = exitResult;
            } else {
              currentTrade = currentTrade.copyWith(lastPrice: liveBar.close);
            }
            tradeUpdated = true;
          }

          currentTrade = currentTrade.copyWith(lastScanDate: DateTime.now());
          tradeUpdated = true;

          if (tradeUpdated) {
            portfolio.updateTrade(currentTrade);
          }
        } catch (e) {
          debugPrint("❌ [Bot] Fehler bei Pending Order ${trade.symbol}: $e");
        }
      }
    }
  }

  Future<void> _checkOpenPositions(
      BotSettingsService settings, PortfolioService portfolio) async {
    final List<TradeRecord> currentTrades = List.from(portfolio.trades);
    final openTrades =
        currentTrades.where((t) => t.status == TradeStatus.open).toList();

    _scanTotal = openTrades.isEmpty ? 1 : openTrades.length;
    _scanCurrent = 0;
    _scanStatus = "Prüfe offene Positionen...";
    notifyListeners();

    if (openTrades.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 200));
      _scanCurrent = 1;
      notifyListeners();
      return;
    }

    const int chunkSize = 5;
    for (var i = 0; i < openTrades.length; i += chunkSize) {
      if (_cancelRequested) break;
      final end = (i + chunkSize < openTrades.length)
          ? i + chunkSize
          : openTrades.length;
      final batch = openTrades.sublist(i, end);

      final dataResults = await Future.wait(
        batch.map(
            (t) => _fetchDataForSymbol(t.symbol, lastScanDate: t.lastScanDate)),
      );

      for (var j = 0; j < batch.length; j++) {
        final trade = batch[j];
        final data = dataResults[j];

        _scanCurrent++;
        _scanStatus =
            "Manage Position: ${trade.symbol} ($_scanCurrent/$_scanTotal)";
        notifyListeners();

        try {
          if (data['error'] != null) throw data['error'];
          final bars = data['bars'] as List<PriceBar>;
          final liveBar = data['liveBar'] as PriceBar?;
          final livePrice = liveBar?.close;

          final startDate =
              trade.lastScanDate ?? trade.entryExecutionDate ?? trade.entryDate;

          final atrSeries = TA.atr(bars);

          final relevantBars = bars.where((b) {
            final bDate = DateTime(b.date.year, b.date.month, b.date.day);
            if (trade.lastScanDate != null) {
              final lsDate = DateTime(trade.lastScanDate!.year,
                  trade.lastScanDate!.month, trade.lastScanDate!.day);
              return bDate.isAfter(lsDate);
            }
            final eDate =
                DateTime(startDate.year, startDate.month, startDate.day);
            return bDate.isAfter(eDate);
          }).toList();

          TradeRecord currentTrade = trade;
          bool tradeUpdated = false;

          for (final bar in relevantBars) {
            final exitResult =
                _checkExitConditions(currentTrade, bar, portfolio, settings);
            if (exitResult != null) {
              currentTrade = exitResult;
              tradeUpdated = true;
              if (currentTrade.status == TradeStatus.closed ||
                  currentTrade.status == TradeStatus.stoppedOut ||
                  currentTrade.status == TradeStatus.takeProfit) {
                break;
              }
            }

            final barIndex = bars.indexOf(bar);
            final currentAtr = (barIndex != -1 && barIndex < atrSeries.length)
                ? (atrSeries[barIndex] ?? bar.close * 0.02)
                : bar.close * 0.02;

            double trailingDist = currentAtr * settings.trailingMult;
            bool isLong = currentTrade.takeProfit1 > currentTrade.entryPrice;

            if (isLong) {
              double newSl = bar.close - trailingDist;
              if (newSl > currentTrade.stopLoss) {
                currentTrade = currentTrade.copyWith(stopLoss: newSl);
                tradeUpdated = true;
              }
            } else {
              double newSl = bar.close + trailingDist;
              if (newSl < currentTrade.stopLoss) {
                currentTrade = currentTrade.copyWith(stopLoss: newSl);
                tradeUpdated = true;
              }
            }

            currentTrade = currentTrade.copyWith(lastScanDate: bar.date);
            tradeUpdated = true;
          }

          if (currentTrade.status == TradeStatus.open) {
            double? priceToUse =
                livePrice ?? (bars.isNotEmpty ? bars.last.close : null);

            if (liveBar != null) {
              bool safeToUseHighLow = true;
              if (currentTrade.entryExecutionDate != null) {
                final entryDay = DateTime(
                    currentTrade.entryExecutionDate!.year,
                    currentTrade.entryExecutionDate!.month,
                    currentTrade.entryExecutionDate!.day);
                final today = DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day);
                if (entryDay.isAtSameMomentAs(today)) {
                  safeToUseHighLow = false;
                }
              }

              final checkBar = safeToUseHighLow
                  ? liveBar
                  : PriceBar(
                      date: DateTime.now(),
                      open: liveBar.close,
                      high: liveBar.close,
                      low: liveBar.close,
                      close: liveBar.close,
                      volume: 0);

              final exitResult = _checkExitConditions(
                  currentTrade, checkBar, portfolio, settings);
              if (exitResult != null) {
                currentTrade = exitResult;
              }
            }

            if (priceToUse != null) {
              currentTrade = currentTrade.copyWith(lastPrice: priceToUse);
            }
            tradeUpdated = true;
          }

          currentTrade = currentTrade.copyWith(lastScanDate: DateTime.now());
          tradeUpdated = true;

          if (tradeUpdated) {
            portfolio.updateTrade(currentTrade);
          }
        } catch (e) {
          debugPrint("❌ [Bot] Fehler beim Check von ${trade.symbol}: $e");
        }
      }
    }
  }

  TradeRecord? _checkExitConditions(TradeRecord trade, PriceBar bar,
      PortfolioService portfolio, BotSettingsService settings) {
    bool isLong = trade.takeProfit1 > trade.entryPrice;
    bool slHit = false;
    bool tp1Hit = false;
    bool tp2Hit = false;

    if (isLong) {
      if (bar.low <= trade.stopLoss) slHit = true;
      if (bar.high >= trade.takeProfit2) tp2Hit = true;
      if (!trade.tp1Hit && bar.high >= trade.takeProfit1) tp1Hit = true;
    } else {
      if (bar.high >= trade.stopLoss) slHit = true;
      if (bar.low <= trade.takeProfit2) tp2Hit = true;
      if (!trade.tp1Hit && bar.low <= trade.takeProfit1) tp1Hit = true;
    }

    if (slHit && tp2Hit) {
      tp2Hit = false;
      tp1Hit = false;
    }

    if (slHit) {
      final pnl = portfolio.calcPnL(trade, trade.stopLoss);
      portfolio.returnFunds(trade.entryPrice * trade.quantity + pnl);
      return trade.copyWith(
        status: TradeStatus.stoppedOut,
        exitDate: bar.date,
        closeExecutionDate: bar.date,
        exitPrice: trade.stopLoss,
        realizedPnL: trade.realizedPnL + pnl,
      );
    } else if (tp2Hit) {
      final pnl = portfolio.calcPnL(trade, trade.takeProfit2);
      portfolio.returnFunds(trade.entryPrice * trade.quantity + pnl);
      return trade.copyWith(
        status: TradeStatus.takeProfit,
        exitDate: bar.date,
        closeExecutionDate: bar.date,
        exitPrice: trade.takeProfit2,
        realizedPnL: trade.realizedPnL + pnl,
      );
    } else if (tp1Hit) {
      return portfolio.handleTp1Hit(
          trade, trade.takeProfit1, bar.date, settings.tp1SellFraction);
    }
    return null;
  }

  Future<void> _scanForNewTrades(BotSettingsService settings,
      PortfolioService portfolio, WatchlistService watchlist) async {
    // Strategie vor dem Scan auf Wunsch randomisieren
    if (settings.autoRandomizeStrategy) {
      settings.randomizeStrategy();
    }

    final activeSymbols = watchlist.watchListMap.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    _scanTotal = activeSymbols.length;
    _scanCurrent = 0;

    for (var symbol in activeSymbols) {
      if (_cancelRequested) {
        _scanStatus = "Scan abgebrochen.";
        break;
      }
      _scanCurrent++;

      if (_lastAnalysisTime.containsKey(symbol)) {
        final lastScan = _lastAnalysisTime[symbol]!;
        if (DateTime.now().difference(lastScan).inMinutes <
            settings.autoIntervalMinutes) {
          continue;
        }
      }

      try {
        _scanStatus = "Analysiere $symbol ($_scanCurrent/$_scanTotal)...";
        notifyListeners();

        if (!settings.unlimitedPositions) {
          int openCount = portfolio.trades
              .where((t) =>
                  t.status == TradeStatus.open ||
                  t.status == TradeStatus.pending)
              .length;
          if (openCount >= settings.maxOpenPositions) {
            _scanStatus =
                "Max Positionen ($openCount/${settings.maxOpenPositions}) erreicht.";
            notifyListeners();
            break;
          }
        }

        final bars = await _dataService.fetchBars(symbol,
            interval: settings.botTimeFrame);
        _lastAnalysisTime[symbol] = DateTime.now();

        if (bars.length < 50) continue;

        final signal = analyzeStock(bars, settings);

        if (signal != null &&
            (signal.type.contains("Buy") || signal.type.contains("Sell"))) {
          bool alreadyOpen = portfolio.trades
              .any((t) => t.symbol == symbol && t.status == TradeStatus.open);
          if (!alreadyOpen) {
            double executionPrice;
            if (settings.entryStrategy == 0) {
              final livePrice =
                  await _dataService.fetchRegularMarketPrice(symbol);
              executionPrice = livePrice ?? bars.last.close;
            } else {
              executionPrice = signal.entryPrice;
            }
            _executeBuy(
                symbol, bars.last, signal, executionPrice, settings, portfolio);
          }
        }

        await Future.delayed(const Duration(milliseconds: 200));
      } catch (e) {
        continue;
      }
    }
  }

  TradeSignal? analyzeStock(List<PriceBar> bars, BotSettingsService settings) {
    if (bars.isEmpty) return null;
    final closes = bars.map((b) => b.close).toList();

    final ema20 = TA.ema(closes, 20);
    final ema50 = TA.ema(closes, 50);
    final rsi = TA.rsi(closes);
    final macdOut = TA.macd(closes);
    final atr = TA.atr(bars);
    final st = TA.supertrend(bars);
    final stoch = TA.stochastic(bars);
    final obv = TA.obv(bars);
    final donchian = TA.donchian(bars);
    final adxOut = TA.calcAdx(bars);
    final squeeze = TA.squeezeFlags(bars);
    final ichimokuOut = TA.ichimoku(bars);
    final divergenceResult = TA.detectDivergences(closes, rsi);
    final cciVals = TAX.cci(bars);
    final psarOut = TAX.psar(bars);
    final cmfVals = TAX.cmf(bars);
    final mfiVals = TAX.mfi(bars);
    final aoVals = TAX.ao(bars);
    final bbExt = TAX.bbExtended(closes);
    final vortexOut = TAX.vortex(bars);
    final chopVals = TAX.chop(bars);

    final lastPrice = closes.last;
    final lastRsi = rsi.last ?? 50;
    final lastMacdHist = macdOut.hist.last ?? 0;
    final lastEma20 = ema20.last ?? lastPrice;
    final lastEma50 = ema50.last ?? lastPrice;
    final lastAtr = atr.last ?? (lastPrice * 0.02);
    final lastStBull = st.bull.isNotEmpty ? st.bull.last : false;
    final lastStochK = stoch.k.last ?? 50;
    final lastObv = obv.isNotEmpty ? (obv.last ?? 0) : 0.0;
    final lastAdx = adxOut.adx.isNotEmpty ? (adxOut.adx.last ?? 0) : 0.0;
    final isSqueeze = squeeze.isNotEmpty ? squeeze.last : false;
    final lastCci = cciVals.isNotEmpty ? (cciVals.last ?? 0) : 0.0;
    final lastPsarBull = psarOut.bull.isNotEmpty ? psarOut.bull.last : false;
    final lastPsar =
        psarOut.sar.isNotEmpty ? (psarOut.sar.last ?? lastPrice) : lastPrice;
    final lastCmf = cmfVals.isNotEmpty ? (cmfVals.last ?? 0) : 0.0;
    final lastMfi = mfiVals.isNotEmpty ? (mfiVals.last ?? 50) : 50.0;
    final lastAo = aoVals.isNotEmpty ? (aoVals.last ?? 0) : 0.0;
    final lastBbPct = bbExt.pct.isNotEmpty ? (bbExt.pct.last ?? 0.5) : 0.5;
    final lastVipVim = vortexOut.vip.isNotEmpty && vortexOut.vim.isNotEmpty
        ? ((vortexOut.vip.last ?? 1) - (vortexOut.vim.last ?? 1))
        : 0.0;
    final lastChop = chopVals.isNotEmpty ? (chopVals.last ?? 61.8) : 61.8;
    final isTrending = lastChop < 61.8;
    final lastTenkan = ichimokuOut.tenkan.last;
    final lastKijun = ichimokuOut.kijun.last;
    const int spanOffset = 26;
    final relevantSpanA = bars.length > spanOffset
        ? ichimokuOut.spanA[bars.length - 1 - spanOffset]
        : null;
    final relevantSpanB = bars.length > spanOffset
        ? ichimokuOut.spanB[bars.length - 1 - spanOffset]
        : null;

    double lastDonchianLo = lastPrice * 0.95;
    for (final v in donchian.lo.reversed) {
      if (v != null) {
        lastDonchianLo = v;
        break;
      }
    }
    double lastDonchianUp = lastPrice * 1.05;
    for (final v in donchian.up.reversed) {
      if (v != null) {
        lastDonchianUp = v;
        break;
      }
    }

    double prevObv = 0;
    if (obv.length > 5) prevObv = obv[obv.length - 5] ?? 0;

    bool prevMacdHistPositive = macdOut.hist.length > 2
        ? (macdOut.hist[macdOut.hist.length - 2] ?? 0) > 0
        : false;
    bool macdHistRising = lastMacdHist > 0 && !prevMacdHistPositive ||
        (lastMacdHist >
            (macdOut.hist.length > 2
                ? (macdOut.hist[macdOut.hist.length - 2] ?? 0)
                : 0));

    double trendScore = 0;
    double momentumScore = 0;
    double volumeScore = 0;
    double patternScore = 0;
    double volatilityScore = 0;
    final List<String> reasons = [];

    bool strongTrend = lastAdx > 25 && isTrending;

    if (lastStBull) {
      trendScore += 10;
      reasons.add("Supertrend Bullish");
    } else {
      trendScore -= 10;
    }
    if (lastPrice > lastEma20) {
      trendScore += 7;
      reasons.add("Kurs > EMA20");
    } else {
      trendScore -= 7;
    }
    if (lastPrice > lastEma50) {
      trendScore += 4;
      reasons.add("Kurs > EMA50");
    } else {
      trendScore -= 4;
    }
    if (lastPsarBull) {
      trendScore += 5;
      reasons.add("PSAR Bullish");
    } else {
      trendScore -= 5;
    }
    bool isCloudBullish = false;
    if (relevantSpanA != null && relevantSpanB != null) {
      if (lastPrice > relevantSpanA && lastPrice > relevantSpanB) {
        trendScore += 6;
        reasons.add("Kurs über Wolke");
        isCloudBullish = true;
      } else if (lastPrice < relevantSpanA && lastPrice < relevantSpanB) {
        trendScore -= 6;
        reasons.add("Kurs unter Wolke");
      }
    }
    bool isCrossBullish = false;
    if (lastTenkan != null && lastKijun != null) {
      if (lastTenkan > lastKijun) {
        trendScore += 3;
        reasons.add("Tenkan > Kijun");
        isCrossBullish = true;
      } else {
        trendScore -= 3;
      }
    }
    if (lastVipVim > 0.1) {
      trendScore = (trendScore + 3).clamp(-35, 35);
      reasons.add("Vortex Bullish");
    } else if (lastVipVim < -0.1) {
      trendScore = (trendScore - 3).clamp(-35, 35);
    }
    trendScore = trendScore.clamp(-35, 35);

    if (strongTrend) {
      if (lastRsi > 50 && lastRsi < 80) {
        momentumScore += 8;
        reasons.add("RSI Momentum");
      } else if (lastRsi >= 80) {
        momentumScore -= 10;
        reasons.add("RSI Überhitzt");
      } else if (lastRsi < 40) {
        momentumScore -= 5;
      }
    } else {
      if (lastRsi > 70) {
        momentumScore -= 12;
        reasons.add("RSI Überkauft");
      } else if (lastRsi < 30) {
        momentumScore += 12;
        reasons.add("RSI Überverkauft");
      } else if (lastRsi > 55) {
        momentumScore += 4;
      }
    }
    if (lastMacdHist > 0 && macdHistRising) {
      momentumScore += 5;
      reasons.add("MACD Hist Steigend");
    } else if (lastMacdHist < 0) {
      momentumScore -= 5;
    }
    if (lastAdx > 30) {
      momentumScore += 4;
      reasons.add("ADX Stark (${lastAdx.toStringAsFixed(1)})");
    } else if (lastAdx < 20) {
      momentumScore -= 2;
    }
    if (lastCci < -100) {
      momentumScore += 5;
      reasons.add("CCI Überverkauft");
    } else if (lastCci > 100) {
      momentumScore -= 5;
      reasons.add("CCI Überkauft");
    }
    if (lastAo > 0) {
      momentumScore += 2;
    } else {
      momentumScore -= 2;
    }
    if (lastStochK < 20) {
      momentumScore += 4;
      reasons.add("Stoch Überverkauft");
    } else if (lastStochK > 80) {
      momentumScore -= (strongTrend ? 2 : 4);
    }
    momentumScore = momentumScore.clamp(-25, 25);

    if (lastObv > prevObv) {
      volumeScore += 8;
      reasons.add("OBV Steigend");
    } else {
      volumeScore -= 8;
    }
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

    final candlePatterns = TAX.detectAllPatterns(bars);
    String bestPattern =
        candlePatterns.isNotEmpty ? candlePatterns.first.name : 'Kein Muster';
    bool patternBull = false, patternBear = false;
    for (final cp in candlePatterns) {
      if (cp.bullish) {
        patternBull = true;
        bestPattern = cp.name;
        break;
      }
    }
    if (!patternBull) {
      for (final cp in candlePatterns) {
        if (!cp.bullish) {
          patternBear = true;
          bestPattern = cp.name;
          break;
        }
      }
    }
    if (patternBull) {
      patternScore += 8;
      reasons.add(bestPattern);
    } else if (patternBear) {
      patternScore -= 8;
      reasons.add(bestPattern);
    }
    String divergenceType = "none";
    for (int i = 1; i <= 3; i++) {
      final idx = bars.length - i;
      if (divergenceResult.bullishIndices.contains(idx)) {
        patternScore += 7;
        reasons.add("Bullish Divergenz");
        divergenceType = "bullish";
        break;
      }
      if (divergenceResult.bearishIndices.contains(idx)) {
        patternScore -= 7;
        reasons.add("Bearish Divergenz");
        divergenceType = "bearish";
        break;
      }
    }
    patternScore = patternScore.clamp(-15, 15);

    if (isSqueeze) {
      volatilityScore += 3;
      reasons.add("Squeeze Aktiv");
    }
    if (lastBbPct < 0.1) {
      volatilityScore += 2;
      reasons.add("BB Oversold");
    } else if (lastBbPct > 0.9) {
      volatilityScore -= 2;
    }
    volatilityScore = volatilityScore.clamp(-5, 5);

    final double rawScore = 50 +
        (trendScore / 35 * 35) +
        (momentumScore / 25 * 25) +
        (volumeScore / 20 * 20) +
        (patternScore / 15 * 15) +
        (volatilityScore / 5 * 5);
    int score = rawScore.round().clamp(0, 100);

    String type = "Neutral";
    if (score >= 80)
      type = "Strong Buy";
    else if (score >= 60)
      type = "Buy";
    else if (score <= 40) type = "Sell";

    if (type == "Neutral") return null;

    bool isLong = type.contains("Buy");
    final String pattern = bestPattern;

    double entry = lastPrice;
    double paddingVal = 0.0;
    if (settings.entryPaddingType == 0) {
      paddingVal = lastPrice * (settings.entryPadding / 100);
    } else {
      paddingVal = lastAtr * settings.entryPadding;
    }

    if (settings.entryStrategy == 1) {
      if (isLong)
        entry = lastPrice - paddingVal;
      else
        entry = lastPrice + paddingVal;
    } else if (settings.entryStrategy == 2) {
      if (isLong)
        entry = bars.last.high + paddingVal;
      else
        entry = bars.last.low - paddingVal;
    }

    double sl, tp1, tp2;
    final _swingPts = TAX.swingPoints(bars, lookback: 20);

    if (isLong) {
      if (settings.stopMethod == 0)
        sl = lastDonchianLo;
      else if (settings.stopMethod == 1)
        sl = lastPrice * (1 - settings.stopPercent / 100);
      else if (settings.stopMethod == 3)
        sl = _swingPts.swingLow;
      else
        sl = lastPrice - (settings.atrMult * lastAtr);

      if (sl >= entry) sl = entry * 0.99;
    } else {
      if (settings.stopMethod == 0)
        sl = lastDonchianUp;
      else if (settings.stopMethod == 1)
        sl = lastPrice * (1 + settings.stopPercent / 100);
      else if (settings.stopMethod == 3)
        sl = _swingPts.swingHigh;
      else
        sl = lastPrice + (settings.atrMult * lastAtr);

      if (sl <= entry) sl = entry * 1.01;
    }

    double risk = (entry - sl).abs();
    final _pivots = settings.tpMethod == 3 ? TAX.pivotPoints(bars) : null;

    if (isLong) {
      if (settings.tpMethod == 1) {
        tp1 = entry * (1 + settings.tpPercent1 / 100);
        tp2 = entry * (1 + settings.tpPercent2 / 100);
      } else if (settings.tpMethod == 2) {
        final atrRisk = lastAtr * settings.atrMult;
        tp1 = entry + (atrRisk * settings.rrTp1);
        tp2 = entry + (atrRisk * settings.rrTp2);
      } else if (settings.tpMethod == 3 && _pivots != null) {
        tp1 = _pivots.r1 > entry ? _pivots.r1 : _pivots.r2;
        tp2 = _pivots.r2 > entry ? _pivots.r2 : _pivots.r3;
        if (tp1 <= entry) tp1 = entry * (1 + settings.tpPercent1 / 100);
        if (tp2 <= tp1) tp2 = entry * (1 + settings.tpPercent2 / 100);
      } else {
        tp1 = entry + (risk * settings.rrTp1);
        tp2 = entry + (risk * settings.rrTp2);
      }
    } else {
      if (settings.tpMethod == 1) {
        tp1 = entry * (1 - settings.tpPercent1 / 100);
        tp2 = entry * (1 - settings.tpPercent2 / 100);
      } else if (settings.tpMethod == 2) {
        final atrRisk = lastAtr * settings.atrMult;
        tp1 = entry - (atrRisk * settings.rrTp1);
        tp2 = entry - (atrRisk * settings.rrTp2);
      } else if (settings.tpMethod == 3 && _pivots != null) {
        tp1 = _pivots.s1 < entry ? _pivots.s1 : _pivots.s2;
        tp2 = _pivots.s2 < entry ? _pivots.s2 : _pivots.s3;
        if (tp1 >= entry) tp1 = entry * (1 - settings.tpPercent1 / 100);
        if (tp2 >= tp1) tp2 = entry * (1 - settings.tpPercent2 / 100);
      } else {
        tp1 = entry - (risk * settings.rrTp1);
        tp2 = entry - (risk * settings.rrTp2);
      }
    }

    double rrFactor = risk == 0 ? 0 : (tp2 - entry).abs() / risk;

    double? tp1Percent, tp2Percent;
    if (isLong) {
      tp1Percent = ((tp1 - entry) / entry) * 100;
      tp2Percent = ((tp2 - entry) / entry) * 100;
    } else {
      tp1Percent = ((entry - tp1) / entry) * 100;
      tp2Percent = ((entry - tp2) / entry) * 100;
    }

    final snapshot = {
      'rsi': lastRsi,
      'ema20': lastEma20,
      'ema50': lastEma50,
      'price': lastPrice,
      'macdHist': lastMacdHist,
      'stBull': lastStBull,
      'stochK': lastStochK,
      'obv': lastObv,
      'adx': lastAdx,
      'squeeze': isSqueeze,
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
    };

    return TradeSignal(
      type: type,
      entryPrice: entry,
      stopLoss: sl,
      takeProfit1: tp1,
      takeProfit2: tp2,
      riskRewardRatio: rrFactor,
      score: score,
      reasons: reasons,
      chartPattern: pattern,
      tp1Percent: tp1Percent,
      tp2Percent: tp2Percent,
      indicatorValues: snapshot,
    );
  }

  void _executeBuy(
    String symbol,
    PriceBar lastBar,
    TradeSignal signal,
    double executionPrice,
    BotSettingsService settings,
    PortfolioService portfolio,
  ) {
    double baseInvest = settings.botBaseInvest;
    double multiplier = 1.0;

    if (settings.dynamicSizing) {
      if (signal.score >= 80 || signal.score <= 20)
        multiplier = 2.0;
      else if (signal.score >= 70 || signal.score <= 30) multiplier = 1.5;
    }
    double positionSize = baseInvest * multiplier;
    double qty = positionSize / executionPrice;

    final priceDifference = executionPrice - signal.entryPrice;
    double adjustedStopLoss = signal.stopLoss + priceDifference;
    final adjustedTakeProfit1 = signal.takeProfit1 + priceDifference;
    final adjustedTakeProfit2 = signal.takeProfit2 + priceDifference;

    bool isLong = signal.type.contains("Buy");
    if (isLong) {
      if (adjustedStopLoss >= executionPrice) {
        adjustedStopLoss = executionPrice * 0.99;
      }
    } else {
      if (adjustedStopLoss <= executionPrice) {
        adjustedStopLoss = executionPrice * 1.01;
      }
    }

    TradeStatus initialStatus = TradeStatus.open;
    if (settings.entryStrategy == 1) initialStatus = TradeStatus.pending;
    if (settings.entryStrategy == 2) initialStatus = TradeStatus.pending;

    if (settings.entryStrategy != 0) {
      signal.reasons.add(
          "Strategy: ${settings.entryStrategy == 1 ? 'Pullback' : 'Breakout'}");
    }

    final settingsSnapshot = {
      'entryStrategy': settings.entryStrategy,
      'entryPadding': settings.entryPadding,
      'entryPaddingType': settings.entryPaddingType,
      'stopMethod': settings.stopMethod,
      'stopPercent': settings.stopPercent,
      'atrMult': settings.atrMult,
      'tpMethod': settings.tpMethod,
      'rrTp1': settings.rrTp1,
      'rrTp2': settings.rrTp2,
      'tpPercent1': settings.tpPercent1,
      'tpPercent2': settings.tpPercent2,
      'tp1SellFraction': settings.tp1SellFraction,
    };

    final fullSnapshot =
        Map<String, dynamic>.from(signal.indicatorValues ?? {});
    fullSnapshot.addAll(settingsSnapshot);

    final newTrade = TradeRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      symbol: symbol,
      entryDate: lastBar.date,
      entryPrice: executionPrice,
      quantity: qty,
      stopLoss: adjustedStopLoss,
      takeProfit1: adjustedTakeProfit1,
      takeProfit2: adjustedTakeProfit2,
      status: initialStatus,
      entryScore: signal.score,
      entryReasons: signal.reasons.join(", "),
      entryPattern: signal.chartPattern,
      aiAnalysisSnapshot: fullSnapshot,
      botTimeFrame: settings.botTimeFrame,
      executionPrice: executionPrice,
      entryExecutionDate:
          initialStatus == TradeStatus.open ? DateTime.now() : null,
      lastScanDate: DateTime.now(),
    );

    portfolio.executeTrade(newTrade, executionPrice, qty);
  }
}
