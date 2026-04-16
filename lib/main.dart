import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'services/portfolio_service.dart';
import 'services/bot_settings_service.dart';
import 'services/watchlist_service.dart';
import 'services/trade_execution_service.dart';
import 'services/update_service.dart';
import 'services/kronos_backend_service.dart';
import 'ui/dashboard_screen.dart';
import 'dart:ui';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioService()),
        ChangeNotifierProvider(create: (_) => BotSettingsService()),
        ChangeNotifierProvider(create: (_) => WatchlistService()),
        ChangeNotifierProvider(create: (_) => TradeExecutionService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode =
        context.select<AppProvider, ThemeMode>((p) => p.themeMode);

    return MaterialApp(
      title: 'TechAna',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: switch (context.select<AppProvider, String>((p) => p.settings.languageCode)) {
        'de' => const Locale('de'),
        'en' => const Locale('en'),
        _ => null,
      },
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),
      home: const UpdateWrapper(child: DashboardScreen()),
    );
  }
}

class UpdateWrapper extends StatefulWidget {
  final Widget child;
  const UpdateWrapper({super.key, required this.child});

  @override
  State<UpdateWrapper> createState() => _UpdateWrapperState();
}

class _UpdateWrapperState extends State<UpdateWrapper> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Nach dem ersten Frame prüfen, damit der Context bereit ist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateService().checkForUpdate(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      KronosBackendService.stopBackend();
    }
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    await KronosBackendService.stopBackend();
    return AppExitResponse.exit;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
