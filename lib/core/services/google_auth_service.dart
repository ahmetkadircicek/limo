import 'dart:convert';
import 'dart:developer' as developer;

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
        developer.log('Google authentication not supported on this platform');
        return null;
      }

      GoogleSignInAccount? user =
          await _googleSignIn.attemptLightweightAuthentication();

      if (user != null) {
        developer.log('Lightweight authentication successful: ${user.email}');
        currentUser = user;
        return user;
      }

      user = await _googleSignIn.authenticate();

      developer.log('Interactive authentication successful: ${user.email}');
      currentUser = user;
      return user;
    } catch (error) {
      developer.log('Google Sign-In Error: $error');

      String errorMessage = error.toString().toLowerCase();
      if (errorMessage.contains('canceled') ||
          errorMessage.contains('cancelled')) {
        developer.log('Sign-in was cancelled by user');
      } else if (errorMessage.contains('network')) {
        developer.log('Network error during sign-in');
      } else if (errorMessage.contains('failed')) {
        developer.log('Sign-in failed due to unknown reason');
      } else {
        developer.log('Unknown Google Sign-In error: $error');
      }

      return null;
    }
  }

  static Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      currentUser = null;
      developer.log('Google Sign-Out successful');
      return true;
    } catch (error) {
      developer.log('Google Sign-Out Error: $error');
      return false;
    }
  }

  static Future<bool> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      currentUser = null;
      developer.log('Google account disconnected');
      return true;
    } catch (error) {
      developer.log('Google disconnect error: $error');
      return false;
    }
  }

  static bool get isSignedIn => currentUser != null;

  static Future<bool> checkAndRestoreSession() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (currentUser != null) {
        developer.log('User already signed in: ${currentUser!.email}');
        return true;
      }

      final restoredUser =
          await _googleSignIn.attemptLightweightAuthentication();

      if (restoredUser != null) {
        currentUser = restoredUser;
        developer.log('User session restored: ${restoredUser.email}');
        return true;
      }

      developer.log('No user session found');
      return false;
    } catch (error) {
      developer.log('Error checking/restoring user session: $error');
      return false;
    }
  }

  static Future<GoogleSignInAuthentication?> getAuthTokens() async {
    try {
      final GoogleSignInAccount? user = currentUser;
      if (user == null) {
        developer.log('No user signed in');
        return null;
      }

      final GoogleSignInAuthentication auth = user.authentication;
      return auth;
    } catch (error) {
      developer.log('Error getting auth tokens: $error');
      return null;
    }
  }

  static Future<void> initialize() async {
    try {
      if (_isInitialized) {
        developer.log('Google Sign-In already initialized, skipping...');
        return;
      }

      developer.log('Initializing Google Sign-In...');

      await _googleSignIn.initialize();

      _googleSignIn.authenticationEvents.listen((event) {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          currentUser = event.user;
          developer.log('User signed in: ${event.user.email}');
        } else if (event is GoogleSignInAuthenticationEventSignOut) {
          currentUser = null;
          developer.log('User signed out');
        }
      });

      final GoogleSignInAccount? user =
          await _googleSignIn.attemptLightweightAuthentication();

      if (user != null) {
        currentUser = user;
        developer.log('User restored from previous session: ${user.email}');
      } else {
        developer.log('No previous user session found');
      }

      _isInitialized = true;
      developer.log('Google Sign-In initialization completed');
    } catch (error) {
      developer.log('Google Sign-In initialization error: $error');
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

      developer.log('=== GOOGLE USER PROFILE DATA ===');
      developer.log(_formatJson(extendedProfile));
      developer.log('=== END GOOGLE USER PROFILE DATA ===');

      return extendedProfile;
    } catch (error) {
      developer.log('Error getting comprehensive user profile: $error');
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
      developer.log('Error creating user model: $error');
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
