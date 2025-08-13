import 'package:flutter/material.dart';
import 'package:limo/core/constants/design_tokens.dart';

class PaddingConstants {
  // PROFESSIONAL DESIGN SYSTEM SPACING - 4pt base system

  // Base spacing values - Following design tokens
  static const double spacingXs = DesignTokens.spacing1; // 4.0
  static const double spacingS = DesignTokens.spacing2; // 8.0
  static const double spacingM = DesignTokens.spacing3; // 12.0
  static const double spacingL = DesignTokens.spacing4; // 16.0
  static const double spacingXl = DesignTokens.spacing6; // 24.0
  static const double spacingXxl = DesignTokens.spacing8; // 32.0
  static const double spacingXxxl = DesignTokens.spacing10; // 40.0

  // Component specific padding - Following design system
  static const double inputPadding = DesignTokens.spacing3; // 12.0

  // EdgeInsets shortcuts for common use cases
  static const EdgeInsets allXs = EdgeInsets.all(spacingXs);
  static const EdgeInsets allS = EdgeInsets.all(spacingS);
  static const EdgeInsets allM = EdgeInsets.all(spacingM);
  static const EdgeInsets allL = EdgeInsets.all(spacingL);
  static const EdgeInsets allXl = EdgeInsets.all(spacingXl);
  static const EdgeInsets allXxl = EdgeInsets.all(spacingXxl);
  static const EdgeInsets allXxxl = EdgeInsets.all(spacingXxxl);

  // Horizontal padding
  static const EdgeInsets horizontalXs =
      EdgeInsets.symmetric(horizontal: spacingXs);
  static const EdgeInsets horizontalS =
      EdgeInsets.symmetric(horizontal: spacingS);
  static const EdgeInsets horizontalM =
      EdgeInsets.symmetric(horizontal: spacingM);
  static const EdgeInsets horizontalL =
      EdgeInsets.symmetric(horizontal: spacingL);
  static const EdgeInsets horizontalXl =
      EdgeInsets.symmetric(horizontal: spacingXl);
  static const EdgeInsets horizontalXxl =
      EdgeInsets.symmetric(horizontal: spacingXxl);

  // Vertical padding
  static const EdgeInsets verticalXs =
      EdgeInsets.symmetric(vertical: spacingXs);
  static const EdgeInsets verticalS = EdgeInsets.symmetric(vertical: spacingS);
  static const EdgeInsets verticalM = EdgeInsets.symmetric(vertical: spacingM);
  static const EdgeInsets verticalL = EdgeInsets.symmetric(vertical: spacingL);
  static const EdgeInsets verticalXl =
      EdgeInsets.symmetric(vertical: spacingXl);
  static const EdgeInsets verticalXxl =
      EdgeInsets.symmetric(vertical: spacingXxl);

  // Single-side padding
  static const EdgeInsets onlyTopS = EdgeInsets.only(top: spacingS);
  static const EdgeInsets onlyTopM = EdgeInsets.only(top: spacingM);
  static const EdgeInsets onlyTopL = EdgeInsets.only(top: spacingL);
  static const EdgeInsets onlyTopXl = EdgeInsets.only(top: spacingXl);

  static const EdgeInsets onlyBottomXs = EdgeInsets.only(bottom: spacingXs);
  static const EdgeInsets onlyBottomS = EdgeInsets.only(bottom: spacingS);
  static const EdgeInsets onlyBottomM = EdgeInsets.only(bottom: spacingM);
  static const EdgeInsets onlyBottomL = EdgeInsets.only(bottom: spacingL);
  static const EdgeInsets onlyBottomXl = EdgeInsets.only(bottom: spacingXl);

  static const EdgeInsets onlyLeftS = EdgeInsets.only(left: spacingS);
  static const EdgeInsets onlyLeftM = EdgeInsets.only(left: spacingM);
  static const EdgeInsets onlyLeftL = EdgeInsets.only(left: spacingL);
  static const EdgeInsets onlyLeftXl = EdgeInsets.only(left: spacingXl);

  static const EdgeInsets onlyRightS = EdgeInsets.only(right: spacingS);
  static const EdgeInsets onlyRightM = EdgeInsets.only(right: spacingM);
  static const EdgeInsets onlyRightL = EdgeInsets.only(right: spacingL);
  static const EdgeInsets onlyRightXl = EdgeInsets.only(right: spacingXl);

  // Deprecated - for backward compatibility
  static const EdgeInsets allSmall = allS;
  static const EdgeInsets allMedium = allM;
  static const EdgeInsets allLarge = allL;

  // Missing getters for backward compatibility
  static const EdgeInsets symmetricVerticalSmall = verticalS;
  static const EdgeInsets inputHorizontal = horizontalM;
}
