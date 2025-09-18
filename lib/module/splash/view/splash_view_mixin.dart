import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/navigation/route_paths.dart';
import 'package:limo/module/splash/view_model/splash_view_model.dart';

mixin SplashMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    initializeSplash();
  }

  void initializeSplash() async {
    bool success = await SplashViewModel.initialize(context);

    if (!mounted) return;

    if (success) {
      _navigateToHome();
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToHome() {
    context.go(RoutePaths.home);
  }

  void _navigateToLogin() {
    context.go(RoutePaths.login);
  }
}
