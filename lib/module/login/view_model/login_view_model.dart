import 'package:flutter/material.dart';
import 'package:limo/core/providers/oauth_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/core/services/shared_preferences_service.dart';
import 'package:limo/module/login/services/google_auth_service.dart';
import 'package:limo/shared/models/user_model.dart';
import 'package:limo/shared/widgets/app_snackbar.dart';
import 'package:provider/provider.dart';

class LoginViewModel extends ChangeNotifier {
  static const _tag = 'LOGIN_VM';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Google login -> save OAuth -> send to backend -> update UserProvider
  Future<UserModel?> signInWithGoogle(BuildContext context) async {
    try {
      _setLoading(true);

      final oauthProvider = context.read<OAuthProvider>();
      final userProvider = context.read<UserProvider>();

      // 1. Google login
      final oauthUser = await GoogleAuthService.signIn(oauthProvider);
      if (oauthUser == null) {
        AppSnackbar.error(message: 'Google sign-in failed');
        return null;
      }

      // 2. Save OAuth to SharedPreferences
      await SharedPreferencesService.saveOAuthModel(oauthUser);

      // 3. Send OAuth to backend and update UserProvider
      final user = await ApiService.sendOAuthData(oauthUser: oauthUser);

      if (user != null) {
        userProvider.setUser(user);
        LoggerService.success('Login successful', tag: _tag);
        AppSnackbar.success(
          message: 'Login successful, welcome ${user.userName}',
        );
      } else {
        LoggerService.warning('Backend rejected OAuth login', tag: _tag);
        await SharedPreferencesService.clearOAuthModel();
        AppSnackbar.warning(message: 'No user data received from server');
      }

      return user;
    } catch (e, st) {
      LoggerService.error('Login failed: $e', error: e, tag: _tag);
      LoggerService.error('StackTrace: $st', tag: _tag);
      AppSnackbar.error(message: 'An error occurred, please try again');
      return null;
    } finally {
      _setLoading(false);
    }
  }
}
