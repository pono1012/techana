import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class DataService {
  // Cache für Yahoo Session (Cookie & Crumb)
  static String? _yahooCookie;
  static String? _yahooCrumb;

  // Setzt die Session zurück, um einen neuen Versuch zu erzwingen
  void _resetSession() {
    _yahooCookie = null;
    _yahooCrumb = null;
  }

  // Holt sich erst einen Cookie von der Hauptseite und dann den Crumb von der API
  Future<void> _ensureYahooSession() async {
    if (_yahooCrumb != null) return;

    try {
      debugPrint("🍪 [Yahoo] Initialisiere Session...");
      const userAgent =
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36";

      // 1. Cookie holen
      final r1 = await http.get(Uri.parse('https://finance.yahoo.com'),
          headers: {"User-Agent": userAgent});

      final rawCookie = r1.headers['set-cookie'];

      if (rawCookie != null) {
        _yahooCookie = rawCookie;

        // 2. Crumb holen (mit dem Cookie)
        final r2 = await http.get(
            Uri.parse('https://query1.finance.yahoo.com/v1/test/getcrumb'),
            headers: {"Cookie": _yahooCookie!, "User-Agent": userAgent});

        if (r2.statusCode == 200) {
          _yahooCrumb = r2.body.trim();
          debugPrint("✅ [Yahoo] Crumb erhalten: $_yahooCrumb");
        } else {
          debugPrint("⚠️ [Yahoo] Crumb Fehler: ${r2.statusCode}");
        }
      }
    } catch (e) {
      debugPrint("❌ [Yahoo] Session Init Fehler: $e");
    }
  }

  Future<List<PriceBar>> fetchBars(String symbol,
      {TimeFrame interval = TimeFrame.d1}) async {
    // Stooq unterstützt nur Tagesdaten. Bei anderen Intervallen direkt zu Yahoo.
    if (interval == TimeFrame.d1) {
      // 1. Versuch: Stooq (CSV) für Tagesdaten
      try {
        final bars = await _fetchBarsStooq(symbol);
        if (bars.isNotEmpty) return bars;
      } catch (e) {
        debugPrint("⚠️ [Stooq] Fehler (evtl. Limit): $e");
      }
    }

    // 2. Versuch: Yahoo Finance (JSON) als Fallback
    debugPrint("📉 [Yahoo] Lade Chart-Daten für $symbol (${interval.name})...");
    try {
      final bars = await _fetchBarsYahoo(symbol, interval: interval);
      return bars;
    } catch (e) {
      debugPrint("❌ [Yahoo] Chart Fehler: $e");
      throw Exception(
          "Keine Daten für ${interval.name} verfügbar (Stooq/Yahoo Fehler).");
    }
  }

  /// Holt Daten für höhere Zeitebenen zur Trend-Bestätigung (MTC)
  Future<Map<TimeFrame, List<PriceBar>>> fetchMtcData(
      String symbol, TimeFrame base) async {
    final Map<TimeFrame, List<PriceBar>> results = {};

    final List<TimeFrame> highers = [];
    if (base == TimeFrame.m15) {
      highers.addAll([TimeFrame.h1, TimeFrame.h4]);
    } else if (base == TimeFrame.h1) {
      highers.addAll([TimeFrame.h4, TimeFrame.d1]);
    } else if (base == TimeFrame.h4) {
      highers.addAll([TimeFrame.d1, TimeFrame.w1]);
    } else if (base == TimeFrame.d1) {
      highers.add(TimeFrame.w1);
    }

    if (highers.isEmpty) return results;

    debugPrint(
        "🔭 [MTC] Lade ${highers.length} höhere Zeitebenen für $symbol...");
    try {
      final futures = highers.map((tf) => fetchBars(symbol, interval: tf));
      final responses = await Future.wait(futures);

      for (int i = 0; i < highers.length; i++) {
        results[highers[i]] = responses[i];
      }
    } catch (e) {
      debugPrint("⚠️ [MTC] Fehler beim Laden der Konfluenz-Daten: $e");
    }

    return results;
  }

  Future<List<PriceBar>> _fetchBarsStooq(String symbol) async {
    final cleanSym = symbol.trim().toLowerCase();
    final url = Uri.parse('https://stooq.com/q/d/l/?s=$cleanSym&i=d');

    debugPrint("📉 [Stooq] Fetch Start: $cleanSym");

    try {
      final resp = await http.get(url);
      if (resp.statusCode != 200)
        throw Exception("Fehler beim Laden (HTTP ${resp.statusCode})");

      final content = utf8.decode(resp.bodyBytes);

      // Check auf Limit-Nachricht oder HTML
      if (content.contains("limit exceeded") ||
          content.trim().startsWith("<")) {
        throw Exception("Stooq Daily Limit erreicht oder ungültige Antwort.");
      }

      final lines = const LineSplitter().convert(content);
      if (lines.length < 2) {
        debugPrint("⚠️ [Stooq] Zu wenige Zeilen (${lines.length}).");
        return [];
      }

      final bars = <PriceBar>[];
      int parseErrors = 0;
      // Skip Header
      for (var i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final parts = line.split(',');
        if (parts.length < 5) {
          parseErrors++;
          continue;
        }
        try {
          // Stooq Format: Date, Open, High, Low, Close
          final dt = DateTime.parse(parts[0]);
          final o = double.parse(parts[1]);
          final h = double.parse(parts[2]);
          final l = double.parse(parts[3]);
          final c = double.parse(parts[4]);
          final v = parts.length > 5 ? (int.tryParse(parts[5]) ?? 0) : 0;

          bars.add(PriceBar(
              date: dt, open: o, high: h, low: l, close: c, volume: v));
        } catch (e) {
          parseErrors++;
        }
      }

      debugPrint(
          "✅ [Stooq] ${bars.length} Bars geladen für $cleanSym (Errors: $parseErrors)");

      // Sortieren nach Datum aufsteigend
      bars.sort((a, b) => a.date.compareTo(b.date));
      return bars;
    } catch (e) {
      debugPrint("❌ [Stooq] Exception: $e");
      throw e; // Weiterwerfen für Fallback
    }
  }

  Future<List<PriceBar>> _fetchBarsYahoo(String symbol,
      {TimeFrame interval = TimeFrame.d1, bool isRetry = false}) async {
    await _ensureYahooSession();

    // Symbol Konvertierung (ähnlich wie bei Fundamentals)
    String ySymbol = symbol.trim().toUpperCase();
    if (ySymbol.endsWith(".US")) ySymbol = ySymbol.replaceAll(".US", "");

    if (!ySymbol.contains(".") && !ySymbol.contains("-")) {
      if (ySymbol.length > 3 &&
          (ySymbol.endsWith("USD") || ySymbol.endsWith("EUR"))) {
        int splitIdx = ySymbol.length - 3;
        ySymbol =
            "${ySymbol.substring(0, splitIdx)}-${ySymbol.substring(splitIdx)}";
      }
    }

    // Range dynamisch anpassen basierend auf dem Intervall, wie von Yahoo gefordert
    String range;
    if (interval.apiString.contains('m')) {
      range = '60d'; // Minuten-Daten: max 60 Tage
    } else if (interval.apiString == '60m') {
      // '1h'
      range = '730d'; // Stunden-Daten: max 2 Jahre
    } else {
      range = '10y'; // Tages/Wochen-Daten: max 10 Jahre
    }

    final apiInterval = interval.apiString;
    String urlStr =
        'https://query2.finance.yahoo.com/v8/finance/chart/$ySymbol?interval=$apiInterval&range=$range';
    if (_yahooCrumb != null) urlStr += '&crumb=$_yahooCrumb';

    final url = Uri.parse(urlStr);
    final headers = {
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
    };
    if (_yahooCookie != null) headers["Cookie"] = _yahooCookie!;

    final resp = await http.get(url, headers: headers);

    if (resp.statusCode != 200) {
      // Bei 401 (Unauthorized) einmalig Session resetten und neu versuchen
      if (resp.statusCode == 401 && !isRetry) {
        debugPrint("🔄 [Yahoo] 401 bei Chart-Daten. Erneuere Session...");
        _resetSession();
        return _fetchBarsYahoo(symbol, interval: interval, isRetry: true);
      }

      throw Exception("Yahoo API Status: ${resp.statusCode} ($url)");
    }

    final json = jsonDecode(resp.body);
    final result = json['chart']['result'];
    if (result == null || (result as List).isEmpty)
      throw Exception("Yahoo: Leeres Result für $ySymbol");

    final data = result[0];
    final timestamps = List<int>.from(data['timestamp'] ?? []);
    final quote = data['indicators']['quote'][0];
    final closes = List<num?>.from(quote['close'] ?? []);
    final opens = List<num?>.from(quote['open'] ?? []);
    final highs = List<num?>.from(quote['high'] ?? []);
    final lows = List<num?>.from(quote['low'] ?? []);
    final volumes = List<num?>.from(quote['volume'] ?? []);

    final bars = <PriceBar>[];
    for (int i = 0; i < timestamps.length; i++) {
      if (closes[i] == null) continue; // Skip incomplete bars
      final dt = DateTime.fromMillisecondsSinceEpoch(timestamps[i] * 1000);
      bars.add(PriceBar(
        date: dt,
        open: (opens[i] ?? closes[i])!.toDouble(),
        high: (highs[i] ?? closes[i])!.toDouble(),
        low: (lows[i] ?? closes[i])!.toDouble(),
        close: closes[i]!.toDouble(),
        volume: (volumes[i] ?? 0).toInt(),
      ));
    }
    debugPrint("✅ [Yahoo] ${bars.length} Bars geladen für $ySymbol.");
    return bars;
  }

  String _normalizeSymbolForYahoo(String symbol) {
    String ySymbol = symbol.trim().toUpperCase();
    if (ySymbol.endsWith(".US")) {
      ySymbol = ySymbol.replaceAll(".US", "");
    }

    if (!ySymbol.contains(".") && !ySymbol.contains("-")) {
      if (ySymbol.length > 3 &&
          (ySymbol.endsWith("USD") || ySymbol.endsWith("EUR"))) {
        int splitIdx = ySymbol.length - 3;
        ySymbol =
            "${ySymbol.substring(0, splitIdx)}-${ySymbol.substring(splitIdx)}";
      }
    }
    return ySymbol;
  }

  Future<FundamentalData?> fetchFundamentals(String symbol) async {
    // Mapping Stooq -> Yahoo
    // Stooq: AAPL.US -> Yahoo: AAPL
    // Stooq: BMW.DE -> Yahoo: BMW.DE
    // Stooq: BTCUSD -> Yahoo: BTC-USD

    String ySymbol = _normalizeSymbolForYahoo(symbol);

    debugPrint("📊 [Yahoo] Lade Fundamentals: $ySymbol");

    // Session sicherstellen (Cookie/Crumb)
    await _ensureYahooSession();

    // URL bauen (Crumb anhängen falls vorhanden)
    String urlStr =
        'https://query2.finance.yahoo.com/v10/finance/quoteSummary/$ySymbol?modules=summaryDetail,financialData,defaultKeyStatistics,assetProfile';
    if (_yahooCrumb != null) {
      urlStr += '&crumb=$_yahooCrumb';
    }
    final url = Uri.parse(urlStr);

    // WICHTIG: User-Agent setzen, sonst blockiert Yahoo oft die Anfrage
    final headers = {
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
      "Accept": "*/*",
      "Origin": "https://finance.yahoo.com",
      "Referer": "https://finance.yahoo.com/quote/$ySymbol",
    };

    if (_yahooCookie != null) {
      headers["Cookie"] = _yahooCookie!;
    }

    try {
      final resp = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));

      // Fallback: Wenn 401/403 (Unauthorized), versuche die einfachere Quote-API
      if (resp.statusCode == 401 || resp.statusCode == 403) {
        debugPrint("⚠️ [Yahoo] Primary API Auth Error. Versuche Fallback...");
        return await _fetchFundamentalsFallback(ySymbol, headers);
      }

      if (resp.statusCode != 200) {
        debugPrint("❌ [Yahoo] Error Code: ${resp.statusCode} für $ySymbol");
        return null;
      }

      final json = jsonDecode(resp.body);
      final result = json['quoteSummary']['result'];
      if (result == null || (result as List).isEmpty) {
        debugPrint("Yahoo: Keine Daten im Result für $ySymbol");
        return null;
      }

      final data = result[0];
      final summary = data['summaryDetail'] ?? {};
      final stats = data['defaultKeyStatistics'] ?? {};
      final profile = data['assetProfile'] ?? {};
      final financial = data['financialData'] ?? {};

      // Hilfsfunktion robuster machen (manchmal fehlt 'raw')
      double? getRaw(Map m, String k) {
        final val = m[k];
        if (val == null) return null;
        if (val is num) return val.toDouble();
        if (val is Map && val['raw'] is num)
          return (val['raw'] as num).toDouble();
        return null;
      }

      String? getStr(Map m, String k) => m[k] is String ? m[k] : null;

      final fd = FundamentalData(
        sector: getStr(profile, 'sector'),
        industry: getStr(profile, 'industry'),
        peRatio: getRaw(summary, 'trailingPE'),
        forwardPe: getRaw(summary, 'forwardPE'),
        pbRatio: getRaw(stats, 'priceToBook'),
        dividendYield: getRaw(summary, 'dividendYield'),
        marketCap: getRaw(summary, 'marketCap'),
        currency: getStr(financial, 'financialCurrency'),
      );

      debugPrint(
          "✅ [Yahoo] Fundamentals geladen: $ySymbol (KGV: ${fd.peRatio})");
      return fd;
    } catch (e) {
      // Fehler beim Abruf oder Parsen ignorieren wir hier stillschweigend,
      // da es Zusatzdaten sind.
      debugPrint("❌ [Yahoo] Fehler bei Fundamentals: $e");
      return null;
    }
  }

  // Fallback-Methode für einfachere Daten (ohne Sektor/Industrie, aber mit KGV/Marktkap)
  Future<FundamentalData?> _fetchFundamentalsFallback(
      String symbol, Map<String, String> headers) async {
    debugPrint("🔄 [Yahoo] Versuche Fallback-API für $symbol");

    String urlStr =
        'https://query2.finance.yahoo.com/v7/finance/quote?symbols=$symbol';
    if (_yahooCrumb != null) {
      urlStr += '&crumb=$_yahooCrumb';
    }
    final url = Uri.parse(urlStr);

    try {
      final resp = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));

      if (resp.statusCode != 200) {
        debugPrint("❌ [Yahoo] Fallback API Error: ${resp.statusCode}");
        return null;
      }

      final json = jsonDecode(resp.body);
      final result = json['quoteResponse']['result'];
      if (result == null || (result as List).isEmpty) {
        return null;
      }

      final data = result[0];
      debugPrint("✅ [Yahoo] Fallback Daten geladen für $symbol");

      return FundamentalData(
        sector: null, // Nicht verfügbar in dieser API
        industry: null,
        peRatio: data['trailingPE']?.toDouble(),
        forwardPe: data['forwardPE']?.toDouble(),
        pbRatio: data['priceToBook']?.toDouble(),
        dividendYield: data['dividendYield']?.toDouble() != null
            ? (data['dividendYield'] / 100.0)
            : null,
        marketCap: data['marketCap']?.toDouble(),
        currency: data['currency'],
      );
    } catch (e) {
      debugPrint("❌ [Yahoo] Fallback Fehler: $e");
      return null;
    }
  }

  Future<double?> fetchRegularMarketPrice(String symbol,
      {bool isRetry = false}) async {
    final bar = await fetchLiveCandle(symbol, isRetry: isRetry);
    return bar?.close;
  }

  Future<PriceBar?> fetchLiveCandle(String symbol,
      {bool isRetry = false}) async {
    // Symbol mapping logic from fetchFundamentals
    String ySymbol = _normalizeSymbolForYahoo(symbol);

    debugPrint("💲 [Yahoo] Lade Live-Candle: $ySymbol");

    await _ensureYahooSession();

    // Use chart API to get current price and day high/low
    String urlStr =
        'https://query2.finance.yahoo.com/v8/finance/chart/$ySymbol?interval=1d&range=1d';
    if (_yahooCrumb != null) urlStr += '&crumb=$_yahooCrumb';

    final url = Uri.parse(urlStr);
    final headers = {
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
    };
    if (_yahooCookie != null) headers["Cookie"] = _yahooCookie!;

    try {
      final resp = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));

      if (resp.statusCode != 200) {
        // Bei 401 (Unauthorized) einmalig Session resetten und neu versuchen
        if (resp.statusCode == 401 && !isRetry) {
          debugPrint("🔄 [Yahoo] 401 bei Live-Preis. Erneuere Session...");
          _resetSession();
          return fetchLiveCandle(symbol, isRetry: true);
        }

        debugPrint(
            "❌ [Yahoo] Live Preis API Error: ${resp.statusCode} für $ySymbol");
        return null;
      }

      final json = jsonDecode(resp.body);
      final result = json['chart']['result'];
      if (result == null || (result as List).isEmpty) {
        debugPrint("⚠️ [Yahoo] Live Preis: Keine Daten für $ySymbol");
        return null;
      }

      final data = result[0];
      final meta = data['meta'];
      final quote = data['indicators']['quote'][0];

      final double? price = (meta['regularMarketPrice'] as num?)?.toDouble();
      final double? dayHigh =
          (meta['regularMarketDayHigh'] as num?)?.toDouble() ??
              (quote['high'] != null && (quote['high'] as List).isNotEmpty
                  ? (quote['high'][0] as num?)?.toDouble()
                  : null);
      final double? dayLow =
          (meta['regularMarketDayLow'] as num?)?.toDouble() ??
              (quote['low'] != null && (quote['low'] as List).isNotEmpty
                  ? (quote['low'][0] as num?)?.toDouble()
                  : null);
      final double? dayOpen =
          (quote['open'] != null && (quote['open'] as List).isNotEmpty
              ? (quote['open'][0] as num?)?.toDouble()
              : null);
      final int? volume =
          (quote['volume'] != null && (quote['volume'] as List).isNotEmpty
              ? (quote['volume'][0] as num?)?.toInt()
              : 0);

      if (price != null) {
        // Wir bauen eine "Live Bar"
        return PriceBar(
          date: DateTime.now(),
          open: dayOpen ?? price,
          high: dayHigh ?? price, // Fallback auf Price wenn High fehlt
          low: dayLow ?? price, // Fallback auf Price wenn Low fehlt
          close: price,
          volume: volume ?? 0,
        );
      }
      return null;
    } catch (e) {
      debugPrint("❌ [Yahoo] Live Candle Fehler: $e");
      return null;
    }
  }

  // --- Financial Modeling Prep API ---
  Future<FmpData?> fetchFmpData(String symbol, String apiKey) async {
    // FMP nutzt oft "BTCUSD" statt "BTC-USD"
    String fmpSymbol = symbol.toUpperCase();
    if (fmpSymbol.contains("-") &&
        (fmpSymbol.endsWith("USD") || fmpSymbol.endsWith("EUR"))) {
      fmpSymbol = fmpSymbol.replaceAll("-", "");
    }
    if (fmpSymbol.endsWith(".DEF")) {
      fmpSymbol = fmpSymbol.replaceAll(".DEF", ".DE");
    }

    debugPrint("🏢 [FMP] Fetch Start: $fmpSymbol");

    // Default Werte
    String companyName = fmpSymbol;
    String description = "Keine Beschreibung verfügbar (Legacy API Limit).";
    String sector = "N/A";
    String industry = "N/A";
    double price = 0.0;
    double marketCap = 0.0;
    double beta = 0.0;
    bool isEtf = false;

    String? website;
    String? ceo;
    String? exchange;
    String? country;
    String? image;
    String? ipoDate;
    String? fullTimeEmployees;
    String? range;
    double? changes;
    double? changesPercentage;
    double? volAvg;
    double? lastDiv;
    String? currency;

    double? dcf;

    double? peRatio;
    double? pbRatio;
    double? debtToEquity;
    double? currentRatio;
    double? roe;
    double? dividendYield;

    EarningsInfo? nextEarnings;
    AnalystTarget? analystTarget;
    List<InsiderTrade>? insiderTrades;

    try {
      // 1. Versuch: Profile (Stable Endpoint - bevorzugt)
      bool profileLoaded = false;
      // Nutzung von stable/profile wie gewünscht
      final urlProfile = Uri.parse(
          'https://financialmodelingprep.com/stable/profile?symbol=$fmpSymbol&apikey=$apiKey');

      try {
        final respProfile =
            await http.get(urlProfile).timeout(const Duration(seconds: 5));
        if (respProfile.statusCode == 200) {
          final List jsonProfile = jsonDecode(respProfile.body);
          if (jsonProfile.isNotEmpty) {
            final p = jsonProfile[0];
            companyName = p['companyName'] ?? companyName;
            description = p['description'] ?? description;
            sector = p['sector'] ?? sector;
            industry = p['industry'] ?? industry;
            price = (p['price'] as num?)?.toDouble() ?? price;
            marketCap = (p['mktCap'] as num?)?.toDouble() ?? marketCap;
            beta = (p['beta'] as num?)?.toDouble() ?? beta;
            isEtf = p['isEtf'] ?? false;
            dcf = (p['dcf'] as num?)?.toDouble();

            // Neue Felder mappen
            website = p['website'];
            ceo = p['ceo'];
            exchange = p['exchangeShortName'] ?? p['exchange'];
            country = p['country'];
            image = p['image'];
            ipoDate = p['ipoDate'];
            fullTimeEmployees = p['fullTimeEmployees'];
            range = p['range'];
            changes = (p['change'] as num?)?.toDouble();
            changesPercentage = (p['changePercentage'] as num?)?.toDouble();
            volAvg = (p['averageVolume'] as num?)?.toDouble();
            lastDiv = (p['lastDividend'] as num?)?.toDouble();
            currency = p['currency'];

            profileLoaded = true;
            debugPrint("✅ [FMP] Profile geladen.");
          }
        } else {
          debugPrint(
              "⚠️ [FMP] Profile Status: ${respProfile.statusCode} (Nutze Fallback)");
        }
      } catch (e) {
        debugPrint("FMP Profile Fehler: $e");
      }

      // 2. Quote (Immer versuchen für aktuelle Preise & PE, falls Profile/Ratios fehlen)
      // Quote ist oft im Free Plan enthalten und hat PE.
      final urlQuote = Uri.parse(
          'https://financialmodelingprep.com/api/v3/quote/$fmpSymbol?apikey=$apiKey');
      try {
        final respQuote =
            await http.get(urlQuote).timeout(const Duration(seconds: 5));
        if (respQuote.statusCode == 200) {
          final List jsonQuote = jsonDecode(respQuote.body);
          if (jsonQuote.isNotEmpty) {
            final q = jsonQuote[0];
            if (companyName == fmpSymbol)
              companyName = q['name'] ?? companyName;
            price = (q['price'] as num?)?.toDouble() ?? price;
            if (marketCap == 0.0)
              marketCap = (q['marketCap'] as num?)?.toDouble() ?? marketCap;

            // PE aus Quote holen, falls noch null (wichtig bei 402 Error auf Ratios)
            peRatio = (q['pe'] as num?)?.toDouble();
            if (currency == null) currency = q['currency'];

            debugPrint("✅ [FMP] Quote geladen (Preis: $price, PE: $peRatio)");
          }
        }
      } catch (e) {
        debugPrint("❌ [FMP] Quote Fehler: $e");
      }

      // 3. Key Metrics (User URL: /stable/key-metrics)
      // Hier holen wir die detaillierten Kennzahlen
      final urlMetrics = Uri.parse(
          'https://financialmodelingprep.com/stable/key-metrics?symbol=$fmpSymbol&apikey=$apiKey');

      try {
        final respMetrics =
            await http.get(urlMetrics).timeout(const Duration(seconds: 10));
        if (respMetrics.statusCode == 200) {
          final List jsonMetrics = jsonDecode(respMetrics.body);
          if (jsonMetrics.isNotEmpty) {
            final m = jsonMetrics[0];

            currentRatio = (m['currentRatio'] as num?)?.toDouble();
            roe = (m['returnOnEquity'] as num?)?.toDouble();

            // PE aus EarningsYield berechnen (PE = 1 / Yield), falls noch nicht da
            if (peRatio == null) {
              double? ey = (m['earningsYield'] as num?)?.toDouble();
              if (ey != null && ey != 0) {
                peRatio = 1.0 / ey;
              }
            }

            // Debt/Equity ist oft nicht direkt drin, wir schauen mal
            debtToEquity = (m['debtToEquity'] as num?)?.toDouble();
            // Fallback: NetDebtToEBITDA als Indikator nutzen? Lieber nicht mischen.

            dividendYield = (m['dividendYield'] as num?)?.toDouble();

            debugPrint("✅ [FMP] Metrics geladen.");
          }
        } else {
          debugPrint("⚠️ [FMP] Metrics Status: ${respMetrics.statusCode}");
        }
      } catch (e) {
        debugPrint("❌ [FMP] Metrics Fehler: $e");
      }

      // 4. Ratios (User URL: /stable/ratios)
      // Ergänzung für PE, PB, DebtToEquity etc.
      final urlRatios = Uri.parse(
          'https://financialmodelingprep.com/stable/ratios?symbol=$fmpSymbol&apikey=$apiKey');

      try {
        final respRatios =
            await http.get(urlRatios).timeout(const Duration(seconds: 10));
        if (respRatios.statusCode == 200) {
          final List jsonRatios = jsonDecode(respRatios.body);
          if (jsonRatios.isNotEmpty) {
            final r = jsonRatios[0];

            // Wir bevorzugen die expliziten Ratios, falls vorhanden
            if (r['priceToEarningsRatio'] != null)
              peRatio = (r['priceToEarningsRatio'] as num).toDouble();
            if (r['priceToBookRatio'] != null)
              pbRatio = (r['priceToBookRatio'] as num).toDouble();
            if (r['debtToEquityRatio'] != null)
              debtToEquity = (r['debtToEquityRatio'] as num).toDouble();
            if (r['currentRatio'] != null)
              currentRatio = (r['currentRatio'] as num).toDouble();
            if (r['dividendYield'] != null)
              dividendYield = (r['dividendYield'] as num).toDouble();

            debugPrint("✅ [FMP] Ratios geladen.");
          }
        } else {
          debugPrint("⚠️ [FMP] Ratios Status: ${respRatios.statusCode}");
        }
      } catch (e) {
        debugPrint("❌ [FMP] Ratios Fehler: $e");
      }

      // 5. Analyst Target
      final urlAnalyst = Uri.parse(
          'https://financialmodelingprep.com/api/v4/price-target-consensus?symbol=$fmpSymbol&apikey=$apiKey');
      try {
        final resp =
            await http.get(urlAnalyst).timeout(const Duration(seconds: 10));
        if (resp.statusCode == 200) {
          final List json = jsonDecode(resp.body);
          if (json.isNotEmpty) {
            final a = json[0];
            analystTarget = AnalystTarget(
              targetHigh: (a['targetHigh'] as num?)?.toDouble() ?? 0.0,
              targetLow: (a['targetLow'] as num?)?.toDouble() ?? 0.0,
              targetConsensus:
                  (a['targetConsensus'] as num?)?.toDouble() ?? 0.0,
              targetMedian: (a['targetMedian'] as num?)?.toDouble() ?? 0.0,
            );
            debugPrint("✅ [FMP] Analyst Targets geladen.");
          }
        }
      } catch (e) {
        debugPrint("Analyst Target Fehler: $e");
      }

      // 6. Insider Trading
      final urlInsider = Uri.parse(
          'https://financialmodelingprep.com/api/v4/insider-trading?symbol=$fmpSymbol&page=0&apikey=$apiKey');
      try {
        final resp =
            await http.get(urlInsider).timeout(const Duration(seconds: 10));
        if (resp.statusCode == 200) {
          final List json = jsonDecode(resp.body);
          if (json.isNotEmpty) {
            insiderTrades = [];
            for (int i = 0; i < math.min(10, json.length); i++) {
              final it = json[i];
              insiderTrades.add(InsiderTrade(
                transactionDate: DateTime.parse(
                    it['transactionDate'] ?? DateTime.now().toIso8601String()),
                reportingName: it['reportingName'] ?? "Unknown",
                typeOfOwner: it['typeOfOwner'] ?? "Unknown",
                transactionType: it['transactionType'] ?? "Unknown",
                securitiesTransacted:
                    (it['securitiesTransacted'] as num?)?.toDouble() ?? 0.0,
                price: (it['price'] as num?)?.toDouble() ?? 0.0,
              ));
            }
            debugPrint("✅ [FMP] Insider Trades geladen.");
          }
        }
      } catch (e) {
        debugPrint("Insider Trading Fehler: $e");
      }

      // 7. Earnings Calendar
      final urlEarnings = Uri.parse(
          'https://financialmodelingprep.com/api/v3/historical/earning_calendar/$fmpSymbol?limit=10&apikey=$apiKey');
      try {
        final resp =
            await http.get(urlEarnings).timeout(const Duration(seconds: 10));
        if (resp.statusCode == 200) {
          final List json = jsonDecode(resp.body);
          if (json.isNotEmpty) {
            final now = DateTime.now();
            // JSON is usually sorted newest first. Let's find the closest future date.
            for (var e in json) {
              if (e['date'] != null) {
                final dt = DateTime.parse(e['date']);
                if (dt.isAfter(now) || dt.isAtSameMomentAs(now)) {
                  nextEarnings =
                      EarningsInfo(date: dt, time: e['time'] ?? 'N/A');
                }
              }
            }
            if (nextEarnings != null)
              debugPrint(
                  "✅ [FMP] Nächste Earnings geladen: ${nextEarnings.date.toIso8601String()}");
          }
        }
      } catch (e) {
        debugPrint("Earnings Fehler: $e");
      }

      // Mapping
      return FmpData(
        symbol: fmpSymbol,
        companyName: companyName,
        description: description,
        sector: sector,
        industry: industry,
        price: price,
        marketCap: marketCap,
        beta: beta,
        isEtf: isEtf,
        website: website,
        ceo: ceo,
        exchange: exchange,
        country: country,
        image: image,
        ipoDate: ipoDate,
        fullTimeEmployees: fullTimeEmployees,
        range: range,
        changes: changes,
        changesPercentage: changesPercentage,
        volAvg: volAvg,
        lastDiv: lastDiv,
        currency: currency,

        // Metrics
        peRatio: peRatio,
        pbRatio: pbRatio,
        debtToEquity: debtToEquity,
        currentRatio: currentRatio,
        roe: roe,
        dividendYield: dividendYield,
        dcf: dcf,
        nextEarnings: nextEarnings,
        analystTarget: analystTarget,
        insiderTrades: insiderTrades,
      );
    } catch (e) {
      debugPrint("❌ [FMP] Exception: $e");
      return null;
    }
  }

  // --- News API (Yahoo RSS - Kostenlos) ---
  Future<List<NewsItem>> fetchNews(String symbol) async {
    // Symbol bereinigen (Yahoo Ticker Format)
    String ySymbol = symbol.toUpperCase();
    if (ySymbol.endsWith(".US")) ySymbol = ySymbol.replaceAll(".US", "");

    final url = Uri.parse(
        "https://feeds.finance.yahoo.com/rss/2.0/headline?s=$ySymbol&region=US&lang=en-US");
    debugPrint("📰 [Yahoo] Lade News für $ySymbol");

    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final xml = utf8.decode(resp.bodyBytes);
        // Simples Regex Parsing für RSS Items (um XML Package Dependency zu sparen)
        final items = <NewsItem>[];
        final regex = RegExp(
            r'<item>.*?<title>(.*?)</title>.*?<link>(.*?)</link>.*?<pubDate>(.*?)</pubDate>.*?</item>',
            dotAll: true);

        for (final match in regex.allMatches(xml)) {
          final title = match
                  .group(1)
                  ?.replaceAll("<![CDATA[", "")
                  .replaceAll("]]>", "")
                  .trim() ??
              "";
          final link = match.group(2)?.trim() ?? "";
          final pubDate = match.group(3)?.trim() ?? "";
          if (title.isNotEmpty)
            items.add(NewsItem(title: title, link: link, pubDate: pubDate));
        }
        return items;
      }
    } catch (e) {
      debugPrint("❌ [Yahoo] News Fehler: $e");
    }
    return [];
  }
}
