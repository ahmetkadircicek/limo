import 'package:flutter/material.dart';
import 'package:limo/core/models/user_model.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/feature/profile_update/services/user_update_service.dart';

class ProfileUpdateViewModel extends ChangeNotifier {
  final UserUpdateService _userUpdateService = UserUpdateService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// Update user profile
  Future<bool> updateUser(
    UserModel updatedUser,
    AppStateProvider appState,
  ) async {
    try {
      _setLoading(true);
      _clearMessages();

      final success = await _userUpdateService.updateUser(updatedUser);

      if (success) {
        // Update app state with new user data
        appState.updateCurrentUser(updatedUser);
        _setSuccessMessage('Profile updated successfully');
        return true;
      } else {
        _setErrorMessage('Failed to update profile');
        return false;
      }
    } catch (e) {
      _setErrorMessage('An error occurred: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Save profile changes with form data
  Future<bool> saveProfileChanges({
    required String fullName,
    required String phone,
    required String companyName,
    required AppStateProvider appState,
  }) async {
    try {
      _setLoading(true);
      _clearMessages();

      final currentUser = appState.currentUser;
      if (currentUser == null) {
        _setErrorMessage('No user data available');
        return false;
      }

      final updatedUser = currentUser.copyWith(
        userName: fullName,
        phone: phone,
        companyName: companyName,
      );

      final success = await _userUpdateService.updateUser(updatedUser);

      if (success) {
        appState.updateCurrentUser(updatedUser);
        _setSuccessMessage('Profile updated successfully');
        return true;
      } else {
        _setErrorMessage('Failed to update profile');
        return false;
      }
    } catch (e) {
      _setErrorMessage('An error occurred: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Set success message
  void _setSuccessMessage(String message) {
    _successMessage = message;
    notifyListeners();
  }

  /// Clear all messages
  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Clear form data
  void clearForm() {
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
}
