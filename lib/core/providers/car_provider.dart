import 'package:flutter/material.dart';
import 'package:limo/core/services/car_service.dart';
import 'package:limo/shared/models/car_model.dart';

class CarProvider extends ChangeNotifier {
  List<CarModel> _cars = [];
  List<CarModel> get cars => _cars;
  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadCars(BuildContext context) async {
    _loading = true;
    notifyListeners();
    final list = await CarService.getCars(context);
    _cars = list;
    _loading = false;
    notifyListeners();
  }

  void clear() {
    _cars = [];
    notifyListeners();
  }
}
