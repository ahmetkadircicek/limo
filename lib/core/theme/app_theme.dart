import 'package:flutter/material.dart';
import 'package:limo/shared/constants/color_constants.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _buildColorScheme(),
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
      surface: ColorConstants.white,
      onSurface: ColorConstants.codGray,
      surfaceContainer: ColorConstants.bonJour,
      surfaceContainerHighest: ColorConstants.bonJour,
      onSurfaceVariant: ColorConstants.silverChalice,
      error: ColorConstants.shiraz,
      onError: ColorConstants.white,
      outline: ColorConstants.bonJour,
      outlineVariant: ColorConstants.bonJour,
      shadow: ColorConstants.codGray,
      scrim: ColorConstants.codGray,
      inverseSurface: ColorConstants.codGray,
      onInverseSurface: ColorConstants.white,
      inversePrimary: ColorConstants.white,
      surfaceTint: ColorConstants.codGray,
    );
  }
}
