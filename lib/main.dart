import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soforvarcom/core/init/theme/app_theme.dart';
import 'package:soforvarcom/feature/authentication/splash/view/splash_view.dart';

import 'core/init/navigation/navigation_service.dart';
import 'core/init/notifier/provider_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ...ProviderManager.instance.providers,
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soforvar.com',
      theme: LightTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
      navigatorKey: NavigationService.instance.navigatorKey,
    );
  }
}
