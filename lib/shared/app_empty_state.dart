import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';

import 'app_text.dart';

/// Reusable empty state component for displaying when there's no data
class AppEmptyState extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const AppEmptyState({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.paddingL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 100),
            SizedBox(height: context.spacingM),
            AppText.heading(
              title,
              color: context.onSurface,
              textAlign: TextAlign.center,
            ),
            AppText.bodySmall(
              description,
              color: context.onSurface.withValues(alpha: 0.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
