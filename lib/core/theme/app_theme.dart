import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:limo/shared/constants/color_constants.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/radius_constants.dart';

// Border width constants
class AppBorderWidth {
  static const double thin = 1.0;
  static const double medium = 2.0;
}

// Elevation constants
class AppElevation {
  static const double none = 0.0;
  static const double low = 4.0;
  static const double medium = 6.0;
  static const double high = 8.0;
}

// Font size constants
class AppFontSize {
  static const double small = 12.0;
  static const double body = 14.0;
  static const double medium = 16.0;
  static const double large = 18.0;
}

// Icon size constants
class AppIconSize {
  static const double small = 16.0;
  static const double medium = 24.0;
  static const double large = 32.0;
}

// Button size constants
class AppButtonSize {
  static const double height = 48.0;
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: _buildColorScheme(),

      // Input Decoration Theme
      inputDecorationTheme: _buildInputDecorationTheme(),

      // Text Theme
      textTheme: _buildTextTheme(),

      // Button Themes
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),

      // Card Theme
      cardTheme: _buildCardTheme(),

      // AppBar Theme
      appBarTheme: _buildAppBarTheme(),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(),

      // Dialog Theme
      dialogTheme: _buildDialogTheme(),

      // SnackBar Theme
      snackBarTheme: _buildSnackBarTheme(),

      // Chip Theme
      chipTheme: _buildChipTheme(),

      // Divider Theme
      dividerTheme: _buildDividerTheme(),

      // List Tile Theme
      listTileTheme: _buildListTileTheme(),

      // Switch Theme
      switchTheme: _buildSwitchTheme(),

      // Checkbox Theme
      checkboxTheme: _buildCheckboxTheme(),

      // Radio Theme
      radioTheme: _buildRadioTheme(),

      // Progress Indicator Theme
      progressIndicatorTheme: _buildProgressIndicatorTheme(),

      // Floating Action Button Theme
      floatingActionButtonTheme: _buildFloatingActionButtonTheme(),

      // Tab Bar Theme
      tabBarTheme: _buildTabBarTheme(),

      // Dropdown Menu Theme
      dropdownMenuTheme: _buildDropdownMenuTheme(),
    );
  }

  // Color Scheme
  static ColorScheme _buildColorScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: ColorConstants.primary,
      onPrimary: ColorConstants.onPrimary,
      secondary: ColorConstants.secondary,
      onSecondary: ColorConstants.onSecondary,
      tertiary: ColorConstants.tertiary,
      onTertiary: ColorConstants.onTertiary,
      surface: ColorConstants.surface,
      onSurface: ColorConstants.onSurface,
      surfaceContainer: ColorConstants.surfaceContainer,
      surfaceContainerHighest: ColorConstants.surfaceContainer,
      onSurfaceVariant: ColorConstants.onSurfaceVariant,
      error: ColorConstants.error,
      onError: ColorConstants.onPrimary,
      outline: ColorConstants.outline,
      outlineVariant: ColorConstants.outline,
      shadow: ColorConstants.primary,
      scrim: ColorConstants.primary,
      inverseSurface: ColorConstants.primary,
      onInverseSurface: ColorConstants.onPrimary,
      inversePrimary: ColorConstants.onPrimary,
      surfaceTint: ColorConstants.primary,
    );
  }

  // Input Decoration Theme
  static InputDecorationTheme _buildInputDecorationTheme() {
    return const InputDecorationTheme(
      filled: true,
      fillColor: ColorConstants.surfaceContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(RadiusConstants.standardRadius),
        ),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(RadiusConstants.standardRadius),
        ),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(RadiusConstants.standardRadius),
        ),
        borderSide: BorderSide(
          color: ColorConstants.primary,
          width: AppBorderWidth.medium,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(RadiusConstants.standardRadius),
        ),
        borderSide: BorderSide(
          color: ColorConstants.error,
          width: AppBorderWidth.thin,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(RadiusConstants.standardRadius),
        ),
        borderSide: BorderSide(
          color: ColorConstants.error,
          width: AppBorderWidth.medium,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: PaddingConstants.p16,
        vertical: PaddingConstants.p16,
      ),
      hintStyle: TextStyle(
        color: ColorConstants.onSurfaceVariant,
        fontSize: AppFontSize.body,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: TextStyle(
        color: ColorConstants.onSurfaceVariant,
        fontSize: AppFontSize.body,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: TextStyle(
        color: ColorConstants.error,
        fontSize: AppFontSize.small,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // Text Theme
  static TextTheme _buildTextTheme() {
    return GoogleFonts.poppinsTextTheme();
  }

  // Elevated Button Theme
  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.primary,
        foregroundColor: ColorConstants.onPrimary,
        disabledBackgroundColor: ColorConstants.primary.withValues(alpha: 0.5),
        disabledForegroundColor: ColorConstants.onPrimary.withValues(
          alpha: 0.5,
        ),
        elevation: AppElevation.none,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusConstants.standardRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingConstants.p20,
          vertical: PaddingConstants.p16,
        ),
        minimumSize: const Size(0, AppButtonSize.height),
        textStyle: const TextStyle(
          fontSize: AppFontSize.medium,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Outlined Button Theme
  static OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorConstants.primary,
        disabledForegroundColor: ColorConstants.disabled,
        side: const BorderSide(
          color: ColorConstants.primary,
          width: AppBorderWidth.thin,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusConstants.standardRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingConstants.p20,
          vertical: PaddingConstants.p16,
        ),
        minimumSize: const Size(0, 48),
        textStyle: const TextStyle(
          fontSize: AppFontSize.medium,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Text Button Theme
  static TextButtonThemeData _buildTextButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorConstants.primary,
        disabledForegroundColor: ColorConstants.disabled,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusConstants.standardRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingConstants.p20,
          vertical: PaddingConstants.p16,
        ),
        minimumSize: const Size(0, 48),
        textStyle: const TextStyle(
          fontSize: AppFontSize.medium,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Card Theme
  static CardThemeData _buildCardTheme() {
    return CardThemeData(
      color: ColorConstants.surface,
      elevation: 0,
      shadowColor: ColorConstants.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusConstants.standardRadius),
      ),
      margin: const EdgeInsets.all(PaddingConstants.p8),
    );
  }

  // AppBar Theme
  static AppBarTheme _buildAppBarTheme() {
    return const AppBarTheme(
      backgroundColor: ColorConstants.surface,
      foregroundColor: ColorConstants.onSurface,
      elevation: AppElevation.none,
      shadowColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: ColorConstants.onSurface,
        fontSize: AppFontSize.large,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(
        color: ColorConstants.onSurface,
        size: AppIconSize.medium,
      ),
      actionsIconTheme: IconThemeData(
        color: ColorConstants.onSurface,
        size: AppIconSize.medium,
      ),
    );
  }

  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme() {
    return const BottomNavigationBarThemeData(
      backgroundColor: ColorConstants.surface,
      selectedItemColor: ColorConstants.primary,
      unselectedItemColor: ColorConstants.onSurfaceVariant,
      selectedLabelStyle: TextStyle(
        fontSize: AppFontSize.small,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: AppFontSize.small,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: AppElevation.high,
    );
  }

  // Dialog Theme
  static DialogThemeData _buildDialogTheme() {
    return DialogThemeData(
      backgroundColor: ColorConstants.surface,
      elevation: AppElevation.high,
      shadowColor: ColorConstants.primary.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusConstants.standardRadius),
      ),
      titleTextStyle: const TextStyle(
        color: ColorConstants.onSurface,
        fontSize: AppFontSize.large,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: const TextStyle(
        color: ColorConstants.onSurfaceVariant,
        fontSize: AppFontSize.body,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // SnackBar Theme
  static SnackBarThemeData _buildSnackBarTheme() {
    return SnackBarThemeData(
      backgroundColor: ColorConstants.onSurface,
      contentTextStyle: const TextStyle(
        color: ColorConstants.surface,
        fontSize: AppFontSize.body,
        fontWeight: FontWeight.w400,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusConstants.standardRadius),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: AppElevation.low,
    );
  }

  // Chip Theme
  static ChipThemeData _buildChipTheme() {
    return ChipThemeData(
      backgroundColor: ColorConstants.surfaceContainer,
      selectedColor: ColorConstants.primary,
      disabledColor: ColorConstants.disabled,
      labelStyle: const TextStyle(
        color: ColorConstants.onSurfaceContainer,
        fontSize: AppFontSize.body,
        fontWeight: FontWeight.w400,
      ),
      secondarySelectedColor: ColorConstants.secondary,
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingConstants.p12,
        vertical: PaddingConstants.p8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusConstants.roundRadius),
      ),
      side: BorderSide.none,
    );
  }

  // Divider Theme
  static DividerThemeData _buildDividerTheme() {
    return const DividerThemeData(
      color: ColorConstants.outline,
      thickness: AppBorderWidth.thin,
      space: AppBorderWidth.thin,
    );
  }

  // List Tile Theme
  static ListTileThemeData _buildListTileTheme() {
    return const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(
        horizontal: PaddingConstants.p16,
        vertical: PaddingConstants.p8,
      ),
      titleTextStyle: TextStyle(
        color: ColorConstants.onSurface,
        fontSize: AppFontSize.medium,
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: TextStyle(
        color: ColorConstants.onSurfaceVariant,
        fontSize: AppFontSize.body,
        fontWeight: FontWeight.w400,
      ),
      leadingAndTrailingTextStyle: TextStyle(
        color: ColorConstants.onSurfaceVariant,
        fontSize: AppFontSize.body,
        fontWeight: FontWeight.w400,
      ),
      iconColor: ColorConstants.onSurfaceVariant,
      textColor: ColorConstants.onSurface,
    );
  }

  // Switch Theme
  static SwitchThemeData _buildSwitchTheme() {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorConstants.primary;
        }
        return ColorConstants.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorConstants.primary.withValues(alpha: 0.3);
        }
        return ColorConstants.outline;
      }),
    );
  }

  // Checkbox Theme
  static CheckboxThemeData _buildCheckboxTheme() {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorConstants.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(ColorConstants.onPrimary),
      side: const BorderSide(
        color: ColorConstants.outline,
        width: AppBorderWidth.medium,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusConstants.standardRadius),
      ),
    );
  }

  // Radio Theme
  static RadioThemeData _buildRadioTheme() {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorConstants.primary;
        }
        return ColorConstants.outline;
      }),
    );
  }

  // Progress Indicator Theme
  static ProgressIndicatorThemeData _buildProgressIndicatorTheme() {
    return const ProgressIndicatorThemeData(
      color: ColorConstants.primary,
      linearTrackColor: ColorConstants.surfaceContainer,
      circularTrackColor: ColorConstants.surfaceContainer,
    );
  }

  // Floating Action Button Theme
  static FloatingActionButtonThemeData _buildFloatingActionButtonTheme() {
    return const FloatingActionButtonThemeData(
      backgroundColor: ColorConstants.primary,
      foregroundColor: ColorConstants.onPrimary,
      elevation: AppElevation.medium,
      shape: CircleBorder(),
    );
  }

  // Tab Bar Theme
  static TabBarThemeData _buildTabBarTheme() {
    return const TabBarThemeData(
      labelColor: ColorConstants.primary,
      unselectedLabelColor: ColorConstants.onSurfaceVariant,
      labelStyle: TextStyle(
        fontSize: AppFontSize.body,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: AppFontSize.body,
        fontWeight: FontWeight.w400,
      ),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: ColorConstants.primary,
          width: AppBorderWidth.medium,
        ),
      ),
      indicatorSize: TabBarIndicatorSize.label,
    );
  }

  // Dropdown Menu Theme
  static DropdownMenuThemeData _buildDropdownMenuTheme() {
    return DropdownMenuThemeData(
      textStyle: const TextStyle(
        fontSize: AppFontSize.medium,
        fontWeight: FontWeight.w400,
        color: ColorConstants.onSurface,
      ),
      menuStyle: MenuStyle(
        backgroundColor: const WidgetStatePropertyAll(
          ColorConstants.surfaceContainer,
        ),
        elevation: WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusConstants.standardRadius),
            side: const BorderSide(
              color: ColorConstants.outline,
              width: AppBorderWidth.thin,
            ),
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            vertical: PaddingConstants.p8,
            horizontal: PaddingConstants.p12,
          ),
        ),
        maximumSize: const WidgetStatePropertyAll<Size>(Size(300, 400)),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: ColorConstants.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(RadiusConstants.standardRadius),
          ),
          borderSide: BorderSide(
            color: ColorConstants.outline,
            width: AppBorderWidth.thin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(RadiusConstants.standardRadius),
          ),
          borderSide: BorderSide(
            color: ColorConstants.outline,
            width: AppBorderWidth.thin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(RadiusConstants.standardRadius),
          ),
          borderSide: BorderSide(
            color: ColorConstants.primary,
            width: AppBorderWidth.medium,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: PaddingConstants.p12,
          horizontal: PaddingConstants.p12,
        ),
      ),
    );
  }
}
