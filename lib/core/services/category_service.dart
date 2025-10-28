import 'package:limo/core/services/api_result.dart';
import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/models/category_model.dart';

class CategoryService {
  static const String _tag = 'CATEGORY_SERVICE';

  static Future<ApiResult<List<CategoryModel>>> getCategories({
    required String userId,
    required String accessToken,
  }) async {
    try {
      final data = {'user_id': userId, 'access_token': accessToken};

      final result = await ApiService.post(
        '/getcategory',
        data: data,
        accessToken: accessToken,
      );

      if (!result.isSuccess) {
        LoggerService.error(
          'Failed to fetch categories: ${result.message}',
          tag: _tag,
        );
        return ApiResult.error(result.message ?? 'Failed to fetch categories');
      }

      final response = result.data;

      List<dynamic> categoriesList;
      if (response is List) {
        categoriesList = response;
        LoggerService.info('Direct list response received', tag: _tag);
      } else if (response is Map<String, dynamic>) {
        categoriesList = response['categories'] as List<dynamic>? ?? [];
        LoggerService.info('Map response with categories field', tag: _tag);
      } else {
        throw Exception('Unexpected response type: ${response.runtimeType}');
      }

      final categories =
          categoriesList
              .map(
                (categoryJson) => CategoryModel.fromJson(
                  categoryJson as Map<String, dynamic>,
                ),
              )
              .toList();

      LoggerService.success(
        'Categories fetched successfully: ${categories.length} categories',
        tag: _tag,
      );
      return ApiResult.success(categories);
    } catch (e) {
      LoggerService.error('Failed to fetch categories: $e', tag: _tag);
      return ApiResult.error(e.toString());
    }
  }
}
