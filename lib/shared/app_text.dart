import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:limo/core/extensions/general_extensions.dart';

/// Simple text component - unified styling
class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  // Factory constructors following Design System Typography
  const AppText.displayXL(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  })  : fontSize = 34.0, // DesignTokens.displayXL
        fontWeight = FontWeight.w600;

  const AppText.title(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  })  : fontSize = 28.0, // DesignTokens.h1
        fontWeight = FontWeight.w600;

  const AppText.subtitle(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  })  : fontSize = 22.0, // DesignTokens.h2
        fontWeight = FontWeight.w500;

  const AppText.heading(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  })  : fontSize = 18.0, // DesignTokens.h3
        fontWeight = FontWeight.w500;

  const AppText.body(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight = FontWeight.w400,
  }) : fontSize = 16.0; // DesignTokens.bodyLarge

  const AppText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  })  : fontSize = 14.0, // DesignTokens.bodySmall
        fontWeight = FontWeight.w400;

  const AppText.caption(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  })  : fontSize = 12.0, // DesignTokens.caption
        fontWeight = FontWeight.w600;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: fontSize ?? 16.0,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color ?? context.textPrimary, // Context'ten alınıyor
        height: _getLineHeight(fontSize ?? 16.0),
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  // Calculate line height based on design system ratios
  double _getLineHeight(double fontSize) {
    switch (fontSize) {
      case 34.0:
        return 40 / 34; // displayXL
      case 28.0:
        return 34 / 28; // h1
      case 22.0:
        return 28 / 22; // h2
      case 18.0:
        return 24 / 18; // h3
      case 16.0:
        return 22 / 16; // bodyLarge
      case 14.0:
        return 20 / 14; // bodySmall
      case 12.0:
        return 16 / 12; // caption
      default:
        return 1.4; // fallback
    }
  }
}
