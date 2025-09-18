import 'package:flutter/material.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/api_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/models/car_model.dart';
import 'package:provider/provider.dart';

class CarService {
  static const _tag = 'ADD_CAR_SERVICE';

  static Future<bool> addCar(
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
        return false;
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

      final res = await ApiService.post(
        '/addcars',
        data: body,
        accessToken: user.accessToken!,
        timeout: const Duration(seconds: 15),
      );

      if (res is Map<String, dynamic>) {
        final ok = (res['success'] == true) || (res['car_id'] != null);
        LoggerService.info(
          'AddCar response keys: ${res.keys.join(', ')}',
          tag: _tag,
        );
        return ok;
      }

      LoggerService.error('Unexpected response: ${res.runtimeType}', tag: _tag);
      return false;
    } catch (e) {
      LoggerService.error('AddCar error: $e', error: e, tag: _tag);
      return false;
    }
  }

  static Future<List<CarModel>> getCars(BuildContext context) async {
    final user = context.read<UserProvider>().user;
    if (user == null || (user.accessToken ?? '').isEmpty) return [];

    final body = {'user_id': user.userId, 'access_token': user.accessToken};

    try {
      final res = await ApiService.post(
        '/getcars',
        data: body,
        accessToken: user.accessToken!,
        timeout: const Duration(seconds: 15),
      );

      if (res is List) {
        return res
            .whereType<Map>()
            .map((e) => CarModel.fromJson(e.cast()))
            .toList();
      }
      if (res is Map && res['data'] is List) {
        final list = (res['data'] as List).whereType<Map>();
        return list.map((e) => CarModel.fromJson(e.cast())).toList();
      }

      LoggerService.error(
        'Unexpected /getcars response: ${res.runtimeType}',
        tag: _tag,
      );
      return [];
    } catch (e) {
      LoggerService.error('getCars error: $e', tag: _tag, error: e);
      return [];
    }
  }

  static Future<bool> deleteCar(
    BuildContext context, {
    required int carsId,
  }) async {
    final user = context.read<UserProvider>().user;
    if (user == null || (user.accessToken ?? '').isEmpty) return false;

    final body = {
      'cars_id': carsId,
      'user_id': user.userId,
      'access_token': user.accessToken,
    };

    try {
      final res = await ApiService.post(
        '/deletecars',
        data: body,
        accessToken: user.accessToken!,
        timeout: const Duration(seconds: 15),
      );

      if (res is Map<String, dynamic>) {
        return res['success'] == true;
      }

      return false;
    } catch (e) {
      LoggerService.error('deleteCar error: $e', error: e, tag: _tag);
      return false;
    }
  }
}


