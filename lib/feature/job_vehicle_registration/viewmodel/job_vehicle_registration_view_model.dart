import 'package:flutter/material.dart';

import '../model/vehicle_model.dart';

/// ViewModel for job vehicle registration form management and validation
class JobVehicleRegistrationViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  late TextEditingController licencePlateController;
  late TextEditingController brandController;
  late TextEditingController modelController;
  late TextEditingController yearController;
  late TextEditingController capacityController;

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

  static const List<String> yearOptions = [
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
    '2018',
    '2017',
    '2016',
    '2015',
    '2014',
    '2013',
    '2012',
    '2011',
    '2010',
    '2009',
    '2008',
    '2007',
    '2006',
    '2005',
  ];

  static const List<String> insuranceOptions = ['Yes', 'No'];
  static const List<String> licenseOptions = ['Yes', 'No'];
  static const List<String> inspectionOptions = ['Yes', 'No'];

  JobVehicleRegistrationViewModel() {
    _buildInitializeControllers();
  }

  /// Initialize all text controllers
  void _buildInitializeControllers() {
    licencePlateController = TextEditingController();
    brandController = TextEditingController();
    modelController = TextEditingController();
    yearController = TextEditingController();
    capacityController = TextEditingController();
  }

  /// Set vehicle to edit and populate form
  void setVehicleToEdit(VehicleModel vehicle) {
    vehicleToEdit = vehicle;
    _buildPopulateFormWithVehicle(vehicle);
  }

  /// Populate form fields with existing vehicle data
  void _buildPopulateFormWithVehicle(VehicleModel vehicle) {
    licencePlateController.text = vehicle.licencePlate;
    brandController.text = vehicle.brand;
    modelController.text = vehicle.model;
    yearController.text = vehicle.year.toString();
    capacityController.text = vehicle.capacity.toString();

    selectedVehicleType = vehicle.vehicleType;
    selectedBrand = vehicle.brand;
    selectedCategory = vehicle.category.displayName;
    selectedInsuranceStatus = vehicle.hasInsurance ? 'Yes' : 'No';
    selectedLicenseStatus = vehicle.hasRegistration ? 'Yes' : 'No';
    selectedInspectionStatus = vehicle.hasInspection ? 'Yes' : 'No';

    notifyListeners();
  }

  /// Clear all form fields
  void clearForm() {
    licencePlateController.clear();
    brandController.clear();
    modelController.clear();
    yearController.clear();
    capacityController.clear();

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

  /// Validate form and return validation result
  bool validateForm() {
    if (!formKey.currentState!.validate()) return false;

    if (selectedVehicleType == null) return false;
    if (selectedBrand == null) return false;
    if (selectedCategory == null) return false;
    if (selectedInsuranceStatus == null) return false;
    if (selectedLicenseStatus == null) return false;
    if (selectedInspectionStatus == null) return false;

    return true;
  }

  /// Get vehicle model from form data
  VehicleModel? getVehicleFromForm() {
    if (!validateForm()) return null;

    try {
      final year = int.parse(yearController.text);
      final capacity = int.parse(capacityController.text);

      return VehicleModel(
        licencePlate: licencePlateController.text.trim(),
        brand: brandController.text.trim(),
        model: modelController.text.trim(),
        year: year,
        capacity: capacity,
        vehicleType: selectedVehicleType!,
        hasInsurance: selectedInsuranceStatus == 'Yes',
        hasRegistration: selectedLicenseStatus == 'Yes',
        hasInspection: selectedInspectionStatus == 'Yes',
      );
    } catch (e) {
      return null;
    }
  }

  /// Save vehicle data
  Future<bool> saveVehicle() async {
    if (!validateForm()) return false;

    final vehicle = getVehicleFromForm();
    if (vehicle == null) return false;

    try {
      // TODO: Implement actual API call to save vehicle
      // For now, just simulate success
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    licencePlateController.dispose();
    brandController.dispose();
    modelController.dispose();
    yearController.dispose();
    capacityController.dispose();
    super.dispose();
  }

  /// Reset form to initial state
  void resetForm() {
    clearForm();
  }
}
