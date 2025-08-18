import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/google_auth_service.dart';

class AppStateProvider extends ChangeNotifier {
  // App settings
  bool _isDarkMode = false;
  String _currentLanguage = 'en';
  bool _notificationsEnabled = true;
  
  // Authentication state
  UserModel? _currentUser;
  bool _isAuthenticated = false;

  // Getters
  bool get isDarkMode => _isDarkMode;
  String get currentLanguage => _currentLanguage;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;

  /// Initialize app state
  Future<void> initialize() async {
    // Don't automatically restore authentication state
    // User must manually sign in through the login screen
    debugPrint('AppStateProvider initialized - authentication state not restored automatically');
  }

  /// Set authentication state
  void setAuthenticationState(bool isAuthenticated, UserModel? user) {
    _isAuthenticated = isAuthenticated;
    _currentUser = user;
    notifyListeners();
  }

  /// Update current user
  void updateCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Update specific user profile fields
  void updateUserProfile({
    String? displayName,
    String? photoUrl,
    String? companyName,
    String? companyAddress,
    String? companyPhone,
    String? companyWebsite,
    String? companyTaxNumber,
    bool? hasDriverLicense,
  }) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        displayName: displayName,
        photoUrl: photoUrl,
        companyName: companyName,
        companyAddress: companyAddress,
        companyPhone: companyPhone,
        companyWebsite: companyWebsite,
        companyTaxNumber: companyTaxNumber,
        hasDriverLicense: hasDriverLicense,
      );
      notifyListeners();
    }
  }

  /// Check if current user has driver license
  bool get hasDriverLicense => _currentUser?.hasDriverLicense ?? false;

  /// Sign out user
  Future<void> signOut() async {
    try {
      await GoogleAuthService.signOut();
      clearAuthentication();
    } catch (e) {
      debugPrint('Failed to sign out: $e');
      // Still clear local state even if Google sign-out fails
      clearAuthentication();
    }
  }

  /// Clear authentication state (logout)
  void clearAuthentication() {
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }

  /// Toggle dark mode
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  /// Set language
  void setLanguage(String language) {
    _currentLanguage = language;
    notifyListeners();
  }

  /// Toggle notifications
  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }
}
