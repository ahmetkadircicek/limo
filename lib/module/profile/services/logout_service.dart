import 'package:flutter/widgets.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/core/services/shared_preferences_service.dart';

class LogoutService {
  static const _tag = 'LOGOUT_SERVICE';

  static Future<void> logout(BuildContext context) async {
    try {
      await SharedPreferencesService.clearAllData();
      LoggerService.info('Logout successful', tag: _tag);
    } catch (e) {
      LoggerService.error('Logout error: $e', tag: _tag);
      rethrow;
    }
  }
}
