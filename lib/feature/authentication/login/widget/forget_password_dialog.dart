import 'package:flutter/material.dart';
import 'package:soforvarcom/shared/modern_dialog.dart';
import 'package:soforvarcom/shared/modern_snackbar.dart';

class ForgetPasswordDialog extends StatelessWidget {
  const ForgetPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ModernDialog(
      type: DialogType.input,
      title: 'Reset Password',
      message:
          'Enter your email address and we\'ll send you a password reset link.',
      inputHint: 'Email Address',
      inputType: TextInputType.emailAddress,
      inputValidator: _validateEmail,
      primaryButtonText: 'Send Reset Link',
      secondaryButtonText: 'Cancel',
      onPrimaryPressed: () => _handleForgetPassword(context),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email address is required';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  void _handleForgetPassword(BuildContext context) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (context.mounted) {
        // Close dialog first
        Navigator.of(context).pop();

        // Show success snackbar
        context.showSuccessSnackbar(
          title: 'Email Sent',
          message: 'Password reset link has been sent to your email address.',
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      if (context.mounted) {
        // Close dialog first
        Navigator.of(context).pop();

        // Show error snackbar
        context.showErrorSnackbar(
          title: 'Error',
          message: 'An error occurred. Please try again.',
        );
      }
    }
  }
}
