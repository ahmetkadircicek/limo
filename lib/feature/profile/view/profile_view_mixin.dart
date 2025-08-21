import 'package:flutter/material.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/feature/profile/viewmodel/profile_view_model.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

/// Mixin for ProfileView to separate business logic
mixin ProfileViewMixin<T extends StatefulWidget> on State<T> {
  // Controllers
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();

  // State variables
  bool _isEditing = false;
  bool get isEditing => _isEditing;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    phoneController.dispose();
    companyNameController.dispose();
    super.dispose();
  }

  /// Initialize controllers with current user data
  void _initializeControllers() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      final user = appState.currentUser;
      if (user != null) {
        phoneController.text = user.phone ?? '';
        companyNameController.text = user.companyName ?? '';
      }
    });
  }

  /// Toggle edit mode
  void toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  /// Save profile changes
  Future<void> saveProfileChanges() async {
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final user = appState.currentUser;
    if (user != null) {
      final updatedUser = user.copyWith(
        phone: phoneController.text,
        companyName: companyNameController.text,
      );

      await viewModel.updateUser(updatedUser, appState);

      // Exit edit mode
      setState(() {
        _isEditing = false;
      });
    }
  }

  /// Cancel edit mode and reset controllers
  void cancelEditMode() {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final user = appState.currentUser;

    // Reset controllers to original values
    phoneController.text = user?.phone ?? '';
    companyNameController.text = user?.companyName ?? '';

    setState(() {
      _isEditing = false;
    });
  }

  /// Update profile image from gallery
  Future<void> updateProfileImageFromGallery(AppStateProvider appState) async {
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    await viewModel.updateProfileImageFromGallery(appState);
  }

  /// Show snackbar messages
  void showSnackbarMessages(ProfileViewModel viewModel) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.errorMessage != null) {
        context.showErrorTopSnackbar(viewModel.errorMessage!);
        viewModel.clearError();
      }

      if (viewModel.successMessage != null) {
        context.showSuccessTopSnackbar(viewModel.successMessage!);
        viewModel.clearSuccess();
      }
    });
  }

  /// Build action buttons (Edit/Save/Cancel)
  Widget buildActionButtons(ProfileViewModel viewModel, user) {
    if (_isEditing) {
      return Row(
        children: [
          Expanded(
            child: AppButton.secondary('Cancel', onPressed: cancelEditMode),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppButton.primary(
              'Save',
              onPressed: saveProfileChanges,
              isLoading: viewModel.isLoading,
            ),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: AppButton.primary('Edit Profile', onPressed: toggleEditMode),
      );
    }
  }
}
