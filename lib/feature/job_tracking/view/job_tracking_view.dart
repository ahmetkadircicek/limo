import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_components.dart';

class JobTrackingView extends StatefulWidget {
  const JobTrackingView({super.key});

  @override
  State<JobTrackingView> createState() => _JobTrackingViewState();
}

class _JobTrackingViewState extends State<JobTrackingView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.surfaceContainer,
      child: const AppEmptyState(
        imagePath: 'assets/png/image/image_dashboard.png',
        title: 'Job Tracking',
        description: 'Track your active jobs and delivery progress here',
      ),
    );
  }
}
