import 'package:flutter/material.dart';
import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/shared_preferences_service.dart';

class SplashViewModel extends ChangeNotifier {
  /// Initialize splash and authenticate if OAuth data exists
  static Future<bool> initialize(BuildContext context) async {
    try {
      final savedOAuth = await SharedPreferencesService.getOAuthModel();
      if (savedOAuth == null) {
        return false;
      }

      if (!context.mounted) return false;

      final user = await ApiService.sendOAuthData(
        oauthUser: savedOAuth,
        context: context,
      );

      if (user != null) {
        return true;
      } else {
        await SharedPreferencesService.clearOAuthModel();
        return false;
      }
    } catch (e, st) {
      await SharedPreferencesService.clearOAuthModel();
      return false;
    }
  }
}
