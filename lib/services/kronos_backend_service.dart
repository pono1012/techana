import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class KronosBackendService {
  static Process? _pythonProcess;
  static bool _isStarting = false;
  static bool _isRunning = false;
  static String? _lastRemoteUrl;
  
  static bool get isRunning => _isRunning;

  /// Prüft ob die Plattform lokales Python-Backend unterstützt (nur Desktop)
  static bool get isDesktopPlatform {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Prüft ob Kronos verfügbar ist (lokal oder remote)
  static bool isAvailable({String? remoteUrl}) {
    if (remoteUrl != null && remoteUrl.trim().isNotEmpty) return true;
    return isDesktopPlatform;
  }

  /// Gibt die Base-URL zurück (remote oder lokal)
  static String _getBaseUrl({String? remoteUrl}) {
    if (remoteUrl != null && remoteUrl.trim().isNotEmpty) {
      String url = remoteUrl.trim();
      if (url.endsWith('/')) url = url.substring(0, url.length - 1);
      return url;
    }
    return 'http://127.0.0.1:8000';
  }

  /// Startet das Python FastAPI Backend im Hintergrund (nur Desktop)
  static Future<bool> startBackend({String? hfToken, String? remoteUrl}) async {
    // Wenn Remote-URL konfiguriert ist, kein lokales Backend nötig
    if (remoteUrl != null && remoteUrl.trim().isNotEmpty) {
      // Wenn wir schon verbunden sind und die URL gleich ist, nicht nochmal prüfen
      if (_isRunning && _lastRemoteUrl == remoteUrl.trim()) return true;

      // Prüfe ob Remote-Server erreichbar ist
      final baseUrl = _getBaseUrl(remoteUrl: remoteUrl);
      print("Kronos: Versuche Remote-Server zu erreichen: $baseUrl/progress");
      try {
        final ping = await http.get(Uri.parse('$baseUrl/progress')).timeout(const Duration(seconds: 8));
        if (ping.statusCode == 200) {
          print("Kronos Remote-Server erreichbar ✓ ($baseUrl)");
          _isRunning = true;
          _lastRemoteUrl = remoteUrl.trim();
          return true;
        } else {
          print("Kronos Remote-Server Status: ${ping.statusCode}");
        }
      } catch (e) {
        print("Kronos Remote-Server NICHT erreichbar: $e");
        print("Tipp: Prüfe ob der PC und das Handy im gleichen WLAN sind und ob die Windows-Firewall Port 8000 erlaubt.");
      }
      return false;
    }

    // Lokales Backend nur auf Desktop-Plattformen
    if (!isDesktopPlatform) {
      print("Kronos lokales Backend nicht verfügbar auf dieser Plattform. Bitte Remote-URL konfigurieren.");
      return false;
    }

    if (_isRunning) return true;
    if (_isStarting) return false;
    
    _isStarting = true;

    // 1. Prüfen ob Backend vielleicht schon existiert (durch Hot Restart / vorigen Start)
    try {
      final ping = await http.get(Uri.parse('http://127.0.0.1:8000/progress')).timeout(const Duration(seconds: 2));
      if (ping.statusCode == 200) {
        print("Kronos Backend läuft bereits auf Port 8000. Wird wiederverwendet!");
        _isRunning = true;
        _isStarting = false;
        return true;
      }
    } catch (e) {
      // Backend läuft nicht, also weiter und neu starten
    }

    try {
      final apiDir = Directory('kronos_api');
      if (!await apiDir.exists()) {
        print("Kronos API directory not found.");
        _isStarting = false;
        return false;
      }

      print("Starte Kronos Python Backend...");
      _pythonProcess = await Process.start(
        Platform.isWindows ? 'cmd' : 'python',
        Platform.isWindows ? ['/c', 'python', 'main.py'] : ['main.py'],
        workingDirectory: 'kronos_api',
        mode: ProcessStartMode.normal,
        environment: (hfToken != null && hfToken.trim().isNotEmpty) ? {'HF_TOKEN': hfToken.trim()} : null,
      );

      _pythonProcess!.stdout.transform(utf8.decoder).listen((data) {
        print('[Kronos Backend STDOUT] $data');
        if (data.contains("Application startup complete") || data.contains("Uvicorn running on")) {
          _isRunning = true;
        }
      });

      _pythonProcess!.stderr.transform(utf8.decoder).listen((data) {
        print('[Kronos Backend STDERR] $data');
        if (data.contains("Application startup complete") || data.contains("Uvicorn running on")) {
          _isRunning = true;
        }
      });

      int retries = 20;
      while (!_isRunning && retries > 0) {
        await Future.delayed(const Duration(milliseconds: 500));
        retries--;
      }
      
      _isStarting = false;
      return _isRunning;
    } catch (e) {
      print("Fehler beim Starten des Kronos Backends: $e");
      _isStarting = false;
      return false;
    }
  }

  static Future<void> stopBackend() async {
    if (!isDesktopPlatform) return;

    try {
      await http.get(Uri.parse('http://127.0.0.1:8000/shutdown')).timeout(const Duration(seconds: 1));
    } catch (_) {}

    if (_pythonProcess != null) {
      print("Stoppe Kronos Python Backend...");
      _pythonProcess!.kill();
      _pythonProcess = null;
    }
    _isRunning = false;
  }

  /// Sendet Kerzen an das Kronos Modell für eine Prognose
  static Future<List<PriceBar>> getForecast({
    required List<PriceBar> historicalCandles,
    required String modelSize, // "mini", "small", "base"
    int lookback = 400,
    int predLen = 60,
    String? hfToken,
    String? remoteUrl,
  }) async {
    final baseUrl = _getBaseUrl(remoteUrl: remoteUrl);
    final isRemote = remoteUrl != null && remoteUrl.trim().isNotEmpty;

    if (!_isRunning || isRemote) {
      bool started = await startBackend(hfToken: hfToken, remoteUrl: remoteUrl);
      if (!started) {
        if (!isDesktopPlatform && !isRemote) {
          throw Exception("Kronos nicht verfügbar auf dieser Plattform. Bitte eine Remote-URL in den Bot-Einstellungen konfigurieren.");
        }
        throw Exception("Kronos Backend läuft nicht und konnte nicht gestartet werden.");
      }
    }

    final url = Uri.parse('$baseUrl/predict');
    
    final payload = {
      "model_size": modelSize,
      "lookback": lookback,
      "pred_len": predLen,
      "hf_token": hfToken,
      "temperature": 1.0,
      "top_p": 0.9,
      "candles": historicalCandles.map((c) => {
        "timestamp": c.date.toIso8601String(),
        "open": c.open,
        "high": c.high,
        "low": c.low,
        "close": c.close,
        "volume": c.volume,
        "amount": 0.0,
      }).toList(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 120)); 

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List predictions = data['predictions'];
        
        List<PriceBar> forecastCandles = predictions.map((json) => PriceBar(
          date: DateTime.parse(json['timestamp']),
          open: json['open'].toDouble(),
          high: json['high'].toDouble(),
          low: json['low'].toDouble(),
          close: json['close'].toDouble(),
          volume: json['volume'].toInt(),
        )).toList();
        
        return forecastCandles;
      } else {
        throw Exception("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Forecast Fehler: $e");
    }
  }

  /// Progress-Abfrage (lokal oder remote)
  static Future<double> getProgress({String? remoteUrl}) async {
    try {
      final baseUrl = _getBaseUrl(remoteUrl: remoteUrl);
      final resp = await http.get(Uri.parse('$baseUrl/progress')).timeout(const Duration(seconds: 1));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return (data['progress'] as num).toDouble();
      }
    } catch (_) {}
    return 0.0;
  }
}
