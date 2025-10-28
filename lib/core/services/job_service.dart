import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/api_result.dart';
import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/models/job_model.dart';

class JobService {
  static const _tag = 'JOB_SERVICE';
  static const _endpoint = '/getjobs';

  static Future<ApiResult<List<JobModel>>> getJobs(BuildContext context) async {
    final user = context.read<UserProvider>().user;
    if (user == null || (user.accessToken ?? '').isEmpty) {
      return ApiResult.error('You must be signed in to load jobs.');
    }

    final payload = {
      'user_id': user.userId,
      'access_token': user.accessToken,
    };

    try {
      final result = await ApiService.post(
        _endpoint,
        data: payload,
        accessToken: user.accessToken!,
        timeout: const Duration(seconds: 20),
      );

      if (!result.isSuccess) {
        LoggerService.error('getJobs error: ${result.message}', tag: _tag);
        return ApiResult.error(result.message ?? 'Failed to load jobs.');
      }

      final data = result.data;
      List<dynamic> rawJobs;
      if (data is List) {
        rawJobs = data;
      } else if (data is Map && data['data'] is List) {
        rawJobs = data['data'] as List<dynamic>;
      } else {
        LoggerService.error(
          'Unexpected /getjobs response: ${data.runtimeType}',
          tag: _tag,
        );
        return ApiResult.error('Unexpected server response.');
      }

      final jobs = rawJobs
          .whereType<Map>()
          .map(
            (e) => JobModel.fromJson(
              e.cast<String, dynamic>(),
              fallbackUserId: user.userId,
            ),
          )
          .toList();

      return ApiResult.success(jobs);
    } catch (e) {
      LoggerService.error('getJobs exception: $e', tag: _tag, error: e);
      return ApiResult.error('Failed to load jobs.');
    }
  }
}
