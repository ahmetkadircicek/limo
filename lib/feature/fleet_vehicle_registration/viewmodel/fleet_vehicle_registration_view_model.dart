import 'package:flutter/material.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/feature/fleet_vehicle_registration/services/fleet_vehicle_registration_service.dart';
import 'package:limo/feature/job_vehicle_registration/model/vehicle_model.dart';

class FleetVehicleRegistrationViewModel extends ChangeNotifier {
  static const String _tag = 'FleetVehicleRegistrationViewModel';

  final FleetVehicleRegistrationService _service =
      FleetVehicleRegistrationService();

  // Form controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController modelController = TextEditingController();

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Selected values for dropdowns
  String? _selectedBrand;
  int? _selectedModelYear;
  int? _selectedCapacity;
  String? _selectedBodyType;
  String? _selectedCategory;

  String? get selectedBrand => _selectedBrand;
  int? get selectedModelYear => _selectedModelYear;
  int? get selectedCapacity => _selectedCapacity;
  String? get selectedBodyType => _selectedBodyType;
  String? get selectedCategory => _selectedCategory;

  // Dropdown options
  List<String> get brandOptions => [
    'Audi',
    'BMW',
    'Fiat',
    'Ford',
    'Mercedes-Benz',
    'Nissan',
    'Peugeot',
    'Renault',
    'Toyota',
    'Volkswagen',
  ];

  List<int> get modelYearOptions =>
      List.generate(15, (index) => DateTime.now().year - index);

  List<int> get capacityOptions => [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    12,
    15,
    20,
    25,
    30,
  ];

  List<String> get bodyTypeOptions => [
    'Bus',
    'Convertible',
    'Coupe',
    'Hatchback',
    'Minibus',
    'Pickup',
    'Sedan',
    'Station Wagon',
    'SUV',
    'Van',
  ];

  List<String> get categoryOptions => [
    'ECONOMY',
    'STANDARD',
    'PREMIUM',
    'LUXURY',
  ];

  // Setters for dropdown values
  void setSelectedBrand(String? value) {
    _selectedBrand = value;
    notifyListeners();
  }

  void setSelectedModelYear(int? value) {
    _selectedModelYear = value;
    notifyListeners();
  }

  void setSelectedCapacity(int? value) {
    _selectedCapacity = value;
    notifyListeners();
  }

  void setSelectedBodyType(String? value) {
    _selectedBodyType = value;
    notifyListeners();
  }

  void setSelectedCategory(String? value) {
    _selectedCategory = value;
    notifyListeners();
  }

  // Pre-fill form for editing
  void initializeForEdit(VehicleModel vehicle) {
    plateNumberController.text = vehicle.licencePlate;
    _selectedBrand = vehicle.brand;
    modelController.text = vehicle.model;
    _selectedModelYear = vehicle.year;
    _selectedCapacity = vehicle.capacity;
    _selectedBodyType = vehicle.vehicleType;
    _selectedCategory = vehicle.category.name;
    notifyListeners();
  }

  // Submit vehicle
  Future<bool> submitVehicle() async {
    if (!formKey.currentState!.validate()) {
      LoggerService.error('Form validation failed', tag: _tag);
      return false;
    }

    if (_selectedBrand == null ||
        _selectedModelYear == null ||
        _selectedCapacity == null ||
        _selectedBodyType == null ||
        _selectedCategory == null) {
      LoggerService.error('Dropdown selections incomplete', tag: _tag);
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final vehicleData = {
        'plateNumber': plateNumberController.text,
        'brand': _selectedBrand!,
        'model': modelController.text,
        'modelYear': _selectedModelYear!,
        'capacity': _selectedCapacity!,
        'bodyType': _selectedBodyType!,
        'category': _selectedCategory!,
      };

      await _service.submitVehicle(vehicleData);
      LoggerService.info('Vehicle submitted successfully', tag: _tag);
      clearForm();
      return true;
    } catch (e) {
      LoggerService.error('Failed to submit vehicle: $e', tag: _tag);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear form
  void clearForm() {
    plateNumberController.clear();
    modelController.clear();
    _selectedBrand = null;
    _selectedModelYear = null;
    _selectedCapacity = null;
    _selectedBodyType = null;
    _selectedCategory = null;
    notifyListeners();
  }

  @override
  void dispose() {
    plateNumberController.dispose();
    modelController.dispose();
    super.dispose();
  }

  /// Reset form to initial state
  void resetForm() {
    clearForm();
  }
}
