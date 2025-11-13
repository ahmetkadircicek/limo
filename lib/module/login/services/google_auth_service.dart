import 'package:google_sign_in/google_sign_in.dart';
import 'package:limo/core/providers/oauth_provider.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/models/oauth_model.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static Future<OAuthModel?> signIn(OAuthProvider oauthProvider) async {
    try {
      final account = await _authenticate();
      if (account == null) {
        _handleSignInFailure();
        return null;
      }

      final oauthUser = _buildOAuthModel(account);
      _updateProvider(oauthProvider, oauthUser);
      _logSuccess();

      return oauthUser;
    } catch (e, st) {
      _handleSignInException(e, st);
      return null;
    }
  }

  static Future<GoogleSignInAccount?> _authenticate() async {
    return await _googleSignIn.authenticate();
  }

  static OAuthModel _buildOAuthModel(GoogleSignInAccount account) {
    return OAuthModel(
      id: account.id,
      provider: 'google',
      email: account.email,
      displayName: account.displayName ?? 'Google User',
      photoUrl: account.photoUrl,
      isActive: 'true',
    );
  }

  static void _updateProvider(
    OAuthProvider oauthProvider,
    OAuthModel oauthUser,
  ) {
    oauthProvider.setUser(oauthUser);
  }

  static void _logSuccess() {
    LoggerService.success('Google Sign-In successful');
  }

  static void _handleSignInFailure() {
    LoggerService.warning('Google Sign-In returned null account');
  }

  static void _handleSignInException(Object e, StackTrace st) {
    LoggerService.error('Google Sign-In failed: $e', error: e);
    LoggerService.error('StackTrace: $st');
  }
}
