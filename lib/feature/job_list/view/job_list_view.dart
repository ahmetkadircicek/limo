import 'package:flutter/material.dart';
import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/feature/job_list/model/coordinate_model.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/view/job_details_page.dart';
import 'package:limo/shared/app_input.dart';

class JobListView extends StatefulWidget {
  const JobListView({super.key});

  @override
  State<JobListView> createState() => _JobListViewState();
}

class _JobListViewState extends State<JobListView> {
  List<JobModel> _jobs = [];
  List<JobModel> _filteredJobs = [];
  final TextEditingController _searchController = TextEditingController();
  final String _selectedJobType = 'All';
  final String _selectedPriceRange = 'All';

  @override
  void initState() {
    super.initState();
    _loadMockJobs();
    _filteredJobs = List.from(_jobs);
    _searchController.addListener(_filterJobs);
  }

  void _filterJobs() {
    final query = _searchController.text.toLowerCase();

    _filteredJobs = _jobs.where((job) {
      final matchesSearch = query.isEmpty ||
          job.fromProvince.toLowerCase().contains(query) ||
          job.toProvince.toLowerCase().contains(query) ||
          job.fromCity?.toLowerCase().contains(query) == true ||
          job.toCity?.toLowerCase().contains(query) == true ||
          job.companyName?.toLowerCase().contains(query) == true ||
          job.description?.toLowerCase().contains(query) == true;

      final matchesJobType = _selectedJobType == 'All' ||
          job.jobType.toString().split('.').last == _selectedJobType;

      final matchesPriceRange = _selectedPriceRange == 'All' ||
          _matchesPriceRange(job.price, _selectedPriceRange);

      return matchesSearch && matchesJobType && matchesPriceRange;
    }).toList();

    setState(() {});
  }

  bool _matchesPriceRange(double? price, String range) {
    if (price == null) return false;

    switch (range) {
      case 'Under 1000':
        return price < 1000;
      case '1000-2000':
        return price >= 1000 && price <= 2000;
      case '2000-3000':
        return price > 2000 && price <= 3000;
      case 'Over 3000':
        return price > 3000;
      default:
        return true;
    }
  }

