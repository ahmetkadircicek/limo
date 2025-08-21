import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Common security service for authentication providers
class AuthSecurityService {
  static AuthSecurityService? _instance;
  static AuthSecurityService get instance =>
      _instance ??= AuthSecurityService._();
  AuthSecurityService._();

  /// Generate random nonce for authentication
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Generate SHA256 hash of nonce
  String generateNonceHash(String nonce) {
    final bytes = utf8.encode(nonce);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate secure random string for state parameter
  String generateState([int length = 16]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Generate timestamp for request validation
  String generateTimestamp() {
    return DateTime.now().toIso8601String();
  }
}
