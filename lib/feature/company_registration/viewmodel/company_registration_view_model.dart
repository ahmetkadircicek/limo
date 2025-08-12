import 'package:flutter/material.dart';

/// ViewModel for company registration and management with edit mode support
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
  bool _isEditMode = false;
  bool _hasChanges = false;

  bool get isLoading => _isLoading;
  bool get isEditMode => _isEditMode;
  bool get hasChanges => _hasChanges;

  CompanyRegistrationViewModel() {
    _initializeControllers();
  }

  /// Initialize all text controllers
  void _initializeControllers() {
    companyNameController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    websiteController = TextEditingController();
    companyTypeController = TextEditingController();
    descriptionController = TextEditingController();
    serviceAreasController = TextEditingController();

    // Add listeners to track changes
    _addControllerListeners();
  }

  /// Add listeners to all controllers to track changes
  void _addControllerListeners() {
    companyNameController.addListener(_onFieldChanged);
    addressController.addListener(_onFieldChanged);
    phoneController.addListener(_onFieldChanged);
    emailController.addListener(_onFieldChanged);
    websiteController.addListener(_onFieldChanged);
    companyTypeController.addListener(_onFieldChanged);
    descriptionController.addListener(_onFieldChanged);
    serviceAreasController.addListener(_onFieldChanged);
  }

  /// Track field changes for edit mode
  void _onFieldChanged() {
    if (_isEditMode) {
      _hasChanges = true;
      notifyListeners();
    }
  }

  /// Toggle edit mode on/off
  void toggleEditMode() {
    if (_isEditMode) {
      // Cancel edit mode - revert changes
      _cancelEdit();
    } else {
      // Enter edit mode
      _isEditMode = true;
      _hasChanges = false;
      notifyListeners();
    }
  }

  /// Cancel edit mode and revert changes
  void _cancelEdit() {
    _isEditMode = false;
    _hasChanges = false;
    // Clear form to revert to empty state
    clearForm();
  }

  /// Update company information
  Future<bool> updateCompany(BuildContext context) async {
    if (!_hasChanges) {
      return true; // No changes to save
    }

    // Store context-dependent objects before async operation
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual update logic

      _isEditMode = false;
      _hasChanges = false;

      _showSuccessSnackbar(
          scaffoldMessenger, 'Company information updated successfully!');
      return true;
    } catch (e) {
      _showErrorSnackbar(scaffoldMessenger, 'Update failed: ${e.toString()}');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Register new company (for new registrations)
  Future<void> registerCompany(BuildContext context) async {
    // Store context-dependent objects before async operation
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate registration
      await Future.delayed(const Duration(seconds: 2));

      _showSuccessSnackbar(
          scaffoldMessenger, 'Company information saved successfully!');
    } catch (e) {
      _showErrorSnackbar(
          scaffoldMessenger, 'Registration failed: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  /// Show success message as snackbar
  void _showSuccessSnackbar(
      ScaffoldMessengerState scaffoldMessenger, String message) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            Colors.green, // Using direct color since we don't have context
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show error message as snackbar
  void _showErrorSnackbar(
      ScaffoldMessengerState scaffoldMessenger, String message) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            Colors.red, // Using direct color since we don't have context
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
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
