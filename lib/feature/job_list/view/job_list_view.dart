import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/viewmodel/job_list_view_model.dart';
import 'package:limo/feature/job_list/widgets/job_card_widget.dart';
import 'package:limo/feature/job_list/widgets/job_list_header_widget.dart';
import 'package:provider/provider.dart';

/// Job list view displaying available jobs with search and filtering capabilities
class JobListView extends StatefulWidget {
  final VoidCallback? onRefresh;

  const JobListView({super.key, this.onRefresh});

  @override
  State<JobListView> createState() => _JobListViewState();
}

class _JobListViewState extends State<JobListView> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JobListViewModel(),
      child: Consumer<JobListViewModel>(
        builder: (context, viewModel, child) {
          // Initialize the ViewModel when first built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (viewModel.jobs.isEmpty) {
              viewModel.initializeJobList();
            }
          });

          // Add search listener
          _searchController.addListener(() {
            viewModel.filterJobs(_searchController.text);
          });

          return Container(
            color: context.surfaceContainer,
            child: RefreshIndicator(
              onRefresh: () async {
                await viewModel.refreshJobList();
                widget.onRefresh?.call();
              },
              child: CustomScrollView(
                slivers: [
                  _buildHeaderSection(viewModel),
                  _buildJobListSection(viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build the header section with search and filters
  Widget _buildHeaderSection(JobListViewModel viewModel) {
    return SliverToBoxAdapter(
      child: JobListHeaderWidget(
        jobCount: viewModel.jobs.length,
        searchController: _searchController,
        onFilterTap: viewModel.showFilters,
      ),
    );
  }

  /// Build the job list section with proper padding
  Widget _buildJobListSection(JobListViewModel viewModel) {
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
            onTap: () => _navigateToJobDetails(job),
          );
        }, childCount: viewModel.filteredJobs.length),
      ),
    );
  }

  /// Navigate to job details page
  void _navigateToJobDetails(JobModel job) {
    debugPrint("Navigation to Job Details from Job List");
    context.push('/job-details', extra: job);
  }
}
