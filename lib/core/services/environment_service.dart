import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/shared/constants/app_constants.dart';

class EnvironmentService {
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');

      final aes = dotenv.env['AES_ENCRYPTION_KEY'];
      AppConstants.aesKey = aes ?? '';

      final api = dotenv.env['API_BASE_URL'];
      AppConstants.apiBaseUrl = api ?? '';

      LoggerService.success('Environment variables loaded successfully');
    } catch (e) {
      LoggerService.error('Failed to load environment variables: $e', error: e);
      rethrow;
    }
  }
}
