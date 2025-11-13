import 'package:flutter/material.dart';
import 'package:limo/core/services/car_service.dart';
import 'package:limo/shared/models/car_model.dart';
import 'package:limo/shared/state/async_status.dart';

class CarProvider extends ChangeNotifier {
  List<CarModel> _cars = [];
  List<CarModel> get cars => _cars;

  AsyncStatus _status = AsyncStatus.idle;
  AsyncStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadCars(BuildContext context, {bool force = false}) async {
    if (!force && _cars.isNotEmpty && _status == AsyncStatus.success) {
      return;
    }
    _setStatus(AsyncStatus.loading);
    _errorMessage = null;

    final result = await CarService.getCars(context);

    if (result.isError) {
      _cars = const [];
      _errorMessage = result.message;
      _setStatus(AsyncStatus.error);
      return;
    }

    _cars = result.data ?? const [];
    if (_cars.isEmpty) {
      _setStatus(AsyncStatus.empty);
    } else {
      _setStatus(AsyncStatus.success);
    }
  }

  void clear() {
    _cars = [];
    _errorMessage = null;
    _setStatus(AsyncStatus.idle);
  }

  void _setStatus(AsyncStatus status) {
    _status = status;
    notifyListeners();
  }
}
