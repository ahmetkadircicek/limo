// This file is deprecated - use ModernDialog instead
// Keeping compatibility methods but redirecting to ModernDialog

import 'package:flutter/material.dart';
import 'package:soforvarcom/core/enums/alert_type_enum.dart';
import 'package:soforvarcom/shared/modern_dialog.dart';

// Helper extension for showing dialogs - Updated to use ModernDialog
extension DialogHelper on BuildContext {
  /// Show error dialog with modern styling
  void showErrorDialog({
    required String message,
    String title = 'Error!',
  }) {
    showDialog(
      context: this,
      builder: (context) => ModernDialog(
        type: DialogType.error,
        title: title,
        message: message,
        primaryButtonText: 'OK',
      ),
    );
  }

  /// Show success dialog with modern styling
  void showSuccessDialog({
    required String message,
    String title = 'Success!',
  }) {
    showDialog(
      context: this,
      builder: (context) => ModernDialog(
        type: DialogType.success,
        title: title,
        message: message,
        primaryButtonText: 'OK',
      ),
    );
  }

  /// Show confirmation dialog with modern styling
  void showConfirmationDialog({
    required String title,
    required String message,
    required String actionText,
    required VoidCallback onConfirm,
    String cancelText = 'Cancel',
  }) {
    showDialog(
      context: this,
      builder: (context) => ModernDialog(
        type: DialogType.confirmation,
        title: title,
        message: message,
        primaryButtonText: actionText,
        secondaryButtonText: cancelText,
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          onConfirm();
        },
      ),
    );
  }

  /// Show warning dialog with modern styling
  void showWarningDialog({
    required String message,
    String title = 'Warning!',
  }) {
    showDialog(
      context: this,
      builder: (context) => ModernDialog(
        type: DialogType.warning,
        title: title,
        message: message,
        primaryButtonText: 'OK',
      ),
    );
  }

  /// Show info dialog with modern styling
  void showInfoDialog({
    required String message,
    String title = 'Information',
  }) {
    showDialog(
      context: this,
      builder: (context) => ModernDialog(
        type: DialogType.info,
        title: title,
        message: message,
        primaryButtonText: 'OK',
      ),
    );
  }

  // Deprecated method - use ModernDialog directly
  @deprecated
  void showGeneralDialog({
    required String title,
    String? message,
    required AlertType alertType,
    String? action,
    VoidCallback? onPressed,
  }) {
    DialogType dialogType;
    switch (alertType) {
      case AlertType.error:
        dialogType = DialogType.error;
        break;
      case AlertType.success:
        dialogType = DialogType.success;
        break;
      case AlertType.warning:
        dialogType = DialogType.warning;
        break;
      case AlertType.info:
        dialogType = DialogType.info;
        break;
      case AlertType.confirmation:
        dialogType = DialogType.confirmation;
        break;
      case AlertType.basic:
        dialogType = DialogType.info;
        break;
    }

    showDialog(
      context: this,
      builder: (context) => ModernDialog(
        type: dialogType,
        title: title,
        message: message ?? '',
        primaryButtonText: action ?? 'OK',
        onPrimaryPressed: onPressed,
      ),
    );
  }
}
