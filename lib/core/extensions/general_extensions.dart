import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/constants/padding_constants.dart';

/// MERKEZI TEMA SİSTEMİ - Tüm tema özellikleri burada!
extension ThemeExtensions on BuildContext {
  // =============================================================================
  // COLORS - Tüm renkler context üzerinden
  // =============================================================================

  /// Primary Colors (Ana renkler)
  Color get primary => Theme.of(this).colorScheme.primary; // #0A0A0A
  Color get onPrimary => Theme.of(this).colorScheme.onPrimary; // #FFFFFF

  /// Secondary/Accent Colors (Vurgu renkleri)
  Color get secondary => Theme.of(this).colorScheme.secondary; // #06B6D4
  Color get onSecondary => Theme.of(this).colorScheme.onSecondary; // #FFFFFF
  Color get accent => secondary; // Alias for secondary

  /// Surface Colors (Yüzey renkleri)
  Color get surface => Theme.of(this).colorScheme.surface; // #FFFFFF
  Color get onSurface => Theme.of(this).colorScheme.onSurface; // #0A0A0A
  Color get surfaceContainer =>
      Theme.of(this).colorScheme.surfaceContainer; // #F6F6F6

  /// Tertiary Colors (Üçüncül renkler)
  Color get tertiary => Theme.of(this).colorScheme.tertiary; // #F6F6F6
  Color get onTertiary => Theme.of(this).colorScheme.onTertiary; // #0A0A0A

  /// Semantic Colors (Anlamsal renkler)
  Color get error => Theme.of(this).colorScheme.error; // #EF4444
  Color get onError => Theme.of(this).colorScheme.onError; // #FFFFFF
  Color get success => DesignTokens.success; // #16A34A
  Color get warning => DesignTokens.warning; // #F59E0B
  Color get danger => error; // Alias for error

  /// Text Colors (Metin renkleri)
  Color get textPrimary => DesignTokens.textPrimary; // #0A0A0A
  Color get textSecondary => DesignTokens.textSecondary; // #6B6B6B
  Color get textInverse => DesignTokens.textInverse; // #FFFFFF

  // =============================================================================
  // TYPOGRAPHY - Tüm text style'lar context üzerinden
  // =============================================================================

  TextStyle get displayXL => Theme.of(this).textTheme.displayLarge!;
  TextStyle get h1 => Theme.of(this).textTheme.headlineLarge!;
  TextStyle get h2 => Theme.of(this).textTheme.headlineMedium!;
  TextStyle get h3 => Theme.of(this).textTheme.titleLarge!;
  TextStyle get bodyLarge => Theme.of(this).textTheme.bodyLarge!;
  TextStyle get bodySmall => Theme.of(this).textTheme.bodyMedium!;
  TextStyle get caption => Theme.of(this).textTheme.bodySmall!;

  // =============================================================================
  // SPACING - Tüm spacing'ler context üzerinden
  // =============================================================================

  /// Base Spacing Values
  double get spacingXs => PaddingConstants.spacingXs; // 4
  double get spacingS => PaddingConstants.spacingS; // 8
  double get spacingM => PaddingConstants.spacingM; // 12
  double get spacingL => PaddingConstants.spacingL; // 16
  double get spacingXl => PaddingConstants.spacingXl; // 24
  double get spacingXxl => PaddingConstants.spacingXxl; // 32
  double get spacingXxxl => PaddingConstants.spacingXxxl; // 40

  /// EdgeInsets Shortcuts
  EdgeInsets get paddingXs => PaddingConstants.allXs;
  EdgeInsets get paddingS => PaddingConstants.allS;
  EdgeInsets get paddingM => PaddingConstants.allM;
  EdgeInsets get paddingL => PaddingConstants.allL;
  EdgeInsets get paddingXl => PaddingConstants.allXl;
  EdgeInsets get paddingXxl => PaddingConstants.allXxl;
  EdgeInsets get paddingXxxl => PaddingConstants.allXxxl;

  EdgeInsets get horizontalXs => PaddingConstants.horizontalXs;
  EdgeInsets get horizontalS => PaddingConstants.horizontalS;
  EdgeInsets get horizontalM => PaddingConstants.horizontalM;
  EdgeInsets get horizontalL => PaddingConstants.horizontalL;
  EdgeInsets get horizontalXl => PaddingConstants.horizontalXl;
  EdgeInsets get horizontalXxl => PaddingConstants.horizontalXxl;

  EdgeInsets get verticalXs => PaddingConstants.verticalXs;
  EdgeInsets get verticalS => PaddingConstants.verticalS;
  EdgeInsets get verticalM => PaddingConstants.verticalM;
  EdgeInsets get verticalL => PaddingConstants.verticalL;
  EdgeInsets get verticalXl => PaddingConstants.verticalXl;
  EdgeInsets get verticalXxl => PaddingConstants.verticalXxl;

  // =============================================================================
  // BORDER RADIUS - Tüm radius'lar context üzerinden
  // =============================================================================

  BorderRadius get radiusSmall =>
      BorderRadius.circular(DesignTokens.radiusSmall); // 4
  BorderRadius get radiusMedium =>
      BorderRadius.circular(DesignTokens.radiusMedium); // 8
  BorderRadius get radiusLarge =>
      BorderRadius.circular(DesignTokens.radiusLarge); // 16
  BorderRadius get radiusRound =>
      BorderRadius.circular(DesignTokens.radiusRound); // 9999

