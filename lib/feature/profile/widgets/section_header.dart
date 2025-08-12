import 'package:flutter/material.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

/// A reusable section header widget with icon and title
class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final Color? titleColor;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? context.primary).withValues(alpha: 0.1),
            borderRadius: GeneralConstants.borderRadius,
          ),
          child: Icon(
            icon,
            color: iconColor ?? context.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        AppText.heading(
          title,
          color: titleColor ?? context.onSurface,
        ),
      ],
    );
  }
}
