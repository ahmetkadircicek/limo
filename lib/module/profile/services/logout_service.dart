import 'package:limo/core/providers/oauth_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/core/services/shared_preferences_service.dart';

class LogoutService {
  static const _tag = 'LOGOUT_SERVICE';

  static Future<void> logout(context) async {
    try {
      await SharedPreferencesService.clearAllData();
      context.read<OAuthProvider>().clear();
      context.read<UserProvider>().clear();
      LoggerService.info('Logout successful', tag: _tag);
    } catch (e) {
      LoggerService.error('Logout error: $e', tag: _tag);
      rethrow;
    }
  }
}
