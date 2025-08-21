import 'package:google_sign_in/google_sign_in.dart';
import 'package:limo/core/services/environment_service.dart';
import 'package:limo/core/services/shared_preferences_service.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/feature/login/models/auth_result.dart';
import 'package:limo/feature/login/services/auth_security_service.dart';

class GoogleAuthService {
  static GoogleAuthService? _instance;
  static GoogleAuthService get instance => _instance ??= GoogleAuthService._();

  GoogleAuthService._();

  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInAccount? _currentGoogleUser;
  AuthResult? _currentAuthResult;

  bool get isSignedIn => _currentGoogleUser != null;

  Future<AuthResult?> signIn() async {
    try {
      LoggerService.info('Starting Google Sign-In process', tag: 'GOOGLE_AUTH');

      // Check Google Client ID configuration
      final googleClientId = EnvironmentService.googleClientId;
      final googleSignInUrlScheme = EnvironmentService.googleSignInUrlScheme;

      LoggerService.info(
        'Google Client ID: ${googleClientId.isNotEmpty ? "✓ Configured" : "✗ Missing"}',
        tag: 'GOOGLE_AUTH',
      );
      LoggerService.info(
        'Google Sign-In URL Scheme: ${googleSignInUrlScheme.isNotEmpty ? "✓ Configured" : "✗ Missing"}',
        tag: 'GOOGLE_AUTH',
      );

      if (googleClientId.isEmpty) {
        LoggerService.error(
          'Google Client ID is missing from environment configuration',
          tag: 'GOOGLE_AUTH',
        );
        throw Exception(
          'Google Sign-In not properly configured. Please check environment settings.',
        );
      }

      LoggerService.info('Initializing Google Sign-In...', tag: 'GOOGLE_AUTH');
      await _googleSignIn.initialize();
      LoggerService.info(
        'Google Sign-In initialized successfully',
        tag: 'GOOGLE_AUTH',
      );

      if (!_googleSignIn.supportsAuthenticate()) {
        LoggerService.error(
          'Google Sign-In not supported on this device',
          tag: 'GOOGLE_AUTH',
        );
        return null;
      }

      LoggerService.info(
        'Google Sign-In is supported on this device',
        tag: 'GOOGLE_AUTH',
      );

      // Generate security parameters for future use
      AuthSecurityService.instance.generateState();
      AuthSecurityService.instance.generateTimestamp();

      // Force interactive authentication - no lightweight auth
      // This ensures user sees the Google sign-in screen every time
      LoggerService.info(
        'Starting Google authentication...',
        tag: 'GOOGLE_AUTH',
      );

      final user = await _googleSignIn.authenticate();

      LoggerService.info(
        'Google authentication completed, user: ${user.email.isNotEmpty ? user.email : 'Unknown'}',
        tag: 'GOOGLE_AUTH',
      );

      _currentGoogleUser = user;

      // Get auth tokens - handle null case
      final auth = user.authentication;

      // Validate required fields and provide defaults
      final userId = user.id;
      if (userId.isEmpty) {
        LoggerService.error(
          'Google user ID is null or empty',
          tag: 'GOOGLE_AUTH',
        );
        throw Exception('Failed to retrieve user ID from Google Sign-In');
      }

      // Create unified AuthResult with null safety
      _currentAuthResult = AuthResult(
        providerUserId: userId,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
        provider: 'google',
        accessToken: null, // No access token in current Google Sign-In version
        idToken: auth.idToken,
      );

      // Save Google auth data to persistence
      await _saveGoogleAuthData(_currentAuthResult!);

      return _currentAuthResult;
    } catch (error) {
      String errorMessage = error.toString().toLowerCase();
      LoggerService.error('Google Sign-In error: $error', tag: 'GOOGLE_AUTH');

      // Check if this is actually an Apple Sign-In error (shouldn't happen)
      if (errorMessage.contains('apple') ||
          errorMessage.contains('authorizationerror')) {
        LoggerService.error(
          'Unexpected Apple Sign-In error during Google Sign-In: $error',
          tag: 'GOOGLE_AUTH',
        );
        throw Exception(
          'Unexpected authentication service error. Please try again.',
        );
      } else if (errorMessage.contains('canceled') ||
          errorMessage.contains('cancelled')) {
        LoggerService.info('User cancelled Google Sign-In', tag: 'GOOGLE_AUTH');
        // Don't treat cancellation as an error
        return null;
      } else if (errorMessage.contains('network')) {
        LoggerService.error(
          'Network error during Google Sign-In',
          tag: 'GOOGLE_AUTH',
        );
        throw Exception(
          'Network error during Google Sign-In. Please check your connection.',
        );
      } else if (errorMessage.contains('failed')) {
        LoggerService.error(
          'Google Sign-In failed due to unknown reason',
          tag: 'GOOGLE_AUTH',
        );
        throw Exception('Google Sign-In failed. Please try again.');
      } else if (errorMessage.contains('not available')) {
        LoggerService.error(
          'Google Sign-In not available on this device',
          tag: 'GOOGLE_AUTH',
        );
        throw Exception('Google Sign-In is not available on this device.');
      } else {
        LoggerService.error(
          'Unknown Google Sign-In error: $error',
          tag: 'GOOGLE_AUTH',
        );
        throw Exception('Google Sign-In error: $error');
      }
    }
  }

