import 'package:flutter/material.dart';
import 'package:limo/shared/constants/icon_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';

class NavigationBarItemWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;
  final String label;

  const NavigationBarItemWidget({
    required this.icon,
    required this.onTap,
    required this.isSelected,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? context.secondary
                      : context.primary.withValues(alpha: 0.2),
              size: IconConstants.medium,
            ),
            Text(
              label,
              style: context.caption1.copyWith(
                color:
                    isSelected
                        ? context.secondary
                        : context.primary.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
