import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_components.dart';

/// Custom OAuth button widget for authentication
class OAuthButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final bool isLoading;
  final VoidCallback? onPressed;

  const OAuthButton({
    super.key,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color transparentColor = Colors.transparent;
    final double indicatorSize = 24;
    final double iconSize = 24;

    ButtonStyle buttonStyle = TextButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      disabledBackgroundColor: backgroundColor,
      padding: context.horizontalL,
      shape: RoundedRectangleBorder(borderRadius: context.radiusMedium),
      elevation: 0,
      shadowColor: transparentColor,
    );

    Widget buttonContent;
    if (isLoading) {
      buttonContent = Center(
        child: SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(textColor),
          ),
        ),
      );
    } else {
      buttonContent = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: iconSize, color: iconColor),
          SizedBox(width: context.spacingM),
          AppText.body(text, color: textColor, fontWeight: FontWeight.w500),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      height: context.buttonHeight,
      child: Container(
        decoration: BoxDecoration(borderRadius: context.radiusMedium),
        child: TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
        ),
      ),
    );
  }
}
