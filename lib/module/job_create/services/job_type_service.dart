import 'package:flutter/material.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/models/job_type_model.dart';
import 'package:provider/provider.dart';

class JobTypeService {
  static const _tag = 'JOB_TYPE_SERVICE';

  static Future<List<JobTypeModel>> getJobTypes(BuildContext context) async {
    final user = context.read<UserProvider>().user;
    if (user == null || (user.accessToken ?? '').isEmpty) return [];

    final body = {'user_id': user.userId, 'access_token': user.accessToken};

    try {
      final res = await ApiService.post(
        '/getjobtype',
        data: body,
        accessToken: user.accessToken!,
        timeout: const Duration(seconds: 15),
      );

      if (res is List) {
        return res
            .whereType<Map>()
            .map((e) => JobTypeModel.fromJson(e.cast<String, dynamic>()))
            .toList();
      }

      if (res is Map && res['data'] is List) {
        return (res['data'] as List)
            .whereType<Map>()
            .map((e) => JobTypeModel.fromJson(e.cast<String, dynamic>()))
            .toList();
      }

      LoggerService.error(
        'Unexpected /getjobtype response: ${res.runtimeType}',
        tag: _tag,
      );
      return [];
    } catch (e) {
      LoggerService.error('getJobTypes error: $e', tag: _tag, error: e);
      return [];
    }
  }
}


