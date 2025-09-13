import 'package:flutter/material.dart';
import 'package:limo/core/services/user_service.dart';
import 'package:limo/core/utils/logger_service.dart';

class ProfileUpdateViewModel extends ChangeNotifier {
  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// Bu method artık view'in onPressed'i olacak
  Future<void> onSavePressed(BuildContext context) async {
    _setLoading(true);

    try {
      final success = await UserService.updateUser(
        context,
        userName: fullNameController.text,
        phone: phoneController.text,
        companyName: companyNameController.text,
      );

      if (success) {
        if (context.mounted) Navigator.of(context).pop();
      }
    } catch (e) {
      LoggerService.error('Failed to update profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void disposeControllers() {
    fullNameController.dispose();
    phoneController.dispose();
    companyNameController.dispose();
  }
}
