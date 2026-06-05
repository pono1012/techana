import 'package:flutter_test/flutter_test.dart';
import 'package:techana/models/models.dart';
import 'package:techana/services/ta_indicators.dart';

void main() {
  group('TA Indicators', () {
    test('SMA calculates correctly', () {
      final data = [10.0, 20.0, 30.0, 40.0, 50.0];
      final sma = TA.sma(data, 3);
      
      expect(sma.length, 5);
      expect(sma[0], isNull);
      expect(sma[1], isNull);
      expect(sma[2], 20.0); // (10+20+30)/3
      expect(sma[3], 30.0); // (20+30+40)/3
      expect(sma[4], 40.0); // (30+40+50)/3
    });

    test('EMA calculates correctly', () {
      final data = [10.0, 20.0, 30.0];
      final ema = TA.ema(data, 2);
      
      expect(ema.length, 3);
      expect(ema[0], 10.0);
      
      // k = 2 / (2+1) = 2/3
      // prev = 10
      // v = 20
      // new = 20 * (2/3) + 10 * (1/3) = 40/3 + 10/3 = 50/3 = 16.666
      expect(ema[1], closeTo(16.666, 0.01));
    });

    test('RSI calculates correctly', () {
      final data = [
        44.34, 44.09, 44.15, 43.61, 44.33, 44.83, 45.10, 45.42, 45.84, 46.08, 45.89, 46.03, 45.61, 46.28, 46.28
      ];
      final rsi = TA.rsi(data, n: 14);
      expect(rsi.length, 15);
      expect(rsi[14], closeTo(70.53, 0.1));
    });

    test('Detect pattern - Hammer', () {
      final bars = [
        PriceBar(date: DateTime(2023, 1, 1), open: 10, high: 11, low: 9, close: 10.5, volume: 100),
        PriceBar(date: DateTime(2023, 1, 2), open: 10, high: 11, low: 9, close: 10.5, volume: 100),
        PriceBar(date: DateTime(2023, 1, 3), open: 10, high: 10.8, low: 8, close: 10.5, volume: 100), // Hammer
      ];
      final pattern = TA.detectPattern(bars);
      expect(pattern, 'Hammer');
    });
  });
}
