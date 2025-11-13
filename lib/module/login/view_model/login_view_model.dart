import 'package:flutter/material.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/job_type_provider.dart';
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
  Future<UserModel?> signInWithGoogle(BuildContext context) async {
    try {
      final oauthProvider = context.read<OAuthProvider>();
      final userProvider = context.read<UserProvider>();

      final oauthUser = await _performGoogleSignIn(oauthProvider);
      if (oauthUser == null) return null;

      await _persistOAuth(oauthUser);

      final user = await _sendOAuthToBackend(oauthUser);
      if (user == null) {
        await _handleBackendRejectedLogin();
        return null;
      }

      await _handleSuccessfulLogin(context, userProvider, user);
      return user;
    } catch (e, st) {
      _handleLoginException(e, st);
      return null;
    }
  }

  Future<dynamic> _performGoogleSignIn(OAuthProvider oauthProvider) async {
    final oauthUser = await GoogleAuthService.signIn(oauthProvider);
    if (oauthUser == null) {
      AppSnackbar.error(message: 'Google sign-in failed');
      LoggerService.warning('Google sign-in returned null user');
    }
    return oauthUser;
  }

  Future<void> _persistOAuth(dynamic oauthUser) async {
    await SharedPreferencesService.saveOAuthModel(oauthUser);
    LoggerService.info('OAuth data persisted');
  }

  Future<UserModel?> _sendOAuthToBackend(dynamic oauthUser) async {
    final user = await ApiService.sendOAuthData(oauthUser: oauthUser);
    if (user == null) {
      LoggerService.warning('sendOAuthData returned null user');
    }
    return user;
  }

  Future<void> _handleBackendRejectedLogin() async {
    LoggerService.warning('Backend rejected OAuth login');
    await SharedPreferencesService.clearOAuthModel();
    AppSnackbar.warning(message: 'No user data received from server');
  }

  Future<void> _handleSuccessfulLogin(
    BuildContext context,
    UserProvider userProvider,
    UserModel user,
  ) async {
    userProvider.setUser(user);

    LoggerService.success('Login successful');

    AppSnackbar.success(message: 'Login successful, welcome ${user.userName}');

    _preloadInitialData(context, user);
  }

  Future<void> _preloadInitialData(BuildContext context, UserModel user) async {
    final token = user.accessToken;
    if (token == null || token.isEmpty) return;

    final brandProv = context.read<BrandProvider>();
    final catProv = context.read<CategoryProvider>();
    final jobTypeProv = context.read<JobTypeProvider>();

    try {
      await Future.wait([
        brandProv.fetchBrands(userId: user.userId, accessToken: token),
        catProv.fetchCategories(userId: user.userId, accessToken: token),
        jobTypeProv.loadJobTypes(context),
      ]);
      LoggerService.info('Preload common data completed');
    } catch (e, st) {
      LoggerService.error('Preload common data failed: $e', error: e);
      LoggerService.error('Preload stackTrace: $st');
    }
  }

  void _handleLoginException(Object e, StackTrace st) {
    LoggerService.error('Login failed: $e', error: e);
    LoggerService.error('StackTrace: $st');
    AppSnackbar.error(message: 'An error occurred, please try again');
  }
}
