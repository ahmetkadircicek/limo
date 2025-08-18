import 'package:flutter/material.dart';
import 'package:limo/core/services/logger_service.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool _isUserAuthenticated = false;

  /// Returns the current loading state
  bool get isLoading => _isLoading;

  /// Returns the current authentication state
  bool get isUserAuthenticated => _isUserAuthenticated;

  /// Initializes the splash view
  Future<bool> initialize() async {
    try {
      _setLoading(true);

      await Future.delayed(const Duration(seconds: 3));

      // Authentication check not implemented yet
      _isUserAuthenticated = false;

      return false; // Always require login for now
    } catch (error) {
      LoggerService.error(
        'Splash initialization error',
        error: error,
        tag: 'SPLASH_VM',
      );
      _isUserAuthenticated = false;
      return false;
    }
  }

  /// Updates the loading state and notifies listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Stops loading state - called after navigation decision
  void stopLoading() {
    _setLoading(false);
  }
}
