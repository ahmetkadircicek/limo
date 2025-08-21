import 'package:limo/core/models/user_model.dart';
import 'package:limo/feature/login/models/auth_result.dart';

/// Helper class for AuthResult business logic operations
class AuthResultHelper {
  /// Get safe email with fallback
  static String getSafeEmail(AuthResult result) {
    final hasRealEmail =
        result.email != null &&
        result.email!.isNotEmpty &&
        !result.email!.startsWith('no-email@');

    if (hasRealEmail) return result.email!;
    return 'no-email@${result.provider}.com';
  }

  /// Get safe display name with fallback
  static String getSafeDisplayName(AuthResult result) {
    final hasRealDisplayName =
        result.displayName != null &&
        result.displayName!.isNotEmpty &&
        result.displayName != 'Apple User' &&
        result.displayName != 'Google User';

    if (hasRealDisplayName) return result.displayName!;
    return '${result.provider} User';
  }

  /// Convert AuthResult to UserModel
  /// This creates a temporary user model before backend response
  static UserModel toUserModel(AuthResult result) {
    return UserModel(
      userId: '', // Will be set from backend response
      provider: result.provider,
      providerUserId: result.providerUserId, // Provider'dan gelen ID
      email: getSafeEmail(result),
      userName: getSafeDisplayName(result),
      userPhoto: result.photoUrl,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );
  }
}
