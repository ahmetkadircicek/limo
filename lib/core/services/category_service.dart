import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/shared/models/category_model.dart';

class CategoryService {
  static const String _tag = 'CATEGORY_SERVICE';

  /// Get categories list from API
  static Future<List<CategoryModel>> getCategories({
    required String userId,
    required String accessToken,
  }) async {
    try {
      final data = {'user_id': userId, 'access_token': accessToken};

      final response = await ApiService.post(
        '/getcategory',
        data: data,
        accessToken: accessToken,
      );

      // Response'u kontrol et - List veya Map olabilir
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

      return categories;
    } catch (e) {
      LoggerService.error('Failed to fetch categories: $e', tag: _tag);
      rethrow;
    }
  }
}
