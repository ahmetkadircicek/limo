import 'package:flutter/material.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_components.dart';

/// Simple dialog and snackbar system
extension AppDialogExtension on BuildContext {
  void showSuccessDialog(String message) {
    showDialog(
      context: this,
      builder: (context) => _AppDialog(
        title: 'Başarılı',
        message: message,
        isSuccess: true,
      ),
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: this,
      builder: (context) => _AppDialog(
        title: 'Hata',
        message: message,
        isSuccess: false,
      ),
    );
  }

  static void showError(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => _AppDialog(
        title: title,
        message: message,
        isSuccess: false,
      ),
    );
  }

  static void showInfo(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => _AppDialog(
        title: title,
        message: message,
        isSuccess: true, // Info dialog uses success styling
      ),
    );
  }

  void showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: AppText.body(message, color: Colors.white),
        backgroundColor: const Color(0xFF00B14F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: AppText.body(message, color: Colors.white),
        backgroundColor: const Color(0xFFD72638),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool isSuccess;

  const _AppDialog({
    required this.title,
    required this.message,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppCard.primary(
        padding: PaddingConstants.allXxl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color:
                  isSuccess ? const Color(0xFF00B14F) : const Color(0xFFD72638),
              size: 48,
            ),
            const SizedBox(height: 16),
            AppText.title(title),
            const SizedBox(height: 8),
            AppText.body(
              message,
              textAlign: TextAlign.center,
              color: context.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 24),
            AppButton.primary(
              'Tamam',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

// Snackbar extension methods
extension SnackbarExtension on BuildContext {
  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444), // semantic.danger
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF16A34A), // semantic.success
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
