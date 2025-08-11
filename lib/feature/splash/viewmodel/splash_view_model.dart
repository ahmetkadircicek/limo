import 'package:flutter/material.dart';
import 'package:limo/core/services/google_auth_service.dart';

/// Splash ViewModel for handling authentication check and navigation logic
class SplashViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool _isInitialized = false;

  // Getters
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  /// Initialize splash screen and check authentication
  Future<bool> initialize() async {
    try {
      _setLoading(true);

      // Minimum splash duration for better UX (3 seconds)
      final minimumSplashDuration = const Duration(seconds: 3);
      final startTime = DateTime.now();

      // Check if user is already signed in
      final isUserSignedIn = await _checkUserAuthentication();

      // Calculate how much time has passed
      final elapsedTime = DateTime.now().difference(startTime);

      // If minimum time hasn't passed, wait for the remaining time
      if (elapsedTime < minimumSplashDuration) {
        final remainingTime = minimumSplashDuration - elapsedTime;
        await Future.delayed(remainingTime);
      }

      _setInitialized(true);
      _setLoading(false);

      return isUserSignedIn;
    } catch (error) {
      debugPrint('Splash initialization error: $error');

      // Even on error, ensure minimum splash duration
      final startTime = DateTime.now();
      final elapsedTime = DateTime.now().difference(startTime);
      if (elapsedTime < const Duration(seconds: 3)) {
        final remainingTime = const Duration(seconds: 3) - elapsedTime;
        await Future.delayed(remainingTime);
      }

      _setLoading(false);
      return false; // On error, assume not signed in
    }
  }

  /// Check if user is already authenticated
  Future<bool> _checkUserAuthentication() async {
    try {
      // Check and restore user session if available
      final isUserSignedIn = await GoogleAuthService.checkAndRestoreSession();

      if (isUserSignedIn) {
        // If user is signed in, also update the UserProvider
        final userModel = await GoogleAuthService.getUserModel();
        if (userModel != null) {
          // Note: UserProvider will be updated when navigating to home
          debugPrint('User authenticated: ${userModel.displayName}');
        }
      }

      return isUserSignedIn;
    } catch (error) {
      debugPrint('Error checking user authentication: $error');
      return false;
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set initialized state
  void _setInitialized(bool initialized) {
    _isInitialized = initialized;
    notifyListeners();
  }
}
