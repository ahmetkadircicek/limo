import 'package:flutter/material.dart';
import 'package:limo/core/models/user_model.dart';
import 'package:limo/core/services/auth_api_service.dart';
import 'package:limo/core/services/auth_token_manager.dart';

/// Global application state provider
/// Manages authentication state, user data, and app-wide settings
class AppStateProvider extends ChangeNotifier {
  // Authentication state
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  // User data
  UserModel? _currentUser;

  // App settings
  bool _isDarkMode = false;
  String _currentLanguage = 'en';
  bool _notificationsEnabled = true;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get isDarkMode => _isDarkMode;
  String get currentLanguage => _currentLanguage;
  bool get notificationsEnabled => _notificationsEnabled;

  /// Initialize app state
  Future<void> initialize() async {
    _setLoading(true);

    try {
      // Initialize token manager
      await AuthTokenManager.instance.initialize();

      // Check if user is authenticated
      if (AuthTokenManager.instance.isAuthenticated) {
        await _restoreUserSession();
      }
    } catch (e) {
      _setError('Failed to initialize app: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Restore user session from stored data
  Future<void> _restoreUserSession() async {
    try {
      // Get user data from token manager
      final userData = await AuthTokenManager.instance.getUserData();

      if (userData != null) {
        _currentUser = UserModel.fromJson(userData);
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      // If restoration fails, clear session
      await logout();
    }
  }

  /// Authenticate user with Google
  Future<bool> authenticateWithGoogle(String googleId) async {
    _setLoading(true);
    _clearError();

    debugPrint(
      '🔐 [APP_STATE] Starting authentication with Google ID: $googleId',
    );

    try {
      debugPrint(
        '🔐 [APP_STATE] Calling AuthApiService.authenticateWithGoogle()...',
      );
      // Authenticate with backend
      final authResponse = await AuthApiService.authenticateWithGoogle(
        googleId,
      );
      debugPrint('✅ [APP_STATE] Backend authentication response received');
      debugPrint(
        '🔐 [APP_STATE] Access token: ${authResponse.accessToken.substring(0, 10)}...',
      );
      debugPrint('🔐 [APP_STATE] Token expires at: ${authResponse.expiresAt}');

      debugPrint('🔐 [APP_STATE] Storing tokens in AuthTokenManager...');
      // Store tokens
      await AuthTokenManager.instance.storeTokens(authResponse);
      debugPrint('✅ [APP_STATE] Tokens stored successfully');

      // Get user profile if not included in response
      UserModel user;
      if (authResponse.user != null) {
        debugPrint('✅ [APP_STATE] User data included in auth response');
        user = authResponse.user!;
      } else {
        debugPrint(
          '🔐 [APP_STATE] User data not in response, fetching profile...',
        );
        // Fetch user profile using automatic token management
        user = await AuthApiService.getUserProfileAuto();
        debugPrint('✅ [APP_STATE] User profile fetched successfully');
      }

      debugPrint(
        '🔐 [APP_STATE] Updating app state with user: ${user.displayName}',
      );
      // Update app state
      _currentUser = user;
      _isAuthenticated = true;

      notifyListeners();
      debugPrint('✅ [APP_STATE] Authentication completed successfully!');
      return true;
    } catch (e) {
      debugPrint('❌ [APP_STATE] Authentication failed: $e');
      _setError('Authentication failed: $e');
      return false;
    } finally {
      _setLoading(false);
      debugPrint('🔐 [APP_STATE] Authentication process completed');
    }
  }

  /// Logout user
  Future<void> logout() async {
    debugPrint('🔐 [APP_STATE] Starting logout process...');
    _setLoading(true);

    try {
      debugPrint('🔐 [APP_STATE] Clearing tokens from AuthTokenManager...');
      // Clear tokens
      await AuthTokenManager.instance.clearTokens();
      debugPrint('✅ [APP_STATE] Tokens cleared successfully');

      debugPrint('🔐 [APP_STATE] Clearing app state...');
      // Clear app state
      _currentUser = null;
      _isAuthenticated = false;

      notifyListeners();
      debugPrint('✅ [APP_STATE] Logout completed successfully!');
    } catch (e) {
      debugPrint('❌ [APP_STATE] Logout failed: $e');
      _setError('Logout failed: $e');
    } finally {
      _setLoading(false);
      debugPrint('🔐 [APP_STATE] Logout process completed');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      _currentUser = updatedUser;

      // Update stored user data
      await AuthTokenManager.instance.updateUserData(updatedUser.toJson());

      notifyListeners();
    } catch (e) {
      _setError('Failed to update profile: $e');
    }
  }

  /// Refresh user data from backend
  Future<void> refreshUserData() async {
    if (!_isAuthenticated) return;

    try {
      final user = await AuthApiService.getUserProfileAuto();
      _currentUser = user;

      // Update stored data
      await AuthTokenManager.instance.updateUserData(user.toJson());

      notifyListeners();
    } catch (e) {
      _setError('Failed to refresh user data: $e');
    }
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

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message (public method)
  void clearError() {
    _clearError();
  }

  /// Check if user has specific permission
  bool hasPermission(String permission) {
    // TODO: Implement permission checking logic
    // This could check user role, subscription status, etc.
    return _isAuthenticated;
  }

  /// Get user's subscription status
  String getSubscriptionStatus() {
    // TODO: Implement subscription status logic
    return _isAuthenticated ? 'active' : 'none';
  }

  /// Check if user is premium
  bool get isPremium {
    // TODO: Implement premium status logic
    return _isAuthenticated && getSubscriptionStatus() == 'premium';
  }
}
