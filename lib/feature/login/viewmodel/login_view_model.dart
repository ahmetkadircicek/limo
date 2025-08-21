import 'package:flutter/material.dart';
import 'package:limo/core/init/navigation/navigation_service.dart';
import 'package:limo/core/models/user_model.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/core/services/shared_preferences_service.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/feature/home/view/home_view.dart';
import 'package:limo/feature/login/services/apple_auth_service.dart';
import 'package:limo/feature/login/services/google_auth_service.dart';
import 'package:limo/feature/login/services/login_service.dart';
import 'package:limo/feature/login/utils/auth_result_helper.dart';
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

  /// Navigate to home page after successful login
  void _navigateToHome() {
    if (_context != null) {
      Navigator.of(
        _context!,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeView()));
      LoggerService.info(
        'Navigating to home page after successful login',
        tag: 'LOGIN_VM',
      );
    } else {
      LoggerService.warning(
        'Context not available for navigation',
        tag: 'LOGIN_VM',
      );
    }
  }

  /// Signs in with Google OAuth
  Future<void> signInWithGoogle() async {
    if (_appStateProvider == null) {
      LoggerService.error('AppStateProvider not set', tag: 'LOGIN_VM');
      return;
    }

    _setLoading(true);
    _clearError();

    final startTime = DateTime.now();
    LoggerService.info('Starting Google Sign-In process', tag: 'LOGIN_VM');

    try {
      // Attempt Google Sign-In
      final user = await GoogleAuthService.instance.signIn();

      if (user != null) {
        final googleSignInDuration = DateTime.now().difference(startTime);
        LoggerService.info(
          'Google Sign-In completed in ${googleSignInDuration.inMilliseconds}ms',
          tag: 'LOGIN_VM',
        );

        // Google Sign-In başarılı - flag'i set et
        _appStateProvider!.setGoogleAuthDataPersisted(true);
        LoggerService.success('Google Sign-In successful', tag: 'LOGIN_VM');

        // Now authenticate with backend
        LoggerService.info('Starting backend authentication', tag: 'LOGIN_VM');
        final backendStartTime = DateTime.now();

        try {
          // Backend authentication flag'ini set et
          _appStateProvider!.setBackendAuthenticationSent(true);

          final loginResponse = await LoginService.loginWithGoogle(
            providerUserId: user.providerUserId,
            email: AuthResultHelper.getSafeEmail(user),
            userName: AuthResultHelper.getSafeDisplayName(user),
          );

          final backendDuration = DateTime.now().difference(backendStartTime);
          LoggerService.info(
            'Backend authentication completed in ${backendDuration.inMilliseconds}ms',
            tag: 'LOGIN_VM',
          );

          if (loginResponse.success) {
            // Backend authentication successful - flag'i set et
            _appStateProvider!.setBackendAuthenticationConfirmed(true);
            LoggerService.success(
              'Backend authentication successful',
              tag: 'LOGIN_VM',
            );

            // Save access token and user data if available
            final tokenToSave =
                loginResponse.accessToken ?? loginResponse.token;
            if (tokenToSave != null && tokenToSave.isNotEmpty) {
              // Create UserModel with token
              final userModel = UserModel.fromJson(loginResponse.user!);
              final userModelWithToken = userModel.copyWith(
                accessToken: tokenToSave,
              );

              // Save OAuth data to SharedPreferences
              final oauthData = {
                'provider': 'google',
                'providerId': userModel.providerUserId,
                'userName': userModel.userName,
                'userEmail': userModel.email,
              };

              final oauthDataSaved =
                  await SharedPreferencesService.saveAllOAuthData(oauthData);

              if (oauthDataSaved) {
                _appStateProvider!.setUserDataSaved(true);
              }

              if (oauthDataSaved) {
                LoggerService.success(
                  'Google OAuth data saved successfully',
                  tag: 'LOGIN_VM',
                );
              } else {
                LoggerService.warning(
                  'Failed to save Google OAuth data to storage',
                  tag: 'LOGIN_VM',
                );
              }

              // Set authentication status
              final authStatusSaved =
                  await SharedPreferencesService.saveOAuthData(
                    provider: 'google',
                    providerId: user.providerUserId,
                    userName: user.displayName ?? 'Google User',
                    userEmail: user.email ?? 'no-email@google.com',
                  );

              if (oauthDataSaved && authStatusSaved) {
                LoggerService.success(
                  'User data and authentication status saved successfully',
                  tag: 'LOGIN_VM',
                );
              } else {
                LoggerService.warning(
                  'Failed to save some authentication data to storage',
                  tag: 'LOGIN_VM',
                );
              }

              // Update AppStateProvider with authentication state
              if (_appStateProvider != null) {
                _appStateProvider!.setAuthenticationState(
                  true,
                  userModelWithToken,
                );
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
              LoggerService.warning(
                'No access token received from backend',
                tag: 'LOGIN_VM',
              );
            }

            // Show success message
            _showSuccessSnackbar('Login successful! Welcome!');

            // Navigate to home page after successful login
            NavigationService.instance.navigateToScreen(const HomeView());
          } else {
            // Backend authentication failed
            String detailedError = 'Backend authentication failed';
            String userError = 'Login failed';

            if (loginResponse.message != null &&
                loginResponse.message!.isNotEmpty) {
              detailedError += ': ${loginResponse.message}';
              userError += ': ${loginResponse.message}';
            } else {
              detailedError += ': No error message provided';
              userError += ': Unknown error';
            }

            // Check if token was missing specifically
            if ((loginResponse.token == null || loginResponse.token!.isEmpty) &&
                (loginResponse.accessToken == null ||
                    loginResponse.accessToken!.isEmpty)) {
              detailedError += ' (access_token missing)';
              LoggerService.warning(
                'Backend did not provide access_token for Google login',
                tag: 'LOGIN_VM',
              );
            }

            _setError(detailedError);
            _showErrorSnackbar(userError);
            LoggerService.error(detailedError, tag: 'LOGIN_VM');
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
        LoggerService.info(
          'Google Sign-In was cancelled by user',
          tag: 'LOGIN_VM',
        );
      }
    } catch (error) {
      final errorMsg = 'Google sign-in error: $error';
      _setError(errorMsg);
      _showErrorSnackbar('Google sign-in error: $error');
      LoggerService.error(errorMsg, error: error, tag: 'LOGIN_VM');
    } finally {
      _setLoading(false);
    }
  }

  /// Signs in with Apple OAuth
  Future<void> signInWithApple() async {
    if (_appStateProvider == null) {
      LoggerService.error('AppStateProvider not set', tag: 'LOGIN_VM');
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      // Attempt Apple Sign-In
      final appleResult = await AppleAuthService.instance.signIn();

      if (appleResult != null) {
        LoggerService.success('Apple Sign-In successful', tag: 'LOGIN_VM');

        // Apple Sign-In başarılı - flag'i set et
        _appStateProvider!.setGoogleAuthDataPersisted(true);

        // Now authenticate with backend
        LoggerService.info(
          'Starting Apple backend authentication',
          tag: 'LOGIN_VM',
        );

        try {
          // Backend authentication flag'ini set et
          _appStateProvider!.setBackendAuthenticationSent(true);

          final loginResponse = await LoginService.loginWithApple(
            providerUserId: appleResult.providerUserId,
            email: AuthResultHelper.getSafeEmail(appleResult),
            userName: AuthResultHelper.getSafeDisplayName(appleResult),
          );

          if (loginResponse.success) {
            // Backend authentication successful - flag'i set et
            _appStateProvider!.setBackendAuthenticationConfirmed(true);
            LoggerService.success(
              'Apple backend authentication successful',
              tag: 'LOGIN_VM',
            );

            // Save access token and user data if available
            final tokenToSave =
                loginResponse.accessToken ?? loginResponse.token;
            if (tokenToSave != null && tokenToSave.isNotEmpty) {
              // Create UserModel with token
              final userModel = UserModel.fromJson(loginResponse.user!);
              final userModelWithToken = userModel.copyWith(
                accessToken: tokenToSave,
              );

              // Save user data to SharedPreferences
              final oauthData = {
                'provider': 'apple',
                'providerId': userModel.providerUserId,
                'userName': userModel.userName,
                'userEmail': userModel.email,
              };

              final oauthDataSaved =
                  await SharedPreferencesService.saveAllOAuthData(oauthData);

              if (oauthDataSaved) {
                _appStateProvider!.setUserDataSaved(true);
              }

              // Set authentication status
              final authStatusSaved =
                  await SharedPreferencesService.saveOAuthData(
                    provider: 'apple',
                    providerId: appleResult.providerUserId,
                    userName: appleResult.displayName ?? 'Apple User',
                    userEmail: appleResult.email ?? 'no-email@apple.com',
                  );

              if (oauthDataSaved && authStatusSaved) {
                LoggerService.success(
                  'Apple user data and authentication status saved successfully',
                  tag: 'LOGIN_VM',
                );
              } else {
                LoggerService.warning(
                  'Failed to save some Apple authentication data to storage',
                  tag: 'LOGIN_VM',
                );
              }

              // Update AppStateProvider with authentication state
              if (_appStateProvider != null) {
                _appStateProvider!.setAuthenticationState(
                  true,
                  userModelWithToken,
                );
                _isAuthenticated = true;
                LoggerService.success(
                  'Apple authentication state updated in AppStateProvider',
                  tag: 'LOGIN_VM',
                );
              }
            } else {
              LoggerService.warning(
                'No access token received from backend for Apple login',
                tag: 'LOGIN_VM',
              );
            }

            // Show success message
            _showSuccessSnackbar('Apple Login successful! Welcome!');

            // Navigate to home page after successful login
            _navigateToHome();
          } else {
            // Backend authentication failed
            String detailedError = 'Backend authentication failed';
            String userError = 'Login failed';

            if (loginResponse.message != null &&
                loginResponse.message!.isNotEmpty) {
              detailedError += ': ${loginResponse.message}';
              userError += ': ${loginResponse.message}';
            } else {
              detailedError += ': No error message provided';
              userError += ': Unknown error';
            }

            // Check if token was missing specifically
            if ((loginResponse.token == null || loginResponse.token!.isEmpty) &&
                (loginResponse.accessToken == null ||
                    loginResponse.accessToken!.isEmpty)) {
              detailedError += ' (access_token missing)';
              LoggerService.warning(
                'Backend did not provide access_token for Apple login',
                tag: 'LOGIN_VM',
              );
            }

            _setError(detailedError);
            _showErrorSnackbar(userError);
            LoggerService.error(detailedError, tag: 'LOGIN_VM');
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
        LoggerService.info(
          'Apple Sign-In was cancelled by user',
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

  /// Logout and clear all tokens
  Future<void> logout() async {
    try {
      LoggerService.info('Starting logout process', tag: 'LOGIN_VM');

      // Clear all authentication data
      await SharedPreferencesService.clearOAuthData();

      // Update local state
      _isAuthenticated = false;
      _clearError();

      // Update AppStateProvider and reset all flags
      if (_appStateProvider != null) {
        _appStateProvider!.setAuthenticationState(false, null);
        _appStateProvider!.resetAuthenticationFlags();
        LoggerService.success(
          'Authentication state and flags cleared in AppStateProvider',
          tag: 'LOGIN_VM',
        );
      }

      LoggerService.success('Logout completed successfully', tag: 'LOGIN_VM');
      notifyListeners();
    } catch (e) {
      LoggerService.error('Error during logout: $e', error: e, tag: 'LOGIN_VM');
    }
  }

  /// Continues as guest
  Future<void> continueAsGuest() async {
    if (_appStateProvider == null) {
      LoggerService.error('AppStateProvider not set', tag: 'LOGIN_VM');
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      LoggerService.info('Continuing as guest', tag: 'LOGIN_VM');

      // Create guest user model
      final guestUser = UserModel(
        userId: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        provider: 'guest',
        providerUserId: 'guest',
        email: 'guest@limo.app',
        userName: 'Guest User',
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
        isActive: true,
      );

      // Update AppStateProvider with guest authentication state
      _appStateProvider!.setAuthenticationState(true, guestUser);
      _isAuthenticated = true;

      LoggerService.success(
        'Guest mode activated successfully',
        tag: 'LOGIN_VM',
      );
      _showSuccessSnackbar('Welcome! You are now in guest mode.');
    } catch (error) {
      final errorMsg = 'Error continuing as guest: $error';
      _setError(errorMsg);
      _showErrorSnackbar('Failed to continue as guest');
      LoggerService.error(errorMsg, error: error, tag: 'LOGIN_VM');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) => _isLoading = loading;

  void _setError(String message) {
    _lastError = message;
    notifyListeners();
  }

  void _clearError() {
    _lastError = null;
    notifyListeners();
  }
}
