import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:limo/core/constants/design_tokens.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.nunito().fontFamily,

    // Professional Design Language Color System
    colorScheme: const ColorScheme.light(
      primary: DesignTokens.primary900, // #0A0A0A
      onPrimary: DesignTokens.textInverse, // #FFFFFF
      secondary: DesignTokens.accent500, // #06B6D4
      onSecondary: DesignTokens.textInverse, // #FFFFFF
      tertiary: DesignTokens.surface200, // #F6F6F6
      onTertiary: DesignTokens.textPrimary, // #0A0A0A
      surface: DesignTokens.surface100, // #FFFFFF
      onSurface: DesignTokens.textPrimary, // #0A0A0A
      surfaceContainer: DesignTokens.surface200, // #F6F6F6
      error: DesignTokens.danger, // #EF4444
      onError: DesignTokens.textInverse, // #FFFFFF
    ),

    // Professional input decoration following design system
    inputDecorationTheme: InputDecorationTheme(
      filled: false, // filled: true yerine false yap
      border: InputBorder.none, // Border radius tanımını kaldır
      enabledBorder: InputBorder.none, // Border radius tanımını kaldır
      focusedBorder: InputBorder.none, // Border radius tanımını kaldır
      disabledBorder: InputBorder.none, // Border radius tanımını kaldır
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing3,
        vertical: DesignTokens.spacing4,
      ),
    ),

    // Professional button styling following design system
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DesignTokens.primary900,
        foregroundColor: DesignTokens.textInverse,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing4,
          vertical: DesignTokens.spacing3,
        ),
        minimumSize: const Size(0, DesignTokens.primaryButtonHeight),
      ),
    ),

    // Professional typography system following design tokens
    textTheme: TextTheme(
      displayLarge:
          DesignTokens.displayXL.copyWith(color: DesignTokens.textPrimary),
      headlineLarge: DesignTokens.h1.copyWith(color: DesignTokens.textPrimary),
      headlineMedium: DesignTokens.h2.copyWith(color: DesignTokens.textPrimary),
      titleLarge: DesignTokens.h3.copyWith(color: DesignTokens.textPrimary),
      bodyLarge:
          DesignTokens.bodyLarge.copyWith(color: DesignTokens.textPrimary),
      bodyMedium:
          DesignTokens.bodySmall.copyWith(color: DesignTokens.textPrimary),
      bodySmall:
          DesignTokens.caption.copyWith(color: DesignTokens.textSecondary),
      labelLarge: DesignTokens.bodySmall.copyWith(
        color: DesignTokens.textPrimary,
        fontWeight: FontWeight.w500,
      ),
    ),

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: DesignTokens.surface100,
      foregroundColor: DesignTokens.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: DesignTokens.h3,
      toolbarHeight: DesignTokens.topAppBarHeight,
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: DesignTokens.surface100,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      margin: const EdgeInsets.all(DesignTokens.spacing2),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: DesignTokens.primary900,
      selectedItemColor: DesignTokens.accent500,
      unselectedItemColor: DesignTokens.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // FloatingActionButton Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: DesignTokens.accent500,
      foregroundColor: DesignTokens.textInverse,
      elevation: DesignTokens.spacing2,
      shape: CircleBorder(),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: DesignTokens.surface200,
      thickness: 1,
      space: DesignTokens.spacing1,
    ),

    // Popup Menu Theme for consistent dropdown styling
    popupMenuTheme: PopupMenuThemeData(
      color: DesignTokens.surface100,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
        side: const BorderSide(
          color: DesignTokens.surface200,
          width: 1.0,
        ),
      ),
    ),

    // Dropdown Menu Theme for Flutter 3.7+ comprehensive styling
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(DesignTokens.surface100),
        elevation: WidgetStateProperty.all(8),
        shadowColor:
            WidgetStateProperty.all(Colors.black.withValues(alpha: 0.08)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
            side: const BorderSide(
              color: DesignTokens.surface200,
              width: 1.0,
            ),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: DesignTokens.spacing2),
        ),
      ),
      textStyle: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: DesignTokens.textPrimary,
      ),
    ),

    // Animation Duration
    splashFactory: InkRipple.splashFactory,
  );
}
