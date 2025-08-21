import 'package:limo/core/utils/logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences service for storing raw OAuth data from providers only
class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferencesService get instance =>
      _instance ??= SharedPreferencesService._();
  SharedPreferencesService._();

  static SharedPreferences? _prefs;

  // ===== OAUTH DATA KEYS =====
  static const String _providerKey = 'oauth_provider';
  static const String _providerIdKey = 'oauth_provider_id';
  static const String _userNameKey = 'oauth_user_name';
  static const String _userEmailKey = 'oauth_user_email';

  // ===== INITIALIZATION =====

  static Future<void> _initialize() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      LoggerService.info('SharedPreferences initialized', tag: 'SHARED_PREFS');
    }
  }

  static SharedPreferences _buildGetPrefs() {
    if (_prefs == null) {
      throw StateError(
        'SharedPreferences not initialized. Call _initialize() first.',
      );
    }
    return _prefs!;
  }

  // ===== GENERIC STORAGE METHODS =====

  static Future<bool> _buildSaveString(String key, String value) async {
    try {
      await _initialize();
      final success = await _buildGetPrefs().setString(key, value);
      if (success) {
        LoggerService.debug('Saved string: $key = $value', tag: 'SHARED_PREFS');
      }
      return success;
    } catch (e) {
      LoggerService.error('Error saving string $key: $e', tag: 'SHARED_PREFS');
      return false;
    }
  }

  static String? _buildGetString(String key) {
    try {
      return _buildGetPrefs().getString(key);
    } catch (e) {
      LoggerService.error('Error getting string $key: $e', tag: 'SHARED_PREFS');
      return null;
    }
  }

  static Future<bool> _buildRemoveKey(String key) async {
    try {
      await _initialize();
      final success = await _buildGetPrefs().remove(key);
      if (success) {
        LoggerService.debug('Removed key: $key', tag: 'SHARED_PREFS');
      }
      return success;
    } catch (e) {
      LoggerService.error('Error removing key $key: $e', tag: 'SHARED_PREFS');
      return false;
    }
  }

  // ===== OAUTH METHODS =====

  static Future<bool> saveOAuthData({
    required String provider,
    required String providerId,
    required String userName,
    required String userEmail,
  }) async {
    try {
      final allSuccess = await Future.wait([
        _buildSaveString(_providerKey, provider),
        _buildSaveString(_providerIdKey, providerId),
        _buildSaveString(_userNameKey, userName),
        _buildSaveString(_userEmailKey, userEmail),
      ]);

      final success = allSuccess.every((result) => result);
      if (success) {
        LoggerService.info(
          'OAuth data saved for $provider user: $userName',
          tag: 'SHARED_PREFS',
        );
      }
      return success;
    } catch (e) {
      LoggerService.error('Error saving OAuth data: $e', tag: 'SHARED_PREFS');
      return false;
    }
  }

  static Future<bool> saveAllOAuthData(Map<String, dynamic> oauthData) async {
    try {
      final allSuccess = await Future.wait([
        _buildSaveString(_providerKey, oauthData['provider'] ?? ''),
        _buildSaveString(_providerIdKey, oauthData['providerId'] ?? ''),
        _buildSaveString(_userNameKey, oauthData['userName'] ?? ''),
        _buildSaveString(_userEmailKey, oauthData['userEmail'] ?? ''),
      ]);

      final success = allSuccess.every((result) => result);
      if (success) {
        LoggerService.info(
          'All OAuth data saved for ${oauthData['provider']} user: ${oauthData['userName']}',
          tag: 'SHARED_PREFS',
        );
      }
      return success;
    } catch (e) {
      LoggerService.error(
        'Error saving all OAuth data: $e',
        tag: 'SHARED_PREFS',
      );
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getOAuthData() async {
    try {
      await _initialize();
      final provider = _buildGetPrefs().getString(_providerKey);
      final providerId = _buildGetPrefs().getString(_providerIdKey);
      final userName = _buildGetPrefs().getString(_userNameKey);
      final userEmail = _buildGetPrefs().getString(_userEmailKey);

      if (provider != null &&
          provider.isNotEmpty &&
          providerId != null &&
          providerId.isNotEmpty &&
          userName != null &&
          userName.isNotEmpty &&
          userEmail != null &&
          userEmail.isNotEmpty) {
        return {
          'provider': provider,
          'providerId': providerId,
          'userName': userName,
          'userEmail': userEmail,
        };
      }
      return null;
    } catch (e) {
      LoggerService.error('Error getting OAuth data: $e', tag: 'SHARED_PREFS');
      return null;
    }
  }

  static Future<Map<String, dynamic>> getAllOAuthData() async {
    try {
      await _initialize();
      return {
        'provider': _buildGetPrefs().getString(_providerKey),
        'providerId': _buildGetPrefs().getString(_providerIdKey),
        'userName': _buildGetPrefs().getString(_userNameKey),
        'userEmail': _buildGetPrefs().getString(_userEmailKey),
      };
    } catch (e) {
      LoggerService.error(
        'Error getting all OAuth data: $e',
        tag: 'SHARED_PREFS',
      );
      return {};
    }
  }

  static Future<bool> hasValidOAuth() async {
    try {
      final authData = await getOAuthData();
      return authData != null;
    } catch (e) {
      LoggerService.error(
        'Error checking OAuth validity: $e',
        tag: 'SHARED_PREFS',
      );
      return false;
    }
  }

  static Future<bool> clearOAuthData() async {
    try {
      final allSuccess = await Future.wait([
        _buildRemoveKey(_providerKey),
        _buildRemoveKey(_providerIdKey),
        _buildRemoveKey(_userNameKey),
        _buildRemoveKey(_userEmailKey),
      ]);

      final success = allSuccess.every((result) => result);
      if (success) {
        LoggerService.info('OAuth data cleared', tag: 'SHARED_PREFS');
      }
      return success;
    } catch (e) {
      LoggerService.error('Error clearing OAuth data: $e', tag: 'SHARED_PREFS');
      return false;
    }
  }
}
