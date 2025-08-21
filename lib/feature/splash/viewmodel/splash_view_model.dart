import 'package:flutter/material.dart';
import 'package:limo/core/models/user_model.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/core/services/shared_preferences_service.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/feature/login/services/login_service.dart';

class SplashViewModel extends ChangeNotifier {
  /// Initialize splash screen and check authentication status
  Future<bool> initialize(AppStateProvider appState) async {
    try {
      LoggerService.info('Starting splash initialization...', tag: 'SPLASH_VM');
      final startTime = DateTime.now();

      if (await SharedPreferencesService.hasValidOAuth()) {
        // OAuth data var - flag'i set et
        appState.setGoogleAuthDataPersisted(true);

        final isAuthenticated = await _buildAuthenticateWithPersistedData(
          appState,
          startTime,
        );
        return isAuthenticated;
      }

      LoggerService.info(
        'No valid persisted auth data found',
        tag: 'SPLASH_VM',
      );
      await _buildEnsureMinimumDuration(startTime);
      return false;
    } catch (error) {
      LoggerService.error(
        'Splash initialization error',
        error: error,
        tag: 'SPLASH_VM',
      );
      final startTime = DateTime.now();
      await _buildEnsureMinimumDuration(startTime);
      return false;
    }
  }

  /// Authenticate using persisted OAuth data
  Future<bool> _buildAuthenticateWithPersistedData(
    AppStateProvider appState,
    DateTime startTime,
  ) async {
    LoggerService.info('Found valid persisted OAuth data', tag: 'SPLASH_VM');

    final authData = await SharedPreferencesService.getOAuthData();
    if (authData == null) {
      await _buildEnsureMinimumDuration(startTime);
      return false;
    }

    LoggerService.info(
      'Attempting to authenticate with backend using persisted data',
      tag: 'SPLASH_VM',
    );

    try {
      // Backend authentication flag'ini set et
      appState.setBackendAuthenticationSent(true);

      final loginResponse = await _buildAuthenticateWithBackend(authData);
      if (loginResponse != null && loginResponse.success) {
        // Backend authentication başarılı - flag'i set et
        appState.setBackendAuthenticationConfirmed(true);

        await _buildHandleSuccessfulAuthentication(
          appState,
          loginResponse,
          startTime,
        );
        return true;
      } else {
        await _buildHandleFailedAuthentication(startTime);
        return false;
      }
    } catch (e) {
      LoggerService.error(
        'Error during backend authentication with persisted data: $e',
        tag: 'SPLASH_VM',
      );
      await SharedPreferencesService.clearOAuthData();
      await _buildEnsureMinimumDuration(startTime);
      return false;
    }
  }

  /// Authenticate with backend using provided auth data
  Future<dynamic> _buildAuthenticateWithBackend(
    Map<String, dynamic> authData,
  ) async {
    return await LoginService.authenticateWithGoogle(
      providerUserId: authData['providerId']!,
      email: authData['userEmail']!,
      userName: authData['userName']!,
    );
  }

  /// Handle successful authentication response
  Future<void> _buildHandleSuccessfulAuthentication(
    AppStateProvider appState,
    dynamic loginResponse,
    DateTime startTime,
  ) async {
    LoggerService.success(
      'Successfully authenticated with backend using persisted data',
      tag: 'SPLASH_VM',
    );

    if (loginResponse.user != null) {
      await _buildUpdateAppStateWithUserData(appState, loginResponse.user!);
    } else {
      LoggerService.warning(
        'Backend response success but no user data received',
        tag: 'SPLASH_VM',
      );
      await _buildRestoreUserDataFromPreferences(appState);
    }

    await _buildEnsureMinimumDuration(startTime);
  }

  /// Update app state with user data from backend
  Future<void> _buildUpdateAppStateWithUserData(
    AppStateProvider appState,
    Map<String, dynamic> userData,
  ) async {
    try {
      final userModel = UserModel.fromJson(userData);
      appState.updateCurrentUser(userModel);
      LoggerService.info(
        'User data updated in AppState: ${userModel.userName}',
        tag: 'SPLASH_VM',
      );

      await _buildSaveUserDataToPreferences(userData);
    } catch (e) {
      LoggerService.error(
        'Error creating UserModel from backend response: $e',
        tag: 'SPLASH_VM',
      );
    }
  }

  /// Save user data to SharedPreferences
  Future<void> _buildSaveUserDataToPreferences(
    Map<String, dynamic> userData,
  ) async {
    try {
      // Convert backend user data to OAuth format
      final oauthData = {
        'provider': userData['provider'] ?? 'google',
        'providerId':
            userData['provider_user_id'] ?? userData['providerUserId'],
        'userName': userData['user_name'] ?? userData['userName'],
        'userEmail': userData['email'] ?? userData['userEmail'],
      };

      await SharedPreferencesService.saveAllOAuthData(oauthData);
      LoggerService.info(
        'OAuth data saved to SharedPreferences',
        tag: 'SPLASH_VM',
      );
    } catch (e) {
      LoggerService.warning(
        'Failed to save OAuth data to SharedPreferences: $e',
        tag: 'SPLASH_VM',
      );
    }
  }

  /// Restore user data from SharedPreferences
  Future<void> _buildRestoreUserDataFromPreferences(
    AppStateProvider appState,
  ) async {
    try {
      final savedOAuthData = await SharedPreferencesService.getOAuthData();
      if (savedOAuthData != null) {
        // Create a minimal user model from OAuth data
        final userModel = UserModel(
          userId: '', // Will be set from backend
          provider: savedOAuthData['provider'] ?? 'google',
          providerUserId: savedOAuthData['providerId'] ?? '',
          email: savedOAuthData['userEmail'] ?? '',
          userName: savedOAuthData['userName'] ?? '',
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );

        appState.updateCurrentUser(userModel);

        // User data shared'den yüklendi - flag'i set et
        appState.setUserDataLoadedFromShared(true);

        LoggerService.info(
          'OAuth data restored from SharedPreferences: ${userModel.userName}',
          tag: 'SPLASH_VM',
        );
      }
    } catch (e) {
      LoggerService.warning(
        'Failed to restore OAuth data from SharedPreferences: $e',
        tag: 'SPLASH_VM',
      );
    }
  }

  /// Handle failed authentication
  Future<void> _buildHandleFailedAuthentication(DateTime startTime) async {
    LoggerService.warning(
      'Backend authentication failed with persisted data',
      tag: 'SPLASH_VM',
    );
    await SharedPreferencesService.clearOAuthData();
    await _buildEnsureMinimumDuration(startTime);
  }

  /// Ensure minimum 3 seconds duration for splash screen
  Future<void> _buildEnsureMinimumDuration(DateTime startTime) async {
    final elapsed = DateTime.now().difference(startTime);
    final minimumDuration = const Duration(seconds: 3);

    if (elapsed < minimumDuration) {
      final remainingTime = minimumDuration - elapsed;
      await Future.delayed(remainingTime);
    }
  }
}
