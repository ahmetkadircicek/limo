import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

/// A reusable card widget for displaying document status with icon, label, value, and chevron
class DocumentStatusCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final Color? labelColor;
  final Color? valueColor;
  final VoidCallback? onTap;

  const DocumentStatusCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.labelColor,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: context.paddingL,
        decoration: BoxDecoration(
          color: context.surfaceContainer,
          borderRadius: context.radiusMedium,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? context.primary,
              size: context.iconMedium,
            ),
            SizedBox(width: context.spacingL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.caption(
                    label,
                    color: labelColor ?? context.onSurface,
                  ),
                  AppText.caption(
                    value,
                    color: valueColor ?? context.onSurface,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.onSurface.withValues(alpha: 0.6),
              size: context.iconMedium,
            ),
          ],
        ),
      ),
    );
  }
}
