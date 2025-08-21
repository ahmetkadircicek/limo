import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

enum ButtonVariant { primary, secondary, tertiary, error, success }

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

  @override
  Widget build(BuildContext context) {
    final buttonHeight = context.buttonHeight;
    final isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: width,
      height: buttonHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: context.radiusMedium,
          boxShadow: _getShadow(context, isEnabled),
        ),
        child: TextButton.icon(
          onPressed: isEnabled ? onPressed : null,
          style: TextButton.styleFrom(
            backgroundColor: _getBackgroundColor(context),
            foregroundColor: _getForegroundColor(context),
            disabledBackgroundColor: _getBackgroundColor(
              context,
            ).withValues(alpha: 0.5),
            side: _getBorder(context),
            shape: RoundedRectangleBorder(borderRadius: context.radiusMedium),
            shadowColor: Colors.transparent,
            minimumSize: Size(0, buttonHeight),
          ),
          icon:
              isLoading
                  ? SizedBox(
                    width: context.iconMedium,
                    height: context.iconMedium,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        _getForegroundColor(context),
                      ),
                    ),
                  )
                  : (icon != null
                      ? Icon(
                        icon,
                        size: context.iconLarge,
                        color: _getForegroundColor(context),
                      )
                      : null),
          label: AppText.body(
            text,
            color: _getForegroundColor(context),
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
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
