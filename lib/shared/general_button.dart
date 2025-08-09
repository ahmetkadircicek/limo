import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/shared/general_text.dart';

class GeneralButton extends StatelessWidget {
  final String text;
  final Color color;
  final Icon? icon;
  final bool? isValid;
  final double? fontSize;
  final Color? fontColor;
  final VoidCallback? onPressed;
  final double? height;
  final Widget? child;

  const GeneralButton({
    super.key,
    required this.text,
    required this.color,
    this.onPressed,
    this.fontSize,
    this.fontColor,
    this.isValid,
    this.icon,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonHeight = height ?? GeneralConstants.buttonHeight;
    final double effectiveFontSize = fontSize ?? GeneralConstants.fontSizeBody;

    return SizedBox(
      height: buttonHeight,
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          padding: PaddingConstants.horizontalL,
          backgroundColor: color,
          disabledBackgroundColor:
              color.withOpacity(GeneralConstants.opacityDisabled),
          disabledForegroundColor: color,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: GeneralConstants.borderRadius,
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        icon: icon != null
            ? Icon(icon!.icon,
                size: GeneralConstants.iconSizeSmall, color: icon!.color)
            : null,
        label: child ??
            FittedBox(
              child: GeneralText(
                text: text,
                color: fontColor ?? context.onPrimary,
                fontWeight: GeneralConstants.fontWeightSubtitle,
                fontSize: effectiveFontSize,
                textAlign: TextAlign.center,
              ),
            ),
      ),
    );
  }
}
