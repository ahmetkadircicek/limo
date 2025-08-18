import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/feature/splash/view/splash_view.dart';
import 'package:limo/feature/splash/viewmodel/splash_view_model.dart';
import 'package:provider/provider.dart';

mixin SplashViewMixin on State<SplashView> {
  bool _isNavigationReady = false;

  @override
  void initState() {
    super.initState();

    // Use addPostFrameCallback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAuthenticationCheck();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startAuthenticationCheck() async {
    final viewModel = _getViewModel();

    try {
      final isUserSignedIn = await viewModel.initialize();

      if (mounted) {
        _isNavigationReady = true;
        _handleNavigation(isUserSignedIn);
        viewModel.stopLoading();
      }
    } catch (error) {
      if (mounted) {
        _isNavigationReady = true;
        _navigateToLogin();
        viewModel.stopLoading();
      }
    }
  }

  SplashViewModel _getViewModel() {
    return Provider.of<SplashViewModel>(context, listen: false);
  }

  void _handleNavigation(bool isUserSignedIn) {
    if (!mounted) {
      return;
    }

    if (isUserSignedIn) {
      _navigateToHome();
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToHome() {
    if (!_isNavigationReady) {
      return;
    }

    context.go('/home');
  }

  void _navigateToLogin() {
    if (!_isNavigationReady) {
      return;
    }

    context.go('/login');
  }
}
