import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/core/services/google_auth_service.dart';
import 'package:limo/shared/app_components.dart';
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
  Future<void> signInWithGoogle(BuildContext context) async {
    if (isAnyLoading) return;

    _setGoogleLoading(true);
    debugPrint('🔐 [AUTH] Starting Google Sign-In process...');

    try {
      debugPrint('🔐 [AUTH] Calling GoogleAuthService.signIn()...');
      final user = await GoogleAuthService.signIn();

      if (user != null) {
        debugPrint('✅ [AUTH] Google Sign-In successful for: ${user.email}');
        debugPrint('🔐 [AUTH] Google ID received: ${user.id}');

        // Get Google ID for authentication
        final googleId = user.id;
        if (googleId.isNotEmpty) {
          debugPrint(
            '🔐 [AUTH] Google ID is valid, proceeding to backend authentication...',
          );

          // Authenticate with backend using Google ID
          final success = await Provider.of<AppStateProvider>(
            context,
            listen: false,
          ).authenticateWithGoogle(googleId);

          if (success) {
            debugPrint('✅ [AUTH] Backend authentication successful!');
            // Successful authentication
            await _handleSuccessfulLogin(
              context,
              user.displayName ?? 'Google User',
            );
          } else {
            debugPrint('❌ [AUTH] Backend authentication failed');
            // Authentication failed
            _handleLoginError(context, 'Backend authentication failed');
          }
        } else {
          debugPrint('❌ [AUTH] Invalid Google ID received');
          _handleLoginError(context, 'Invalid Google ID');
        }
      } else {
        debugPrint('❌ [AUTH] Google Sign-In cancelled or failed');
        // User cancelled or error
        _handleLoginError(context, 'Google sign-in cancelled');
      }
    } catch (error) {
      debugPrint('❌ [AUTH] Google Sign-In error: $error');
      _handleLoginError(context, 'Google sign-in error: $error');
    } finally {
      _setGoogleLoading(false);
      debugPrint('🔐 [AUTH] Google Sign-In process completed');
    }
  }

  /// Sign in with Apple OAuth
  Future<void> signInWithApple(BuildContext context) async {
    if (isAnyLoading) return;

    _setAppleLoading(true);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual Apple Sign-In
      // final SignInWithAppleResult result = await SignInWithApple.getAppleIDCredential();
      // if (result.success) {
      //   await _handleSuccessfulLogin(context, result.user);
      // }

      // For now, simulate successful login
      await _handleSuccessfulLogin(context, 'Apple User');
    } catch (error) {
      _handleLoginError(context, 'Apple sign-in error: $error');
    } finally {
      _setAppleLoading(false);
    }
  }

  /// Continue as guest (limited access)
  Future<void> continueAsGuest(BuildContext context) async {
    if (isAnyLoading) return;

    _setGuestLoading(true);

    try {
      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 1));

      // Navigate to home with guest mode
      await _navigateToHome(context, isGuest: true);
    } catch (error) {
      _handleLoginError(context, 'Guest login error: $error');
    } finally {
      _setGuestLoading(false);
    }
  }

  /// Handle successful login for any method
  Future<void> _handleSuccessfulLogin(
    BuildContext context,
    String userInfo,
  ) async {
    // Show success message
    AppSnackbar.showSuccess(
      context,
      message: 'Successfully signed in! Welcome.',
    );

    // Navigate to home
    await _navigateToHome(context);
  }

  /// Handle login errors
  void _handleLoginError(BuildContext context, String errorMessage) {
    // Show error dialog
    AppDialogExtension(context).showErrorDialog(errorMessage);
  }

  /// Navigate to home screen
  Future<void> _navigateToHome(
    BuildContext context, {
    bool isGuest = false,
  }) async {
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
