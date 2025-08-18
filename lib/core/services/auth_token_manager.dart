import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:limo/core/services/auth_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages authentication tokens securely
class AuthTokenManager {
  static AuthTokenManager? _instance;
  static AuthTokenManager get instance => _instance ??= AuthTokenManager._();

  AuthTokenManager._();

  // SharedPreferences keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _userDataKey = 'user_data';

  // Current tokens in memory
  String? _currentAccessToken;
  String? _currentRefreshToken;
  DateTime? _currentTokenExpiry;

  /// Get current access token
  String? get accessToken => _currentAccessToken;

  /// Get current refresh token
  String? get refreshToken => _currentRefreshToken;

  /// Check if user is authenticated
  bool get isAuthenticated => _currentAccessToken != null && !_isTokenExpired;

  /// Check if token is expired
  bool get _isTokenExpired {
    if (_currentTokenExpiry == null) return true;
    return DateTime.now().isAfter(_currentTokenExpiry!);
  }

  /// Check if token will expire soon (within 5 minutes)
  bool get willExpireSoon {
    if (_currentTokenExpiry == null) return true;
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return _currentTokenExpiry!.isBefore(fiveMinutesFromNow);
  }

  /// Initialize token manager and restore tokens from storage
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Restore tokens from storage
      _currentAccessToken = prefs.getString(_accessTokenKey);
      _currentRefreshToken = prefs.getString(_refreshTokenKey);

      final expiryString = prefs.getString(_tokenExpiryKey);
      if (expiryString != null) {
        _currentTokenExpiry = DateTime.parse(expiryString);
      }

      // Check if token is expired and try to refresh if needed
      if (_isTokenExpired && _currentRefreshToken != null) {
        await _refreshTokenIfNeeded();
      }
    } catch (e) {
      // If there's an error, clear all tokens
      await clearTokens();
    }
  }

  /// Store authentication tokens
  Future<void> storeTokens(AuthResponse authResponse) async {
    debugPrint('🔐 [TOKEN_MANAGER] Starting to store authentication tokens...');

    try {
      final prefs = await SharedPreferences.getInstance();
      debugPrint('✅ [TOKEN_MANAGER] SharedPreferences instance obtained');

      debugPrint('🔐 [TOKEN_MANAGER] Storing tokens in memory...');
      // Store in memory
      _currentAccessToken = authResponse.accessToken;
      _currentRefreshToken = authResponse.refreshToken;
      _currentTokenExpiry = authResponse.expiresAt;
      debugPrint('✅ [TOKEN_MANAGER] Tokens stored in memory');

      debugPrint('🔐 [TOKEN_MANAGER] Storing tokens in SharedPreferences...');
      // Store in SharedPreferences
      await prefs.setString(_accessTokenKey, authResponse.accessToken);
      await prefs.setString(_refreshTokenKey, authResponse.refreshToken);
      await prefs.setString(
        _tokenExpiryKey,
        authResponse.expiresAt.toIso8601String(),
      );
      debugPrint('✅ [TOKEN_MANAGER] Tokens stored in SharedPreferences');

      // Store user data if available
      if (authResponse.user != null) {
        debugPrint('🔐 [TOKEN_MANAGER] Storing user data...');
        await prefs.setString(
          _userDataKey,
          json.encode(authResponse.user!.toJson()),
        );
        debugPrint('✅ [TOKEN_MANAGER] User data stored');
      } else {
        debugPrint('ℹ️ [TOKEN_MANAGER] No user data to store');
      }

      debugPrint('✅ [TOKEN_MANAGER] All tokens stored successfully!');
    } catch (e) {
      debugPrint('❌ [TOKEN_MANAGER] Failed to store tokens: $e');
      throw Exception('Failed to store tokens: $e');
    }
  }

  /// Get valid access token (refreshes if needed)
  Future<String?> getValidAccessToken() async {
    // If no token, return null
    if (_currentAccessToken == null) return null;

    // If token is expired, try to refresh
    if (_isTokenExpired) {
      final refreshed = await _refreshTokenIfNeeded();
      if (!refreshed) return null;
    }

    return _currentAccessToken;
  }

  /// Refresh token if needed
  Future<bool> _refreshTokenIfNeeded() async {
    if (_currentRefreshToken == null) return false;

    try {
      final authResponse = await AuthApiService.refreshToken(
        _currentRefreshToken!,
      );
      await storeTokens(authResponse);
      return true;
    } catch (e) {
      // Refresh failed, clear tokens
      await clearTokens();
      return false;
    }
  }

  /// Clear all stored tokens
  Future<void> clearTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear from memory
      _currentAccessToken = null;
      _currentRefreshToken = null;
      _currentTokenExpiry = null;

      // Clear from SharedPreferences
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_tokenExpiryKey);
      await prefs.remove(_userDataKey);
    } catch (e) {
      // Ignore errors when clearing
    }
  }

  /// Get stored user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userDataKey);

      if (userDataString != null) {
        return json.decode(userDataString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Update user data
  Future<void> updateUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userDataKey, json.encode(userData));
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

  /// Force token refresh
  Future<bool> forceTokenRefresh() async {
    return await _refreshTokenIfNeeded();
  }

  /// Validate current token with backend
  Future<bool> validateCurrentToken() async {
    if (_currentAccessToken == null) return false;

    try {
      return await AuthApiService.validateToken(_currentAccessToken!);
    } catch (e) {
      return false;
    }
  }
}
