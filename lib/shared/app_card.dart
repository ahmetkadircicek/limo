import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';

enum CardVariant { primary, secondary, tertiary }

/// Unified card component with 3 variants
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final CardVariant variant;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.width,
    this.onTap,
    this.variant = CardVariant.primary,
  });

  // Factory constructors
  const AppCard.primary({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.width,
    this.onTap,
  }) : variant = CardVariant.primary;

  const AppCard.secondary({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.width,
    this.onTap,
  }) : variant = CardVariant.secondary;

  const AppCard.tertiary({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.width,
    this.onTap,
  }) : variant = CardVariant.tertiary;

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      height: height,
      width: width,
      padding: padding ?? context.paddingL, // Context'ten alınıyor
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: context.radiusMedium, // Context'ten alınıyor
        border: _getBorder(context),
        boxShadow: _getShadow(context), // Context'ten shadow
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: widget,
      );
    }

    return widget;
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (variant) {
      case CardVariant.primary:
        return context.surface; // White
      case CardVariant.secondary:
        return context.surfaceContainer; // Light gray - Context'ten
      case CardVariant.tertiary:
        return context.secondary.withValues(alpha: 0.05); // Subtle tint
    }
  }

  Border? _getBorder(BuildContext context) {
    switch (variant) {
      case CardVariant.primary:
        return null; // No border, just shadow
      case CardVariant.secondary:
        return Border.all(
          color: context.onSurface.withValues(alpha: 0.1),
          width: 1.0,
        );
      case CardVariant.tertiary:
        return Border.all(
          color: context.secondary.withValues(alpha: 0.2),
          width: 1.0,
        );
    }
  }

  List<BoxShadow>? _getShadow(BuildContext context) {
    switch (variant) {
      case CardVariant.primary:
        return context.elevationLow; // Context'ten elevation
      case CardVariant.secondary:
        return context.elevationNone; // Context'ten elevation
      case CardVariant.tertiary:
        return context.elevationNone; // No shadow - Context'ten
    }
  }
}
