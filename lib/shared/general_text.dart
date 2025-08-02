import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';

class GeneralText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final FontWeight? fontWeight;
  final double fontSize;
  final int? maxLines;
  final bool? isUnderline;

  const GeneralText({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.start,
    this.color,
    this.fontSize = GeneralConstants.fontSizeExtraSmall,
    this.maxLines = 2,
    this.isUnderline,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      // text.locale,
      text,
      style: GoogleFonts.nunito(
        color: color ?? Theme.of(context).colorScheme.onSurface,
        fontWeight: fontWeight,
        fontSize: fontSize,
        decoration: isUnderline == true
            ? TextDecoration.underline
            : TextDecoration.none,
        decorationThickness: 3,
        decorationColor: color,
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}
