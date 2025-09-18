import 'dart:convert';

import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/models/oauth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _tag = 'SHARED_PREFS';
  static const String _oauthKey = 'oauth_model';

  /// SharedPreferences'ı başlat
  static Future<void> initialize() async {
    try {
      await SharedPreferences.getInstance();
      LoggerService.info('SharedPreferences initialized', tag: _tag);
    } catch (e) {
      LoggerService.error(
        'Failed to initialize SharedPreferences: $e',
        tag: _tag,
      );
    }
  }

  /// OAuth model'i kaydet
  static Future<bool> saveOAuthModel(OAuthModel oauthModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // OAuth verisini detaylı logla
      LoggerService.info('=== SAVING OAUTH DATA ===', tag: _tag);
      LoggerService.info('OAuth ID: ${oauthModel.id}', tag: _tag);
      LoggerService.info('OAuth Provider: ${oauthModel.provider}', tag: _tag);
      LoggerService.info('OAuth Email: ${oauthModel.email}', tag: _tag);
      LoggerService.info(
        'OAuth DisplayName: ${oauthModel.displayName}',
        tag: _tag,
      );
      LoggerService.info('OAuth PhotoUrl: ${oauthModel.photoUrl}', tag: _tag);
      LoggerService.info('OAuth IsActive: ${oauthModel.isActive}', tag: _tag);

      // toJson() ile oluşan veriyi logla
      final jsonData = oauthModel.toJson();
      LoggerService.info('OAuth toJson() result: $jsonData', tag: _tag);

      final jsonString = jsonEncode(jsonData);
      LoggerService.info(
        'OAuth JSON string length: ${jsonString.length}',
        tag: _tag,
      );

      final result = await prefs.setString(_oauthKey, jsonString);

      if (result) {
        LoggerService.success('OAuth data saved successfully', tag: _tag);
      } else {
        LoggerService.warning('Failed to save OAuth data', tag: _tag);
      }

      return result;
    } catch (e) {
      LoggerService.error('Error saving OAuth model: $e', tag: _tag);
      return false;
    }
  }

  /// OAuth model'i oku
  static Future<OAuthModel?> getOAuthModel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_oauthKey);

      if (jsonString == null) {
        LoggerService.info(
          'No OAuth data found in SharedPreferences',
          tag: _tag,
        );
        return null;
      }

      LoggerService.info('=== READING OAUTH DATA ===', tag: _tag);
      LoggerService.info('Raw JSON string: $jsonString', tag: _tag);
      LoggerService.info('JSON string length: ${jsonString.length}', tag: _tag);

      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      LoggerService.info('Decoded JSON data: $jsonData', tag: _tag);

      final oauthModel = OAuthModel.fromJson(jsonData);

      LoggerService.info('=== OAUTH MODEL CREATED ===', tag: _tag);
      LoggerService.info('Model ID: ${oauthModel.id}', tag: _tag);
      LoggerService.info('Model Provider: ${oauthModel.provider}', tag: _tag);
      LoggerService.info('Model Email: ${oauthModel.email}', tag: _tag);
      LoggerService.info(
        'Model DisplayName: ${oauthModel.displayName}',
        tag: _tag,
      );
      LoggerService.info('Model PhotoUrl: ${oauthModel.photoUrl}', tag: _tag);
      LoggerService.info('Model IsActive: ${oauthModel.isActive}', tag: _tag);

      return oauthModel;
    } catch (e) {
      LoggerService.error('Error reading OAuth model: $e', tag: _tag);
      return null;
    }
  }

  /// OAuth model'i temizle
  static Future<bool> clearOAuthModel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      LoggerService.info(
        'Clearing OAuth data from SharedPreferences',
        tag: _tag,
      );

      final result = await prefs.remove(_oauthKey);

      if (result) {
        LoggerService.success('OAuth data cleared successfully', tag: _tag);
      } else {
        LoggerService.warning('Failed to clear OAuth data', tag: _tag);
      }

      return result;
    } catch (e) {
      LoggerService.error('Error clearing OAuth model: $e', tag: _tag);
      return false;
    }
  }

  /// Clear all SharedPreferences data
  static Future<bool> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      LoggerService.info('Clearing all data from SharedPreferences', tag: _tag);

      final result = await prefs.clear();

      if (result) {
        LoggerService.success(
          'All SharedPreferences data cleared successfully',
          tag: _tag,
        );
      } else {
        LoggerService.warning(
          'Failed to clear all SharedPreferences data',
          tag: _tag,
        );
      }

      return result;
    } catch (e) {
      LoggerService.error(
        'Error clearing all SharedPreferences data: $e',
        tag: _tag,
      );
      return false;
    }
  }
}
