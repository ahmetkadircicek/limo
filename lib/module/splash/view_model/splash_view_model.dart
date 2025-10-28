import 'package:flutter/material.dart';

import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/shared_preferences_service.dart';
import 'package:provider/provider.dart';

class SplashViewModel extends ChangeNotifier {
  /// Initialize splash and authenticate if OAuth data exists
  static Future<bool> initialize(BuildContext context) async {
    try {
      final userProvider = context.read<UserProvider>();
      final savedOAuth = await SharedPreferencesService.getOAuthModel();
      if (savedOAuth == null) {
        return false;
      }

      final user = await ApiService.sendOAuthData(oauthUser: savedOAuth);

      if (user != null) {
        userProvider.setUser(user);
        return true;
      } else {
        await SharedPreferencesService.clearOAuthModel();
        return false;
      }
    } catch (e) {
      await SharedPreferencesService.clearOAuthModel();
      return false;
    }
  }
}
