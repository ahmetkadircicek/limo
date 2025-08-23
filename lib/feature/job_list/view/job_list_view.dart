import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/view/job_list_mixin.dart';
import 'package:limo/feature/job_list/widgets/job_card_widget.dart';
import 'package:limo/feature/job_search/view/job_search_view.dart';
import 'package:limo/shared/app_components.dart';

/// Job list view displaying available jobs
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
    initializeViewModelIfNeeded();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disposeJobListMixin();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainContainer(context);
  }

  /// Build the main container with scroll view
  Widget _buildMainContainer(BuildContext context) {
    return Container(
      color: context.surfaceContainer,
      child: CustomScrollView(
        slivers: [_buildSearchSection(), _buildJobListSection()],
      ),
    );
  }

  /// Build the search section with search field and filter button
  Widget _buildSearchSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(context.spacingL),
        child: AppCard.primary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: context.spacingL,
            children: [
              // Header section with title and job count
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: context.spacingS,
                      children: [
                        AppText.heading('Available Jobs'),
                        AppText.bodySmall(
                          '${viewModel.jobs.length} jobs found',
                          color: context.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  AppButton.chip(
                    'Filter',
                    icon: Icons.tune,
                    onPressed: _showFilters,
                  ),
                ],
              ),
              // Search input
              GestureDetector(
                onTap: () => _navigateToSearch(),
                child: AppInput.search(
                  hintText: 'Search jobs...',
                  enabled: false, // Make it non-functional
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show filter options
  void _showFilters() {
    AppSnackbar.showInfo(context, message: 'Filters will be implemented soon');
  }

  /// Navigate to search page
  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JobSearchView()),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return const AppEmptyState(
      imagePath: 'assets/png/image/image_dashboard.png',
      title: 'No jobs available',
      description: 'Check back later for new job opportunities',
    );
  }

  /// Build the job list section with proper padding
  Widget _buildJobListSection() {
    if (viewModel.jobs.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildEmptyState(),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        context.spacingL,
        context.spacingS,
        context.spacingL,
        context.spacingXxl + context.spacingL,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final job = viewModel.jobs[index];
          return JobCardWidget(
            job: job,
            onTap: () {
              // Job details navigation will be implemented later
            },
          );
        }, childCount: viewModel.jobs.length),
      ),
    );
  }
}
