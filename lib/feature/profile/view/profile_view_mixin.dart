import 'package:flutter/material.dart';
import 'package:limo/feature/profile/viewmodel/profile_view_model.dart';
import 'package:limo/shared/app_components.dart';

/// Mixin for ProfileView to separate business logic
mixin ProfileViewMixin<T extends StatefulWidget> on State<T> {
  /// Show snackbar messages
  void showSnackbarMessages(ProfileViewModel viewModel) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.errorMessage != null) {
        AppSnackbar.showError(context, message: viewModel.errorMessage!);
        viewModel.clearError();
      }

      if (viewModel.successMessage != null) {
        AppSnackbar.showSuccess(context, message: viewModel.successMessage!);
        viewModel.clearSuccess();
      }
    });
  }
}
