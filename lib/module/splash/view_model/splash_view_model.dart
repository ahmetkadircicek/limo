import 'package:flutter/material.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/job_type_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/shared_preferences_service.dart';
import 'package:limo/shared/models/user_model.dart';
import 'package:provider/provider.dart';

class SplashViewModel extends ChangeNotifier {
  /// Entry point
  static Future<bool> initialize(BuildContext context) async {
    try {
      final userProvider = context.read<UserProvider>();

      final savedOAuth = await _loadSavedOAuth();
      if (savedOAuth == null) return false;

      final user = await _authenticateUser(savedOAuth);
      if (user == null) return false;

      userProvider.setUser(user);

      final currentUser = _validateAccessToken(context);
      if (currentUser == null) return false;

      final preloadSuccess = await _preloadInitialData(context, currentUser);
      return preloadSuccess;
    } catch (_) {
      await SharedPreferencesService.clearOAuthModel();
      return false;
    }
  }

  /// 1) OAuth verisini yükle
  static Future<dynamic> _loadSavedOAuth() async {
    final saved = await SharedPreferencesService.getOAuthModel();
    if (saved == null) {
      await SharedPreferencesService.clearOAuthModel();
      return null;
    }
    return saved;
  }

  /// 2) OAuth’ı backend’e gönder ve kullanıcıyı doğrula
  static Future<UserModel?> _authenticateUser(dynamic savedOAuth) async {
    final user = await ApiService.sendOAuthData(oauthUser: savedOAuth);
    if (user == null) {
      await SharedPreferencesService.clearOAuthModel();
      return null;
    }
    return user;
  }

  /// 3) Token geçerliliğini kontrol et
  static UserModel? _validateAccessToken(BuildContext context) {
    final currentUser = context.read<UserProvider>().user;
    final token = currentUser?.accessToken ?? '';

    if (currentUser == null || token.isEmpty) {
      SharedPreferencesService.clearOAuthModel();
      return null;
    }

    return currentUser;
  }

  /// 4) Markalar / Kategoriler / JobTypes gibi preload datalarını çek
  static Future<bool> _preloadInitialData(
    BuildContext context,
    UserModel currentUser,
  ) async {
    final brandProv = context.read<BrandProvider>();
    final catProv = context.read<CategoryProvider>();
    final jobTypeProv = context.read<JobTypeProvider>();

    try {
      await Future.wait([
        brandProv.fetchBrands(
          userId: currentUser.userId,
          accessToken: currentUser.accessToken!,
        ),
        catProv.fetchCategories(
          userId: currentUser.userId,
          accessToken: currentUser.accessToken!,
        ),
        jobTypeProv.loadJobTypes(context),
      ]);
      return true;
    } catch (_) {
      return false;
    }
  }
}
