import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/providers/job_provider.dart';
import 'package:limo/module/jobs/widgets/job_card_widget.dart';
import 'package:limo/module/jobs/widgets/jobs_header_widget.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:provider/provider.dart';

class JobsSuccess extends StatelessWidget {
  const JobsSuccess({
    super.key,
    required this.scrollController,
    required this.onFilter,
  });

  final ScrollController scrollController;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();

    return RefreshIndicator(
      onRefresh: () => jobProvider.loadJobs(context, force: true),
      child: ListView.separated(
        controller: scrollController,
        padding: PaddingConstants.all24,
        itemCount: jobProvider.visibleJobs.length + 1,
        separatorBuilder:
            (context, index) => const SizedBox(height: PaddingConstants.p16),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _JobsHeader(
              activeCount: _activeJobCount(jobProvider),
              onFilter: onFilter,
            );
          }

          final job = jobProvider.visibleJobs[index - 1];

          return JobCard(
            job: job,
            onTap: () => context.push('/job/details', extra: job),
          );
        },
      ),
    );
  }

  int _activeJobCount(JobProvider jobProvider) {
    return jobProvider.jobs
        .where((job) => (job.status ?? 'active').toLowerCase() == 'active')
        .length;
  }
}

class _JobsHeader extends StatelessWidget {
  const _JobsHeader({required this.activeCount, required this.onFilter});

  final int activeCount;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return JobsHeaderWidget(activeCount: activeCount, onFilter: onFilter);
  }
}
