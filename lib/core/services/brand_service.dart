import 'package:limo/core/services/api_result.dart';
import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/models/brand_model.dart';

class BrandService {
  static const String _tag = 'BRAND_SERVICE';

  static Future<ApiResult<List<BrandModel>>> getBrands({
    required String userId,
    required String accessToken,
  }) async {
    try {
      final data = {'user_id': userId, 'access_token': accessToken};

      final result = await ApiService.post(
        '/getbrands',
        data: data,
        accessToken: accessToken,
      );

      if (!result.isSuccess) {
        LoggerService.error(
          'Failed to fetch brands: ${result.message}',
          tag: _tag,
        );
        return ApiResult.error(result.message ?? 'Failed to fetch brands');
      }

      final response = result.data;

      List<dynamic> brandsList;

      if (response is List) {
        brandsList = response;
        LoggerService.info('Direct list response received', tag: _tag);
      } else if (response is Map<String, dynamic>) {
        brandsList = response['brands'] as List<dynamic>? ?? [];
        LoggerService.info('Map response with brands field', tag: _tag);
      } else {
        throw Exception('Unexpected response type: ${response.runtimeType}');
      }

      final brands =
          brandsList
              .map(
                (brandJson) =>
                    BrandModel.fromJson(brandJson as Map<String, dynamic>),
              )
              .toList();

      LoggerService.success(
        'Brands fetched successfully: ${brands.length} brands',
        tag: _tag,
      );

      return ApiResult.success(brands);
    } catch (e) {
      LoggerService.error('Failed to fetch brands: $e', tag: _tag);
      return ApiResult.error(e.toString());
    }
  }
}
