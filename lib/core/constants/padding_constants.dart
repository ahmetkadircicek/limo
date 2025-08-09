import 'package:flutter/material.dart';

class PaddingConstants {
  // DESIGN SYSTEM SPACING CONSTANTS

  // Base spacing values
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0; // Between elements
  static const double spacingL = 16.0; // Default
  static const double spacingXl = 20.0; // Horizontal page padding
  static const double spacingXxl = 24.0; // Section spacing (vertical)
  static const double spacingXxxl = 32.0;

  // Input field horizontal padding
  static const double inputPadding = 16.0;

  // Zero padding
  static const EdgeInsets zeroPadding = EdgeInsets.zero;

  // All sides padding
  static const EdgeInsets allXs = EdgeInsets.all(spacingXs);
  static const EdgeInsets allS = EdgeInsets.all(spacingS);
  static const EdgeInsets allM = EdgeInsets.all(spacingM);
  static const EdgeInsets allL = EdgeInsets.all(spacingL); // Default: 16.0
  static const EdgeInsets allXl =
      EdgeInsets.all(spacingXl); // Page padding: 20.0
  static const EdgeInsets allXxl = EdgeInsets.all(spacingXxl); // Section: 24.0
  static const EdgeInsets allXxxl = EdgeInsets.all(spacingXxxl);

  // Legacy naming for gradual migration
  static const EdgeInsets allSmall = EdgeInsets.all(spacingM); // 12.0
  static const EdgeInsets allMedium = EdgeInsets.all(spacingL); // 16.0
  static const EdgeInsets allLarge = EdgeInsets.all(spacingXxl); // 24.0

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
      EdgeInsets.symmetric(horizontal: spacingXl); // Page padding
  static const EdgeInsets horizontalXxl =
      EdgeInsets.symmetric(horizontal: spacingXxl);

  // Input field padding
  static const EdgeInsets inputHorizontal =
      EdgeInsets.symmetric(horizontal: inputPadding);

  // Legacy horizontal padding
  static const EdgeInsets symmetricHorizontalSmall =
      EdgeInsets.symmetric(horizontal: spacingM);
  static const EdgeInsets symmetricHorizontalMedium =
      EdgeInsets.symmetric(horizontal: spacingL);
  static const EdgeInsets symmetricHorizontalLarge =
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
      EdgeInsets.symmetric(vertical: spacingXxl); // Section spacing

  // Legacy vertical padding
  static const EdgeInsets symmetricVerticalSmall =
      EdgeInsets.symmetric(vertical: spacingM);
  static const EdgeInsets symmetricVerticalMedium =
      EdgeInsets.symmetric(vertical: spacingL);
  static const EdgeInsets symmetricVerticalLarge =
      EdgeInsets.symmetric(vertical: spacingXxl);

  // Directional padding - Top
  static const EdgeInsets onlyTopXs = EdgeInsets.only(top: spacingXs);
  static const EdgeInsets onlyTopS = EdgeInsets.only(top: spacingS);
  static const EdgeInsets onlyTopM = EdgeInsets.only(top: spacingM);
  static const EdgeInsets onlyTopL = EdgeInsets.only(top: spacingL);
  static const EdgeInsets onlyTopXl = EdgeInsets.only(top: spacingXl);
  static const EdgeInsets onlyTopXxl = EdgeInsets.only(top: spacingXxl);

  // Legacy top padding
  static const EdgeInsets onlyTopSmall = EdgeInsets.only(top: spacingM);
  static const EdgeInsets onlyTopMedium = EdgeInsets.only(top: spacingL);
  static const EdgeInsets onlyTopLarge = EdgeInsets.only(top: spacingXxl);

  // Directional padding - Bottom
  static const EdgeInsets onlyBottomXs = EdgeInsets.only(bottom: spacingXs);
  static const EdgeInsets onlyBottomS = EdgeInsets.only(bottom: spacingS);
  static const EdgeInsets onlyBottomM = EdgeInsets.only(bottom: spacingM);
  static const EdgeInsets onlyBottomL = EdgeInsets.only(bottom: spacingL);
  static const EdgeInsets onlyBottomXl = EdgeInsets.only(bottom: spacingXl);
  static const EdgeInsets onlyBottomXxl = EdgeInsets.only(bottom: spacingXxl);

  // Legacy bottom padding
  static const EdgeInsets onlyBottomSmall = EdgeInsets.only(bottom: spacingM);
  static const EdgeInsets onlyBottomMedium = EdgeInsets.only(bottom: spacingL);
  static const EdgeInsets onlyBottomLarge = EdgeInsets.only(bottom: spacingXxl);

  // Directional padding - Left
  static const EdgeInsets onlyLeftXs = EdgeInsets.only(left: spacingXs);
  static const EdgeInsets onlyLeftS = EdgeInsets.only(left: spacingS);
  static const EdgeInsets onlyLeftM = EdgeInsets.only(left: spacingM);
  static const EdgeInsets onlyLeftL = EdgeInsets.only(left: spacingL);
  static const EdgeInsets onlyLeftXl = EdgeInsets.only(left: spacingXl);
  static const EdgeInsets onlyLeftXxl = EdgeInsets.only(left: spacingXxl);

  // Legacy left padding
  static const EdgeInsets onlyLeftSmall = EdgeInsets.only(left: spacingM);
  static const EdgeInsets onlyLeftMedium = EdgeInsets.only(left: spacingL);
  static const EdgeInsets onlyLeftLarge = EdgeInsets.only(left: spacingXxl);

  // Directional padding - Right
  static const EdgeInsets onlyRightXs = EdgeInsets.only(right: spacingXs);
  static const EdgeInsets onlyRightS = EdgeInsets.only(right: spacingS);
  static const EdgeInsets onlyRightM = EdgeInsets.only(right: spacingM);
  static const EdgeInsets onlyRightL = EdgeInsets.only(right: spacingL);
  static const EdgeInsets onlyRightXl = EdgeInsets.only(right: spacingXl);
  static const EdgeInsets onlyRightXxl = EdgeInsets.only(right: spacingXxl);

  // Legacy right padding
  static const EdgeInsets onlyRightSmall = EdgeInsets.only(right: spacingM);
  static const EdgeInsets onlyRightMedium = EdgeInsets.only(right: spacingL);
  static const EdgeInsets onlyRightLarge = EdgeInsets.only(right: spacingXxl);
}
