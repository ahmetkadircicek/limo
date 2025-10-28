import 'package:limo/core/services/api_result.dart';
import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/models/model_model.dart';

class ModelService {
  static const String _tag = 'MODEL_SERVICE';

  static Future<ApiResult<List<ModelModel>>> getModels({
    required String userId,
    required String accessToken,
    required int brandId,
  }) async {
    try {
      final data = {
        'user_id': userId,
        'access_token': accessToken,
        'brand_id': brandId,
      };

      final result = await ApiService.post(
        '/getmodel',
        data: data,
        accessToken: accessToken,
      );

      if (!result.isSuccess) {
        LoggerService.error(
          'Failed to fetch models: ${result.message}',
          tag: _tag,
        );
        return ApiResult.error(result.message ?? 'Failed to fetch models');
      }

      final response = result.data;

      List<dynamic> modelsList;
      if (response is List) {
        modelsList = response;
        LoggerService.info('Direct list response received', tag: _tag);
      } else if (response is Map<String, dynamic>) {
        modelsList = response['models'] as List<dynamic>? ?? [];
        LoggerService.info('Map response with models field', tag: _tag);
      } else {
        throw Exception('Unexpected response type: ${response.runtimeType}');
      }

      final models =
          modelsList
              .map(
                (modelJson) =>
                    ModelModel.fromJson(modelJson as Map<String, dynamic>),
              )
              .toList();

      LoggerService.success(
        'Models fetched successfully: ${models.length} models for brand $brandId',
        tag: _tag,
      );
      return ApiResult.success(models);
    } catch (e) {
      LoggerService.error('Failed to fetch models: $e', tag: _tag);
      return ApiResult.error(e.toString());
    }
  }
}
