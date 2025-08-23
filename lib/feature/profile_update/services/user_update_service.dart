import 'package:limo/core/models/user_model.dart';
import 'package:limo/core/services/api_client.dart';
import 'package:limo/core/utils/logger_service.dart';

/// Service for updating user information
class UserUpdateService {
  static const String _tag = 'USER_UPDATE_SERVICE';

  /// Update user profile information
  Future<bool> updateUser(UserModel userModel) async {
    try {
      LoggerService.info('Starting user update process', tag: _tag);

      final requestData = {
        'user_id': userModel.userId,
        'provider': userModel.provider,
        'provider_user_id': userModel.providerUserId,
        'email': userModel.email,
        'phone': userModel.phone,
        'user_name': userModel.userName,
        'company_name': userModel.companyName,
        'created_at': userModel.createdAt.toIso8601String(),
        'last_login': userModel.lastLogin.toIso8601String(),
        'access_token': userModel.accessToken,
        'is_active': userModel.isActive,
        'driver_lisans': userModel.driverLicense,
        'approved': userModel.approved,
        'user_photo': userModel.userPhoto,
      };

      final response = await ApiClient.post(
        '/user_update',
        data: requestData,
        timeout: const Duration(seconds: 15),
      );

      // Check if update was successful - be more lenient with validation
      // Just check if we got a response with user_id (basic success indicator)
      final hasUserId = response['user_id'] != null;

      // Log the response for debugging
      LoggerService.info(
        'Backend response: ${response.keys.join(', ')}',
        tag: _tag,
      );

      // Consider it successful if we have a user_id in response
      final success = hasUserId;

      if (success) {
        LoggerService.success('User update successful', tag: _tag);
        return true;
      } else {
        LoggerService.error('User update failed', tag: _tag);
        return false;
      }
    } catch (error) {
      LoggerService.error(
        'Error during user update: $error',
        error: error,
        tag: _tag,
      );
      return false;
    }
  }
}
