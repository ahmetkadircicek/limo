import 'package:flutter/material.dart';
import 'package:limo/core/init/provider_initializer.dart';
import 'package:limo/core/navigation/navigation_service.dart';
import 'package:limo/core/services/environment_service.dart';
import 'package:limo/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvironmentService.initialize();
  _runApp();
}

void _runApp() {
  runApp(
    MultiProvider(
      providers: ProviderInitializer.instance.allProviders,
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
    return MaterialApp.router(
      title: 'Limo',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      routerConfig: NavigationService.router,
    );
  }
}
