import 'package:flutter/material.dart';

extension BuildContextColorExtension on BuildContext {
  Color get primary => Theme.of(this).colorScheme.primary;
  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;

  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;

  Color get tertiary => Theme.of(this).colorScheme.tertiary;
  Color get onTertiary => Theme.of(this).colorScheme.onTertiary;

  Color get surface => Theme.of(this).colorScheme.surface;
  Color get onSurface => Theme.of(this).colorScheme.onSurface;
  Color get onSurfaceVariant => Theme.of(this).colorScheme.onSurfaceVariant;

  Color get error => Theme.of(this).colorScheme.error;
  Color get onError => Theme.of(this).colorScheme.onError;

  Color get success => Theme.of(this).colorScheme.secondaryContainer;
  Color get onSuccess => Theme.of(this).colorScheme.onSecondaryContainer;

  Color get warning => Theme.of(this).colorScheme.tertiaryContainer;
  Color get onWarning => Theme.of(this).colorScheme.onTertiaryContainer;

  Color get info => Theme.of(this).colorScheme.primaryContainer;
  Color get onInfo => Theme.of(this).colorScheme.onPrimaryContainer;

  Color get disabled => Theme.of(this).disabledColor;
  Color get outline => Theme.of(this).colorScheme.outline;

  Color get surfaceContainer => Theme.of(this).colorScheme.surfaceContainer;
  Color get onSurfaceContainer => Theme.of(this).colorScheme.onSurface;

  // Additional surface colors
  Color get surface200 => Theme.of(this).colorScheme.surfaceContainerHighest;

  // Text colors
  Color get textPrimary => Theme.of(this).colorScheme.onSurface;
  Color get textSecondary => Theme.of(this).colorScheme.onSurfaceVariant;
}
