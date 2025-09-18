import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:limo/core/services/logger_service.dart';

class EnvironmentService {
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');

      LoggerService.success('Environment variables loaded successfully');
    } catch (e) {
      LoggerService.error('Failed to load environment variables: $e', error: e);
      rethrow;
    }
  }

  // Required
  static String get apiBaseUrl => _getRequired('API_BASE_URL');
  static String get appVersion => _getRequired('APP_VERSION');

  // Optional
  static String? get mapsKey => _getOptional('MAPS_KEY');
  static String? get sentryDsn => _getOptional('SENTRY_DSN');
  static String? get cdnUrl => _getOptional('CDN_URL');

  static String _getRequired(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing required env: $key');
    }
    return value;
  }

  static String? _getOptional(String key) {
    final value = dotenv.env[key];
    return (value == null || value.isEmpty) ? null : value;
  }
}
