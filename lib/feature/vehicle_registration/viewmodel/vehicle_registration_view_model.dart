import 'package:flutter/material.dart';
import 'package:limo/core/enums/field_error_enum.dart';
import 'package:limo/core/enums/success_message_enum.dart';
import 'package:limo/shared/app_components.dart';

import '../model/vehicle_model.dart';

class VehicleRegistrationViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  late TextEditingController licencePlateController;
  late TextEditingController brandController;
  late TextEditingController modelController;

  // Dropdown values
  String? selectedYear;
  String? selectedCapacity;
  String? selectedVehicleType;
  String? selectedInteriorColor;
  String? selectedExteriorColor;

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

  static const List<String> colorOptions = [
    'White',
    'Black',
    'Silver',
    'Gray',
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Orange',
    'Brown',
    'Purple',
    'Pink',
    'Gold',
    'Bronze',
    'Beige',
    'Cream',
  ];

  // Generate years from 1990 to current year + 1
  static List<String> get yearOptions {
    final currentYear = DateTime.now().year;
    return List.generate(
            currentYear - 1990 + 2, (index) => (1990 + index).toString())
        .reversed
        .toList();
  }

  VehicleRegistrationViewModel(BuildContext context) {
    debugPrint('VehicleRegistrationViewModel created');
    licencePlateController = TextEditingController();
    brandController = TextEditingController();
    modelController = TextEditingController();
  }

  // Update dropdown selections
  void updateYear(String? year) {
    selectedYear = year;
    notifyListeners();
  }

  void updateCapacity(String? capacity) {
    selectedCapacity = capacity;
    notifyListeners();
  }

  void updateVehicleType(String? vehicleType) {
    selectedVehicleType = vehicleType;
    notifyListeners();
  }

  void updateInteriorColor(String? color) {
    selectedInteriorColor = color;
    notifyListeners();
  }

  void updateExteriorColor(String? color) {
    selectedExteriorColor = color;
    notifyListeners();
  }

  /// Validates licence plate format (general format for international use)
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

  /// Validates brand field
  String? validateBrand(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Will be handled in registerVehicle method
    }
    if (value.trim().length < 2) {
      return 'Brand must be at least 2 characters';
    }
    return null;
  }

  /// Validates model field
  String? validateModel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Will be handled in registerVehicle method
    }
    if (value.trim().isEmpty) {
      return 'Model must not be empty';
    }
    return null;
  }

  /// Registers the vehicle with professional dialog validation
  Future<bool> registerVehicle(BuildContext context) async {
    // Get values
    String licencePlate = licencePlateController.text.trim().toUpperCase();
    String brand = brandController.text.trim();
    String model = modelController.text.trim();

    // Manual validation with proper error messages
    FieldError? validationError;

    if (licencePlate.isEmpty) {
      validationError = FieldError.emptyLicencePlate;
    } else if (!RegExp(r'^[A-Za-z0-9\s\-\.]{2,15}$').hasMatch(licencePlate)) {
      validationError = FieldError.invalidLicencePlate;
    } else if (brand.isEmpty) {
      validationError = FieldError.emptyBrand;
    } else if (brand.length < 2) {
      validationError = FieldError.invalidBrand;
    } else if (model.isEmpty) {
      validationError = FieldError.emptyModel;
    } else if (selectedYear == null) {
      validationError = FieldError.emptyYear;
    } else if (selectedCapacity == null) {
      validationError = FieldError.emptyCapacity;
    } else if (selectedVehicleType == null) {
      validationError = FieldError.emptyVehicleType;
    } else if (selectedInteriorColor == null) {
      validationError = FieldError.emptyInteriorColor;
    } else if (selectedExteriorColor == null) {
      validationError = FieldError.emptyExteriorColor;
    }

    if (validationError != null) {
      // Show error dialog
      context.showErrorDialog(validationError.message);
      return false;
    }

    // Create vehicle model
    final vehicle = VehicleModel(
      licencePlate: licencePlate,
      brand: brand,
      model: model,
      year: int.parse(selectedYear!),
      capacity: selectedCapacity! == '10+' ? 10 : int.parse(selectedCapacity!),
      vehicleType: selectedVehicleType!,
      interiorColor: selectedInteriorColor!,
      exteriorColor: selectedExteriorColor!,
    );

    // Debug print vehicle data
    debugPrint('Vehicle Registration Data:');
    debugPrint('Licence Plate: ${vehicle.licencePlate}');
    debugPrint('Brand: ${vehicle.brand}');
    debugPrint('Model: ${vehicle.model}');
    debugPrint('Year: ${vehicle.year}');
    debugPrint('Capacity: ${vehicle.capacity}');
    debugPrint('Vehicle Type: ${vehicle.vehicleType}');
    debugPrint('Interior Color: ${vehicle.interiorColor}');
    debugPrint('Exterior Color: ${vehicle.exteriorColor}');

    // TODO: Implement actual vehicle registration logic here
    // await registerVehicleToServer(context, vehicle);

    // Show success dialog
    context.showSuccessDialog(
      SuccessMessageEnum.vehicleRegisterSuccess.successMessage,
    );

    return true;
  }

  @override
  void dispose() {
    debugPrint('VehicleRegistrationViewModel disposed');
    licencePlateController.dispose();
    brandController.dispose();
    modelController.dispose();
    super.dispose();
  }
}
