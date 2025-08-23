import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

enum CardVariant { primary, secondary, tertiary }

/// Unified card component with 3 variants
class AppCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final CardVariant variant;

  const AppCard({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.onTap,
    this.variant = CardVariant.primary,
  });

  // Factory constructors
  const AppCard.primary({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.onTap,
  }) : variant = CardVariant.primary;

  const AppCard.secondary({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.onTap,
  }) : variant = CardVariant.secondary;

  const AppCard.tertiary({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.onTap,
  }) : variant = CardVariant.tertiary;

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      height: height,
      width: width,
      padding: context.paddingL,
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: context.radiusMedium,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: widget);
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
}

/// A reusable card widget for displaying information with icon, label, value, and chevron
/// Perfect for status cards, location cards, and other info display cards
class AppInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final Color? iconColor;
  final Color? labelColor;
  final Color? valueColor;
  final Color? subtitleColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const AppInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.iconColor,
    this.labelColor,
    this.valueColor,
    this.subtitleColor,
    this.backgroundColor,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      padding: context.paddingL,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.surfaceContainer,
        borderRadius: context.radiusMedium,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? context.primary,
            size: context.iconMedium,
          ),
          SizedBox(width: context.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.caption(
                  label,
                  color: labelColor ?? context.onSurface.withValues(alpha: 0.6),
                ),
                AppText.caption(value, color: valueColor ?? context.onSurface),
                if (subtitle != null) ...[
                  SizedBox(height: context.spacingS),
                  AppText.caption(
                    subtitle!,
                    color:
                        subtitleColor ??
                        context.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ],
            ),
          ),
          trailing ??
              Icon(
                Icons.chevron_right,
                color: context.onSurface.withValues(alpha: 0.6),
                size: context.iconMedium,
              ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: cardContent);
    }

    return cardContent;
  }
}
