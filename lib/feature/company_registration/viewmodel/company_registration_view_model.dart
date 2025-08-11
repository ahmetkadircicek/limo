import 'package:flutter/material.dart';
import 'package:limo/shared/app_components.dart';

class CompanyRegistrationViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  late TextEditingController companyNameController;
  late TextEditingController taxNumberController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController websiteController;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CompanyRegistrationViewModel() {
    companyNameController = TextEditingController();
    taxNumberController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    websiteController = TextEditingController();
  }

  Future<void> registerCompany(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate registration
      await Future.delayed(const Duration(seconds: 2));

      context.showSuccessDialog('Şirket başarıyla kayıt edildi!');
    } catch (e) {
      context.showErrorDialog('Kayıt başarısız: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    companyNameController.dispose();
    taxNumberController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    websiteController.dispose();
    super.dispose();
  }
}
