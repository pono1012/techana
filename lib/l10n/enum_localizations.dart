import 'package:flutter/material.dart';
import '../models/models.dart';
import 'l10n_extension.dart';

extension TimeFrameLocalization on TimeFrame {
  String label(BuildContext context) {
    switch (this) {
      case TimeFrame.m15:
        return context.l10n.timeframe15min;
      case TimeFrame.h1:
        return context.l10n.timeframe1h;
      case TimeFrame.h4:
        return context.l10n.timeframe4h;
      case TimeFrame.d1:
        return context.l10n.timeframeDay;
      case TimeFrame.w1:
        return context.l10n.timeframeWeek;
    }
  }
}

extension MarketRegimeLocalization on MarketRegime {
  String label(BuildContext context) {
    switch (this) {
      case MarketRegime.trendingBull:
        return context.l10n.regimeTrendingBull;
      case MarketRegime.trendingBear:
        return context.l10n.regimeTrendingBear;
      case MarketRegime.ranging:
        return context.l10n.regimeRanging;
      case MarketRegime.volatile:
        return context.l10n.regimeVolatile;
      case MarketRegime.unknown:
        return context.l10n.regimeUnknown;
    }
  }
}
