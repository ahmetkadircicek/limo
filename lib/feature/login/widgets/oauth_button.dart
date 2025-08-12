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
    return SizedBox(
      width: double.infinity,
      height: context.buttonHeight,
      child: Container(
        decoration: _buildButtonDecoration(),
        child: TextButton(
          onPressed: isLoading ? null : onPressed,
          style: _buildButtonStyle(context),
          child: _buildButtonContent(context),
        ),
      ),
    );
  }

  BoxDecoration _buildButtonDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(
        color: borderColor,
        width: 1,
      ),
    );
  }

  ButtonStyle _buildButtonStyle(BuildContext context) {
    return TextButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      disabledBackgroundColor: backgroundColor.withValues(alpha: 0.7),
      padding: context.horizontalL,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      shadowColor: Colors.transparent,
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return _buildLoadingIndicator();
    }
    return _buildButtonContentWithIcon(context);
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(iconColor),
        ),
      ),
    );
  }

  Widget _buildButtonContentWithIcon(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(
          icon,
          size: 24,
          color: iconColor,
        ),
        SizedBox(width: context.spacingM),
        AppText.body(
          text,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
