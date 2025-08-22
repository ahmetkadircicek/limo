import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/view/job_list_mixin.dart';
import 'package:limo/feature/job_list/widgets/job_card_widget.dart';
import 'package:limo/feature/job_list/widgets/job_list_header_widget.dart';

/// Job list view displaying available jobs with search and filtering capabilities
class JobListView extends StatefulWidget {
  const JobListView({super.key});

  @override
  State<JobListView> createState() => _JobListViewState();
}

class _JobListViewState extends State<JobListView>
    with WidgetsBindingObserver, JobListMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeJobListMixin();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disposeJobListMixin();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeViewModelIfNeeded();
    setupSearchListener();

    return _buildMainContainer(context);
  }

  /// Build the main container with refresh indicator and scroll view
  Widget _buildMainContainer(BuildContext context) {
    return Container(
      color: context.surfaceContainer,
      child: CustomScrollView(
        slivers: [_buildHeaderSection(), _buildJobListSection()],
      ),
    );
  }

  /// Build the header section with search and filters
  Widget _buildHeaderSection() {
    return SliverToBoxAdapter(
      child: JobListHeaderWidget(
        jobCount: viewModel.jobs.length,
        searchController: searchController,
        onFilterTap: viewModel.showFilters,
      ),
    );
  }

  /// Build the job list section with proper padding
  Widget _buildJobListSection() {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        context.spacingL,
        context.spacingS,
        context.spacingL,
        context.spacingXxl + context.spacingL,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final job = viewModel.filteredJobs[index];
          return JobCardWidget(
            job: job,
            onTap: () => navigateToJobDetails(context, job),
          );
        }, childCount: viewModel.filteredJobs.length),
      ),
    );
  }
}
