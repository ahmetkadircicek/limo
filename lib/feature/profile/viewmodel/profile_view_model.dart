import 'package:limo/core/models/user_model.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/feature/profile/services/profile_image_service.dart';
import 'package:limo/feature/profile/services/user_update_service.dart';

/// Profile ViewModel for managing profile data and state
class ProfileViewModel {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// Update user profile with new data
  Future<void> updateUser(
    UserModel updatedUser,
    AppStateProvider appState,
  ) async {
    _setLoading(true);
    _clearMessages();

    try {
      final backendResponse = await UserUpdateService.updateUser(updatedUser);

      if (backendResponse != null) {
        final updatedUserFromBackend = UserModel.fromJson(backendResponse);
        appState.updateCurrentUser(updatedUserFromBackend);

        _setSuccess('Profile updated successfully');
      } else {
        _setError('Failed to update profile. Please try again.');
      }
    } catch (e) {
      LoggerService.error(
        'Error updating user profile: $e',
        tag: 'PROFILE_VIEWMODEL',
      );
      _setError('Failed to save profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Update user profile image from gallery
  Future<void> updateProfileImageFromGallery(AppStateProvider appState) async {
    _setLoading(true);
    _clearMessages();

    try {
      final imageFile = await ProfileImageService.pickImageFromGallery();

      if (imageFile == null) {
        _setError('No image selected');
        return;
      }

      // Validate image file
      if (!ProfileImageService.isValidImageFile(imageFile)) {
        _setError('Please select a valid image file (JPG, PNG, WebP)');
        return;
      }

      // Check file size
      if (!ProfileImageService.isFileSizeAcceptable(imageFile)) {
        _setError('Image file size must be less than 5MB');
        return;
      }

      // Convert image to base64
      final base64String = await ProfileImageService.convertImageToBase64(
        imageFile,
      );
      if (base64String == null) {
        _setError('Failed to process image. Please try again.');
        return;
      }

      final currentUser = appState.currentUser;

      if (currentUser != null) {
        // Update user with base64 image data
        final updatedUser = currentUser.copyWith(userPhoto: base64String);

        // Update local state immediately for better UX
        appState.updateCurrentUser(updatedUser);

        // Upload base64 to backend via UserUpdateService
        await updateUser(updatedUser, appState);

        _setSuccess('Profile image updated successfully');
      } else {
        _setError('No user found. Please sign in again.');
      }
    } catch (e) {
      LoggerService.error(
        'Error updating profile image: $e',
        tag: 'PROFILE_VIEWMODEL',
      );
      _setError('Failed to update profile image: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Update user profile image
  Future<void> updateProfileImage(String imageUrl) async {
    _setLoading(true);
    _clearMessages();

    try {
      final appState = AppStateProvider();
      final currentUser = appState.currentUser;

      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(userPhoto: imageUrl);
        await updateUser(updatedUser, appState);
      } else {
        _setError('No user found. Please sign in again.');
      }
    } catch (e) {
      LoggerService.error(
        'Error updating profile image: $e',
        tag: 'PROFILE_VIEWMODEL',
      );
      _setError('Failed to update profile image: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) => _isLoading = loading;

  void _setError(String message) {
    _errorMessage = message;
    _successMessage = null;
    // Clear error message after a short delay since AppSnackbar will show it
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_errorMessage == message) clearError();
    });
  }

  void _setSuccess(String message) {
    _successMessage = message;
    _errorMessage = null;
    // Clear success message after a short delay since AppSnackbar will show it
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_successMessage == message) clearSuccess();
    });
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  void clearError() => _errorMessage = null;
  void clearSuccess() => _successMessage = null;
}
