import 'package:flutter/material.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/api_result.dart';
import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:provider/provider.dart';

class UserService {
  static const String _tag = 'USER_UPDATE_SERVICE';

  /// Update user profile. Only non-null parameters are sent to backend.
  static Future<ApiResult<Map<String, dynamic>>> updateUser(
    BuildContext context, {
    String? userName,
    String? email,
    String? phone,
    String? companyName,
    String? driverLicence,
    bool? approved,
    String? userPhoto,
  }) async {
    try {
      LoggerService.info('Starting user update process', tag: _tag);

      // Get current user from provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.user;
      if (currentUser == null) {
        LoggerService.error('No current user found', tag: _tag);
        return ApiResult.error('No current user found');
      }

      // Prepare request data with fallback to current user
      final requestData = <String, dynamic>{
        'user_id': currentUser.userId,
        'provider': currentUser.provider,
        'provider_user_id': currentUser.providerUserId,
        'user_name': userName ?? currentUser.userName,
        'email': email ?? currentUser.email,
        'phone': phone ?? currentUser.phone,
        'company_name': companyName ?? currentUser.companyName,
        'created_at': currentUser.createdAt,
        'last_login': currentUser.lastLogin,
        'is_active': currentUser.isActive,
        'access_token': currentUser.accessToken,
        'driver_lisans': driverLicence ?? currentUser.driverLicense,
        'approved': approved ?? currentUser.approved,
        'user_photo': userPhoto ?? currentUser.userPhoto,
      };

      final result = await ApiService.post(
        '/user_update',
        data: requestData,
        accessToken: currentUser.accessToken ?? '',
        timeout: const Duration(seconds: 15),
      );

      if (!result.isSuccess) {
        LoggerService.error('User update failed: ${result.message}', tag: _tag);
        return ApiResult.error(result.message ?? 'Failed to update user');
      }

      final response = result.data;

      if (response is Map<String, dynamic>) {
        final success = response['user_id'] != null;

        if (success) {
          LoggerService.success('User update successful', tag: _tag);
        } else {
          LoggerService.error('User update failed', tag: _tag);
        }

        LoggerService.info(
          'Backend response keys: ${response.keys.join(', ')}',
          tag: _tag,
        );

        if (success) {
          return ApiResult.success(response);
        }
        return ApiResult.error('User update failed');
      } else {
        LoggerService.error(
          'Unexpected response type: ${response.runtimeType}',
          tag: _tag,
        );
        return ApiResult.error('Unexpected response type');
      }
    } catch (error) {
      LoggerService.error(
        'Error during user update: $error',
        error: error,
        tag: _tag,
      );
      return ApiResult.error(error.toString());
    }
  }
}
