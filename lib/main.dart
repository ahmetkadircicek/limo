import 'package:flutter/material.dart';
import 'package:limo/core/init/navigation/app_routes.dart';
import 'package:limo/core/init/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'core/init/notifier/provider_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: ProviderManager.instance.providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