  // =============================================================================
  // BOX SHADOWS - Tüm shadow'lar context üzerinden
  // =============================================================================

  /// Subtle shadow for cards and elevated elements
  List<BoxShadow> get shadowSmall => [
    BoxShadow(
      color: surface.withValues(alpha: 0.08),
      blurRadius: 4,
      offset: const Offset(0, 1),
      spreadRadius: 0,
    ),
  ];

  /// Medium shadow for buttons and interactive elements
  List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: surface.withValues(alpha: 0.12),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Large shadow for modals and floating elements
  List<BoxShadow> get shadowLarge => [
    BoxShadow(
      color: surface.withValues(alpha: 0.16),
      blurRadius: 16,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Extra large shadow for prominent elements
  List<BoxShadow> get shadowXl => [
    BoxShadow(
      color: surface.withValues(alpha: 0.20),
      blurRadius: 24,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  /// Custom shadow with specified parameters
  List<BoxShadow> shadowCustom({
    double blurRadius = 8,
    Offset offset = const Offset(0, 2),
    double spreadRadius = 0,
    double alpha = 0.12,
  }) => [
    BoxShadow(
      color: surface.withValues(alpha: alpha),
      blurRadius: blurRadius,
      offset: offset,
      spreadRadius: spreadRadius,
    ),
  ];

  // =============================================================================
  // ELEVATION - Tüm shadow'lar context üzerinden
  // =============================================================================

  List<BoxShadow> get elevationNone => DesignTokens.elevationNone;
  List<BoxShadow> get elevationLow => DesignTokens.elevationLow;
  List<BoxShadow> get elevationMedium => DesignTokens.elevationMedium;
  List<BoxShadow> get elevationHigh => DesignTokens.elevationHigh;

  // =============================================================================
  // COMPONENT SIZES - Tüm component boyutları context üzerinden
  // =============================================================================

  double get buttonHeight => DesignTokens.primaryButtonHeight; // 48
  double get buttonHeightSecondary => DesignTokens.secondaryButtonHeight; // 44
  double get buttonHeightSmall => DesignTokens.smallButtonHeight; // 36
  double get inputHeight => DesignTokens.inputHeight; // 48
  double get appBarHeight => DesignTokens.topAppBarHeight; // 56
  double get bottomNavHeight => DesignTokens.bottomNavHeight; // 56
  double get fabSize => DesignTokens.fabRegular; // 56
  double get fabSizeSmall => DesignTokens.fabSmall; // 40

  // =============================================================================
  // ICON SIZES - Tüm icon boyutları context üzerinden
  // =============================================================================

  double get iconSmall => DesignTokens.iconSmall; // 16
  double get iconMedium => DesignTokens.iconMedium; // 20
  double get iconLarge => DesignTokens.iconLarge; // 24
  double get iconXL => DesignTokens.iconXL; // 32
  double get iconHitArea => DesignTokens.iconHitArea; // 44

  // =============================================================================
  // ANIMATION DURATIONS - Tüm animasyon süreleri context üzerinden
  // =============================================================================

  Duration get durationSmall => DesignTokens.durationSmall; // 100ms
  Duration get durationMedium => DesignTokens.durationMedium; // 200ms
  Duration get durationLarge => DesignTokens.durationLarge; // 350ms

  // =============================================================================
  // SCREEN DIMENSIONS - Ekran boyutları
  // =============================================================================

  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  Size get size => MediaQuery.of(this).size;

  // =============================================================================
  // RESPONSIVE BREAKPOINTS - Responsive tasarım
  // =============================================================================

  bool get isMobile => width <= 500.0;
  bool get isTablet => width < 1024.0 && width >= 650.0;
  bool get isSmallTablet => width < 650.0 && width > 500.0;
  bool get isDesktop => width >= 1024.0;
  bool get isSmall => width < 850.0 && width >= 560.0;

  // =============================================================================
  // UTILITY METHODS - Yardımcı metodlar
  // =============================================================================

  /// Responsive padding based on screen width
  EdgeInsets get responsivePadding => width > 600 ? horizontalXxl : horizontalL;

  /// Theme aware colors with opacity
  Color colorWithOpacity(Color color, double opacity) =>
      color.withValues(alpha: opacity);
}

// =============================================================================
// DEPRECATED - Backward Compatibility
// =============================================================================

extension BuildContextExtension<T> on BuildContext {
  // Text Style Extensions (DEPRECATED - Use context.h1, context.h2 etc.)
  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;
  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;
  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;
  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall;
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;
  TextStyle? get bodyLargeOld => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodySmallOld => Theme.of(this).textTheme.bodySmall;
  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;
  TextStyle? get labelMedium => Theme.of(this).textTheme.labelMedium;
  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall;
}

// =============================================================================
// UTILITY EXTENSIONS - Genel yardımcı metodlar
// =============================================================================

extension StringExtensions on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get formatCurrency => NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 2,
  ).format(double.tryParse(this) ?? 0);
}

extension DoubleExtensions on double {
  String get formatCurrency => NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 2,
  ).format(this);
}
