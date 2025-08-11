import 'package:flutter/material.dart';
import 'package:limo/core/services/google_auth_service.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/feature/home/view/home_view.dart';
import 'package:limo/feature/login/view/login_view.dart';

/// Splash ViewModel for handling authentication check and navigation logic
class SplashViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool _isInitialized = false;

  // Getters
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  /// Initialize splash screen and check authentication
  Future<void> initialize() async {
    try {
      _setLoading(true);
      
      // Wait for a minimum splash duration for better UX
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Check if user is already signed in
      final isUserSignedIn = await _checkUserAuthentication();
      
      _setInitialized(true);
      _setLoading(false);
      
      // Navigate based on authentication status
      if (isUserSignedIn) {
        // User is already signed in, navigate to home
        await _navigateToHome();
      } else {
        // User is not signed in, navigate to login
        await _navigateToLogin();
      }
    } catch (error) {
      debugPrint('Splash initialization error: $error');
      _setLoading(false);
      // On error, navigate to login
      await _navigateToLogin();
    }
  }

  /// Check if user is already authenticated
  Future<bool> _checkUserAuthentication() async {
    try {
      // Check if Google Sign-In is initialized
      await GoogleAuthService.initialize();
      
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

  /// Navigate to home page
  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Navigation will be handled by the view
  }

  /// Navigate to login page
  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Navigation will be handled by the view
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

  /// Get navigation destination based on authentication status
  Future<Widget> getNavigationDestination() async {
    final isUserSignedIn = await _checkUserAuthentication();
    
    if (isUserSignedIn) {
      return const HomeView();
    } else {
      return const LoginView();
    }
  }
}
