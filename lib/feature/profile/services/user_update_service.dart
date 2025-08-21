import 'package:limo/core/models/user_model.dart';
import 'package:limo/core/services/api_client.dart';
import 'package:limo/core/utils/logger_service.dart';

/// Service for updating user information
class UserUpdateService {
  static const String _tag = 'USER_UPDATE_SERVICE';

  /// Update user information using UserModel
  static Future<Map<String, dynamic>?> updateUser(UserModel userModel) async {
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

      // Check if update was successful
      final hasUserId = response['user_id'] != null;
      final hasUpdatedProvider = response['provider'] == userModel.provider;
      final hasUpdatedProviderUserId =
          response['provider_user_id'] == userModel.providerUserId;
      final hasUpdatedEmail = response['email'] == userModel.email;
      final hasUpdatedPhone = response['phone'] == userModel.phone;
      final hasUpdatedUserName = response['user_name'] == userModel.userName;
      final hasUpdatedCompany =
          response['company_name'] == userModel.companyName;
      final hasUpdatedCreatedAt =
          response['created_at'] == userModel.createdAt.toIso8601String();
      final hasUpdatedLastLogin =
          response['last_login'] == userModel.lastLogin.toIso8601String();
      final hasUpdatedAccessToken =
          response['access_token'] == userModel.accessToken;
      final hasUpdatedIsActive = response['is_active'] == userModel.isActive;
      final hasUpdatedPhoto = response['user_photo'] == userModel.userPhoto;
      final hasUpdatedLicense =
          response['driver_lisans'] == userModel.driverLicense;
      final hasUpdatedApproved = response['approved'] == userModel.approved;

      final success =
          hasUserId &&
          hasUpdatedProvider &&
          hasUpdatedProviderUserId &&
          hasUpdatedEmail &&
          (hasUpdatedPhone || userModel.phone == null) &&
          hasUpdatedUserName &&
          (hasUpdatedCompany || userModel.companyName == null) &&
          hasUpdatedCreatedAt &&
          hasUpdatedLastLogin &&
          hasUpdatedAccessToken &&
          hasUpdatedIsActive &&
          (hasUpdatedPhoto || userModel.userPhoto == null) &&
          (hasUpdatedLicense || userModel.driverLicense == null) &&
          hasUpdatedApproved;

      if (success) {
        LoggerService.success('User update successful', tag: _tag);
        return response;
      } else {
        LoggerService.error('User update failed', tag: _tag);
        return null;
      }
    } catch (error) {
      LoggerService.error(
        'Error during user update: $error',
        error: error,
        tag: _tag,
      );
      return null;
    }
  }
}
