import 'package:flutter/material.dart';
import 'package:limo/shared/app_components.dart';

class CompanyRegistrationViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  late TextEditingController companyNameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController websiteController;
  late TextEditingController companyTypeController;
  late TextEditingController descriptionController;
  late TextEditingController serviceAreasController;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CompanyRegistrationViewModel() {
    companyNameController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    websiteController = TextEditingController();
    companyTypeController = TextEditingController();
    descriptionController = TextEditingController();
    serviceAreasController = TextEditingController();
  }

  /// Clear all form fields
  void clearForm() {
    companyNameController.clear();
    addressController.clear();
    phoneController.clear();
    emailController.clear();
    websiteController.clear();
    companyTypeController.clear();
    descriptionController.clear();
    serviceAreasController.clear();
    notifyListeners();
  }

  Future<void> registerCompany(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate registration
      await Future.delayed(const Duration(seconds: 2));

      context.showSuccessDialog('Company information saved successfully!');
    } catch (e) {
      context.showErrorDialog('Registration failed: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    companyNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    websiteController.dispose();
    companyTypeController.dispose();
    descriptionController.dispose();
    serviceAreasController.dispose();
    super.dispose();
  }
}
