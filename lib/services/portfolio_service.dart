import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../models/trade_record.dart';

class PortfolioService extends ChangeNotifier {
  List<TradeRecord> _trades = [];
  List<TradeRecord> get trades => _trades;

  double _virtualBalance = 0.0;
  List<PortfolioSnapshot> _history = [];
  List<PortfolioSnapshot> get history => _history;

  PortfolioService() {
    _loadPortfolio();
  }

  // Helper method for TradeExecutionService
  double calcPnL(TradeRecord t, double exitPrice, {double? qty}) {
    double q = qty ?? t.quantity;
    double entry = t.executionPrice ?? t.entryPrice;
    bool isLong = t.takeProfit1 > t.entryPrice;
    return isLong ? (exitPrice - entry) * q : (entry - exitPrice) * q;
  }

  void returnFunds(double amount) {
    _virtualBalance += amount;
    _savePortfolio();
    notifyListeners();
  }

  void updateTrade(TradeRecord trade) {
    final index = _trades.indexWhere((t) => t.id == trade.id);
    if (index != -1) {
      _trades[index] = trade;
      _savePortfolio();
      notifyListeners();
    }
  }

  void executeTrade(TradeRecord trade, double executionPrice, double qty) {
    _trades.add(trade);
    _virtualBalance -= (executionPrice * qty);
    _savePortfolio();
    notifyListeners();
  }

  TradeRecord handleTp1Hit(
      TradeRecord trade, double price, DateTime date, double tp1SellFraction) {
    if (trade.tp1Hit) return trade;

    final double quantityToSell = trade.quantity * tp1SellFraction;
    final double remainingQuantity = trade.quantity - quantityToSell;

    bool isLong = trade.takeProfit1 > trade.entryPrice;
    double pnlFromPartialClose;
    double newSl = trade.stopLoss;

    if (isLong) {
      pnlFromPartialClose = (price - trade.entryPrice) * quantityToSell;
      if (trade.stopLoss < trade.entryPrice) {
        newSl = trade.entryPrice;
      }
    } else {
      pnlFromPartialClose = (trade.entryPrice - price) * quantityToSell;
      if (trade.stopLoss > trade.entryPrice) {
        newSl = trade.entryPrice;
      }
    }

    final newTrade = trade.copyWith(
      tp1Hit: true,
      quantity: remainingQuantity,
      realizedPnL: trade.realizedPnL + pnlFromPartialClose,
      stopLoss: newSl,
    );

    _virtualBalance +=
        (trade.entryPrice * quantityToSell) + pnlFromPartialClose;

    updateTrade(newTrade);
    return newTrade;
  }

  void deleteTrade(String id) {
    _trades.removeWhere((t) => t.id == id);
    _savePortfolio();
    notifyListeners();
  }

  void resetPortfolio() {
    _trades.clear();
    _virtualBalance = 0.0;
    _savePortfolio();
    notifyListeners();
  }

  double get totalInvested {
    return _trades
        .where((t) => t.status == TradeStatus.open)
        .fold(0.0, (sum, t) => sum + (t.entryPrice * t.quantity));
  }

  double get totalRealizedPnL {
    return _trades.fold(0.0, (sum, t) => sum + t.realizedPnL);
  }

  double get totalUnrealizedPnL {
    return _trades.where((t) => t.status == TradeStatus.open).fold(
          0.0,
          (sum, t) => sum + t.calcUnrealizedPnL(t.lastPrice ?? t.entryPrice),
        );
  }

  int get openTradesCount =>
      _trades.where((t) => t.status == TradeStatus.open).length;

  int get openTradesPositive => _trades
      .where((t) =>
          t.status == TradeStatus.open &&
          t.calcUnrealizedPnL(t.lastPrice ?? t.entryPrice) > 0)
      .length;

  int get openTradesNegative => _trades
      .where((t) =>
          t.status == TradeStatus.open &&
          t.calcUnrealizedPnL(t.lastPrice ?? t.entryPrice) < 0)
      .length;

  int get closedTradesCount => _trades
      .where((t) =>
          t.status == TradeStatus.closed ||
          t.status == TradeStatus.stoppedOut ||
          t.status == TradeStatus.takeProfit)
      .length;

  int get closedTradesPositive => _trades
      .where((t) =>
          (t.status == TradeStatus.closed ||
              t.status == TradeStatus.stoppedOut ||
              t.status == TradeStatus.takeProfit) &&
          t.realizedPnL > 0)
      .length;

  int get closedTradesNegative => _trades
      .where((t) =>
          (t.status == TradeStatus.closed ||
              t.status == TradeStatus.stoppedOut ||
              t.status == TradeStatus.takeProfit) &&
          t.realizedPnL < 0)
      .length;

  void recordSnapshot() {
    final snapshot = PortfolioSnapshot(
      date: DateTime.now(),
      totalInvested: totalInvested,
      realizedPnL: totalRealizedPnL,
      unrealizedPnL: totalUnrealizedPnL,
    );
    _history.add(snapshot);

    if (_history.length > 500) {
      _history.removeAt(0);
    }
  }

  Future<void> _savePortfolio() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonStr = jsonEncode(_trades.map((t) => t.toJson()).toList());
    await prefs.setString('bot_trades', jsonStr);
    await prefs.setDouble('bot_balance', _virtualBalance);

    final String portfolioHistoryJson =
        jsonEncode(_history.map((h) => h.toJson()).toList());
    await prefs.setString('bot_portfolio_history', portfolioHistoryJson);
  }

  Future<void> _loadPortfolio() async {
    final prefs = await SharedPreferences.getInstance();
    _virtualBalance = prefs.getDouble('bot_balance') ?? 0.0;

    final String? jsonStr = prefs.getString('bot_trades');
    if (jsonStr != null) {
      final List decoded = jsonDecode(jsonStr);
      _trades = decoded.map((x) => TradeRecord.fromJson(x)).toList();
    }

    final String? portfolioHistoryJson =
        prefs.getString('bot_portfolio_history');
    if (portfolioHistoryJson != null) {
      final List decoded = jsonDecode(portfolioHistoryJson);
      _history = decoded.map((x) => PortfolioSnapshot.fromJson(x)).toList();
    }

    notifyListeners();
  }
}
