import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

/// A reusable info box component for displaying informational messages
/// with different states (info, success, warning, error)
class AppInfo extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AppInfo({
    super.key,
    required this.message,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.iconSize,
    this.padding,
    this.borderRadius,
  });

  /// Info state with blue color
  factory AppInfo.info({
    Key? key,
    required String message,
    IconData? icon,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return AppInfo(
      key: key,
      message: message,
      icon: icon ?? Icons.info_outline,
      color: Colors.blue,
      backgroundColor: Colors.blue.withValues(alpha: 0.1),
      padding: padding,
      borderRadius: borderRadius,
    );
  }

  /// Success state with green color
  factory AppInfo.success({
    Key? key,
    required String message,
    IconData? icon,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return AppInfo(
      key: key,
      message: message,
      icon: icon ?? Icons.check_circle_outline,
      color: Colors.green,
      backgroundColor: Colors.green.withValues(alpha: 0.1),
      padding: padding,
      borderRadius: borderRadius,
    );
  }

  /// Warning state with orange color
  factory AppInfo.warning({
    Key? key,
    required String message,
    IconData? icon,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return AppInfo(
      key: key,
      message: message,
      icon: icon ?? Icons.warning_amber_outlined,
      color: Colors.orange,
      backgroundColor: Colors.orange.withValues(alpha: 0.1),
      padding: padding,
      borderRadius: borderRadius,
    );
  }

  /// Error state with red color
  factory AppInfo.error({
    Key? key,
    required String message,
    IconData? icon,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return AppInfo(
      key: key,
      message: message,
      icon: icon ?? Icons.error_outline,
      color: Colors.red,
      backgroundColor: Colors.red.withValues(alpha: 0.1),
      padding: padding,
      borderRadius: borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? context.primary;
    final defaultBackgroundColor =
        backgroundColor ?? defaultColor.withValues(alpha: 0.1);
    final defaultIconSize = iconSize ?? context.iconMedium;
    final defaultPadding = padding ?? context.paddingL;
    final defaultBorderRadius = borderRadius ?? context.radiusMedium;

    return Container(
      padding: defaultPadding,
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        borderRadius: defaultBorderRadius,
      ),
      child: Row(
        children: [
          Icon(icon, color: defaultColor, size: defaultIconSize),
          SizedBox(width: context.spacingM),
          Expanded(child: AppText.caption(message, color: defaultColor)),
        ],
      ),
    );
  }
}