  Future<bool> signOut() async {
    try {
      // Sign out from Google
      await _googleSignIn.signOut();

      // Also disconnect to remove all permissions
      await _googleSignIn.disconnect();

      // Clear local state
      _currentGoogleUser = null;
      _currentAuthResult = null;

      // Clear persisted auth data
      await SharedPreferencesService.clearOAuthData();

      return true;
    } catch (error) {
      LoggerService.warning(
        'Error during Google sign-out: $error',
        tag: 'GOOGLE_AUTH',
      );
      // Still clear local state even if Google sign-out fails
      _currentGoogleUser = null;
      _currentAuthResult = null;

      // Try to clear persisted data even if Google sign-out fails
      try {
        await SharedPreferencesService.clearOAuthData();
      } catch (e) {
        LoggerService.warning(
          'Failed to clear persisted auth data during sign-out: $e',
          tag: 'GOOGLE_AUTH',
        );
      }

      return false;
    }
  }

  Future<bool> disconnect() async {
    try {
      await _googleSignIn.disconnect();

      // Clear local state
      _currentGoogleUser = null;
      _currentAuthResult = null;

      // Clear persisted auth data
      await SharedPreferencesService.clearOAuthData();

      return true;
    } catch (error) {
      LoggerService.warning(
        'Error during Google disconnect: $error',
        tag: 'GOOGLE_AUTH',
      );
      // Still clear local state even if disconnect fails
      _currentGoogleUser = null;
      _currentAuthResult = null;

      // Try to clear persisted data even if disconnect fails
      try {
        await SharedPreferencesService.clearOAuthData();
      } catch (e) {
        LoggerService.warning(
          'Failed to clear persisted auth data during disconnect: $e',
          tag: 'GOOGLE_AUTH',
        );
      }

      return false;
    }
  }

  /// Initialize Google Sign-In
  static Future<void> initialize() async {
    try {
      await _googleSignIn.initialize();
      LoggerService.info(
        'Google Sign-In initialized successfully',
        tag: 'GOOGLE_AUTH',
      );
    } catch (error) {
      LoggerService.error(
        'Google Sign-In initialization failed: $error',
        tag: 'GOOGLE_AUTH',
      );
      // Google Sign-In initialization failed silently
    }
  }

  /// Get current user safely
  GoogleSignInAccount? get currentUser => _currentGoogleUser;

  /// Get current auth result safely
  AuthResult? get currentAuthResult => _currentAuthResult;

  /// Check if user has valid authentication data
  bool get hasValidAuth =>
      _currentAuthResult != null &&
      _currentAuthResult!.providerUserId.isNotEmpty;

  /// Save Google authentication data to persistence
  Future<void> _saveGoogleAuthData(AuthResult authResult) async {
    try {
      final success = await SharedPreferencesService.saveOAuthData(
        provider: 'google',
        providerId: authResult.providerUserId,
        userName: authResult.displayName ?? 'Google User',
        userEmail: authResult.email ?? 'no-email@google.com',
      );

      if (success) {
        LoggerService.info(
          'Google OAuth data saved to persistence successfully',
          tag: 'GOOGLE_AUTH',
        );
      } else {
        LoggerService.warning(
          'Failed to save Google OAuth data to persistence',
          tag: 'GOOGLE_AUTH',
        );
      }
    } catch (e) {
      LoggerService.error(
        'Error saving Google OAuth data to persistence: $e',
        tag: 'GOOGLE_AUTH',
      );
    }
  }

  /// Check if user has valid persisted OAuth data
  Future<bool> get hasPersistedOAuth =>
      SharedPreferencesService.hasValidOAuth();

  /// Get persisted OAuth data
  Future<Map<String, dynamic>?> get persistedOAuthData =>
      SharedPreferencesService.getOAuthData();
}
