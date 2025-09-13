import 'package:flutter/material.dart';
import 'package:limo/shared/constants/icon_constants.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/radius_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';

class SharedInfo extends StatelessWidget {
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

  const SharedInfo({
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
      padding: PaddingConstants.all16,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.surface,
        borderRadius: RadiusConstants.standard,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? context.primary,
            size: IconConstants.medium,
          ),
          SizedBox(width: PaddingConstants.p8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.caption1.copyWith(
                    color:
                        labelColor ?? context.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  value,
                  style: context.caption1.copyWith(
                    color: valueColor ?? context.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: PaddingConstants.p8),
                  Text(
                    subtitle!,
                    style: context.caption1.copyWith(
                      color:
                          subtitleColor ??
                          context.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
          trailing ??
              Icon(
                Icons.chevron_right,
                color: context.onSurface.withValues(alpha: 0.6),
                size: IconConstants.medium,
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
