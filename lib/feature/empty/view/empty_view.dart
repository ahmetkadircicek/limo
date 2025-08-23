import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_components.dart';

/// Simple empty view for features that are not yet developed
class EmptyView extends StatelessWidget {
  final String featureName;

  const EmptyView({super.key, this.featureName = 'This feature'});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.surfaceContainer,
      child: AppEmptyState(
        imagePath: 'assets/png/image/image_under_development.png',
        title: '$featureName is under development',
        description: 'This feature will be available in future updates',
      ),
    );
  }
}
