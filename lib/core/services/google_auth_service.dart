import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:limo/core/models/user_model.dart';

class GoogleAuthService {
  static GoogleAuthService? _instance;
  static GoogleAuthService get instance => _instance ??= GoogleAuthService._();

  static bool _isInitialized = false;

  GoogleAuthService._();

  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Stream<GoogleSignInAuthenticationEvent> get onAuthStateChanged =>
      _googleSignIn.authenticationEvents;

  static GoogleSignInAccount? currentUser;

  static Future<GoogleSignInAccount?> signIn() async {
    try {
      await _googleSignIn.initialize();

      if (!_googleSignIn.supportsAuthenticate()) {
        debugPrint(
          '❌ [GOOGLE_AUTH] Google authentication not supported on this platform',
        );
        return null;
      }

      // Force interactive authentication - no lightweight auth
      // This ensures user sees the Google sign-in screen every time
      debugPrint('🔐 [GOOGLE_AUTH] Forcing interactive authentication...');

      final user = await _googleSignIn.authenticate();

      debugPrint(
        '🔐 [GOOGLE_AUTH] Interactive authentication başarılı: ${user.email}',
      );
      currentUser = user;
      return user;

      return null;
    } catch (error) {
      debugPrint('❌ [GOOGLE_AUTH] Google Sign-In Error: $error');

      String errorMessage = error.toString().toLowerCase();
      if (errorMessage.contains('canceled') ||
          errorMessage.contains('cancelled')) {
        debugPrint('❌ [GOOGLE_AUTH] Sign-in kullanıcı tarafından iptal edildi');
      } else if (errorMessage.contains('network')) {
        debugPrint('❌ [GOOGLE_AUTH] Network error during sign-in');
      } else if (errorMessage.contains('failed')) {
        debugPrint('❌ [GOOGLE_AUTH] Sign-in failed due to unknown reason');
      } else {
        debugPrint('❌ [GOOGLE_AUTH] Unknown Google Sign-In error: $error');
      }

      return null;
    }
  }

  static Future<bool> signOut() async {
    try {
      // Sign out from Google
      await _googleSignIn.signOut();

      // Also disconnect to remove all permissions
      await _googleSignIn.disconnect();

      currentUser = null;
      debugPrint('🔐 [GOOGLE_AUTH] Google Sign-Out and disconnect başarılı');
      return true;
    } catch (error) {
      debugPrint('❌ [GOOGLE_AUTH] Google Sign-Out Error: $error');
      // Still clear local state even if Google sign-out fails
      currentUser = null;
      return false;
    }
  }

  static Future<bool> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      currentUser = null;
      debugPrint('🔐 [GOOGLE_AUTH] Google account disconnected');
      return true;
    } catch (error) {
      debugPrint('❌ [GOOGLE_AUTH] Google disconnect error: $error');
      return false;
    }
  }

  static bool get isSignedIn => currentUser != null;

  static Future<bool> checkAndRestoreSession() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // Never restore sessions automatically
      // User must manually sign in through the login screen
      debugPrint(
        '🔐 [GOOGLE_AUTH] No automatic session restoration - manual sign-in required',
      );
      return false;
    } catch (error) {
      debugPrint('❌ [GOOGLE_AUTH] Error checking Google user session: $error');
      return false;
    }
  }

  static Future<GoogleSignInAuthentication?> getAuthTokens() async {
    try {
      final GoogleSignInAccount? user = currentUser;
      if (user == null) {
        debugPrint('❌ [GOOGLE_AUTH] No user signed in');
        return null;
      }

      final GoogleSignInAuthentication auth = user.authentication;
      return auth;
    } catch (error) {
      debugPrint('❌ [GOOGLE_AUTH] Error getting auth tokens: $error');
      return null;
    }
  }

  static Future<void> initialize() async {
    try {
      if (_isInitialized) {
        debugPrint(
          '🔐 [GOOGLE_AUTH] Google Sign-In already initialized, skipping...',
        );
        return;
      }

      debugPrint('🔐 [GOOGLE_AUTH] Initializing Google Sign-In...');

      await _googleSignIn.initialize();

      // Listen to authentication events
      _googleSignIn.authenticationEvents.listen((event) {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          currentUser = event.user;
          debugPrint('🔐 [GOOGLE_AUTH] User signed in: ${event.user.email}');
        } else if (event is GoogleSignInAuthenticationEventSignOut) {
          currentUser = null;
          debugPrint('🔐 [GOOGLE_AUTH] User signed out');
        }
      });

      // No automatic session restoration - user must manually sign in
      debugPrint(
        '🔐 [GOOGLE_AUTH] No automatic session restoration - manual sign-in required',
      );

      _isInitialized = true;
      debugPrint('🔐 [GOOGLE_AUTH] Google Sign-In initialization completed');
    } catch (error) {
      debugPrint('❌ [GOOGLE_AUTH] Google Sign-In initialization error: $error');
    }
  }

  static Map<String, dynamic>? getUserProfile() {
    final GoogleSignInAccount? user = currentUser;
    if (user == null) return null;

    return {
      'id': user.id,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
    };
  }

  static Future<Map<String, dynamic>?> getComprehensiveUserProfile() async {
    final GoogleSignInAccount? user = currentUser;
    if (user == null) return null;

    try {
      final Map<String, dynamic> extendedProfile = {
        'basicProfile': {
          'id': user.id,
          'email': user.email,
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
        },
      };

      debugPrint('🔐 [GOOGLE_AUTH] === GOOGLE USER PROFILE DATA ===');
      debugPrint('🔐 [GOOGLE_AUTH] ${_formatJson(extendedProfile)}');
      debugPrint('🔐 [GOOGLE_AUTH] === END GOOGLE USER PROFILE DATA ===');

      return extendedProfile;
    } catch (error) {
      debugPrint(
        '❌ [GOOGLE_AUTH] Error getting comprehensive user profile: $error',
      );
      return null;
    }
  }

  static Future<UserModel?> getUserModel() async {
    final GoogleSignInAccount? user = currentUser;
    if (user == null) return null;

    try {
      return UserModel.fromGoogleAuth(
        id: user.id,
        email: user.email,
        displayName: user.displayName ?? 'Google User',
        photoUrl: user.photoUrl,
      );
    } catch (error) {
      debugPrint('❌ [GOOGLE_AUTH] Error creating user model: $error');
      return null;
    }
  }

  static String _formatJson(Map<String, dynamic> data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (e) {
      return data.toString();
    }
  }

  static Future<bool> requestScopes(List<String> scopes) async {
    try {
      final GoogleSignInAccount? user = currentUser;
      if (user == null) {
        developer.log('No user signed in for scope request');
        return false;
      }

      final auth = await user.authorizationClient.authorizationForScopes(
        scopes,
      );
      if (auth?.accessToken != null) {
        developer.log('Scopes already granted');
        return true;
      }

      final authorization = await user.authorizationClient.authorizeScopes(
        scopes,
      );
      return authorization.accessToken.isNotEmpty;
    } catch (error) {
      developer.log('Error requesting scopes: $error');
      return false;
    }
  }

  static Future<String?> getServerAuthCode(List<String> scopes) async {
    try {
      final GoogleSignInAccount? user = currentUser;
      if (user == null) {
        developer.log('No user signed in for server auth code');
        return null;
      }

      final serverAuth = await user.authorizationClient.authorizeServer(scopes);
      return serverAuth?.serverAuthCode;
    } catch (error) {
      developer.log('Error getting server auth code: $error');
      return null;
    }
  }
}
