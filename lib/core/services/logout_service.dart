import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/model_provider.dart';
import 'package:limo/core/providers/oauth_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/shared_preferences_service.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:provider/provider.dart';

class LogoutService {
  static const String _tag = 'LOGOUT_SERVICE';

  /// Complete logout process - clear all data and providers
  static Future<void> logout(BuildContext context) async {
    try {
      LoggerService.info('Starting logout process...', tag: _tag);

      // 1. Clear all providers
      await _clearAllProviders(context);

      // 2. Clear SharedPreferences
      await _clearSharedPreferences();

      // 3. Sign out from Google
      await _signOutFromGoogle();

      LoggerService.success('Logout completed successfully', tag: _tag);
    } catch (e, st) {
      LoggerService.error('Error during logout: $e', error: e, tag: _tag);
      LoggerService.error('StackTrace: $st', tag: _tag);
    }
  }

  /// Clear all ChangeNotifier providers
  static Future<void> _clearAllProviders(BuildContext context) async {
    try {
      // Clear OAuth provider
      final oauthProvider = Provider.of<OAuthProvider>(context, listen: false);
      oauthProvider.clearUser();

      // Clear User provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.clearUser();

      // Clear Brand provider
      final brandProvider = Provider.of<BrandProvider>(context, listen: false);
      brandProvider.clearBrands();

      // Clear Category provider
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );
      categoryProvider.clearCategories();

      // Clear Model provider
      final modelProvider = Provider.of<ModelProvider>(context, listen: false);
      modelProvider.clearModels();

      LoggerService.info('All providers cleared successfully', tag: _tag);
    } catch (e) {
      LoggerService.error('Error clearing providers: $e', tag: _tag);
    }
  }

  /// Clear all SharedPreferences data
  static Future<void> _clearSharedPreferences() async {
    try {
      await SharedPreferencesService.clearAllData();

      LoggerService.info('SharedPreferences cleared successfully', tag: _tag);
    } catch (e) {
      LoggerService.error('Error clearing SharedPreferences: $e', tag: _tag);
    }
  }

  /// Sign out from Google services
  static Future<void> _signOutFromGoogle() async {
    try {
      // Google Sign-In instance'ından çıkış yap
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.signOut();

      LoggerService.info('Google Sign-Out completed', tag: _tag);
    } catch (e) {
      LoggerService.error('Error during Google Sign-Out: $e', tag: _tag);
    }
  }
}
