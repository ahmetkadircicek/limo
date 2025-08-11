import 'dart:convert'; // Added for JsonEncoder
import 'dart:developer' as developer;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:limo/core/models/user_model.dart';

/// Enhanced Google Authentication Service
/// Provides comprehensive Google Sign-In functionality with proper error handling
class GoogleAuthService {
  static GoogleAuthService? _instance;
  static GoogleAuthService get instance => _instance ??= GoogleAuthService._();

  // Flag to prevent duplicate initialization
  static bool _isInitialized = false;

  GoogleAuthService._();

  // Configure GoogleSignIn instance
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// Stream to listen to authentication state changes
  Stream<GoogleSignInAuthenticationEvent> get onAuthStateChanged =>
      _googleSignIn.authenticationEvents;

  /// Current user
  static GoogleSignInAccount? currentUser;

  /// Sign in with Google
  /// Returns [GoogleSignInAccount] on success, null on failure or cancellation
  static Future<GoogleSignInAccount?> signIn() async {
    try {
      // Initialize Google Sign-In first
      await _googleSignIn.initialize();

      // Check if authentication is supported on this platform
      if (!_googleSignIn.supportsAuthenticate()) {
        developer.log('Google authentication not supported on this platform');
        return null;
      }

      // Attempt lightweight authentication first (silent sign-in)
      GoogleSignInAccount? user =
          await _googleSignIn.attemptLightweightAuthentication();

      if (user != null) {
        developer.log('Lightweight authentication successful: ${user.email}');
        currentUser = user;
        return user;
      }

      // If lightweight fails, perform interactive authentication
      user = await _googleSignIn.authenticate();

      developer.log('Interactive authentication successful: ${user.email}');
      currentUser = user;
      return user;
    } catch (error) {
      developer.log('Google Sign-In Error: $error');

      // Handle specific error types with string matching
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

  /// Sign out from Google
  /// Clears all cached authentication data
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

  /// Disconnect Google account
  /// Revokes access and removes account from device
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

  /// Check if user is currently signed in
  static bool get isSignedIn => currentUser != null;

  /// Check if user is signed in and restore session if possible
  static Future<bool> checkAndRestoreSession() async {
    try {
      // Ensure Google Sign-In is initialized
      if (!_isInitialized) {
        await initialize();
      }

      // Check if there's already a current user
      if (currentUser != null) {
        developer.log('User already signed in: ${currentUser!.email}');
        return true;
      }

      // Try to restore user session
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

  /// Get authentication tokens for current user
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

  /// Initialize Google Sign-In
  /// Call this method in main() or app initialization
  static Future<void> initialize() async {
    try {
      // Check if already initialized
      if (_isInitialized) {
        developer.log('Google Sign-In already initialized, skipping...');
        return;
      }

      developer.log('Initializing Google Sign-In...');

      // Initialize Google Sign-In
      await _googleSignIn.initialize();

      // Listen to authentication events
      _googleSignIn.authenticationEvents.listen((event) {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          currentUser = event.user;
          developer.log('User signed in: ${event.user.email}');
        } else if (event is GoogleSignInAuthenticationEventSignOut) {
          currentUser = null;
          developer.log('User signed out');
        }
      });

      // Try lightweight authentication
      final GoogleSignInAccount? user =
          await _googleSignIn.attemptLightweightAuthentication();

      if (user != null) {
        currentUser = user;
        developer.log('User restored from previous session: ${user.email}');
      } else {
        developer.log('No previous user session found');
      }

      // Mark as initialized
      _isInitialized = true;
      developer.log('Google Sign-In initialization completed');
    } catch (error) {
      developer.log('Google Sign-In initialization error: $error');
    }
  }

  /// Get user profile information
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

  /// Get comprehensive user profile information with all available data
  static Future<Map<String, dynamic>?> getComprehensiveUserProfile() async {
    final GoogleSignInAccount? user = currentUser;
    if (user == null) return null;

    try {
      // Get extended profile information
      final Map<String, dynamic> extendedProfile = {
        // Basic Profile Information
        'basicProfile': {
          'id': user.id,
          'email': user.email,
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
        },
      };

      // Log comprehensive profile in JSON format
      developer.log('=== GOOGLE USER PROFILE DATA ===');
      developer.log(_formatJson(extendedProfile));
      developer.log('=== END GOOGLE USER PROFILE DATA ===');

      return extendedProfile;
    } catch (error) {
      developer.log('Error getting comprehensive user profile: $error');
      return null;
    }
  }

  /// Get user model from Google authentication
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

  /// Format JSON data for better logging
  static String _formatJson(Map<String, dynamic> data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (e) {
      return data.toString();
    }
  }

  /// Request additional scopes for authorization
  static Future<bool> requestScopes(List<String> scopes) async {
    try {
      final GoogleSignInAccount? user = currentUser;
      if (user == null) {
        developer.log('No user signed in for scope request');
        return false;
      }

      // Check if scopes are already granted
      final auth =
          await user.authorizationClient.authorizationForScopes(scopes);
      if (auth?.accessToken != null) {
        developer.log('Scopes already granted');
        return true;
      }

      // Request new scopes
      final authorization =
          await user.authorizationClient.authorizeScopes(scopes);
      return authorization.accessToken.isNotEmpty;
    } catch (error) {
      developer.log('Error requesting scopes: $error');
      return false;
    }
  }

  /// Get server authorization code
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
