import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/init/navigation/navigation_service.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/google_auth_service.dart';
import 'package:limo/shared/app_components.dart';
import 'package:limo/shared/app_text.dart';
import 'package:provider/provider.dart';

/// OAuth-focused Login ViewModel
class LoginViewModel extends ChangeNotifier {
  // Loading states for each auth method
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;
  bool _isGuestLoading = false;

  // Getters
  bool get isGoogleLoading => _isGoogleLoading;
  bool get isAppleLoading => _isAppleLoading;
  bool get isGuestLoading => _isGuestLoading;
  bool get isAnyLoading =>
      _isGoogleLoading || _isAppleLoading || _isGuestLoading;

  /// Sign in with Google OAuth
  Future<void> signInWithGoogle() async {
    if (isAnyLoading) return;

    _setGoogleLoading(true);

    try {
      final user = await GoogleAuthService.signIn();
      if (user != null) {
        // Create user model and set it in provider
        final userModel = await GoogleAuthService.getUserModel();
        if (userModel != null) {
          // Set user in provider (this will be accessed from main.dart)
          final context = NavigationService.instance.navigatorKey.currentContext;
          if (context != null) {
            Provider.of<UserProvider>(context, listen: false)
                .setUser(userModel);
          }
        }

        // Successful Google Sign-In
        await _handleSuccessfulLogin(
          user.displayName ?? 'Google User',
        );
      } else {
        // User cancelled or error
        _handleLoginError('Google giriş iptal edildi');
      }
    } catch (error) {
      _handleLoginError('Google giriş hatası: $error');
    } finally {
      _setGoogleLoading(false);
    }
  }

  /// Sign in with Apple OAuth
  Future<void> signInWithApple() async {
    if (isAnyLoading) return;

    _setAppleLoading(true);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual Apple Sign-In
      // final SignInWithAppleResult result = await SignInWithApple.getAppleIDCredential();
      // if (result.success) {
      //   await _handleSuccessfulLogin(result.user);
      // }

      // For now, simulate successful login
      await _handleSuccessfulLogin('Apple User');
    } catch (error) {
      _handleLoginError('Apple giriş hatası: $error');
    } finally {
      _setAppleLoading(false);
    }
  }

  /// Continue as guest (limited access)
  Future<void> continueAsGuest() async {
    if (isAnyLoading) return;

    _setGuestLoading(true);

    try {
      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 1));

      // Navigate to home with guest mode
      await _navigateToHome(isGuest: true);
    } catch (error) {
      _handleLoginError('Misafir girişi hatası: $error');
    } finally {
      _setGuestLoading(false);
    }
  }

  /// Handle successful login for any method
  Future<void> _handleSuccessfulLogin(String userInfo) async {
    final context = NavigationService.instance.navigatorKey.currentContext;
    if (context == null) return;

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const AppText.body('Başarıyla giriş yapıldı! Hoş geldiniz.'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        dismissDirection: DismissDirection.up,
      ),
    );

    // Navigate to home
    await _navigateToHome();
  }

  /// Handle login errors
  void _handleLoginError(String errorMessage) {
    final context = NavigationService.instance.navigatorKey.currentContext;
    if (context == null) return;

    // Show error dialog
    AppDialogExtension(context).showErrorDialog(
      errorMessage,
    );
  }

  /// Navigate to home screen
  Future<void> _navigateToHome({bool isGuest = false}) async {
    final context = NavigationService.instance.navigatorKey.currentContext;
    if (context == null) return;

    // Add small delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));

    // Navigate to home using go_router
    debugPrint("Navigation to Home from Login");
    context.go('/home');
  }

  /// Loading state setters
  void _setGoogleLoading(bool loading) {
    _isGoogleLoading = loading;
    notifyListeners();
  }

  void _setAppleLoading(bool loading) {
    _isAppleLoading = loading;
    notifyListeners();
  }

  void _setGuestLoading(bool loading) {
    _isGuestLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up any resources
    super.dispose();
  }
}
