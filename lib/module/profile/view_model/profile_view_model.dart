import 'package:flutter/material.dart';
import 'package:limo/module/profile_update/view/profile_edit_view.dart';

/// Profile ViewModel for managing profile display data
class ProfileViewModel extends ChangeNotifier {
  final bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void clearError() => _errorMessage = null;

  void clearSuccess() => _successMessage = null;

  void onEditPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileEditView()),
    );
  }
}
