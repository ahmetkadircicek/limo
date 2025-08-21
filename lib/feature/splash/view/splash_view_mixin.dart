import 'package:flutter/material.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/feature/home/view/home_view.dart';
import 'package:limo/feature/login/view/login_view.dart';
import 'package:limo/feature/splash/view/splash_view.dart';
import 'package:limo/feature/splash/viewmodel/splash_view_model.dart';
import 'package:provider/provider.dart';

mixin SplashViewMixin on State<SplashView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAuthenticationCheck();
    });
  }

  void _startAuthenticationCheck() {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    _getViewModel().initialize(appState).then((isUserSignedIn) {
      if (mounted) {
        _navigate(isUserSignedIn);
      }
    });
  }

  SplashViewModel _getViewModel() {
    return Provider.of<SplashViewModel>(context, listen: false);
  }

  void _navigate(bool isUserSignedIn) {
    if (!mounted) return;

    if (isUserSignedIn) {
      // Navigate to home screen
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeView()));
    } else {
      // Navigate to login screen
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginView()));
    }
  }
}
