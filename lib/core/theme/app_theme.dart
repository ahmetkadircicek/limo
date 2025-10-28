import 'package:flutter/material.dart';
import 'package:limo/shared/constants/color_constants.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/radius_constants.dart';
import 'package:limo/shared/constants/widget_constants.dart';

class AppTheme {
  static ThemeData get theme {
    final colorScheme = _buildColorScheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
    );
  }

  static ColorScheme _buildColorScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: ColorConstants.codGray,
      onPrimary: ColorConstants.white,
      secondary: ColorConstants.cerulean,
      onSecondary: ColorConstants.white,
      tertiary: ColorConstants.bondiBlue,
      onTertiary: ColorConstants.white,
      surface: ColorConstants.alabaster,
      onSurface: ColorConstants.codGray,
      surfaceContainer: ColorConstants.white,
      surfaceContainerHighest: ColorConstants.alabaster,
      onSurfaceVariant: ColorConstants.silverChalice,
      error: ColorConstants.shiraz,
      onError: ColorConstants.white,
      outline: ColorConstants.seashell,
      outlineVariant: ColorConstants.alabaster,
      shadow: ColorConstants.codGray,
      scrim: ColorConstants.codGray,
      inverseSurface: ColorConstants.codGray,
      onInverseSurface: ColorConstants.white,
      inversePrimary: ColorConstants.white,
      surfaceTint: ColorConstants.codGray,
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(
    ColorScheme colorScheme,
  ) {
    return InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: PaddingConstants.p16,
        vertical: PaddingConstants.p16,
      ),
      filled: true,
      fillColor: colorScheme.surfaceContainer,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      constraints: const BoxConstraints.tightFor(
        height: WidgetConstants.formFieldHeight,
      ),
      border: _outlineBorder(colorScheme.outline, 1),
      enabledBorder: _outlineBorder(colorScheme.outline, 1),
      disabledBorder: _outlineBorder(
        colorScheme.outline.withValues(alpha: 0.3),
        1,
      ),
      focusedBorder: _outlineBorder(colorScheme.primary, 1.5),
      errorBorder: _outlineBorder(colorScheme.error, 1),
      focusedErrorBorder: _outlineBorder(colorScheme.error, 1.5),
      errorStyle: const TextStyle(height: 0, color: Colors.transparent),
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      hintStyle: const TextStyle(fontSize: 13),
    );
  }

  static OutlineInputBorder _outlineBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: RadiusConstants.standard,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
