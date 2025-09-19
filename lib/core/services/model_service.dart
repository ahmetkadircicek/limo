import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/models/model_model.dart';

class ModelService {
  static const String _tag = 'MODEL_SERVICE';

  static Future<List<ModelModel>> getModels({
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

      final response = await ApiService.post(
        '/getmodel',
        data: data,
        accessToken: accessToken,
      );

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

      final models = modelsList
          .map((modelJson) => ModelModel.fromJson(modelJson as Map<String, dynamic>))
          .toList();

      LoggerService.success(
        'Models fetched successfully: ${models.length} models for brand $brandId',
        tag: _tag,
      );
      return models;
    } catch (e) {
      LoggerService.error('Failed to fetch models: $e', tag: _tag);
      rethrow;
    }
  }
}


