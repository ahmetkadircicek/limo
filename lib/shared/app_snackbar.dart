import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

class AppSnackbar {
  /// Üstten kayan snackbar (custom overlay)
  static void show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 4),
  }) {
    final overlay = Overlay.of(context);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: -1, end: 0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value * 100),
                  child: child,
                );
              },
              child: GestureDetector(
                onTap: () {
                  if (entry.mounted) entry.remove();
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppText.body(
                          message,
                          color: Colors.white,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);
    Future.delayed(duration, () {
      if (entry.mounted) entry.remove();
    });
  }

  /// Yukarıdan kayan success snackbar
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      backgroundColor: context.success,
      duration: duration,
    );
  }

  /// Yukarıdan kayan error snackbar
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      backgroundColor: const Color(0xFFD72638),
      duration: duration,
    );
  }

  /// Yukarıdan kayan info snackbar
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      backgroundColor: const Color(0xFF3B82F6),
      duration: duration,
    );
  }

  /// Yukarıdan kayan warning snackbar
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      backgroundColor: const Color(0xFFF59E0B),
      duration: duration,
    );
  }
}

/// Extension ile kolay kullanım
extension AppSnackbarTopExtension on BuildContext {
  void showSuccessTopSnackbar(String message, {Duration? duration}) {
    AppSnackbar.showSuccess(
      this,
      message: message,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  void showErrorTopSnackbar(String message, {Duration? duration}) {
    AppSnackbar.showError(
      this,
      message: message,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  void showInfoTopSnackbar(String message, {Duration? duration}) {
    AppSnackbar.showInfo(
      this,
      message: message,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  void showWarningTopSnackbar(String message, {Duration? duration}) {
    AppSnackbar.showWarning(
      this,
      message: message,
      duration: duration ?? const Duration(seconds: 4),
    );
  }
}
