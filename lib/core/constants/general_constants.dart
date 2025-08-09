import 'package:flutter/material.dart';

class GeneralConstants {
  // DESIGN SYSTEM CONSTANTS

  // Heights
  static const buttonHeight = 48.0;
  static const inputHeight = 48.0;
  static const heightLarge = 56.0;
  static const heightMedium = 48.0;
  static const heightSmall = 40.0;
  static const heightExtraSmall = 32.0;

  // Border Radius
  static final borderRadius = BorderRadius.circular(12.0);
  static final borderRadiusSmall = BorderRadius.circular(8.0);
  static final borderRadiusLarge = BorderRadius.circular(16.0);
  static const borderRadiusValue = 12.0;

  // Font Sizes
  static const fontSizeCaption = 12.0; // Caption / Footnote
  static const fontSizeBody = 16.0; // Body Text
  static const fontSizeSubtitle = 18.0; // Subtitle
  static const fontSizeTitle = 24.0; // Title (AppBar / Headings)

  // Legacy font sizes for gradual migration
  static const fontSizeExtraSmall = 12.0;
  static const fontSizeSmall = 16.0;
  static const fontSizeMedium = 18.0;
  static const fontSizeLarge = 24.0;
  static const fontSizeExtraLarge = 28.0;

  // Font Weights
  static const fontWeightCaption = FontWeight.w300; // Caption
  static const fontWeightBody = FontWeight.w400; // Body
  static const fontWeightSubtitle = FontWeight.w500; // Subtitle
  static const fontWeightTitle = FontWeight.w600; // Title

  // Legacy font weights for gradual migration
  static const fontWeightLight = FontWeight.w300;
  static const fontWeightRegular = FontWeight.w400;
  static const fontWeightMedium = FontWeight.w500;
  static const fontWeightSemiBold = FontWeight.w600;
  static const fontWeightBold = FontWeight.w700;

  // Icon Sizes
  static const iconSizeDefault = 24.0;
  static const iconSizeSmall = 20.0;
  static const iconSizeLarge = 32.0;

  // Opacity
  static const opacityDisabled = 0.5;
  static const opacityOverlay = 0.4;
  static const opacityShadow = 0.1;
  static const opacityShadowMedium = 0.15;
  static const opacityShadowStrong = 0.2;

  // Shadow
  static const shadowBlurRadius = 8.0;
  static const shadowOffset = Offset(0, 2);
  static const shadowColor = Color(0x1A000000); // Black with 0.1 opacity

  // BoxShadow presets
  static const boxShadowDefault = [
    BoxShadow(
      color: shadowColor,
      blurRadius: shadowBlurRadius,
      offset: shadowOffset,
    ),
  ];

  static const boxShadowMedium = [
    BoxShadow(
      color: Color(0x26000000), // Black with 0.15 opacity
      blurRadius: 12.0,
      offset: Offset(0, 4),
    ),
  ];
}
