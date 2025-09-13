import 'package:google_sign_in/google_sign_in.dart';
import 'package:limo/core/providers/oauth_provider.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/shared/models/oauth_model.dart';

class GoogleAuthService {
  static final _tag = 'GOOGLE_AUTH_SERVICE';
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// Google ile oturum aç ve OAuthProvider'a ekle
  static Future<OAuthModel?> signIn(OAuthProvider oauthProvider) async {
    try {
      final account = await _googleSignIn.authenticate();

      final oauthUser = OAuthModel(
        id: account.id,
        provider: 'google',
        email: account.email,
        displayName: account.displayName ?? 'Google User',
        photoUrl: account.photoUrl,
        isActive: 'true',
      );

      oauthProvider.setUser(oauthUser);

      LoggerService.success('Google Sign-In successful', tag: _tag);
      return oauthUser;
    } catch (e, st) {
      LoggerService.error('Google Sign-In failed: $e', error: e, tag: _tag);
      LoggerService.error('StackTrace: $st', tag: _tag);
      return null;
    }
  }
}
