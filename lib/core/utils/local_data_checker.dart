import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Utility class to check and display local data stored in SharedPreferences
class LocalDataChecker {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _userDataKey = 'user_data';
  static const String _userIdKey = 'user_id';
  static const String _userDisplayNameKey = 'user_display_name';
  static const String _userEmailKey = 'user_email';
  static const String _isAuthenticatedKey = 'is_authenticated';
  static const String _lastSelectedLocationKey = 'last_selected_location';

  /// Check all local data and return a formatted string
  static Future<String> checkAllLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> allData = {};

      // Check auth-related data
      allData['Access Token'] = prefs.getString(_accessTokenKey);
      allData['Refresh Token'] = prefs.getString(_refreshTokenKey);
      allData['Token Expiry'] = prefs.getString(_tokenExpiryKey);
      allData['User Data'] = prefs.getString(_userDataKey);
      allData['User ID'] = prefs.getString(_userIdKey);
      allData['User Display Name'] = prefs.getString(_userDisplayNameKey);
      allData['User Email'] = prefs.getString(_userEmailKey);
      allData['Is Authenticated'] = prefs.getBool(_isAuthenticatedKey);
      allData['Last Selected Location'] = prefs.getString(
        _lastSelectedLocationKey,
      );

      // Check if any data exists
      final hasData = allData.values.any((value) => value != null);

      if (!hasData) {
        return '❌ Hiç local veri bulunamadı. SharedPreferences boş.';
      }

      // Format the data for display
      final buffer = StringBuffer();
      buffer.writeln('✅ Local veri bulundu:');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      allData.forEach((key, value) {
        if (value != null) {
          if (key == 'Access Token' || key == 'Refresh Token') {
            final token = value.toString();
            final displayValue =
                token.length > 20
                    ? '${token.substring(0, 20)}... (${token.length} karakter)'
                    : token;
            buffer.writeln('🔑 $key: $displayValue');
          } else if (key == 'User Data') {
            try {
              final userData = json.decode(value.toString());
              buffer.writeln('👤 $key: ${json.encode(userData)}');
            } catch (e) {
              buffer.writeln('👤 $key: $value (JSON parse hatası)');
            }
          } else {
            buffer.writeln('📝 $key: $value');
          }
        }
      });

      return buffer.toString();
    } catch (e) {
      return '❌ Local veri kontrol edilirken hata oluştu: $e';
    }
  }

  /// Clear all local data
  static Future<String> clearAllLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear all known keys
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_tokenExpiryKey);
      await prefs.remove(_userDataKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userDisplayNameKey);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_isAuthenticatedKey);
      await prefs.remove(_lastSelectedLocationKey);

      // Clear all SharedPreferences (nuclear option)
      await prefs.clear();

      return '✅ Tüm local veriler başarıyla temizlendi!';
    } catch (e) {
      return '❌ Local veriler temizlenirken hata oluştu: $e';
    }
  }

  /// Get all SharedPreferences keys for debugging
  static Future<List<String>> getAllKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getKeys().toList();
    } catch (e) {
      return [];
    }
  }

  /// Get all SharedPreferences data as a map
  static Future<Map<String, dynamic>> getAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> allData = {};

      for (final key in prefs.getKeys()) {
        final value = prefs.get(key);
        if (value != null) {
          allData[key] = value;
        }
      }

      return allData;
    } catch (e) {
      return {};
    }
  }
}
