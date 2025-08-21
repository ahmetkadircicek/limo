import 'package:flutter/material.dart';
import 'package:limo/core/enums/job_type_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/shared/app_button.dart';
import 'package:limo/shared/app_snackbar.dart';
import 'package:limo/shared/app_text.dart';

/// Reusable card component for job details page
class JobDetailsCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color? titleColor;

  const JobDetailsCard({
    super.key,
    required this.title,
    required this.children,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: context.radiusMedium,
      ),
      child: Padding(
        padding: context.paddingL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.body(
              title,
              color: titleColor ?? context.onSurface,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class JobDetailsPage extends StatefulWidget {
  final JobModel job;

  const JobDetailsPage({super.key, required this.job});

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  // Format date and time for display
  String _formatDateTime(DateTime dateTime) {
    // Format as MM/DD/YYYY with leading zeros for American format
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$month/$day/$year $hour:$minute';
  }

  // Format date only for display
  String _formatDate(DateTime date) {
    // Format as MM/DD/YYYY with leading zeros for American format
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$month/$day/$year';
  }

  // Compact info row to match the vehicle card's typography/spacing
  Widget _buildInfoRowCompact({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.onSurface.withValues(alpha: 0.6)),
        SizedBox(width: context.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.caption(
                label,
                color: context.onSurface.withValues(alpha: 0.5),
              ), // Standard label size
              AppText.bodySmall(
                value,
                color: context.onSurface,
              ), // Standard value size
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.job.id.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const AppText.heading('Job Details'),
          backgroundColor: context.surface,
          foregroundColor: context.onSurface,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: TabBar(
            labelColor: context.primary,
            unselectedLabelColor: context.textSecondary,
            indicatorColor: context.onSurface.withValues(alpha: 0.3),
            tabs: const [
              Tab(text: 'General Information'),
              Tab(text: 'Vehicle Requirements'),
            ],
          ),
        ),
        backgroundColor: context.surfaceContainer,
        body: TabBarView(
          children: [
            // First Tab: General Information
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildJobDetailsCard(context),
                  const SizedBox(height: 16),
                  _buildCompanyCard(context),
                  const SizedBox(height: 16),
                  _buildRouteCard(context),
                  const SizedBox(height: 16),
                  _buildDateInfoCard(context),
                  const SizedBox(height: 16),
                  if (widget.job.hourlyRate != null ||
                      widget.job.pricePerMile != null) ...[
                    _buildPricingCard(context),
                    const SizedBox(height: 16),
                  ],
                  _buildActionButtons(context),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            // Second Tab: Vehicle Requirements
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildVehicleRequirementsAndSelectionCard(context),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context) {
    return JobDetailsCard(
      title: 'Company Information',
      children: [
        _buildInfoRow(
          icon: Icons.business,
          label: 'Company',
          value: widget.job.companyName ?? 'Not specified',
          color: context.primary,
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          icon: Icons.phone,
          label: 'Contact',
          value: widget.job.contactInfo ?? 'Not specified',
          color: context.primary,
        ),
        if (widget.job.price != null) ...[
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.attach_money,
            label: 'Total Price',
            value: '\$${widget.job.price}',
            color: context.primary,
          ),
        ],
      ],
    );
  }

  Widget _buildRouteCard(BuildContext context) {
    final hasDestination = widget.job.toLocation != null;

    // Only show destination for point-to-point jobs
    final shouldShowDestination =
        widget.job.jobType == JobType.pointToPoint && hasDestination;

    return JobDetailsCard(
      title:
          shouldShowDestination ? 'Route Information' : 'Location Information',
      children: [
        _buildInfoRow(
          icon: Icons.location_on,
          label: 'Pickup',
          value: widget.job.fromLocation?.address ?? 'Location not specified',
          color: const Color(0xFF3B82F6),
        ),
        if (shouldShowDestination) ...[
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Destination',
            value: widget.job.toLocation?.address ?? 'Location not specified',
            color: const Color(0xFF3B82F6),
          ),
        ],
      ],
    );
  }

  Widget _buildDateInfoCard(BuildContext context) {
    return JobDetailsCard(
      title: 'Date Information',
      children: [
        if (widget.job.startDate != null) ...[
          _buildInfoRow(
            icon: Icons.schedule,
            label: 'Start Date',
            value: _formatDate(widget.job.startDate!),
            color: const Color(0xFF8B5CF6),
          ),
        ],
        if (widget.job.startDate != null && widget.job.endDate != null) ...[
          const SizedBox(height: 16),
        ],
        if (widget.job.endDate != null) ...[
          _buildInfoRow(
            icon: Icons.schedule_outlined,
            label: 'End Date',
            value: _formatDate(widget.job.endDate!),
            color: const Color(0xFF8B82F6),
          ),
        ],
      ],
    );
  }

  Widget _buildJobDetailsCard(BuildContext context) {
    return JobDetailsCard(
      title: 'Job Details',
      children: [
        _buildInfoRowCompact(
          icon: Icons.category,
          label: 'Job Type',
          value: _getJobTypeDisplayText(widget.job.jobType),
          color: context.primary,
        ),
        const SizedBox(height: 16),
        _buildInfoRowCompact(
          icon: Icons.info_outline,
          label: 'Job ID',
          value: widget.job.id,
          color: context.onSurface,
        ),
        const SizedBox(height: 16),
        _buildInfoRowCompact(
          icon: Icons.calendar_today,
          label: 'Created At',
          value: _formatDateTime(widget.job.createdAt!),
          color: context.onSurface,
        ),
        const SizedBox(height: 16),
        _buildInfoRowCompact(
          icon: Icons.description_outlined,
          label: 'Description',
          value: widget.job.description ?? 'Not specified',
          color: context.onSurface,
        ),
      ],
    );
  }

  Widget _buildPricingCard(BuildContext context) {
    return JobDetailsCard(
      title: 'Pricing',
      children: [
        if (widget.job.hourlyRate != null)
          _buildInfoRow(
            icon: Icons.access_time,
            label: 'Hourly',
            value: '\$${widget.job.hourlyRate}/hr',
            color: const Color(0xFF10B981),
          ),
        if (widget.job.hourlyRate != null && widget.job.pricePerMile != null)
          const SizedBox(height: 16),
        if (widget.job.pricePerMile != null)
          _buildInfoRow(
            icon: Icons.route,
            label: 'Per Mile',
            value: '\$${widget.job.pricePerMile}/mile',
            color: const Color(0xFF10B981),
          ),
      ],
    );
  }

  Widget _buildVehicleRequirementsAndSelectionCard(BuildContext context) {
    return JobDetailsCard(
      title: 'Vehicle Requirements',
      children: [
        if (widget.job.vehicleRequirements.isNotEmpty) ...[
          ...widget.job.vehicleRequirements.map((requirement) {
            return _buildRequirementCard(requirement, context);
          }),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: context.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText.bodySmall(
                    'No special vehicle requirements for this job. All vehicle categories are accepted.',
                    color: context.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRequirementCard(
    VehicleRequirement requirement,
    BuildContext context,
  ) {
    final category = requirement.minimumCategory;

    return Container(
      margin: EdgeInsets.only(bottom: context.spacingM),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: context.radiusLarge, // 16.0
        border: Border.all(
          color:
              (category?.color.withValues(alpha: 0.2) ??
                  context.primary.withValues(alpha: 0.2)),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.onSurface.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with category badge and apply button
          Container(
            padding: EdgeInsets.all(context.spacingM),
            decoration: BoxDecoration(
              color:
                  (category?.color.withValues(alpha: 0.05) ??
                      context.primary.withValues(alpha: 0.05)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Category badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacingM,
                    vertical: context.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (category?.color.withValues(alpha: 0.1) ??
                            context.primary.withValues(alpha: 0.1)),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (category?.color ?? context.primary),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        category?.icon ?? Icons.directions_car,
                        size: 20,
                        color: (category?.color ?? context.primary),
                      ),
                      SizedBox(width: context.spacingS),
                      AppText.bodySmall(
                        category?.displayName ?? 'Vehicle',
                        color: (category?.color ?? context.primary),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Apply button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showApplyMessage(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacingM,
                        vertical: context.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: context.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AppText.bodySmall(
                        'Apply Now',
                        color: context.surface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(context.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle information in single column
                if (requirement.specificBrand != null) ...[
                  _buildInfoRowCompact(
                    icon: Icons.branding_watermark,
                    label: 'Brand',
                    value: requirement.specificBrand!,
                    color: context.onSurface,
                  ),
                  SizedBox(height: context.spacingM),
                ],
                if (requirement.specificModel != null) ...[
                  _buildInfoRowCompact(
                    icon: Icons.directions_car,
                    label: 'Model',
                    value: requirement.specificModel!,
                    color: context.onSurface,
                  ),
                  SizedBox(height: context.spacingM),
                ],
                if (requirement.capacity != null) ...[
                  _buildInfoRowCompact(
                    icon: Icons.people_outline,
                    label: 'Capacity',
                    value: '${requirement.capacity}+ people',
                    color: context.primary,
                  ),
                  SizedBox(height: context.spacingM),
                ],
                if (requirement.year != null) ...[
                  _buildInfoRowCompact(
                    icon: Icons.calendar_today,
                    label: 'Year',
                    value: '${requirement.year}+',
                    color: context.onSurface,
                  ),
                  SizedBox(height: context.spacingM),
                ],

                if (requirement.notes != null &&
                    requirement.notes!.isNotEmpty) ...[
                  SizedBox(height: context.spacingM),
                  _buildInfoRowCompact(
                    icon: Icons.notes,
                    label: 'Notes',
                    value: requirement.notes!,
                    color: context.onSurface,
                  ),
                ],
                // Divider before pricing section
                if (requirement.hourlyRate != null ||
                    requirement.pricePerMile != null) ...[
                  SizedBox(height: context.spacingM),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          context.onSurface.withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: context.spacingM),
                ],
                // Pricing information at the bottom
                if (requirement.hourlyRate != null ||
                    requirement.pricePerMile != null) ...[
                  if (requirement.hourlyRate != null) ...[
                    _buildInfoRowCompact(
                      icon: Icons.access_time,
                      label: 'Hourly Rate',
                      value: '\$${requirement.hourlyRate}/hr',
                      color: const Color(
                        0xFF8B5CF6,
                      ), // Purple color for pricing icons
                    ),
                    SizedBox(height: context.spacingS),
                  ],
                  if (requirement.pricePerMile != null) ...[
                    _buildInfoRowCompact(
                      icon: Icons.route,
                      label: 'Price per Mile',
                      value: '\$${requirement.pricePerMile}/mile',
                      color: const Color(
                        0xFF8B5CF6,
                      ), // Purple color for pricing icons
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showApplyMessage(BuildContext context) {
    AppSnackbar.showInfo(
      context,
      message: 'Application feature will be added soon',
    );
  }

  String _getJobTypeDisplayText(JobType? jobType) {
    switch (jobType) {
      case JobType.pointToPoint:
        return 'Point-to-Point';
      case JobType.fullDay:
        return 'Daily Rental';
      case JobType.hourly:
        return 'Hourly Rental';
      default:
        return 'Not Specified';
    }
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color.withValues(alpha: 0.7)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.caption(
                label,
                color: context.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 2),
              AppText.bodySmall(value, color: context.onSurface),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AppButton.success(
            'Contact',
            onPressed: () {
              AppSnackbar.showInfo(
                context,
                message: 'Contact information will be displayed',
              );
            },
            icon: Icons.phone,
            width: double.infinity,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: AppButton.secondary(
            'Share',
            onPressed: () {
              AppSnackbar.showSuccess(
                context,
                message: 'Sharing options will be displayed',
              );
            },
            icon: Icons.share,
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
