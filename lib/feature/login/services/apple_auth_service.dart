import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/feature/login/models/auth_result.dart';
import 'package:limo/feature/login/services/auth_security_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthService {
  static AppleAuthService? _instance;
  static AppleAuthService get instance => _instance ??= AppleAuthService._();
  AppleAuthService._();

  AuthResult? _currentAuthResult;

  bool get isSignedIn => _currentAuthResult != null;

  /// Generate random nonce for Apple Sign-In
  String _generateNonce([int length = 32]) {
    return AuthSecurityService.instance.generateNonce(length);
  }

  /// Generate SHA256 hash of nonce
  String _sha256ofString(String input) {
    return AuthSecurityService.instance.generateNonceHash(input);
  }

  Future<AuthResult?> signIn() async {
    try {
      LoggerService.info('Starting Apple Sign-In process', tag: 'APPLE_AUTH');

      // Check availability first
      final isAppleAvailable = await isAvailable();
      LoggerService.info(
        'Apple Sign-In available: $isAppleAvailable',
        tag: 'APPLE_AUTH',
      );

      if (!isAppleAvailable) {
        LoggerService.error(
          'Apple Sign-In not available on this device',
          tag: 'APPLE_AUTH',
        );
        throw Exception('Apple Sign-In is not available on this device');
      }

      // Generate nonce
      LoggerService.info(
        'Generating nonce for Apple Sign-In...',
        tag: 'APPLE_AUTH',
      );
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);
      LoggerService.info('Nonce generated successfully', tag: 'APPLE_AUTH');

      // Request Apple Sign-In
      LoggerService.info(
        'Requesting Apple Sign-In credentials...',
        tag: 'APPLE_AUTH',
      );

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      LoggerService.info(
        'Apple Sign-In credential received: ${credential.userIdentifier != null ? 'Success' : 'Failed'}',
        tag: 'APPLE_AUTH',
      );

      if (credential.userIdentifier != null) {
        LoggerService.success('Apple Sign-In successful', tag: 'APPLE_AUTH');
        LoggerService.info(
          'User ID: ${credential.userIdentifier}',
          tag: 'APPLE_AUTH',
        );
        LoggerService.info(
          'Email: ${credential.email ?? 'Not provided'}',
          tag: 'APPLE_AUTH',
        );
        LoggerService.info(
          'Display Name: ${credential.givenName ?? 'Not provided'} ${credential.familyName ?? ''}',
          tag: 'APPLE_AUTH',
        );

        _currentAuthResult = AuthResult(
          providerUserId: credential.userIdentifier!,
          email: credential.email,
          displayName: _formatDisplayName(
            credential.givenName,
            credential.familyName,
          ),
          provider: 'apple',
          rawNonce: rawNonce,
          idToken: credential.identityToken,
        );

        return _currentAuthResult;
      } else {
        LoggerService.error(
          'Apple Sign-In failed: No user ID',
          tag: 'APPLE_AUTH',
        );
        throw Exception('Apple Sign-In failed: No user ID received');
      }
    } catch (e) {
      String errorMessage = e.toString().toLowerCase();
      LoggerService.error('Apple Sign-In error: $e', tag: 'APPLE_AUTH');

      if (errorMessage.contains('canceled') ||
          errorMessage.contains('cancelled')) {
        LoggerService.info('User cancelled Apple Sign-In', tag: 'APPLE_AUTH');
        // Don't treat cancellation as an error
        return null;
      } else if (errorMessage.contains('network')) {
        LoggerService.error(
          'Network error during Apple Sign-In',
          tag: 'APPLE_AUTH',
        );
        throw Exception(
          'Network error during Apple Sign-In. Please check your connection.',
        );
      } else if (errorMessage.contains('not available')) {
        LoggerService.error(
          'Apple Sign-In not available on this device',
          tag: 'APPLE_AUTH',
        );
        throw Exception('Apple Sign-In is not available on this device');
      } else if (errorMessage.contains('configuration')) {
        LoggerService.error(
          'Apple Sign-In configuration error',
          tag: 'APPLE_AUTH',
        );
        throw Exception(
          'Apple Sign-In configuration error. Please contact support.',
        );
      } else if (errorMessage.contains('1000') ||
          errorMessage.contains('authorizationerror')) {
        LoggerService.error(
          'Apple Sign-In authorization error 1000 - likely simulator or config issue',
          tag: 'APPLE_AUTH',
        );
        throw Exception(
          'Apple Sign-In not properly configured for this device. Try on a real device or check Apple Developer settings.',
        );
      } else {
        LoggerService.error(
          'Unknown Apple Sign-In error: $e',
          tag: 'APPLE_AUTH',
        );
        throw Exception('Apple Sign-In failed: $e');
      }
    }
  }

  /// Format display name from given and family name
  String? _formatDisplayName(String? givenName, String? familyName) {
    if (givenName != null &&
        familyName != null &&
        givenName.isNotEmpty &&
        familyName.isNotEmpty) {
      return '$givenName $familyName';
    } else if (givenName != null && givenName.isNotEmpty) {
      return givenName;
    } else if (familyName != null && familyName.isNotEmpty) {
      return familyName;
    } else {
      return null; // Let service layer handle null case
    }
  }

  Future<bool> isAvailable() async {
    return await SignInWithApple.isAvailable();
  }

  /// Get Apple Sign-In status
  Future<CredentialState> getCredentialState(String userID) async {
    try {
      return await SignInWithApple.getCredentialState(userID);
    } catch (e) {
      LoggerService.error(
        'Error getting credential state: $e',
        tag: 'APPLE_AUTH',
      );
      return CredentialState.revoked;
    }
  }
}
