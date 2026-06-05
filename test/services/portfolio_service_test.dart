import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techana/models/models.dart';
import 'package:techana/models/trade_record.dart';
import 'package:techana/services/portfolio_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('PortfolioService', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('executeTrade adds trade and updates balance', () async {
      final service = PortfolioService();
      
      // Warten bis init load fertig ist (microtask)
      await Future.delayed(Duration.zero);
      
      final trade = TradeRecord(
        id: 'test_1',
        symbol: 'AAPL',
        status: TradeStatus.open,
        entryDate: DateTime.now(),
        entryPrice: 150.0,
        stopLoss: 140.0,
        takeProfit1: 160.0,
        takeProfit2: 170.0,
        quantity: 10,
        entryReasons: "",
      );

      service.executeTrade(trade, 150.0, 10);
      
      expect(service.trades.length, 1);
      expect(service.trades.first.symbol, 'AAPL');
      
      // Balance sollte negativ sein da gekauft
      // initial 0 - (150 * 10)
      // Wobei virtualBalance private ist, wir können aber totalInvested checken
      expect(service.totalInvested, 1500.0);
    });

    test('calcPnL works correctly', () async {
      final service = PortfolioService();
      await Future.delayed(Duration.zero);
      
      final tradeLong = TradeRecord(
        id: 'test_2',
        symbol: 'AAPL',
        status: TradeStatus.open,
        entryDate: DateTime.now(),
        entryPrice: 150.0,
        stopLoss: 140.0,
        takeProfit1: 160.0,
        takeProfit2: 170.0,
        quantity: 10,
        entryReasons: "",
      );

      // Exit at 160 -> Profit = (160 - 150) * 10 = 100
      final pnlLong = service.calcPnL(tradeLong, 160.0);
      expect(pnlLong, 100.0);
      
      // Exit at 140 -> Loss = (140 - 150) * 10 = -100
      final pnlLongLoss = service.calcPnL(tradeLong, 140.0);
      expect(pnlLongLoss, -100.0);
    });
  });
}
