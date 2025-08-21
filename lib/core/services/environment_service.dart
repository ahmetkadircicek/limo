import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:limo/core/utils/logger_service.dart';

/// Service for managing environment variables and configuration
/// Loads sensitive data from .env file to keep it out of source code
class EnvironmentService {
  static const String _tag = 'ENVIRONMENT_SERVICE';
  static bool _isInitialized = false;

  /// Initialize environment service by loading .env file
  /// Must be called before using any other methods
  static Future<void> initialize() async {
    try {
      LoggerService.info('Loading environment configuration...', tag: _tag);
      await _buildLoadEnvFile();
      _isInitialized = true;
      LoggerService.success(
        'Environment configuration loaded successfully',
        tag: _tag,
      );
      _buildLogConfiguration();
    } catch (e) {
      LoggerService.error(
        'Failed to load environment configuration: $e',
        error: e,
        tag: _tag,
      );
      LoggerService.warning('Using default configuration values', tag: _tag);
      _isInitialized = true;
    }
  }

  /// Check if environment service is initialized
  static bool get isInitialized => _isInitialized;

  /// Get environment variable with optional default value
  static String get(String key, {String defaultValue = ''}) {
    if (!_isInitialized) {
      LoggerService.warning(
        'Environment service not initialized, using default value for $key',
        tag: _tag,
      );
      return defaultValue;
    }
    return dotenv.env[key] ?? defaultValue;
  }

  /// Get environment variable as bool
  static bool getBool(String key, {bool defaultValue = false}) {
    final value = get(key, defaultValue: defaultValue.toString()).toLowerCase();
    return value == 'true' || value == '1' || value == 'yes';
  }

  /// Get environment variable as int
  static int getInt(String key, {int defaultValue = 0}) {
    final value = get(key, defaultValue: defaultValue.toString());
    return int.tryParse(value) ?? defaultValue;
  }

  /// Get environment variable as double
  static double getDouble(String key, {double defaultValue = 0.0}) {
    final value = get(key, defaultValue: defaultValue.toString());
    return double.tryParse(value) ?? defaultValue;
  }

