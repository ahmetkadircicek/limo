import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/providers/job_provider.dart';
import 'package:limo/module/jobs/widgets/job_card_widget.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/widgets/shared_async_status_builder.dart';
import 'package:provider/provider.dart';

class JobsView extends StatefulWidget {
  const JobsView({super.key});

  @override
  State<JobsView> createState() => _JobsViewState();
}

class _JobsViewState extends State<JobsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<JobProvider>().loadJobs(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobProvider>(
      builder: (context, jobProvider, _) {
        return SharedAsyncStatusBuilder(
          status: jobProvider.status,
          errorMessage: jobProvider.errorMessage,
          idleBuilder: (_) => const Center(child: CircularProgressIndicator()),
          loadingBuilder:
              (_) => const Center(child: CircularProgressIndicator()),
          emptyBuilder:
              (_) => _JobsEmptyState(
                onRefresh: () => context.read<JobProvider>().loadJobs(context),
              ),
          errorBuilder:
              (ctx, message) => _JobsErrorState(
                message: message,
                onRetry: () => ctx.read<JobProvider>().loadJobs(ctx),
              ),
          successBuilder:
              (_) => RefreshIndicator(
                onRefresh: () => context.read<JobProvider>().loadJobs(context),
                child: ListView.separated(
                  padding: PaddingConstants.all12,
                  itemCount: jobProvider.jobs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final job = jobProvider.jobs[i];
                    return JobCard(
                      job: job,
                      onTap: () => context.push('/job/details', extra: job),
                    );
                  },
                ),
              ),
        );
      },
    );
  }
}

class _JobsEmptyState extends StatelessWidget {
  const _JobsEmptyState({required this.onRefresh});
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: PaddingConstants.all32,
      children: [
        const Icon(Icons.event_note_outlined, size: 64),
        const SizedBox(height: 16),
        Text(
          'No jobs yet',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Create a new job to see it listed here.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ),
      ],
    );
  }
}

class _JobsErrorState extends StatelessWidget {
  const _JobsErrorState({this.message, required this.onRetry});
  final String? message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: PaddingConstants.all32,
      children: [
        const Icon(Icons.error_outline, size: 64),
        const SizedBox(height: 16),
        Text(
          message ?? 'Failed to load jobs.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ),
      ],
    );
  }
}
