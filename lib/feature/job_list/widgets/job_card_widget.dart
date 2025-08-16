import 'package:flutter/material.dart';
import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/shared/app_text.dart';

/// Individual job card widget displaying job information
class JobCardWidget extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;

  const JobCardWidget({super.key, required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.spacingM),
      decoration: _buildJobCardDecoration(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: context.radiusLarge,
          child: Padding(
            padding: context.paddingL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildJobCardHeader(context),
                SizedBox(height: context.spacingM),
                _buildRouteSection(context),
                SizedBox(height: context.spacingL),
                _buildJobCardFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build the job card decoration with theme-aware styling
  BoxDecoration _buildJobCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.surface,
      borderRadius: context.radiusLarge,
      boxShadow: [
        BoxShadow(
          color: context.onSurface.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Build the job card header with company name and job type
  Widget _buildJobCardHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppText.body(
            job.companyName ?? 'Company Name',
            color: context.textPrimary,
          ),
        ),
        _buildJobTypeChip(context),
      ],
    );
  }

  /// Build the route section showing from/to locations
  Widget _buildRouteSection(BuildContext context) {
    // Only show destination for point-to-point jobs
    final shouldShowDestination =
        job.jobType == JobType.pointToPoint &&
        (job.toLocation != null ||
            job.toCity != null ||
            job.toProvince != null);

    if (!shouldShowDestination) {
      // Single location layout for full day, hourly, or jobs without destination
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row: Main location
          Row(
            children: [
              _buildLocationDot(context.success),
              SizedBox(width: context.spacingS),
              Expanded(
                child: AppText.bodySmall(
                  job.fromLocation?.placeName ??
                      job.fromCity ??
                      job.fromProvince ??
                      'Location',
                  color: context.textSecondary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // Second row: Address details
          if (job.fromLocation?.address != null) ...[
            SizedBox(height: context.spacingXs),
            Padding(
              padding: EdgeInsets.only(left: context.spacingL),
              child: AppText.caption(
                job.fromLocation!.address,
                color: context.textSecondary.withValues(alpha: 0.7),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      );
    }

    // Two location layout only for point-to-point jobs with destination
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pickup location with address
        _buildFromLocationWithAddress(context),
        SizedBox(height: context.spacingS),
        // Drop-off location with address
        _buildToLocationWithAddress(context),
      ],
    );
  }

  /// Build the from location section with green dot and address
  Widget _buildFromLocationWithAddress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildLocationDot(context.success),
            SizedBox(width: context.spacingS),
            Expanded(
              child: AppText.bodySmall(
                job.fromLocation?.placeName ??
                    job.fromCity ??
                    job.fromProvince ??
                    'Pickup',
                color: context.textSecondary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        // Address below pickup location
        if (job.fromLocation?.address != null) ...[
          SizedBox(height: context.spacingXs),
          Padding(
            padding: EdgeInsets.only(left: context.spacingL),
            child: AppText.caption(
              job.fromLocation!.address,
              color: context.textSecondary.withValues(alpha: 0.7),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  /// Build the to location section with red dot and address
  Widget _buildToLocationWithAddress(BuildContext context) {
    // Only show destination for point-to-point jobs
    if (job.jobType != JobType.pointToPoint) {
      return const SizedBox.shrink();
    }

    // Only show if there's actual destination information
    final hasDestinationInfo =
        job.toLocation?.placeName != null ||
        job.toCity != null ||
        job.toProvince != null;

    if (!hasDestinationInfo) {
      return const SizedBox.shrink(); // Don't show anything if no destination
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildLocationDot(context.error),
            SizedBox(width: context.spacingS),
            Expanded(
              child: AppText.bodySmall(
                job.toLocation?.placeName ??
                    job.toCity ??
                    job.toProvince ??
                    'Destination',
                color: context.textSecondary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        // Address below drop-off location
        if (job.toLocation?.address != null) ...[
          SizedBox(height: context.spacingXs),
          Padding(
            padding: EdgeInsets.only(left: context.spacingL),
            child: AppText.caption(
              job.toLocation!.address,
              color: context.textSecondary.withValues(alpha: 0.7),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  /// Build a location dot indicator
  Widget _buildLocationDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  /// Build the job card footer with all chips grouped together
  Widget _buildJobCardFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First row: All info chips grouped together
        Row(
          children: [
            // Vehicle requirements chip
            if (job.vehicleRequirements.isNotEmpty) ...[
              _buildInfoChip(
                context,
                Icons.directions_car,
                '${job.vehicleRequirements.length} vehicles',
                context.primary,
              ),
              SizedBox(width: context.spacingS),
            ],
            // Price chip if available
            if (job.price != null) ...[
              _buildInfoChip(
                context,
                Icons.attach_money,
                '\$${job.price}',
                context.success,
              ),
              SizedBox(width: context.spacingS),
            ],
            // Date chip if available
            if (job.startDate != null) ...[
              _buildInfoChip(
                context,
                Icons.calendar_today,
                _formatDate(job.startDate!),
                context.secondary,
              ),
              SizedBox(width: context.spacingS),
            ],
            // Status chip removed as requested
            const Spacer(),
            // Clickable indicator icon
            Icon(
              Icons.arrow_forward_ios,
              color: context.textSecondary.withValues(alpha: 0.5),
              size: 16,
            ),
          ],
        ),
      ],
    );
  }

  /// Build the job type chip with theme-aware colors
  Widget _buildJobTypeChip(BuildContext context) {
    if (job.jobType == null) return const SizedBox();

    final chipData = _getJobTypeChipData(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacingS,
        vertical: context.spacingXs,
      ),
      decoration: BoxDecoration(
        color: chipData.color.withValues(alpha: 0.1),
        borderRadius: context.radiusSmall,
      ),
      child: AppText.caption(chipData.text, color: chipData.color),
    );
  }

  /// Get job type chip data with theme-aware colors
  _JobTypeChipData _getJobTypeChipData(BuildContext context) {
    switch (job.jobType) {
      case JobType.pointToPoint:
        return _JobTypeChipData('Point-to-Point', context.primary);
      case JobType.fullDay:
        return _JobTypeChipData('Full Day', context.success);
      case JobType.hourly:
        return _JobTypeChipData('Hourly', context.warning);
      case null:
        return _JobTypeChipData('Unknown', context.textSecondary);
    }
  }

  /// Build an info chip with icon and text
  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacingS,
        vertical: context.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: context.radiusSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: context.iconSmall, color: color),
          SizedBox(width: context.spacingXs),
          AppText.caption(text, color: color),
        ],
      ),
    );
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    // Format as MM/DD with leading zeros for American format
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month/$day';
  }
}

/// Helper class for job type chip data
class _JobTypeChipData {
  final String text;
  final Color color;

  _JobTypeChipData(this.text, this.color);
}
