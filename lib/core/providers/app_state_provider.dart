import 'package:flutter/material.dart';

import '../models/user_model.dart';

class AppStateProvider extends ChangeNotifier {
  // App settings
  bool _isDarkMode = false;
  String _currentLanguage = 'en';
  bool _notificationsEnabled = true;

  // Authentication state
  UserModel? _currentUser;
  bool _isAuthenticated = false;

  // Authentication flow flags
  bool _isGoogleAuthDataPersisted = false;
  bool _isUserDataLoadedFromShared = false;
  bool _isBackendAuthenticationSent = false;
  bool _isBackendAuthenticationConfirmed = false;
  bool _isUserDataSaved = false;

  // Getters
  bool get isDarkMode => _isDarkMode;
  String get currentLanguage => _currentLanguage;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;

  // Authentication flow flag getters
  bool get isGoogleAuthDataPersisted => _isGoogleAuthDataPersisted;
  bool get isUserDataLoadedFromShared => _isUserDataLoadedFromShared;
  bool get isBackendAuthenticationSent => _isBackendAuthenticationSent;
  bool get isBackendAuthenticationConfirmed =>
      _isBackendAuthenticationConfirmed;
  bool get isUserDataSaved => _isUserDataSaved;

  /// Get token saved status from current user
  bool get isTokenSaved =>
      _currentUser?.accessToken != null &&
      _currentUser!.accessToken!.isNotEmpty;

  /// Initialize app state
  Future<void> initialize() async {
    // Don't automatically restore authentication state
    // User must manually sign in through the login screen
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
    String? userName,
    String? userPhoto,
    String? phone,
    String? companyName,
    bool? approved,
  }) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        userName: userName,
        userPhoto: userPhoto,
        phone: phone,
        companyName: companyName,
        approved: approved,
      );
      notifyListeners();
    }
  }

  /// Update driver license
  void updateDriverLicense(String driverLicense) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(driverLicense: driverLicense);
      notifyListeners();
    }
  }

  /// Check if current user has driver license
  bool get hasDriverLicense =>
      _currentUser?.driverLicense != null &&
      _currentUser!.driverLicense!.isNotEmpty;

  /// Check if current user has profile image
  bool get hasProfileImage =>
      _currentUser?.userPhoto != null && _currentUser!.userPhoto!.isNotEmpty;

  // =============================================================================
  // AUTHENTICATION FLOW FLAG MANAGEMENT
  // =============================================================================

  /// Set Google auth data persistence flag
  void setGoogleAuthDataPersisted(bool value) {
    _isGoogleAuthDataPersisted = value;
    notifyListeners();
  }

  /// Set user data loaded from shared preferences flag
  void setUserDataLoadedFromShared(bool value) {
    _isUserDataLoadedFromShared = value;
    notifyListeners();
  }

  /// Set backend authentication sent flag
  void setBackendAuthenticationSent(bool value) {
    _isBackendAuthenticationSent = value;
    notifyListeners();
  }

  /// Set backend authentication confirmed flag
  void setBackendAuthenticationConfirmed(bool value) {
    _isBackendAuthenticationConfirmed = value;
    notifyListeners();
  }

  /// Set user data saved flag
  void setUserDataSaved(bool value) {
    _isUserDataSaved = value;
    notifyListeners();
  }

  /// Reset all authentication flow flags
  void resetAuthenticationFlags() {
    _isGoogleAuthDataPersisted = false;
    _isUserDataLoadedFromShared = false;
    _isBackendAuthenticationSent = false;
    _isBackendAuthenticationConfirmed = false;
    _isUserDataSaved = false;
    notifyListeners();
  }

  /// Get authentication flow status summary
  Map<String, bool> getAuthenticationFlowStatus() {
    return {
      'googleAuthDataPersisted': _isGoogleAuthDataPersisted,
      'userDataLoadedFromShared': _isUserDataLoadedFromShared,
      'backendAuthenticationSent': _isBackendAuthenticationSent,
      'backendAuthenticationConfirmed': _isBackendAuthenticationConfirmed,
      'tokenSaved': isTokenSaved,
      'userDataSaved': _isUserDataSaved,
    };
  }

  /// Sign out user
  Future<void> signOut() async {
    clearAuthentication();
  }

  /// Clear authentication state (logout)
  void clearAuthentication() {
    _isAuthenticated = false;
    _currentUser = null;
    resetAuthenticationFlags();
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
