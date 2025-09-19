import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/constants/app_constants.dart';

class EnvironmentService {
  // environment_service.dart
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
    AppConstants.apiBaseUrl = _getRequired('API_BASE_URL');
    AppConstants.aesKey = _getRequired('AES_ENCRYPTION_KEY');
    LoggerService.success('Environment variables loaded successfully');
  }

  // Required
  static String get apiBaseUrl => _getRequired('API_BASE_URL');
  static String get aesKey => _getRequired('AES_ENCRYPTION_KEY');

  static String _getRequired(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing required env: $key');
    }
    return value;
  }
}
