import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/navigation/navigation_manager.dart';
import 'package:limo/feature/login/view_model/login_view_model.dart';
import 'package:limo/shared/widgets/app_snackbar.dart';

mixin LoginViewMixin<T extends StatefulWidget> on State<T> {
  Future<void> signInWithGoogleView(
    BuildContext context,
    LoginViewModel viewModel,
  ) async {
    try {
      final user = await viewModel.signInWithGoogle(context);

      if (!context.mounted) return;

      if (user != null) {
        AppSnackbar.success(
          message: "Login successful, welcome ${user.userName}",
        );
        context.go(NavigationManager.home);
      } else {
        AppSnackbar.warning(
          message: "Login failed or no data received from server",
        );
      }
    } catch (e) {
      AppSnackbar.error(message: "An error occurred: $e");
    }
  }
}
