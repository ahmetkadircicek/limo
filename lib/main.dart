import 'package:flutter/material.dart';
import 'package:limo/core/init/theme/app_theme.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/feature/splash/view/splash_view.dart';
import 'package:provider/provider.dart';

import 'core/init/navigation/navigation_service.dart';
import 'core/init/notifier/provider_manager.dart';
import 'feature/home/view/home_view.dart';
import 'feature/login/view/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Google Auth Service will be initialized in SplashView
  // await GoogleAuthService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ...ProviderManager.instance.providers,
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
      title: 'Limo',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
      navigatorKey: NavigationService.instance.navigatorKey,
      routes: {
        '/login': (context) => const LoginView(),
        '/home': (context) => const HomeView(),
      },
    );
  }
}
