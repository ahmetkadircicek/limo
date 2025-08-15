import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:limo/core/models/user_model.dart';
import 'package:limo/core/services/encryption_service.dart';
import 'package:limo/core/services/http_interceptor.dart';

/// Authentication API Service for backend communication
class AuthApiService {
  static AuthApiService? _instance;
  static AuthApiService get instance => _instance ??= AuthApiService._();

  AuthApiService._();

  // API base URL (in production, this should be configurable)
  static const String _baseUrl =
      'https://api.limo.com'; // Replace with your actual API URL

  // API endpoints
  static const String _loginEndpoint = '/auth/google-login';
  static const String _userProfileEndpoint = '/user/profile';
  static const String _refreshTokenEndpoint = '/auth/refresh';

    /// Authenticate with Google ID
  /// 1. Encrypts Google ID using AES
  /// 2. Sends encrypted ID to backend
  /// 3. Returns authentication token
  static Future<AuthResponse> authenticateWithGoogle(String googleId) async {
    debugPrint('🔐 [AUTH_API] Starting Google authentication for ID: $googleId');
    
    try {
      debugPrint('🔐 [AUTH_API] Encrypting Google ID using AES...');
      // Encrypt Google ID using AES
      final encryptedId = EncryptionService.encryptData(googleId);
      debugPrint('✅ [AUTH_API] Google ID encrypted successfully');
      
      // Prepare request payload
      final payload = {
        'encryptedGoogleId': encryptedId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'platform': 'flutter',
      };
      debugPrint('🔐 [AUTH_API] Request payload prepared: ${payload.keys.join(', ')}');
      debugPrint('🔐 [AUTH_API] Making POST request to: $_baseUrl$_loginEndpoint');

      // Make API call
      final response = await http.post(
        Uri.parse('$_baseUrl$_loginEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(payload),
      );

      debugPrint('🔐 [AUTH_API] Response received - Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        debugPrint('✅ [AUTH_API] Authentication successful!');
        final responseData = json.decode(response.body);
        debugPrint('🔐 [AUTH_API] Response data keys: ${responseData.keys.join(', ')}');
        return AuthResponse.fromJson(responseData);
      } else {
        debugPrint('❌ [AUTH_API] Authentication failed - Status: ${response.statusCode}');
        debugPrint('❌ [AUTH_API] Response body: ${response.body}');
        throw AuthException(
          'Authentication failed',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      debugPrint('❌ [AUTH_API] Error during authentication: $e');
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e', 0, '');
    }
  }

  /// Get user profile using authentication token
  static Future<UserModel> getUserProfile(String authToken) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_userProfileEndpoint'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return UserModel.fromJson(responseData['user']);
      } else if (response.statusCode == 401) {
        throw AuthException('Token expired or invalid', 401, '');
      } else {
        throw AuthException(
          'Failed to get user profile',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e', 0, '');
    }
  }

  /// Get user profile using automatic token management
  static Future<UserModel> getUserProfileAuto() async {
    try {
      final request = await HttpInterceptor.authenticatedGet(
        '$_baseUrl$_userProfileEndpoint',
      );
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return UserModel.fromJson(responseData['user']);
      } else if (response.statusCode == 401) {
        // Handle authentication error
        await HttpInterceptor.handleAuthenticationError();
        throw AuthException('Token expired or invalid', 401, '');
      } else {
        throw AuthException(
          'Failed to get user profile',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e', 0, '');
    }
  }

  /// Refresh authentication token
  static Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_refreshTokenEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return AuthResponse.fromJson(responseData);
      } else {
        throw AuthException(
          'Token refresh failed',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: $e', 0, '');
    }
  }

  /// Validate token with backend
  static Future<bool> validateToken(String authToken) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_userProfileEndpoint'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

/// Authentication response model
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final DateTime expiresAt;
  final UserModel? user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.expiresAt,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      expiresIn: json['expiresIn'] as int? ?? 3600,
      expiresAt: DateTime.now().add(
        Duration(seconds: json['expiresIn'] as int? ?? 3600),
      ),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'expiresAt': expiresAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }

  /// Check if token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if token will expire soon (within 5 minutes)
  bool get willExpireSoon {
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return expiresAt.isBefore(fiveMinutesFromNow);
  }
}

/// Authentication exception
class AuthException implements Exception {
  final String message;
  final int statusCode;
  final String responseBody;

  AuthException(this.message, this.statusCode, this.responseBody);

  @override
  String toString() => 'AuthException: $message (Status: $statusCode)';
}
