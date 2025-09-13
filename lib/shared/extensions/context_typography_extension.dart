import 'package:flutter/material.dart';

extension HIGTextTheme on BuildContext {
  TextStyle get largeTitle => Theme.of(this).textTheme.displayLarge!;
  TextStyle get title1 => Theme.of(this).textTheme.headlineMedium!;
  TextStyle get title2 => Theme.of(this).textTheme.headlineSmall!;
  TextStyle get title3 => Theme.of(this).textTheme.titleLarge!;
  TextStyle get headline => Theme.of(this).textTheme.titleMedium!;
  TextStyle get body => Theme.of(this).textTheme.bodyLarge!;
  TextStyle get callout => Theme.of(this).textTheme.bodyMedium!;
  TextStyle get subhead => Theme.of(this).textTheme.bodySmall!;
  TextStyle get footnote => Theme.of(this).textTheme.labelMedium!;
  TextStyle get caption1 => Theme.of(this).textTheme.labelSmall!;
  TextStyle get caption2 => Theme.of(this).textTheme.displaySmall!;
}
