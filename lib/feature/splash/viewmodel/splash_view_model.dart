import 'package:flutter/material.dart';
import 'package:limo/core/services/google_auth_service.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool _isInitialized = false;

  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  Future<bool> initialize() async {
    try {
      _setLoading(true);

      final minimumSplashDuration = const Duration(seconds: 3);
      final startTime = DateTime.now();
      final isUserSignedIn = await _checkUserAuthentication();
      final elapsedTime = DateTime.now().difference(startTime);
      if (elapsedTime < minimumSplashDuration) {
        final remainingTime = minimumSplashDuration - elapsedTime;
        await Future.delayed(remainingTime);
      }

      _setInitialized(true);
      _setLoading(false);

      return isUserSignedIn;
    } catch (error) {
      debugPrint('Splash initialization error: $error');

      final startTime = DateTime.now();
      final elapsedTime = DateTime.now().difference(startTime);
      if (elapsedTime < const Duration(seconds: 3)) {
        final remainingTime = const Duration(seconds: 3) - elapsedTime;
        await Future.delayed(remainingTime);
      }

      _setLoading(false);
      return false;
    }
  }

  Future<bool> _checkUserAuthentication() async {
    try {
      final isUserSignedIn = await GoogleAuthService.checkAndRestoreSession();

      if (isUserSignedIn) {
        final userModel = await GoogleAuthService.getUserModel();
        if (userModel != null) {
          debugPrint('User authenticated: ${userModel.displayName}');
        }
      }

      return isUserSignedIn;
    } catch (error) {
      debugPrint('Error checking user authentication: $error');
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setInitialized(bool initialized) {
    _isInitialized = initialized;
    notifyListeners();
  }
}
