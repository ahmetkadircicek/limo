import 'package:flutter/material.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/api_result.dart';
import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/models/job_type_model.dart';
import 'package:provider/provider.dart';

class JobTypeService {
  static const _tag = 'JOB_TYPE_SERVICE';

  static Future<ApiResult<List<JobTypeModel>>> getJobTypes(
    BuildContext context,
  ) async {
    final user = context.read<UserProvider>().user;
    if (user == null || (user.accessToken ?? '').isEmpty) {
      return ApiResult.error('Missing user credentials');
    }

    final body = {'user_id': user.userId, 'access_token': user.accessToken};

    try {
      final result = await ApiService.post(
        '/getjobtype',
        data: body,
        accessToken: user.accessToken!,
        timeout: const Duration(seconds: 15),
      );

      if (!result.isSuccess) {
        LoggerService.error('getJobTypes error: ${result.message}', tag: _tag);
        return ApiResult.error(result.message ?? 'Failed to fetch job types');
      }

      final res = result.data;

      if (res is List) {
        final types =
            res
                .whereType<Map>()
                .map((e) => JobTypeModel.fromJson(e.cast<String, dynamic>()))
                .toList();
        if (types.isEmpty) {
          return ApiResult.success(const []);
        }
        return ApiResult.success(types);
      }

      if (res is Map && res['data'] is List) {
        final types =
            (res['data'] as List)
                .whereType<Map>()
                .map((e) => JobTypeModel.fromJson(e.cast<String, dynamic>()))
                .toList();
        return ApiResult.success(types);
      }

      LoggerService.error(
        'Unexpected /getjobtype response: ${res.runtimeType}',
        tag: _tag,
      );
      return ApiResult.error('Unexpected server response');
    } catch (e) {
      LoggerService.error('getJobTypes error: $e', tag: _tag, error: e);
      return ApiResult.error(e.toString());
    }
  }
}
