import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';

class LightTheme {
  LightTheme._();

  static ThemeData theme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFD5C00),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF4C5D6E),
      onSecondary: Color(0xFFFFFFFF),
      tertiary: Color(0xFFF7F7F7),
      onTertiary: Color(0xFF1A1A1A),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1A1A1A),
      surfaceContainer: Color(0xFFF8F8F8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: GeneralConstants.borderRadius,
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: GeneralConstants.borderRadius,
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: GeneralConstants.borderRadius,
        borderSide: const BorderSide(color: Colors.transparent),
      ),
    ),
  );
}
