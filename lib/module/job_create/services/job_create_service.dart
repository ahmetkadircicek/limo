import 'package:flutter/material.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/api_result.dart';
import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/models/job_model.dart';
import 'package:provider/provider.dart';

class JobCreateService {
  static const _tag = 'JOB_CREATE_SERVICE';
  static const _endpoint = '/addjobs';

  static Future<ApiResult<Map<String, dynamic>>> submitJob(
    BuildContext context,
    JobModel job,
  ) async {
    final user = context.read<UserProvider>().user;
    if (user == null || (user.accessToken ?? '').isEmpty) {
      LoggerService.error('Missing user or access token', tag: _tag);
      return ApiResult.error('Missing user credentials');
    }

    final body = job.toJson()..['access_token'] = user.accessToken;
    LoggerService.info('CreateJob payload: $body', tag: _tag);

    try {
      final result = await ApiService.post(
        _endpoint,
        data: body,
        accessToken: user.accessToken!,
        timeout: const Duration(seconds: 20),
      );

      if (!result.isSuccess) {
        LoggerService.error('submitJob error: ${result.message}', tag: _tag);
        return ApiResult.error(result.message ?? 'Failed to create job.');
      }

      final response = result.data;

      // Accept any 2xx as success. If backend returns a List, try to extract first Map.
      if (response is Map<String, dynamic>) {
        return ApiResult.success(response);
      }
      if (response is List) {
        Map<String, dynamic> payload = const {};
        if (response.isNotEmpty && response.first is Map) {
          payload = (response.first as Map).cast<String, dynamic>();
        }
        return ApiResult.success(payload);
      }

      // Fallback: still treat as success with empty payload.
      LoggerService.warning(
        'Treating unexpected response type as success: ${response.runtimeType}',
        tag: _tag,
      );
      return ApiResult.success(<String, dynamic>{});
    } catch (e) {
      LoggerService.error('submitJob error: $e', error: e, tag: _tag);
      return ApiResult.error(e.toString());
    }
  }
}
