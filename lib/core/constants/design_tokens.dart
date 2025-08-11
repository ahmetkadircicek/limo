import 'package:flutter/material.dart';

/// Design System Tokens - Modern Design Language
class DesignTokens {
  // Spacing - 4pt base system
  static const double spacingBase = 4.0;
  static const double spacing1 = 4.0; // xs
  static const double spacing2 = 8.0; // sm
  static const double spacing3 = 12.0; // md
  static const double spacing4 = 16.0; // lg
  static const double spacing5 = 20.0; // xl
  static const double spacing6 = 24.0; // 2xl
  static const double spacing8 = 32.0; // 3xl
  static const double spacing10 = 40.0; // 4xl
  static const double spacing12 = 48.0; // 5xl
  static const double spacing16 = 64.0; // 6xl

  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 16.0;
  static const double radiusRound = 9999.0;

  // Elevation (Box Shadows)
  static const List<BoxShadow> elevationNone = [];

  static const List<BoxShadow> elevationLow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.08),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> elevationMedium = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.12),
      blurRadius: 18,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> elevationHigh = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.18),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  // Typography
  static const TextStyle displayXL = TextStyle(
    fontSize: 34,
    height: 40 / 34,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );

  // Colors
  static const Color primary900 = Color(0xFF0A0A0A);
  static const Color primary700 = Color(0xFF222222);

  static const Color surface100 = Color(0xFFFFFFFF);
  static const Color surface200 = Color(0xFFF6F6F6);

  static const Color accent500 = Color(0xFF06B6D4);
  static const Color accent700 = Color(0xFF039FB0);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  static const Color textPrimary = Color(0xFF0A0A0A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Component Specs
  static const double topAppBarHeight = 56.0;
  static const double bottomNavHeight = 56.0;
  static const double primaryButtonHeight = 48.0;
  static const double secondaryButtonHeight = 44.0;
  static const double smallButtonHeight = 36.0;
  static const double inputHeight = 48.0;
  static const double fabRegular = 56.0;
  static const double fabSmall = 40.0;
  static const double listItemSingle = 56.0;
  static const double listItemDouble = 72.0;
  static const double avatarSmall = 40.0;
  static const double avatarLarge = 56.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 20.0;
  static const double iconLarge = 24.0;
  static const double iconXL = 32.0;
  static const double iconHitArea = 44.0;

  // Motion
  static const Duration durationSmall = Duration(milliseconds: 100);
  static const Duration durationMedium = Duration(milliseconds: 200);
  static const Duration durationLarge = Duration(milliseconds: 350);

  static const Curve standardEasing = Curves.easeInOut;
  static const Curve modalEasing = Curves.easeOutBack;
}
