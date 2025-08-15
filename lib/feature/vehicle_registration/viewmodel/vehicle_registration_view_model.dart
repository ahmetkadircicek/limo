import 'package:flutter/material.dart';
import 'package:limo/core/enums/field_error_enum.dart';
import 'package:limo/core/enums/vehicle_category_enum.dart';
import 'package:limo/shared/app_snackbar.dart';

import '../model/vehicle_model.dart';

/// ViewModel for vehicle registration form management and validation
class VehicleRegistrationViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  late TextEditingController licencePlateController;
  late TextEditingController brandController;
  late TextEditingController modelController;

  // Vehicle being edited (if any)
  VehicleModel? vehicleToEdit;

  // Dropdown values
  String? selectedYear;
  String? selectedCapacity;
  String? selectedVehicleType;
  String? selectedBrand;
  String? selectedCategory;
  String? selectedInsuranceStatus;
  String? selectedLicenseStatus;
  String? selectedInspectionStatus;

  // Controllers for new fields
  late TextEditingController yearController;
  late TextEditingController capacityController;

  // Predefined options
  static const List<String> vehicleTypes = [
    'Sedan',
    'Hatchback',
    'SUV',
    'Station Wagon',
    'Coupe',
    'Convertible',
    'Pickup Truck',
    'Minivan',
    'Van',
    'Bus',
    'Truck',
    'Motorcycle',
    'Scooter',
  ];

  static const List<String> capacityOptions = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10+',
  ];

  static const List<String> brandOptions = [
    'Ford',
    'Mercedes',
    'Volvo',
    'Scania',
    'MAN',
    'Iveco',
    'DAF',
    'Renault',
    'BMW',
    'Audi',
    'Toyota',
    'Honda',
    'Nissan',
    'Chevrolet',
    'Hyundai',
    'Kia',
    'Volkswagen',
    'Peugeot',
    'Citroën',
    'Fiat',
  ];

  static const List<String> categoryOptions = [
    'Standard Sedan',
    'Premium Sedan',
    'Luxury Sedan',
    'Standard SUV',
    'Premium SUV',
    'Luxury SUV',
    'Standard Van',
    'Premium Van',
    'Standard Truck',
    'Premium Truck',
    'Economy Sedan',
    'Economy SUV',
    'Economy Hatchback',
    'Utility Vehicle',
  ];

  static const List<String> insuranceStatusOptions = [
    'Valid',
    'Pending Approval',
    'Missing',
  ];

  static const List<String> licenseStatusOptions = [
    'Valid',
    'Pending Approval',
    'Missing',
  ];

  static const List<String> inspectionStatusOptions = [
    'Valid',
    'Pending Approval',
    'Missing',
  ];

  /// Generates year options from 1990 to current year + 1
  static List<String> get yearOptions {
    final currentYear = DateTime.now().year;
    return List.generate(
            currentYear - 1990 + 2, (index) => (1990 + index).toString())
        .reversed
        .toList();
  }

  /// Constructor initializes all text controllers
  VehicleRegistrationViewModel(BuildContext context) {
    debugPrint('VehicleRegistrationViewModel created');
    licencePlateController = TextEditingController();
    brandController = TextEditingController();
    modelController = TextEditingController();
    yearController = TextEditingController();
    capacityController = TextEditingController();
  }

  /// Updates the selected vehicle type
  void updateVehicleType(String? value) {
    selectedVehicleType = value;
    notifyListeners();
  }

  /// Updates the selected year
  void updateYear(String? value) {
    selectedYear = value;
    notifyListeners();
  }

  /// Updates the selected capacity
  void updateCapacity(String? value) {
    selectedCapacity = value;
    notifyListeners();
  }

  /// Updates the selected insurance status
  void updateInsuranceStatus(String? value) {
    selectedInsuranceStatus = value;
    notifyListeners();
  }

  /// Updates the selected license status
  void updateLicenseStatus(String? value) {
    selectedLicenseStatus = value;
    notifyListeners();
  }

  /// Updates the selected inspection status
  void updateInspectionStatus(String? value) {
    selectedInspectionStatus = value;
    notifyListeners();
  }

  /// Sets the vehicle type and notifies listeners
  void setVehicleType(String? vehicleType) {
    selectedVehicleType = vehicleType;
    notifyListeners();
  }

  /// Sets the brand and notifies listeners
  void setBrand(String? brand) {
    selectedBrand = brand;
    notifyListeners();
  }

  /// Sets the category and notifies listeners
  void setCategory(String? category) {
    selectedCategory = category;
    notifyListeners();
  }

  /// Validates licence plate format for international use
  String? validateLicencePlate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Will be handled in registerVehicle method
    }

    // General format: allow letters, numbers, spaces, and common separators
    final RegExp plateRegex = RegExp(r'^[A-Za-z0-9\s\-\.]{2,15}$');
    if (!plateRegex.hasMatch(value.trim())) {
      return 'Please enter a valid licence plate';
    }
    return null;
  }

  /// Validates brand field for minimum length requirement
  String? validateBrand(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Will be handled in registerVehicle method
    }
    if (value.trim().length < 2) {
      return 'Brand must be at least 2 characters';
    }
    return null;
  }

  /// Validates model field for non-empty requirement
  String? validateModel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Will be handled in registerVehicle method
    }
    if (value.trim().isEmpty) {
      return 'Model must not be empty';
    }
    return null;
  }

  /// Registers the vehicle with comprehensive validation and snackbar feedback
  Future<bool> registerVehicle(BuildContext context) async {
    // Get values
    String licencePlate = licencePlateController.text.trim().toUpperCase();
    String brand = selectedBrand ?? '';
    String model = modelController.text.trim();

    // Manual validation with proper error messages
    FieldError? validationError = _validateVehicleData(
      licencePlate: licencePlate,
      brand: brand,
      model: model,
    );

    if (validationError != null) {
      _showErrorSnackbar(context, validationError.message);
      return false;
    }

    // Create and save vehicle
    final vehicle = _createVehicleModel(
      licencePlate: licencePlate,
      brand: brand,
      model: model,
    );

    _logVehicleData(vehicle);
    _showSuccessSnackbar(context);

    return true;
  }

  /// Validates all vehicle data and returns appropriate error if any
  FieldError? _validateVehicleData({
    required String licencePlate,
    required String brand,
    required String model,
  }) {
    if (licencePlate.isEmpty) {
      return FieldError.emptyLicencePlate;
    } else if (!RegExp(r'^[A-Za-z0-9\s\-\.]{2,15}$').hasMatch(licencePlate)) {
      return FieldError.invalidLicencePlate;
    } else if (brand.isEmpty) {
      return FieldError.emptyBrand;
    } else if (brand.length < 2) {
      return FieldError.invalidBrand;
    } else if (model.isEmpty) {
      return FieldError.emptyModel;
    } else if (selectedYear == null) {
      return FieldError.emptyYear;
    } else if (selectedCapacity == null) {
      return FieldError.emptyCapacity;
    } else if (selectedVehicleType == null) {
      return FieldError.emptyVehicleType;
    } else if (selectedCategory == null) {
      return FieldError.emptyVehicleType;
    }
    return null;
  }

  /// Creates VehicleModel instance from form data
  VehicleModel _createVehicleModel({
    required String licencePlate,
    required String brand,
    required String model,
  }) {
    return VehicleModel(
      licencePlate: licencePlate,
      brand: selectedBrand!,
      model: model,
      year: int.parse(selectedYear!),
      capacity: selectedCapacity! == '10+' ? 10 : int.parse(selectedCapacity!),
      vehicleType: selectedVehicleType!,
      interiorColor: 'N/A',
      exteriorColor: 'N/A',
      category: VehicleCategory.values.firstWhere(
        (cat) => cat.displayName == selectedCategory,
        orElse: () => VehicleCategory.standardSedan,
      ),
      hasInsurance: selectedInsuranceStatus == 'Valid',
      hasRegistration: selectedLicenseStatus == 'Valid',
      hasInspection: selectedInspectionStatus == 'Valid',
    );
  }

  /// Shows error message as snackbar instead of dialog
  void _showErrorSnackbar(BuildContext context, String message) {
    AppSnackbar.showError(context, message: message);
  }

  /// Shows success message as snackbar
  void _showSuccessSnackbar(BuildContext context) {
    AppSnackbar.showSuccess(context,
        message: 'Vehicle registered successfully!');
  }

  /// Logs vehicle data for debugging purposes
  void _logVehicleData(VehicleModel vehicle) {
    debugPrint('Vehicle Registration Data:');
    debugPrint('Licence Plate: ${vehicle.licencePlate}');
    debugPrint('Brand: ${vehicle.brand}');
    debugPrint('Model: ${vehicle.model}');
    debugPrint('Year: ${vehicle.year}');
    debugPrint('Capacity: ${vehicle.capacity}');
    debugPrint('Vehicle Type: ${vehicle.vehicleType}');
    debugPrint('Category: ${vehicle.category.displayName}');
  }

  /// Clears all form data and resets to initial state
  void clearForm() {
    licencePlateController.clear();
    brandController.clear();
    modelController.clear();
    yearController.clear();
    capacityController.clear();

    // Reset dropdown selections
    selectedYear = null;
    selectedCapacity = null;
    selectedVehicleType = null;
    selectedBrand = null;
    selectedCategory = null;
    selectedInsuranceStatus = null;
    selectedLicenseStatus = null;
    selectedInspectionStatus = null;

    notifyListeners();
  }

  /// Disposes all controllers to prevent memory leaks
  @override
  void dispose() {
    licencePlateController.dispose();
    brandController.dispose();
    modelController.dispose();
    yearController.dispose();
    capacityController.dispose();
    super.dispose();
  }
}
