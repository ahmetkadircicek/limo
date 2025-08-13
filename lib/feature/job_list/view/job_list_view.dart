import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/shared/app_input.dart';
import 'package:limo/shared/app_text.dart';

/// Job list view displaying available jobs with search and filtering capabilities
class JobListView extends StatefulWidget {
  final VoidCallback? onRefresh;

  const JobListView({super.key, this.onRefresh});

  @override
  State<JobListView> createState() => _JobListViewState();
}

class _JobListViewState extends State<JobListView> with WidgetsBindingObserver {
  List<JobModel> _jobs = [];
  List<JobModel> _filteredJobs = [];
  final TextEditingController _searchController = TextEditingController();
  final String _selectedJobType = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeJobList();
    _searchController.addListener(_filterJobs);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh jobs when app becomes visible
    if (state == AppLifecycleState.resumed) {
      _refreshJobList();
    }
  }

  /// Initialize the job list (currently empty - mock data removed)
  void _initializeJobList() {
    setState(() {
      _jobs = [];
      _filteredJobs = [];
    });
  }

  /// Filter jobs based on search query and job type
  void _filterJobs() {
    final query = _searchController.text.toLowerCase();

    _filteredJobs = _jobs.where((job) {
      final matchesSearch = query.isEmpty ||
          (job.fromProvince?.toLowerCase().contains(query) ?? false) ||
          (job.toProvince?.toLowerCase().contains(query) ?? false) ||
          (job.fromCity?.toLowerCase().contains(query) ?? false) ||
          (job.toCity?.toLowerCase().contains(query) ?? false) ||
          (job.companyName?.toLowerCase().contains(query) ?? false) ||
          (job.description?.toLowerCase().contains(query) ?? false);

      final matchesJobType = _selectedJobType == 'All' ||
          job.jobType.toString().split('.').last == _selectedJobType;

      return matchesSearch && matchesJobType;
    }).toList();

    setState(() {});
  }

  /// Manually refresh the job list
  Future<void> _refreshJobList() async {
    // Mock data loading removed - implement real API call here
    setState(() {
      _jobs = [];
      _filteredJobs = [];
    });

    // Notify parent that jobs have been refreshed
    widget.onRefresh?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.surfaceContainer,
      child: RefreshIndicator(
        onRefresh: _refreshJobList,
        child: CustomScrollView(
          slivers: [
            _buildHeaderSection(),
            _buildJobListSection(),
          ],
        ),
      ),
    );
  }

  /// Build the header section with search and filters
  Widget _buildHeaderSection() {
    return SliverToBoxAdapter(
      child: _buildHeaderCard(context),
    );
  }

  /// Build the job list section
  Widget _buildJobListSection() {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        PaddingConstants.spacingL,
        PaddingConstants.spacingS,
        PaddingConstants.spacingL,
        PaddingConstants.spacingXxl +
            PaddingConstants.spacingL, // 88px for navigation bar
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final job = _filteredJobs[index];
            return _buildModernJobCard(context, job, index);
          },
          childCount: _filteredJobs.length,
        ),
      ),
    );
  }

  /// Build the header card with title and search
  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        PaddingConstants.spacingL,
        PaddingConstants.spacingL,
        PaddingConstants.spacingL,
        0,
      ),
      decoration: _buildHeaderCardDecoration(context),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          PaddingConstants.spacingL,
          PaddingConstants.spacingL,
          PaddingConstants.spacingL,
          PaddingConstants.spacingXl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderTitleSection(context),
            const SizedBox(height: 16),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  /// Build the header card decoration
  BoxDecoration _buildHeaderCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: context.onSurface.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Build the header title section
  Widget _buildHeaderTitleSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTitleAndCount(context),
        ),
        _buildFilterButton(context),
      ],
    );
  }

  /// Build the title and job count
  Widget _buildTitleAndCount(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.heading(
          'Available Jobs',
          color: context.onSurface,
        ),
        SizedBox(height: PaddingConstants.spacingXs),
        AppText.bodySmall(
          '${_jobs.length} jobs found',
          color: context.onSurface.withValues(alpha: 0.6),
        ),
      ],
    );
  }

  /// Build the filter button
  Widget _buildFilterButton(BuildContext context) {
    return Container(
      padding: PaddingConstants.allM,
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.tune,
        color: context.onSurface.withValues(alpha: 0.7),
      ),
    );
  }

  /// Build the search bar
  Widget _buildSearchBar() {
    return AppInput.primary(
      labelText: 'Search',
      controller: _searchController,
      hintText: 'City, route or company...',
    );
  }

  /// Build the modern job card
  Widget _buildModernJobCard(BuildContext context, JobModel job, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _buildJobCardDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToJobDetails(job),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildJobCardHeader(context, job),
                const SizedBox(height: 12),
                _buildRouteSection(context, job),
                const SizedBox(height: 16),
                _buildJobCardFooter(context, job),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build the job card decoration
  BoxDecoration _buildJobCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Build the job card header with company name and job type
  Widget _buildJobCardHeader(BuildContext context, JobModel job) {
    return Row(
      children: [
        Expanded(
          child: AppText.body(
            job.companyName ?? 'Company Name',
            color: const Color(0xFF1A1A1A),
          ),
        ),
        _buildJobTypeChip(job.jobType),
      ],
    );
  }

  /// Build the route section showing from/to locations
  Widget _buildRouteSection(BuildContext context, JobModel job) {
    return Row(
      children: [
        Expanded(child: _buildFromLocation(context, job)),
        _buildRouteArrow(),
        Expanded(child: _buildToLocation(context, job)),
      ],
    );
  }

  /// Build the from location section
  Widget _buildFromLocation(BuildContext context, JobModel job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildLocationDot(const Color(0xFF10B981)),
            const SizedBox(width: 8),
            Expanded(
              child: AppText.bodySmall(
                job.fromProvince?.toUpperCase() ?? '',
                color: const Color(0xFF374151),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: AppText.caption(
            job.fromCity ?? '',
            color: const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  /// Build the route arrow
  Widget _buildRouteArrow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: const Icon(
        Icons.arrow_forward,
        color: Color(0xFF9CA3AF),
        size: 16,
      ),
    );
  }

  /// Build the to location section
  Widget _buildToLocation(BuildContext context, JobModel job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildLocationDot(const Color(0xFFEF4444)),
            const SizedBox(width: 8),
            Expanded(
              child: AppText.bodySmall(
                job.toProvince?.toUpperCase() ?? '',
                color: const Color(0xFF374151),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: AppText.caption(
            job.toCity ?? '',
            color: const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  /// Build a location dot indicator
  Widget _buildLocationDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  /// Build the job card footer with vehicle count and action buttons
  Widget _buildJobCardFooter(BuildContext context, JobModel job) {
    return Row(
      children: [
        if (job.vehicleCount != null) ...[
          _buildInfoChip(
            Icons.local_shipping_outlined,
            '${job.vehicleCount} vehicles',
            const Color(0xFF3B82F6),
          ),
          const SizedBox(width: 8),
        ],
        _buildInfoChip(
          Icons.request_quote_outlined,
          'Get Quote',
          const Color(0xFF8B5CF6),
        ),
        const Spacer(),
        _buildDetailsButton(),
      ],
    );
  }

  /// Build the job type chip
  Widget _buildJobTypeChip(JobType? jobType) {
    if (jobType == null) return const SizedBox();

    final chipData = _getJobTypeChipData(jobType);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipData.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: AppText.caption(
        chipData.text,
        color: chipData.color,
      ),
    );
  }

  /// Get job type chip data
  _JobTypeChipData _getJobTypeChipData(JobType jobType) {
    switch (jobType) {
      case JobType.pointToPoint:
        return _JobTypeChipData('Point-to-Point', const Color(0xFF3B82F6));
      case JobType.fullDay:
        return _JobTypeChipData('Full Day', const Color(0xFF10B981));
      case JobType.hourly:
        return _JobTypeChipData('Hourly', const Color(0xFFF59E0B));
    }
  }

  /// Build an info chip with icon and text
  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          AppText.caption(
            text,
            color: color,
          ),
        ],
      ),
    );
  }

  /// Build the details button
  Widget _buildDetailsButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppText.caption(
        'Details',
        color: Colors.white,
      ),
    );
  }

  /// Navigate to job details page
  void _navigateToJobDetails(JobModel job) {
    debugPrint("Navigation to Job Details from Job List");
    context.push('/job-details', extra: job);
  }
}

/// Helper class for job type chip data
class _JobTypeChipData {
  final String text;
  final Color color;

  _JobTypeChipData(this.text, this.color);
}
