import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

class AppSnackbar {
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
          top: context.spacingM,
          left: context.spacingM,
          right: context.spacingM,
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
                  padding: context.paddingL,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: context.radiusMedium,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppText.body(
                          message,
                          color: context.onSurface,
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

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      backgroundColor: context.error,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      backgroundColor: context.secondary,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      backgroundColor: context.warning,
      duration: duration,
    );
  }
}

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
