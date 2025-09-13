import 'package:flutter/material.dart';

@immutable
final class ColorConstants {
  const ColorConstants._();

  // Primary / Secondary / Tertiary
  static const Color primary = Color(0xFF0A0A0A);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFF06B6D4);
  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color tertiary = Color(0xFF039FB0);
  static const Color onTertiary = Color(0xFFFFFFFF);

  // Surface / Background
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1A1A1A);
  static const Color onSurfaceVariant = Color(0xFFAAAAAA);
  // static const Color onSurfaceVariant3 = Color(0xFFDDDDDD);

  static const Color surfaceContainer = Color(0xFFF9F9F9);
  static const Color onSurfaceContainer = Color(0xFF2A2A2A);

  // Feedback / States
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFB00020);
  static const Color info = Color(0xFF1976D2);
  static const Color disabled = Color(0xFF9E9E9E);

  // Borders / Outline
  static const Color outline = Color(0xFFE0E0E0);

  static const Color google = Color(0xFFEA4335);
  static const Color apple = Color(0xFF000000);
}