  void _loadMockJobs() {
    _jobs = [
      JobModel(
        id: '1',
        fromProvince: 'CALIFORNIA',
        toProvince: 'NEW YORK',
        fromLocation: Coordinate(latitude: 34.0522, longitude: -118.2437),
        toLocation: Coordinate(latitude: 40.7128, longitude: -74.0060),
        fromCity: 'Los Angeles',
        toCity: 'Manhattan',
        price: 2500,
        jobType: JobType.pointToPoint,
        companyName: 'California Express',
        contactInfo: '+1 213 555 0123',
        description: 'Urgent cargo transport service from LA to NYC',
        vehicleCount: 2,
      ),
      JobModel(
        id: '2',
        fromProvince: 'TEXAS',
        toProvince: 'FLORIDA',
        fromLocation: Coordinate(latitude: 29.7604, longitude: -95.3698),
        toLocation: Coordinate(latitude: 25.7617, longitude: -80.1918),
        fromCity: 'Houston',
        toCity: 'Miami',
        price: 1800,
        jobType: JobType.pointToPoint,
        companyName: 'Southern Logistics',
        contactInfo: '+1 713 555 0456',
        description: 'Electronics and textile product transport',
        vehicleCount: 1,
      ),
      JobModel(
        id: '3',
        fromProvince: 'ILLINOIS',
        toProvince: 'ARIZONA',
        fromLocation: Coordinate(latitude: 41.8781, longitude: -87.6298),
        toLocation: Coordinate(latitude: 33.4484, longitude: -112.0740),
        fromCity: 'Chicago',
        toCity: 'Phoenix',
        price: 2200,
        jobType: JobType.pointToPoint,
        companyName: 'Midwest Transport',
        contactInfo: '+1 312 555 0789',
        description: 'By offer - contact for details',
        vehicleCount: 3,
      ),
      JobModel(
        id: '4',
        fromProvince: 'WASHINGTON',
        toProvince: 'OREGON',
        fromLocation: Coordinate(latitude: 47.6062, longitude: -122.3321),
        toLocation: Coordinate(latitude: 45.5152, longitude: -122.6784),
        fromCity: 'Seattle',
        toCity: 'Portland',
        price: 3200,
        jobType: JobType.fullDay,
        companyName: 'Pacific Northwest Logistics',
        contactInfo: '+1 206 555 0123',
        description: 'Daily shuttle service between major cities',
        vehicleCount: 1,
      ),
      JobModel(
        id: '5',
        fromProvince: 'MASSACHUSETTS',
        toProvince: 'VIRGINIA',
        fromLocation: Coordinate(latitude: 42.3601, longitude: -71.0589),
        toLocation: Coordinate(latitude: 38.9072, longitude: -77.0369),
        fromCity: 'Boston',
        toCity: 'Washington DC',
        price: 2800,
        jobType: JobType.hourly,
        companyName: 'East Coast Express',
        contactInfo: '+1 617 555 0456',
        description: 'Hourly rental service for government contracts',
        vehicleCount: 2,
      ),
      JobModel(
        id: '6',
        fromProvince: 'COLORADO',
        toProvince: 'UTAH',
        fromLocation: Coordinate(latitude: 39.7392, longitude: -104.9903),
        toLocation: Coordinate(latitude: 40.7608, longitude: -111.8910),
        fromCity: 'Denver',
        toCity: 'Salt Lake City',
        price: 2100,
        jobType: JobType.pointToPoint,
        companyName: 'Rocky Mountain Transport',
        contactInfo: '+1 303 555 0123',
        description: 'Safe delivery through mountain passes',
        vehicleCount: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA), // Uber-style light background
      child: CustomScrollView(
        slivers: [
          // Modern header with search and filters
          SliverToBoxAdapter(
            child: _buildHeaderCard(context),
          ),
          // Job cards list
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0,
                88.0), // Added 80px bottom padding for navigation bar
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final job = _filteredJobs[index];
                  return _buildModernJobCard(context, job, index);
                },
                childCount: _filteredJobs.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and filter button
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Jobs',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1A1A),
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_jobs.length} jobs found',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF6B7280),
                            ),
                      ),
                    ],
                  ),
                ),
                // Filter button
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: Color(0xFF374151),
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Search bar (AppInput ile değiştirildi)
            AppInput.primary(
              controller: _searchController,
              hintText: 'Search city, route or company...',
              prefixIcon: Icons.search,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernJobCard(BuildContext context, JobModel job, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
                // Company name and job type
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        job.companyName ?? 'Company Name',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    _buildJobTypeChip(job.jobType),
                  ],
                ),
                const SizedBox(height: 12),

                // Route with modern design
                Row(
                  children: [
                    // From location
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  job.fromProvince.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              job.fromCity ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Arrow
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF9CA3AF),
                        size: 16,
                      ),
                    ),

                    // To location
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  job.toProvince.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              job.toCity ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Bottom info row
                Row(
                  children: [
                    // Vehicle count
                    if (job.vehicleCount != null) ...[
                      _buildInfoChip(
                        Icons.local_shipping_outlined,
                        '${job.vehicleCount} vehicles',
                        const Color(0xFF3B82F6),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Price or quote
                    if (job.price != null) ...[
                      _buildInfoChip(
                        Icons.attach_money,
                        '₺${job.price!.toStringAsFixed(0)}',
                        const Color(0xFF10B981),
                      ),
                    ] else ...[
                      _buildInfoChip(
                        Icons.request_quote_outlined,
                        'Get Quote',
                        const Color(0xFF8B5CF6),
                      ),
                    ],

                    const Spacer(),

                    // View details button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobTypeChip(JobType? jobType) {
    if (jobType == null) return const SizedBox();

    String text;
    Color color;

    switch (jobType) {
      case JobType.pointToPoint:
        text = 'Point-to-Point';
        color = const Color(0xFF3B82F6);
        break;
      case JobType.fullDay:
        text = 'Full Day';
        color = const Color(0xFF10B981);
        break;
      case JobType.hourly:
        text = 'Hourly';
        color = const Color(0xFFF59E0B);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
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
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToJobDetails(JobModel job) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: JobDetailsPage(job: job),
        ),
      ),
    );
  }
}
