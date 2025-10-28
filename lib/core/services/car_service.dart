import 'package:flutter/material.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/api_result.dart';
import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/models/car_model.dart';
import 'package:provider/provider.dart';

class CarService {
  static const _tag = 'ADD_CAR_SERVICE';

  static Future<ApiResult<Map<String, dynamic>>> addCar(
    BuildContext context, {
    required String plateNumber,
    required int brandId,
    required int modelId,
    required int categoryId,
    required int modelYear,
    required int capacity,
  }) async {
    try {
      final user = context.read<UserProvider>().user;
      if (user == null || (user.accessToken ?? '').isEmpty) {
        LoggerService.error('No user or accessToken', tag: _tag);
        return ApiResult.error('Missing user credentials');
      }

      final body = {
        'platenumber': plateNumber,
        'brand_id': brandId,
        'model_id': modelId,
        'category_id': categoryId,
        'modelyear': modelYear,
        'capacity': capacity,
        'access_token': user.accessToken!,
        'user_id': user.userId,
      };

      final result = await ApiService.post(
        '/addcars',
        data: body,
        accessToken: user.accessToken!,
        timeout: const Duration(seconds: 15),
      );

      if (!result.isSuccess) {
        LoggerService.error('AddCar error: ${result.message}', tag: _tag);
        return ApiResult.error(result.message ?? 'Failed to add car');
      }

      final res = result.data;

      if (res is Map<String, dynamic>) {
        final ok = (res['success'] == true) || (res['car_id'] != null);
        LoggerService.info(
          'AddCar response keys: ${res.keys.join(', ')}',
          tag: _tag,
        );
        if (ok) {
          return ApiResult.success(res);
        }
        return ApiResult.error('Unexpected server response');
      }

      LoggerService.error('Unexpected response: ${res.runtimeType}', tag: _tag);
      return ApiResult.error('Unexpected server response');
    } catch (e) {
      LoggerService.error('AddCar error: $e', error: e, tag: _tag);
      return ApiResult.error(e.toString());
    }
  }

  static Future<ApiResult<List<CarModel>>> getCars(BuildContext context) async {
    final user = context.read<UserProvider>().user;
    if (user == null || (user.accessToken ?? '').isEmpty) {
      return ApiResult.error('You must be signed in to load cars.');
    }

    final body = {'user_id': user.userId, 'access_token': user.accessToken};

    try {
      final result = await ApiService.post(
        '/getcars',
        data: body,
        accessToken: user.accessToken!,
        timeout: const Duration(seconds: 15),
      );

      if (!result.isSuccess) {
        LoggerService.error('getCars error: ${result.message}', tag: _tag);
        return ApiResult.error(result.message ?? 'Failed to load cars.');
      }

      final res = result.data;

      if (res is List) {
        final cars =
            res
                .whereType<Map>()
                .map((e) => CarModel.fromJson(e.cast()))
                .toList();
        return ApiResult.success(cars);
      }
      if (res is Map && res['data'] is List) {
        final list = (res['data'] as List).whereType<Map>();
        final cars = list.map((e) => CarModel.fromJson(e.cast())).toList();
        return ApiResult.success(cars);
      }

      LoggerService.error(
        'Unexpected /getcars response: ${res.runtimeType}',
        tag: _tag,
      );
      return ApiResult.error('Unexpected server response.');
    } catch (e) {
      LoggerService.error('getCars error: $e', tag: _tag, error: e);
      return ApiResult.error('Failed to load cars.');
    }
  }

  static Future<ApiResult<Map<String, dynamic>>> deleteCar(
    BuildContext context, {
    required int carsId,
  }) async {
    final user = context.read<UserProvider>().user;
    if (user == null || (user.accessToken ?? '').isEmpty) {
      return ApiResult.error('Missing user credentials');
    }

    final body = {
      'cars_id': carsId,
      'user_id': user.userId,
      'access_token': user.accessToken,
    };

    try {
      final result = await ApiService.post(
        '/deletecars',
        data: body,
        accessToken: user.accessToken!,
        timeout: const Duration(seconds: 15),
      );

      if (!result.isSuccess) {
        LoggerService.error('deleteCar error: ${result.message}', tag: _tag);
        return ApiResult.error(result.message ?? 'Failed to delete car');
      }

      final res = result.data;

      if (res is Map<String, dynamic>) {
        final success = res['success'] == true;
        if (success) {
          return ApiResult.success(res);
        }
        return ApiResult.error('Car could not be deleted');
      }

      return ApiResult.error('Unexpected server response');
    } catch (e) {
      LoggerService.error('deleteCar error: $e', error: e, tag: _tag);
      return ApiResult.error(e.toString());
    }
  }
}
