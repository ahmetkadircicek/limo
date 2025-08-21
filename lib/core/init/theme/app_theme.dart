import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:limo/core/constants/design_tokens.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.montserrat().fontFamily,
    colorScheme: const ColorScheme.light(
      primary: DesignTokens.primary900,
      onPrimary: DesignTokens.textInverse,
      secondary: DesignTokens.accent500,
      onSecondary: DesignTokens.textInverse,
      tertiary: DesignTokens.surface200,
      onTertiary: DesignTokens.textPrimary,
      surface: DesignTokens.surface100,
      onSurface: DesignTokens.textPrimary,
      surfaceContainer: DesignTokens.surface200,
      error: DesignTokens.danger,
      onError: DesignTokens.textInverse,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: const BorderSide(
          color: DesignTokens.surface200,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: const BorderSide(
          color: DesignTokens.surface200,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: const BorderSide(
          color: DesignTokens.primary900,
          width: 1.0,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: const BorderSide(
          color: DesignTokens.surface200,
          width: 1.0,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing3,
        vertical: DesignTokens.spacing4,
      ),
    ),
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
    textTheme: TextTheme(
      displayLarge: DesignTokens.displayXL.copyWith(
        color: DesignTokens.textPrimary,
      ),
      headlineLarge: DesignTokens.h1.copyWith(color: DesignTokens.textPrimary),
      headlineMedium: DesignTokens.h2.copyWith(color: DesignTokens.textPrimary),
      titleLarge: DesignTokens.h3.copyWith(color: DesignTokens.textPrimary),
      bodyLarge: DesignTokens.bodyLarge.copyWith(
        color: DesignTokens.textPrimary,
      ),
      bodyMedium: DesignTokens.bodySmall.copyWith(
        color: DesignTokens.textPrimary,
      ),
      bodySmall: DesignTokens.caption.copyWith(
        color: DesignTokens.textSecondary,
      ),
      labelLarge: DesignTokens.bodySmall.copyWith(
        color: DesignTokens.textPrimary,
        fontWeight: FontWeight.w500,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: DesignTokens.surface100,
      foregroundColor: DesignTokens.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: DesignTokens.h3,
      toolbarHeight: DesignTokens.topAppBarHeight,
    ),
    cardTheme: CardThemeData(
      color: DesignTokens.surface100,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      margin: const EdgeInsets.all(DesignTokens.spacing2),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: DesignTokens.primary900,
      selectedItemColor: DesignTokens.accent500,
      unselectedItemColor: DesignTokens.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: DesignTokens.accent500,
      foregroundColor: DesignTokens.textInverse,
      elevation: DesignTokens.spacing2,
      shape: CircleBorder(),
    ),
    dividerTheme: const DividerThemeData(
      color: DesignTokens.surface200,
      thickness: 1,
      space: DesignTokens.spacing1,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: DesignTokens.surface100,
      elevation: DesignTokens.spacing2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        side: const BorderSide(color: DesignTokens.surface200, width: 1.0),
      ),
      textStyle: GoogleFonts.montserrat(
        fontSize: DesignTokens.bodyLarge.fontSize,
        fontWeight: FontWeight.w400,
        color: DesignTokens.textPrimary,
        height: DesignTokens.bodyLarge.height,
      ),
    ),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(DesignTokens.surface100),
        elevation: WidgetStateProperty.all(DesignTokens.spacing2),
        shadowColor: WidgetStateProperty.all(
          Colors.black.withValues(alpha: 0.08),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            side: const BorderSide(color: DesignTokens.surface200, width: 1.0),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            vertical: DesignTokens.spacing2,
            horizontal: DesignTokens.spacing1,
          ),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: DesignTokens.surface100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        side: const BorderSide(color: DesignTokens.surface200, width: 1.0),
      ),
      titleTextStyle: GoogleFonts.montserrat(
        fontSize: DesignTokens.h3.fontSize,
        fontWeight: FontWeight.w500,
        color: DesignTokens.textPrimary,
        height: DesignTokens.h3.height,
      ),
      contentTextStyle: GoogleFonts.montserrat(
        fontSize: DesignTokens.bodyLarge.fontSize,
        fontWeight: FontWeight.w400,
        color: DesignTokens.textPrimary,
        height: DesignTokens.bodyLarge.height,
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: DesignTokens.surface100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        side: const BorderSide(color: DesignTokens.surface200, width: 1.0),
      ),
      headerBackgroundColor: DesignTokens.primary900,
      headerForegroundColor: DesignTokens.textInverse,
      headerHeadlineStyle: GoogleFonts.montserrat(
        fontSize: DesignTokens.h3.fontSize,
        fontWeight: FontWeight.w600,
        color: DesignTokens.textInverse,
      ),
      headerHelpStyle: GoogleFonts.montserrat(
        fontSize: DesignTokens.bodySmall.fontSize,
        fontWeight: FontWeight.w400,
        color: DesignTokens.textInverse.withValues(alpha: 0.7),
        height: DesignTokens.bodySmall.height,
      ),
      dayStyle: GoogleFonts.montserrat(
        fontSize: DesignTokens.bodyLarge.fontSize,
        fontWeight: FontWeight.w500,
        color: DesignTokens.primary900,
        height: DesignTokens.bodyLarge.height,
      ),
      yearStyle: GoogleFonts.montserrat(
        fontSize: DesignTokens.bodyLarge.fontSize,
        fontWeight: FontWeight.w500,
        color: DesignTokens.primary900,
        height: DesignTokens.bodyLarge.height,
      ),
      weekdayStyle: GoogleFonts.montserrat(
        fontSize: DesignTokens.bodySmall.fontSize,
        fontWeight: FontWeight.w600,
        color: DesignTokens.accent500,
        height: DesignTokens.bodySmall.height,
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: DesignTokens.surface200,
      elevation: DesignTokens.spacing2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      confirmButtonStyle: ElevatedButton.styleFrom(
        backgroundColor: DesignTokens.primary900,
        foregroundColor: DesignTokens.textInverse,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
      ),
      cancelButtonStyle: ElevatedButton.styleFrom(
        backgroundColor: DesignTokens.surface200,
        foregroundColor: DesignTokens.textPrimary,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
      ),
      hourMinuteTextStyle: GoogleFonts.montserrat(
        fontSize: DesignTokens.h1.fontSize,
        fontWeight: FontWeight.w600,
        color: DesignTokens.textInverse, // Seçili saat text'i beyaz
        height: DesignTokens.h1.height,
      ),
      hourMinuteColor: DesignTokens.accent500, // Seçili saat background'ı mavi
      hourMinuteShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      dayPeriodTextStyle: GoogleFonts.montserrat(
        fontSize: DesignTokens.bodyLarge.fontSize,
        fontWeight: FontWeight.w500,
        color: DesignTokens.accent500,
        height: DesignTokens.bodyLarge.height,
      ),
      dayPeriodColor: DesignTokens.accent500,
      dayPeriodBorderSide: BorderSide(
        color: DesignTokens.primary900.withValues(alpha: 0.1),
        width: 1,
      ),
      dialHandColor: DesignTokens.accent500, // Seçili saat için mavi ok
      dialBackgroundColor:
          DesignTokens.surface100, // Dial arka planı surface container
      dialTextColor:
          DesignTokens.textSecondary, // Seçili olmayan saatler için gri
      dialTextStyle: GoogleFonts.montserrat(
        fontSize: DesignTokens.bodyLarge.fontSize,
        fontWeight: FontWeight.w500,
        color: DesignTokens.textSecondary, // Seçili olmayan saatler için gri
        height: DesignTokens.bodyLarge.height,
      ),
      helpTextStyle: GoogleFonts.montserrat(
        fontSize: DesignTokens.bodySmall.fontSize,
        fontWeight: FontWeight.w400,
        color: DesignTokens.primary900,
        height: DesignTokens.bodySmall.height,
      ),
      entryModeIconColor: Colors.transparent,
    ),
    splashFactory: InkRipple.splashFactory,
  );
}
