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
  final double fontSize;
  final Color? fontColor;
  final VoidCallback? onPressed;

  const GeneralButton({
    super.key,
    required this.text,
    required this.color,
    this.onPressed,
    required this.fontSize,
    this.fontColor,
    this.isValid,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        padding: PaddingConstants.zeroPadding,
        backgroundColor: color,
        disabledBackgroundColor: color.withOpacity(0.5),
        disabledForegroundColor: color,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: GeneralConstants
              .borderRadius, // Updated to use GeneralConstants for border radius
        ),
      ),
      icon: icon,
      label: FittedBox(
        child: GeneralText(
          text: text,
          color: fontColor ?? context.onPrimary,
          fontWeight: GeneralConstants.fontWeightBold,
          fontSize: fontSize,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