  /// Get environment variable as list (comma-separated)
  static List<String> getList(
    String key, {
    List<String> defaultValue = const [],
  }) {
    final value = get(key);
    if (value.isEmpty) return defaultValue;
    return value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  // =============================================================================
  // ENCRYPTION CONFIGURATION
  // =============================================================================

  /// Get AES encryption key
  static String get aesEncryptionKey => get('AES_ENCRYPTION_KEY');

  // =============================================================================
  // GOOGLE SERVICES CONFIGURATION
  // =============================================================================

  /// Get Google Client ID for OAuth
  static String get googleClientId => get('GOOGLE_CLIENT_ID');

  /// Get Google Maps API Key
  static String get googleMapsApiKey => get('GOOGLE_MAPS_API_KEY');

  /// Get Google Sign-In URL Scheme (for iOS callback)
  static String get googleSignInUrlScheme => get('GOOGLE_SIGN_IN_URL_SCHEME');

  // =============================================================================
  // APPLE SERVICES CONFIGURATION
  // =============================================================================

  /// Get Apple Service ID
  static String get appleServiceId => get('APPLE_SERVICE_ID');

  // =============================================================================
  // FIREBASE CONFIGURATION
  // =============================================================================

  /// Get Firebase Project Number
  static String get firebaseProjectNumber => get('FIREBASE_PROJECT_NUMBER');

  /// Get Firebase Project ID
  static String get firebaseProjectId => get('FIREBASE_PROJECT_ID');

  /// Get Firebase Storage Bucket
  static String get firebaseStorageBucket => get('FIREBASE_STORAGE_BUCKET');

  /// Get Android App ID
  static String get androidAppId => get('ANDROID_APP_ID');

  /// Get Package Name
  static String get packageName => get('PACKAGE_NAME');

  /// Get Reversed Client ID
  static String get reversedClientId => get('REVERSED_CLIENT_ID');

  /// Get Bundle ID
  static String get bundleId => get('BUNDLE_ID');

  /// Get API base URL
  static String get apiBaseUrl =>
      get('API_BASE_URL', defaultValue: 'https://api.example.com');

  /// Get API timeout in milliseconds
  static int get apiTimeout => getInt('API_TIMEOUT', defaultValue: 30000);

  /// Get API version
  static String get apiVersion => get('API_VERSION', defaultValue: 'v1');

  // =============================================================================
  // UTILITY METHODS
  // =============================================================================

  /// Load .env file from assets
  static Future<void> _buildLoadEnvFile() async {
    await dotenv.load(fileName: '.env');
  }

  /// Log non-sensitive configuration for debugging
  static void _buildLogConfiguration() {
    LoggerService.info('=== Environment Configuration ===', tag: _tag);
    LoggerService.info('API Base URL: $apiBaseUrl', tag: _tag);
    LoggerService.info('API Version: $apiVersion', tag: _tag);
    LoggerService.info('API Timeout: ${apiTimeout}ms', tag: _tag);
    _buildLogGoogleConfig();
    LoggerService.info('=== End Configuration ===', tag: _tag);
  }

  /// Log Google configuration status
  static void _buildLogGoogleConfig() {
    final hasGoogleClientId = googleClientId.isNotEmpty;
    final hasGoogleMapsApiKey = googleMapsApiKey.isNotEmpty;
    final hasGoogleSignInUrlScheme = googleSignInUrlScheme.isNotEmpty;

    LoggerService.info(
      'Google Client ID: ${hasGoogleClientId ? "✓ Loaded" : "✗ Missing"}',
      tag: _tag,
    );
    LoggerService.info(
      'Google Maps API Key: ${hasGoogleMapsApiKey ? "✓ Loaded" : "✗ Missing"}',
      tag: _tag,
    );
    LoggerService.info(
      'Google Sign-In URL Scheme: ${hasGoogleSignInUrlScheme ? "✓ Loaded" : "✗ Missing"}',
      tag: _tag,
    );
  }

  /// Get all environment variables (for debugging - excludes sensitive data)
  static Map<String, String> getAllNonSensitive() {
    if (!_isInitialized) return {};

    const sensitiveKeys = [
      'AES_ENCRYPTION_KEY',
      'JWT_SECRET',
      'GOOGLE_CLIENT_ID',
      'GOOGLE_MAPS_API_KEY',
      'GOOGLE_SIGN_IN_URL_SCHEME',
      'APPLE_SERVICE_ID',
      'LOCAL_DB_ENCRYPTION_KEY',
      'FIREBASE_PROJECT_NUMBER',
      'FIREBASE_PROJECT_ID',
      'FIREBASE_STORAGE_BUCKET',
      'ANDROID_APP_ID',
      'PACKAGE_NAME',
      'REVERSED_CLIENT_ID',
      'BUNDLE_ID',
    ];

    final allEnv = Map<String, String>.from(dotenv.env);
    _buildHideSensitiveData(allEnv, sensitiveKeys);
    return allEnv;
  }

  /// Hide sensitive data in environment variables map
  static void _buildHideSensitiveData(
    Map<String, String> envMap,
    List<String> sensitiveKeys,
  ) {
    for (final key in sensitiveKeys) {
      if (envMap.containsKey(key)) {
        envMap[key] = '***HIDDEN***';
      }
    }
  }

  /// Validate required environment variables
  static bool validateRequired() {
    final requiredKeys = ['AES_ENCRYPTION_KEY', 'API_BASE_URL'];
    final missingKeys = _buildGetMissingKeys(requiredKeys);

    if (missingKeys.isNotEmpty) {
      LoggerService.error(
        'Missing required environment variables: ${missingKeys.join(', ')}',
        tag: _tag,
      );
      return false;
    }

    LoggerService.success(
      'All required environment variables are present',
      tag: _tag,
    );
    return true;
  }

  /// Get list of missing required environment variables
  static List<String> _buildGetMissingKeys(List<String> requiredKeys) {
    final missingKeys = <String>[];
    for (final key in requiredKeys) {
      if (get(key).isEmpty) {
        missingKeys.add(key);
      }
    }
    return missingKeys;
  }
}
