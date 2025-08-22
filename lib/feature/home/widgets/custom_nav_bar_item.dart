import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

/// Custom navigation bar item widget for the home view bottom navigation
class CustomNavBarItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;
  final bool isHighlighted;

  const CustomNavBarItem({
    super.key,
    required this.icon,
    required this.text,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == selectedIndex;
    final Color iconColor =
        isSelected ? context.secondary : context.surface.withValues(alpha: 0.4);

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor),
          AppText(
            text,
            color: iconColor,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
