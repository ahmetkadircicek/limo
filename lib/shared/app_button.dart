import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_snackbar.dart';
import 'package:limo/shared/app_text.dart';

enum ButtonVariant { primary, secondary, tertiary, error, success, black, chip }

class AppButton extends StatelessWidget {
  final String text;
  final ButtonVariant variant;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final bool isLoading;

  const AppButton(
    this.text, {
    super.key,
    this.variant = ButtonVariant.primary,
    this.onPressed,
    this.icon,
    this.width,
    this.isLoading = false,
  });

  const AppButton.primary(
    this.text, {
    super.key,
    this.onPressed,
    this.icon,
    this.width,
    this.isLoading = false,
  }) : variant = ButtonVariant.primary;

  const AppButton.secondary(
    this.text, {
    super.key,
    this.onPressed,
    this.icon,
    this.width,
    this.isLoading = false,
  }) : variant = ButtonVariant.secondary;

  const AppButton.tertiary(
    this.text, {
    super.key,
    this.onPressed,
    this.icon,
    this.width,
    this.isLoading = false,
  }) : variant = ButtonVariant.tertiary;

  const AppButton.error(
    this.text, {
    super.key,
    this.onPressed,
    this.icon,
    this.width,
    this.isLoading = false,
  }) : variant = ButtonVariant.error;

  const AppButton.success(
    this.text, {
    super.key,
    this.onPressed,
    this.icon,
    this.width,
    this.isLoading = false,
  }) : variant = ButtonVariant.success;

  const AppButton.chip(
    this.text, {
    super.key,
    this.onPressed,
    this.icon,
    this.width,
    this.isLoading = false,
  }) : variant = ButtonVariant.chip;

  @override
  Widget build(BuildContext context) {
    final buttonHeight =
        variant == ButtonVariant.chip ? 40.0 : context.buttonHeight;
    final isEnabled = onPressed != null && !isLoading;
    final hasText = text.isNotEmpty;

    // Tertiary variant için width ve height eşit olsun
    final buttonWidth =
        variant == ButtonVariant.tertiary && !hasText ? buttonHeight : width;

    // onPressed null ise "Yapılacak" snackbar göster
    VoidCallback? handleOnPressed =
        onPressed ??
        (() {
          AppSnackbar.showInfo(context, message: 'Yapılacak');
        });

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              variant == ButtonVariant.chip
                  ? BorderRadius.circular(20.0)
                  : context.radiusMedium,
          boxShadow: _getShadow(context, isEnabled),
        ),
        child:
            hasText
                ? TextButton.icon(
                  onPressed: isEnabled ? handleOnPressed : null,
                  style: TextButton.styleFrom(
                    backgroundColor: _getBackgroundColor(context),
                    foregroundColor: _getForegroundColor(context),
                    disabledBackgroundColor: _getBackgroundColor(
                      context,
                    ).withValues(alpha: 0.5),
                    side: _getBorder(context),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          variant == ButtonVariant.chip
                              ? BorderRadius.circular(20.0)
                              : context.radiusMedium,
                    ),
                    shadowColor: Colors.transparent,
                    minimumSize: Size(0, buttonHeight),
                    padding:
                        variant == ButtonVariant.chip
                            ? const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            )
                            : null,
                    splashFactory:
                        variant == ButtonVariant.tertiary
                            ? NoSplash.splashFactory
                            : null,
                  ),
                  icon: _buildIcon(context, isEnabled),
                  label:
                      variant == ButtonVariant.chip
                          ? AppText.caption(
                            text,
                            color: _getForegroundColor(context),
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          )
                          : AppText.body(
                            text,
                            color: _getForegroundColor(context),
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center,
                          ),
                )
                : TextButton(
                  onPressed: isEnabled ? handleOnPressed : null,
                  style: TextButton.styleFrom(
                    backgroundColor: _getBackgroundColor(context),
                    foregroundColor: _getForegroundColor(context),
                    disabledBackgroundColor: _getBackgroundColor(
                      context,
                    ).withValues(alpha: 0.5),
                    side: _getBorder(context),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          variant == ButtonVariant.chip
                              ? BorderRadius.circular(20.0)
                              : context.radiusMedium,
                    ),
                    shadowColor: Colors.transparent,
                    minimumSize: Size(0, buttonHeight),
                    padding: EdgeInsets.zero,
                    splashFactory:
                        variant == ButtonVariant.tertiary
                            ? NoSplash.splashFactory
                            : null,
                  ),
                  child: _buildIcon(context, isEnabled),
                ),
      ),
    );
  }

  /// Build icon widget
  Widget _buildIcon(BuildContext context, bool isEnabled) {
    if (isLoading) {
      return SizedBox(
        width: variant == ButtonVariant.chip ? 16 : context.iconMedium,
        height: variant == ButtonVariant.chip ? 16 : context.iconMedium,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(_getForegroundColor(context)),
        ),
      );
    }

    if (icon != null) {
      return Icon(
        icon,
        size: variant == ButtonVariant.chip ? 16 : context.iconLarge,
        color: _getForegroundColor(context),
      );
    }

    return const SizedBox.shrink();
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
        return context.primary;
      case ButtonVariant.secondary:
        return context.secondary;
      case ButtonVariant.tertiary:
        return context.tertiary;
      case ButtonVariant.error:
        return context.error;
      case ButtonVariant.success:
        return context.success;
      case ButtonVariant.black:
        return Colors.black;
      case ButtonVariant.chip:
        return context.surface200;
    }
  }

  Color _getForegroundColor(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
        return context.onPrimary;
      case ButtonVariant.secondary:
        return context.onSecondary;
      case ButtonVariant.tertiary:
        return context.onTertiary;
      case ButtonVariant.error:
        return context.onError;
      case ButtonVariant.success:
        return Colors.white;
      case ButtonVariant.black:
        return Colors.white;
      case ButtonVariant.chip:
        return context.textPrimary;
    }
  }

  BorderSide? _getBorder(BuildContext context) {
    return null;
  }

  List<BoxShadow>? _getShadow(BuildContext context, bool isEnabled) {
    if (isEnabled && variant == ButtonVariant.primary) {
      return context.elevationLow;
    }
    return context.elevationNone;
  }
}
