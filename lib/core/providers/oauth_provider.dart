import 'package:flutter/foundation.dart';
import 'package:limo/shared/models/oauth_model.dart';

class OAuthProvider extends ChangeNotifier {
  OAuthModel? _oauthUser;

  OAuthModel? get oauthUser => _oauthUser;

  bool get hasUser => _oauthUser != null;

  /// Set OAuth user (e.g., after Google Sign-In)
  void setUser(OAuthModel user) {
    _oauthUser = user;
    notifyListeners();
  }

  /// Update existing OAuth user
  void updateUser(OAuthModel updatedUser) {
    _oauthUser = updatedUser;
    notifyListeners();
  }

  /// Clear OAuth user (sign out)
  void clearUser() {
    _oauthUser = null;
    notifyListeners();
  }
}
