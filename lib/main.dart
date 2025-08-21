import 'package:flutter/material.dart';
import 'package:limo/core/init/navigation/navigation_service.dart';
import 'package:limo/core/init/theme/app_theme.dart';
import 'package:limo/core/services/encryption_service.dart';
import 'package:limo/core/services/environment_service.dart';
import 'package:limo/feature/login/services/google_auth_service.dart';
import 'package:limo/feature/splash/view/splash_view.dart';
import 'package:provider/provider.dart';

import 'core/init/notifier/provider_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeServices();
  _runApp();
}

/// Initialize all required services
Future<void> _initializeServices() async {
  await EnvironmentService.initialize();

  if (!EnvironmentService.validateRequired()) {
    throw Exception('Missing required environment variables');
  }

  await EncryptionService.initialize();
  await GoogleAuthService.initialize();
}

/// Run the application
void _runApp() {
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Limo',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.instance.navigatorKey,
      home: const SplashView(),
    );
  }
}
