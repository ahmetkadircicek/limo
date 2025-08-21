import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/job_model.dart';

/// Header widget for job details with title and company information
class JobDetailsHeaderWidget extends StatelessWidget {
  final JobModel job;

  const JobDetailsHeaderWidget({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job.description ?? 'No description available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          if (job.companyName != null)
            Text(
              job.companyName!,
              style: TextStyle(
                fontSize: 16,
                color: context.onSurface.withValues(alpha: 0.7),
              ),
            ),
        ],
      ),
    );
  }
}
