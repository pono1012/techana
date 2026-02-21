import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class WatchlistService extends ChangeNotifier {
  static const Map<String, List<String>> _defaultWatchlistByCategory = {
    // DAX 40 (Auswahl)
    "Germany (DAX & MDAX)": [
      "SAP.DE",
      "SIE.DE",
      "ALV.DE",
      "DTE.DE",
      "BMW.DE",
      "VOW3.DE",
      "AIR.DE",
      "BAS.DE",
      "MUV2.DE",
      "IFX.DE",
      "MBG.DE",
      "DB1.DE",
      "DHL.DE",
      "RWE.DE",
      "BAYN.DE",
      "ADS.DE",
      "BEI.DE",
      "EOAN.DE",
      "HNR1.DE",
      "DBK.DE",
      "VNA.DE",
      "SY1.DE",
      "FRE.DE",
      "HEI.DE",
      "MTX.DE",
      "CBK.DE",
      "PUM.DE",
      "ZAL.DE",
      "QIA.DE",
      "BNR.DE",
      "SHL.DE",
      "DTG.DE",
      "ENR.DE",
      "HEN3.DE",
      "MRK.DE",
      "P911.DE",
      "RHM.DE",
      "SAT.DE",
      "SRT3.DE",
      "1COV.DE",
      "NEM.DE",
      "AI.DE",
      "BOSS.DE",
      "EVT.DE",
      "FRA.DE",
      "LEG.DE",
      "LHAG.DE",
      "SIEGn.DE",
    ],
    // US Tech (Nasdaq 100 Auswahl)
    "US Tech (Nasdaq)": [
      "AAPL.US",
      "MSFT.US",
      "GOOGL.US",
      "AMZN.US",
      "NVDA.US",
      "TSLA.US",
      "META.US",
      "NFLX.US",
      "AMD.US",
      "INTC.US",
      "CSCO.US",
      "CMCSA.US",
      "PEP.US",
      "ADBE.US",
      "AVGO.US",
      "TXN.US",
      "QCOM.US",
      "TMUS.US",
      "COST.US",
      "SBUX.US",
      "AMGN.US",
      "CHTR.US",
      "GILD.US",
      "INTU.US",
      "PYPL.US",
      "FISV.US",
      "BKNG.US",
      "MDLZ.US",
      "ADP.US",
      "ISRG.US",
      "ZM.US",
      "CRWD.US",
      "SNOW.US",
      "MRNA.US",
      "LRCX.US",
      "MU.US",
      "KLAC.US",
      "ASML.US",
      "ADI.US",
      "EXC.US",
      "KDP.US",
      "MAR.US",
      "MELI.US",
      "PANW.US",
      "ROST.US",
      "SIRI.US",
      "VRSK.US",
      "WBA.US",
      "WDAY.US",
      "XEL.US",
      "UBER.US",
      "SQ.US",
      "PLTR.US",
      "SHOP.US",
      "RIVN.US",
    ],
    // US Dow / S&P (Auswahl)
    "US Blue Chips (S&P 500)": [
      "JPM.US",
      "JNJ.US",
      "V.US",
      "PG.US",
      "UNH.US",
      "HD.US",
      "MA.US",
      "DIS.US",
      "BAC.US",
      "XOM.US",
      "KO.US",
      "VZ.US",
      "CVX.US",
      "MRK.US",
      "PFE.US",
      "WMT.US",
      "T.US",
      "BA.US",
      "MCD.US",
      "NKE.US",
      "IBM.US",
      "MMM.US",
      "GE.US",
      "CAT.US",
      "GS.US",
      "AXP.US",
      "RTX.US",
      "HON.US",
      "C.US",
      "WFC.US",
      "LLY.US",
      "BRK-B",
      "DELL.US",
      "ORCL.US",
      "CRM.US",
      "ABT.US",
      "ACN.US",
      "BLK.US",
      "BMY.US",
      "COP.US",
      "DUK.US",
      "F.US",
      "GM.US",
      "LOW.US",
      "NEE.US",
      "PM.US",
      "SRE.US",
      "SO.US",
      "TGT.US",
      "UPS.US",
    ],
    // Europe
    "Europe (ex-DE)": [
      "MC.PA",
      "OR.PA",
      "ASML.AS",
      "PROX.BR",
      "ABI.BR",
      "SAN.MC",
      "ITX.MC",
      "ENEL.MI",
      "ISP.MI",
      "NESN.SW",
      "NOVN.SW",
      "ROG.SW",
      "UBSG.SW",
      "SHEL.L",
      "AZN.L",
      "HSBA.L",
      "ULVR.L",
      "DGE.L",
      "BATS.L",
      "GSK.L",
      "BP.L",
      "RIO.L",
      "REL.L",
      "PRU.L",
      "VOD.L",
      "BARC.L",
      "LLOY.L",
      "TTE.PA",
      "BNP.PA",
      "KER.PA",
      "DG.PA",
      "ACA.PA",
      "RACE.MI",
      "ENI.MI",
      "UCG.MI",
      "IBE.MC",
      "REP.MC",
      "PHIA.AS",
      "INGA.AS",
      "DSV.CO",
      "MAERSK-B.CO",
      "NOVO-B.CO",
      "EQNR.OL",
      "VOLV-B.ST",
      "HM-B.ST",
      "ERIC-B.ST",
      "NDA-SE.ST",
    ],
    // Japan (Nikkei 225 Auswahl)
    "Japan (Nikkei 225)": [
      "7203.T",
      "9984.T",
      "6758.T",
      "9432.T",
      "8058.T",
      "6861.T",
      "4063.T",
      "8306.T",
      "6954.T",
      "7974.T",
      "6501.T",
      "9983.T",
      "8031.T",
      "4502.T",
      "8001.T",
      "6367.T",
      "8766.T",
      "2914.T",
      "7267.T",
      "4901.T",
      "3382.T",
      "6273.T",
      "6702.T",
      "7751.T",
      "8411.T",
      "4568.T",
      "9020.T",
      "9022.T",
      "5108.T",
      "8801.T",
      "8802.T",
      "7201.T",
      "7270.T",
      "6902.T",
      "6981.T",
      "7202.T",
      "8053.T",
      "8316.T",
      "9201.T",
      "9735.T",
    ],
    // Crypto
    "Crypto": [
      "BTC-USD",
      "ETH-USD",
      "SOL-USD",
      "XRP-USD",
      "ADA-USD",
      "AVAX-USD",
      "DOGE-USD",
      "DOT-USD",
      "LINK-USD",
      "MATIC-USD",
      "LTC-USD",
      "BCH-USD",
      "TRX-USD",
      "SHIB-USD",
      "LEO-USD",
      "ATOM-USD",
      "UNI-USD",
      "OKB-USD",
      "ETC-USD",
      "XLM-USD",
      "XMR-USD",
      "NEAR-USD",
      "ALGO-USD",
      "VET-USD",
      "ICP-USD",
      "FIL-USD",
      "HBAR-USD",
      "CRO-USD",
      "EOS-USD",
      "AAVE-USD",
    ],
  };

  Map<String, bool> _watchListMap = {};
  List<TopMoverScanResult> _topMoverHistory = [];

  Map<String, List<String>> get defaultWatchlistByCategory =>
      _defaultWatchlistByCategory;
  Map<String, bool> get watchListMap => _watchListMap;
  List<TopMoverScanResult> get topMoverHistory => _topMoverHistory;

  WatchlistService() {
    _loadData();
  }

  void toggleWatchlistSymbol(String symbol, bool isActive) {
    _watchListMap[symbol] = isActive;
    _saveData();
    notifyListeners();
  }

  void addWatchlistSymbol(String symbol) {
    _watchListMap[symbol.toUpperCase()] = true;
    _saveData();
    notifyListeners();
  }

  void removeWatchlistSymbol(String symbol) {
    _watchListMap.remove(symbol);
    _saveData();
    notifyListeners();
  }

  void addTopMoversToHistory(
    List<dynamic> topLong,
    List<dynamic> topShort,
    TimeFrame tf,
  ) {
    final combined = [...topLong, ...topShort];
    final records = combined.map((mover) {
      return TopMoverRecord(
        symbol: mover.symbol,
        score: mover.signal.score,
        priceAtScan: mover.signal.entryPrice,
        signalType: mover.signal.type.contains("Buy") ? "Buy" : "Sell",
      );
    }).toList();

    final result = TopMoverScanResult(
      scanDate: DateTime.now(),
      timeFrame: tf,
      topMovers: records,
    );
    _topMoverHistory.insert(0, result);
    if (_topMoverHistory.length > 20) {
      _topMoverHistory = _topMoverHistory.sublist(0, 20);
    }
    _saveData();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bot_watchlist_map', jsonEncode(_watchListMap));

    final String historyJson = jsonEncode(
      _topMoverHistory.map((h) => h.toJson()).toList(),
    );
    await prefs.setString('bot_top_mover_history', historyJson);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final String? wlStr = prefs.getString('bot_watchlist_map');
    if (wlStr != null) {
      _watchListMap = Map<String, bool>.from(jsonDecode(wlStr));
    } else {
      _defaultWatchlistByCategory.values.forEach((symbolList) {
        for (var symbol in symbolList) {
          _watchListMap[symbol] = true;
        }
      });
    }

    final String? historyJson = prefs.getString('bot_top_mover_history');
    if (historyJson != null) {
      final List decoded = jsonDecode(historyJson);
      _topMoverHistory =
          decoded.map((x) => TopMoverScanResult.fromJson(x)).toList();
    }
    notifyListeners();
  }
}
