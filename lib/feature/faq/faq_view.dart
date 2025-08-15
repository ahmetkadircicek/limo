import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

class FAQView extends StatelessWidget {
  const FAQView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.paddingL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.question_answer,
              size: 64,
              color: context.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            AppText.title(
              'Coming Soon',
              color: context.primary,
            ),
            const SizedBox(height: 16),
            AppText.body(
              'FAQ feature will be available soon. Stay tuned for updates!',
              color: context.textSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
