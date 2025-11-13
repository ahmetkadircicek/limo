import 'package:flutter/material.dart';
import 'package:limo/core/providers/job_provider.dart';
import 'package:limo/module/jobs/models/jobs_filter.dart';
import 'package:limo/module/jobs/widgets/jobs_filter_sheet.dart';
import 'package:limo/module/jobs/widgets/jobs_header_widget.dart';
import 'package:limo/module/jobs/widgets/jobs_success.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/widgets/shared_async_status_builder.dart';
import 'package:provider/provider.dart';

class JobsView extends StatefulWidget {
  const JobsView({super.key});

  @override
  State<JobsView> createState() => _JobsViewState();
}

class _JobsViewState extends State<JobsView> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<JobProvider>().loadJobs(context);
      scrollController.addListener(_onScrollPositionChanged);
    });
  }

  void _onScrollPositionChanged() {
    final jobProvider = context.read<JobProvider>();
    if (!scrollController.hasClients) return;
    final maxExtent = scrollController.position.maxScrollExtent;
    final offset = scrollController.offset;
    if (maxExtent - offset < 200) {
      jobProvider.loadMore();
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScrollPositionChanged);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobProvider>(
      builder: (context, jobProvider, _) {
        return SharedAsyncStatusBuilder(
          status: jobProvider.status,
          errorMessage: jobProvider.errorMessage,
          idleBuilder: (_) => const _JobsLoadingState(),
          loadingBuilder: (_) => const _JobsLoadingState(),
          emptyBuilder:
              (_) => _JobsEmptyState(
                onRefresh: () => context.read<JobProvider>().loadJobs(context),
              ),
          errorBuilder: (context, message) {
            return _JobsErrorState(
              message: message,
              onRetry: () => context.read<JobProvider>().loadJobs(context),
            );
          },
          successBuilder:
              (_) => JobsSuccess(
                scrollController: scrollController,
                onFilter: () => _onFilterPressed(context),
              ),
        );
      },
    );
  }

  Future<void> _onFilterPressed(BuildContext context) async {
    final jobProvider = context.read<JobProvider>();
    final initial = jobProvider.filter;

    final JobsFilterModel? result = await showModalBottomSheet<JobsFilterModel>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => JobsFilterSheet(initial: initial),
    );

    if (result == null) return;
    if (result.isEmpty) {
      jobProvider.clearFilter();
      return;
    }
    jobProvider.setFilter(result);
  }
}

class _JobsEmptyState extends StatelessWidget {
  const _JobsEmptyState({required this.onRefresh});
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: PaddingConstants.all24,
      children: [
        JobsHeaderWidget(
          activeCount: 0,
          onFilter: () => _onFilterPressed(context),
        ),
        const SizedBox(height: PaddingConstants.p16),
        const Icon(Icons.event_note_outlined, size: 64),
        const SizedBox(height: PaddingConstants.p16),
        Text(
          'No jobs yet',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: PaddingConstants.p8),
        Text(
          'Create a new job to see it listed here.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: PaddingConstants.p16),
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

  void _onFilterPressed(BuildContext context) {
    final state = context.findAncestorStateOfType<_JobsViewState>();
    state?._onFilterPressed(context);
  }
}

class _JobsErrorState extends StatelessWidget {
  const _JobsErrorState({this.message, required this.onRetry});
  final String? message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: PaddingConstants.all24,
      children: [
        JobsHeaderWidget(
          activeCount: 0,
          onFilter: () => _onFilterPressed(context),
        ),
        const SizedBox(height: PaddingConstants.p16),
        const Icon(Icons.error_outline, size: 64),
        const SizedBox(height: PaddingConstants.p16),
        Text(
          message ?? 'Failed to load jobs.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: PaddingConstants.p16),
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

  void _onFilterPressed(BuildContext context) {
    final state = context.findAncestorStateOfType<_JobsViewState>();
    state?._onFilterPressed(context);
  }
}

class _JobsLoadingState extends StatelessWidget {
  const _JobsLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
