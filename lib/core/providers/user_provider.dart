import 'package:flutter/material.dart';
import 'package:limo/core/models/user_model.dart';

/// Provider for managing current user state
class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  /// Set current user
  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Update user information
  void updateUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Update last login time
  void updateLastLogin() {
    if (_currentUser != null) {
      _currentUser = _currentUser!.updateLastLogin();
      notifyListeners();
    }
  }

  /// Clear current user (logout)
  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  /// Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Get user email
  String? get userEmail => _currentUser?.email;

  /// Get user display name
  String? get userDisplayName => _currentUser?.displayName;

  /// Get user photo URL
  String? get userPhotoUrl => _currentUser?.photoUrl;

  /// Get user ID
  String? get userId => _currentUser?.id;
}
