import 'package:flutter/material.dart';
import 'package:limo/core/init/navigation/app_routes.dart';
import 'package:limo/core/init/theme/app_theme.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/core/services/google_auth_service.dart';
import 'package:provider/provider.dart';

import 'core/init/notifier/provider_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Sign-In
  await GoogleAuthService.initialize();

  runApp(
    MultiProvider(
      providers: ProviderManager.instance.providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize app state when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appStateProvider = Provider.of<AppStateProvider>(
        context,
        listen: false,
      );
      appStateProvider.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Limo',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoutes.router,
    );
  }
}
