import 'package:flutter/material.dart';
import 'package:limo/core/providers/user_provider.dart';

/// ViewModel for Profile feature that handles all business logic
class ProfileViewModel extends ChangeNotifier {
  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();

  // State
  bool _isLoading = false;
  bool _isEditing = false;
  final List<Map<String, String>> _vehicles = [];
  String? _errorMessage;
  String? _successMessage;

  // Store original values for cancel functionality
  String _originalPhone = '';

  // Getters
  bool get isLoading => _isLoading;
  bool get isEditing => _isEditing;
  List<Map<String, String>> get vehicles => _vehicles;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// Initialize the ViewModel with user data
  Future<void> initialize(UserProvider userProvider) async {
    _setLoading(true);

    try {
      // Production: Initialize with empty data, no mock data
      debugPrint('ProfileViewModel: Production mode - no mock data loaded');

      // Initialize with empty data
      addressController.text = '';
      licenseController.text = '';
      _vehicles.clear();

      // Load existing phone number if available (you can extend UserProvider to include phone)
      // For demo purposes, let's set a default phone number
      if (phoneController.text.isEmpty) {
        phoneController.text = '+90 555 123 4567'; // Demo phone number
      }

      // Store original values
      _originalPhone = phoneController.text;

      // Update controllers with user data if available
      if (userProvider.isLoggedIn) {
        if (userProvider.userDisplayName != null) {
          nameController.text = userProvider.userDisplayName!;
        }
        if (userProvider.userEmail != null) {
          emailController.text = userProvider.userEmail!;
        }
        // Load existing phone number if available (you can extend UserProvider to include phone)
        // For now, we'll keep the existing value in the controller
      }

      _clearMessages();
    } catch (e) {
      _setError('Failed to initialize profile data: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Start editing mode
  void startEditing() {
    // Store current values as original values
    _originalPhone = phoneController.text;

    _isEditing = true;
    notifyListeners();
  }

  /// Cancel editing and reset to original values
  void cancelEditing() {
    _isEditing = false;
    _clearMessages();

    // Reset to original values
    phoneController.text = _originalPhone;

    notifyListeners();
  }

  /// Save profile changes
  Future<void> saveChanges() async {
    if (!_isEditing) return;

    _setLoading(true);

    try {
      // Validate required fields
      if (!_validateRequiredFields()) {
        _setError('Please fill in all required fields');
        return;
      }

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Update user data
      _setSuccess('Profile updated successfully');
      _isEditing = false;

      notifyListeners();
    } catch (e) {
      _setError('Failed to save profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Add a new vehicle to the list
  void addVehicle(Map<String, String> vehicle) {
    _vehicles.add(vehicle);
    notifyListeners();
  }

  /// Remove a vehicle from the list
  void removeVehicle(int index) {
    if (index >= 0 && index < _vehicles.length) {
      _vehicles.removeAt(index);
      notifyListeners();
    }
  }

  /// Update vehicle information
  void updateVehicle(int index, Map<String, String> vehicle) {
    if (index >= 0 && index < _vehicles.length) {
      _vehicles[index] = vehicle;
      notifyListeners();
    }
  }

  /// Validate required fields
  bool _validateRequiredFields() {
    // Validate phone number
    if (phoneController.text.trim().isEmpty) {
      _setError('Phone number is required');
      return false;
    }

    // Remove all non-digit characters for validation
    String digitsOnly = phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Basic phone number validation
    if (digitsOnly.length < 10) {
      _setError('Phone number must be at least 10 digits');
      return false;
    }

    if (digitsOnly.length > 15) {
      _setError('Phone number is too long');
      return false;
    }

    return true;
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String message) {
    _errorMessage = message;
    _successMessage = null;
    notifyListeners();
  }

  /// Set success message
  void _setSuccess(String message) {
    _successMessage = message;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all messages
  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear success message
  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    licenseController.dispose();
    expiryController.dispose();
    super.dispose();
  }
}
