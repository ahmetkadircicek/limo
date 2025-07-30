import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension BuildContextExtension<T> on BuildContext {
  // Size Extensions
  bool get isMobile => width <= 500.0;
  bool get isTablet => width < 1024.0 && width >= 650.0;
  bool get isSmallTablet => width < 650.0 && width > 500.0;
  bool get isDesktop => width >= 1024.0;
  bool get isSmall => width < 850.0 && width >= 560.0;

  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  Size get size => MediaQuery.of(this).size;

  // Text Style Extensions
  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;
  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;
  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;
  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;
  TextStyle? get titleTextStyle => Theme.of(this).appBarTheme.titleTextStyle;
  TextStyle? get bodyExtraSmall => bodySmall?.copyWith(fontSize: 10, height: 1.6, letterSpacing: .5);
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get dividerTextSmall =>
      bodySmall?.copyWith(letterSpacing: 0.5, fontWeight: FontWeight.w700, fontSize: 12.0);
  TextStyle? get dividerTextLarge =>
      bodySmall?.copyWith(letterSpacing: 1.5, fontWeight: FontWeight.w700, fontSize: 13.0, height: 1.23);

  // Color Extensions
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get primaryColorDark => Theme.of(this).primaryColorDark;
  Color get primaryColorLight => Theme.of(this).primaryColorLight;
  Color get primary => Theme.of(this).colorScheme.primary;
  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;
  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;
  Color get cardColor => Theme.of(this).cardColor;
  Color get error => Theme.of(this).colorScheme.error;
  Color get onError => Theme.of(this).colorScheme.onError;
  Color get errorContainer => Theme.of(this).colorScheme.errorContainer;
  Color get surface => Theme.of(this).colorScheme.surface;
  Color get onSurface => Theme.of(this).colorScheme.onSurface;
  Color get surfaceContainer => Theme.of(this).colorScheme.surfaceContainer;
  Color get onSecondaryContainer => Theme.of(this).colorScheme.onSecondaryContainer;

  // Spacer
  Widget spacerHeight(double percentage) {
    final height = MediaQuery.of(this).size.height * (percentage / 100);
    return SizedBox(height: height);
  }

  Widget spacerWidth(double percentage) {
    final width = MediaQuery.of(this).size.width * (percentage / 100);
    return SizedBox(width: width);
  }
}

extension DateTimeExtension on DateTime {
  String toFormattedString() {
    return DateFormat('dd-MM-yyyy').format(this);
  }
}
