import 'package:flutter/material.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

/// A reusable card widget for displaying profile information with icon, label, and value
class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? badgeText;
  final Color? iconColor;
  final Color? labelColor;
  final Color? valueColor;
  final VoidCallback? onTap;

  const ProfileInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.badgeText,
    this.iconColor,
    this.labelColor,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: GeneralConstants.borderRadius,
        border: Border.all(
          color: context.onSurface.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? context.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.caption(
                  label,
                  color: labelColor ?? context.onSurface.withValues(alpha: 0.6),
                ),
                AppText.caption(value, color: valueColor ?? context.onSurface),
              ],
            ),
          ),
          if (badgeText != null)
            Container(
              padding:
                  PaddingConstants.horizontalS + PaddingConstants.verticalXs,
              decoration: BoxDecoration(
                color: context.primary.withValues(alpha: 0.1),
                borderRadius: GeneralConstants.borderRadiusRound,
              ),
              child: AppText.caption(badgeText!, color: context.primary),
            ),
          if (onTap != null) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: context.onSurface.withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return card;

    return InkWell(
      onTap: onTap,
      borderRadius: GeneralConstants.borderRadius,
      child: card,
    );
  }
}
