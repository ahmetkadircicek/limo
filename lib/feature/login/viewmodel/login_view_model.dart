import 'package:flutter/material.dart';
import 'package:limo/core/models/user_model.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/core/services/google_auth_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/core/services/login_service.dart';
import 'package:limo/shared/app_snackbar.dart';

/// Simple Login ViewModel for UI only
class LoginViewModel extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _lastError;
  bool _isLoading = false;
  AppStateProvider? _appStateProvider;
  BuildContext? _context;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  String? get lastError => _lastError;
  bool get isLoading => _isLoading;

  /// Set the AppStateProvider for authentication state management
  void setAppStateProvider(AppStateProvider provider) {
    _appStateProvider = provider;
    LoggerService.info(
      'AppStateProvider set in LoginViewModel',
      tag: 'LOGIN_VM',
    );
  }

  /// Set the BuildContext for showing snackbars
  void setContext(BuildContext context) {
    _context = context;
    LoggerService.info('BuildContext set in LoginViewModel', tag: 'LOGIN_VM');
  }

  /// Show error snackbar if context is available
  void _showErrorSnackbar(String message) {
    if (_context != null) {
      AppSnackbar.showError(_context!, message: message);
    }
    LoggerService.error('Error snackbar shown: $message', tag: 'LOGIN_VM');
  }

  /// Show success snackbar if context is available
  void _showSuccessSnackbar(String message) {
    if (_context != null) {
      AppSnackbar.showSuccess(_context!, message: message);
    }
    LoggerService.info('Success snackbar shown: $message', tag: 'LOGIN_VM');
  }

  /// Signs in with Google OAuth
  Future<void> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    final startTime = DateTime.now();
    LoggerService.info('Starting Google Sign-In process', tag: 'LOGIN_VM');

    try {
      // Attempt Google Sign-In
      final user = await GoogleAuthService.signIn();

      if (user != null) {
        final googleSignInDuration = DateTime.now().difference(startTime);
        LoggerService.info(
          'Google Sign-In completed in ${googleSignInDuration.inMilliseconds}ms',
          tag: 'LOGIN_VM',
        );

        // Google Sign-In başarılı - kullanıcı bilgilerini logla
        LoggerService.success('Google Sign-In successful', tag: 'LOGIN_VM');
        LoggerService.info('User ID: ${user.id}', tag: 'LOGIN_VM');
        LoggerService.info('Email: ${user.email}', tag: 'LOGIN_VM');
        LoggerService.info(
          'Display Name: ${user.displayName}',
          tag: 'LOGIN_VM',
        );
        LoggerService.debug(
          'Photo URL: ${user.photoUrl ?? 'No photo'}',
          tag: 'LOGIN_VM',
        );

        // Now authenticate with backend
        LoggerService.info('Starting backend authentication', tag: 'LOGIN_VM');
        final backendStartTime = DateTime.now();

        try {
          final loginResponse = await LoginService.loginWithGoogle(
            providerUserId: user.id,
            email: user.email,
            userName: user.displayName ?? 'User',
          );

          final backendDuration = DateTime.now().difference(backendStartTime);
          LoggerService.info(
            'Backend authentication completed in ${backendDuration.inMilliseconds}ms',
            tag: 'LOGIN_VM',
          );

          if (loginResponse.success) {
            // Backend authentication successful
            LoggerService.success(
              'Backend authentication successful',
              tag: 'LOGIN_VM',
            );

            // Show success message
            _showSuccessSnackbar('Login successful! Welcome!');

            // Create UserModel from Google user data
            final userModel = UserModel.fromGoogleAuth(
              id: user.id,
              email: user.email,
              displayName: user.displayName ?? 'User',
              photoUrl: user.photoUrl,
            );

            // Update AppStateProvider with authentication state
            if (_appStateProvider != null) {
              _appStateProvider!.setAuthenticationState(true, userModel);
              _isAuthenticated = true;
              LoggerService.success(
                'Authentication state updated in AppStateProvider',
                tag: 'LOGIN_VM',
              );
            } else {
              LoggerService.warning(
                'AppStateProvider not set, cannot update authentication state',
                tag: 'LOGIN_VM',
              );
            }
          } else {
            // Backend authentication failed
            final errorMsg =
                'Backend authentication failed: ${loginResponse.message ?? 'Unknown error'}';
            _setError(errorMsg);
            _showErrorSnackbar(
              'Login failed: ${loginResponse.message ?? 'Unknown error'}',
            );
            LoggerService.error(errorMsg, tag: 'LOGIN_VM');
          }
        } catch (backendError) {
          // Backend authentication error
          String errorMsg;
          if (backendError.toString().contains('Request timeout')) {
            errorMsg = 'Connection timeout. Please try again.';
          } else if (backendError.toString().contains(
            'No internet connection',
          )) {
            errorMsg =
                'No internet connection found. Please check your connection.';
          } else {
            errorMsg = 'Server error: $backendError';
          }

          _setError(errorMsg);
          _showErrorSnackbar(errorMsg);
          LoggerService.error(
            'Backend authentication error: $backendError',
            error: backendError,
            tag: 'LOGIN_VM',
          );
        }
      } else {
        LoggerService.warning(
          'Google Sign-In cancelled or failed',
          tag: 'LOGIN_VM',
        );
        _setError('Google sign-in iptal edildi');
        _showErrorSnackbar('Google sign-in cancelled');
      }
    } catch (error) {
      final errorMsg = 'Google sign-in error: $error';
      _setError(errorMsg);
      _showErrorSnackbar('Google sign-in error: $error');
      LoggerService.error(errorMsg, error: error, tag: 'LOGIN_VM');
    } finally {
      final totalDuration = DateTime.now().difference(startTime);
      LoggerService.info(
        'Total Google sign-in process completed in ${totalDuration.inMilliseconds}ms',
        tag: 'LOGIN_VM',
      );
      _setLoading(false);
    }
  }

  /// Signs in with Apple OAuth
  Future<void> signInWithApple() async {
    _setLoading(true);
    _clearError();

    try {
      LoggerService.info('Starting Apple Sign-In process', tag: 'LOGIN_VM');

      // Simulate Apple Sign-In for now
      await Future.delayed(const Duration(seconds: 1));

      // For demo purposes, use sample data
      // In real implementation, this would come from Apple Sign-In
      final sampleUserId = 'apple_user_123';
      final sampleEmail = 'user@example.com';
      final sampleName = 'Apple User';

      LoggerService.info('Apple Sign-In simulated', tag: 'LOGIN_VM');
      LoggerService.info('User ID: $sampleUserId', tag: 'LOGIN_VM');
      LoggerService.info('Email: $sampleEmail', tag: 'LOGIN_VM');
      LoggerService.info('Display Name: $sampleName', tag: 'LOGIN_VM');

      // Authenticate with backend
      LoggerService.info(
        'Starting backend authentication for Apple',
        tag: 'LOGIN_VM',
      );

      try {
        final loginResponse = await LoginService.loginWithApple(
          providerUserId: sampleUserId,
          email: sampleEmail,
          userName: sampleName,
        );

        if (loginResponse.success) {
          // Backend authentication successful
          LoggerService.success(
            'Apple backend authentication successful',
            tag: 'LOGIN_VM',
          );

          // Create UserModel from Apple user data
          final userModel = UserModel.fromGoogleAuth(
            id: sampleUserId,
            email: sampleEmail,
            displayName: sampleName,
            photoUrl: null, // Apple doesn't provide photo URL
          );

          // Update AppStateProvider with authentication state
          if (_appStateProvider != null) {
            _appStateProvider!.setAuthenticationState(true, userModel);
            _isAuthenticated = true;
            LoggerService.success(
              'Apple authentication state updated in AppStateProvider',
              tag: 'LOGIN_VM',
            );
          }
        } else {
          // Backend authentication failed
          final errorMsg =
              'Backend authentication failed: ${loginResponse.message ?? 'Unknown error'}';
          _setError(errorMsg);
          _showErrorSnackbar(
            'Login failed: ${loginResponse.message ?? 'Unknown error'}',
          );
          LoggerService.error(errorMsg, tag: 'LOGIN_VM');
        }
      } catch (backendError) {
        // Backend authentication error
        String errorMsg;
        if (backendError.toString().contains('Request timeout')) {
          errorMsg = 'Connection timeout. Please try again.';
        } else if (backendError.toString().contains('No internet connection')) {
          errorMsg =
              'No internet connection found. Please check your connection.';
        } else {
          errorMsg = 'Server error: $backendError';
        }

        _setError(errorMsg);
        _showErrorSnackbar(errorMsg);
        LoggerService.error(
          'Backend authentication error: $backendError',
          error: backendError,
          tag: 'LOGIN_VM',
        );
      }
    } catch (error) {
      final errorMsg = 'Apple sign-in error: $error';
      _setError(errorMsg);
      _showErrorSnackbar('Apple sign-in error: $error');
      LoggerService.error(errorMsg, error: error, tag: 'LOGIN_VM');
    } finally {
      _setLoading(false);
    }
  }

  /// Continues as guest
  Future<void> continueAsGuest() async {
    _setLoading(true);
    _clearError();

    try {
      LoggerService.info('Guest sign-in attempted', tag: 'LOGIN_VM');
      await Future.delayed(const Duration(seconds: 1)); // Simulate loading

      final errorMsg =
          'Guest mode is not supported. Please sign in with Google or Apple.';
      _setError(errorMsg);
      _showErrorSnackbar(errorMsg);
      LoggerService.warning(errorMsg, tag: 'LOGIN_VM');
    } finally {
      _setLoading(false);
    }
  }

  /// Sets loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      LoggerService.info('Setting loading state to true', tag: 'LOGIN_VM');
    } else {
      LoggerService.info('Setting loading state to false', tag: 'LOGIN_VM');
    }
    notifyListeners();
  }

  /// Sets error message
  void _setError(String errorMessage) {
    _lastError = errorMessage;
    _isAuthenticated = false;
    LoggerService.error(
      'Setting error message: $errorMessage',
      tag: 'LOGIN_VM',
    );
    notifyListeners();
  }

  /// Clears error message
  void _clearError() {
    _lastError = null;
    LoggerService.info('Error message cleared', tag: 'LOGIN_VM');
    notifyListeners();
  }

  /// Resets authentication state
  void resetAuthState() {
    _isAuthenticated = false;
    _lastError = null;
    _isLoading = false;
    LoggerService.info('Authentication state reset', tag: 'LOGIN_VM');
    notifyListeners();
  }
}
