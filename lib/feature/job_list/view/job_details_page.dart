import 'package:flutter/material.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/shared/app_button.dart';
import 'package:limo/shared/app_snackbar.dart';
import 'package:limo/shared/app_text.dart';

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

  // Compact info row to match the vehicle card's typography/spacing
  Widget _buildInfoRowCompact({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: context.onSurface.withValues(alpha: 0.7),
        ),
        SizedBox(width: PaddingConstants.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.caption(
                label,
                color: context.onSurface.withValues(alpha: 0.5),
              ),
              AppText.bodySmall(
                value,
                color: context.onSurface,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.job.id.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const AppText.heading('Job Details'),
        backgroundColor: context.surface,
        foregroundColor: context.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: context.surfaceContainer,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCompanyCard(context),
            const SizedBox(height: 16),
            _buildRouteCard(context),
            const SizedBox(height: 16),
            _buildJobInfoCard(context),
            const SizedBox(height: 16),
            if (widget.job.description != null) ...[
              _buildDescriptionCard(),
              const SizedBox(height: 16),
            ],
            _buildVehicleRequirementsAndSelectionCard(context),
            const SizedBox(height: 16),
            _buildActionButtons(context),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: GeneralConstants.borderRadius,
        boxShadow: [
          BoxShadow(
            color: context.surface,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: PaddingConstants.allM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.primary.withValues(alpha: 0.1),
                    borderRadius: GeneralConstants.borderRadius,
                  ),
                  child: Icon(
                    Icons.business,
                    color: context.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                AppText.heading(
                  'Company Information',
                  color: context.onSurface,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.business,
              label: 'Company Name',
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
          ],
        ),
      ),
    );
  }

  Widget _buildRouteCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.surface,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: PaddingConstants.allM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.route,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                AppText.heading(
                  'Route Information',
                  color: context.onSurface,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.location_on,
              label: 'Departure',
              value: '${widget.job.fromCity ?? ''}, ${widget.job.fromProvince}',
              color: const Color(0xFF3B82F6),
            ),
            const SizedBox(height: 16),
            if (widget.job.toCity != null || widget.job.toProvince!.isNotEmpty)
              _buildInfoRow(
                icon: Icons.location_on_outlined,
                label: 'Destination',
                value: '${widget.job.toCity ?? ''}, ${widget.job.toProvince}',
                color: const Color(0xFF3B82F6),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobInfoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.surface,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: PaddingConstants.allM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.work,
                    color: Color(0xFF8B5CF6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                AppText.heading(
                  'Job Information',
                  color: context.onSurface,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.category,
              label: 'Job Type',
              value: _getJobTypeDisplayText(widget.job.jobType),
              color: const Color(0xFF8B5CF6),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.local_shipping,
              label: 'Vehicle Count',
              value:
                  '${widget.job.vehicleCount ?? widget.job.vehicleRequirements.length}',
              color: const Color(0xFF8B5CF6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.surface,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: PaddingConstants.allM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B7280).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: Color(0xFF6B7280),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                AppText.heading(
                  'Description',
                  color: const Color(0xFF1A1A1A),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppText.body(
              widget.job.description ?? '',
              color: const Color(0xFF374151),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleRequirementsAndSelectionCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: PaddingConstants.allM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_shipping,
                    color: context.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                AppText.heading(
                  'Vehicle Requirements',
                  color: context.onSurface,
                ),
                Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppText.caption(
                    '${widget.job.vehicleRequirements.length} requirements',
                    color: context.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                    Icon(
                      Icons.info_outline,
                      color: context.primary,
                      size: 20,
                    ),
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
        ),
      ),
    );
  }

  Widget _buildRequirementCard(
      VehicleRequirement requirement, BuildContext context) {
    return _FramedContainer(
      margin: EdgeInsets.only(bottom: PaddingConstants.spacingM),
      borderColor: requirement.isFlexible
          ? context.primary.withValues(alpha: 0.2)
          : (requirement.minimumCategory?.borderColor.withValues(alpha: 0.2) ??
              context.primary.withValues(alpha: 0.2)),
      boxShadow: [
        BoxShadow(
          color: context.onSurface.withValues(alpha: 0.03),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
      child: Padding(
        padding: PaddingConstants.allL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with category badge and action buttons
            Row(
              children: [
                // Category badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        PaddingConstants.spacingS + PaddingConstants.spacingXs,
                    vertical: PaddingConstants.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: requirement.isFlexible
                        ? context.primary.withValues(alpha: 0.1)
                        : (requirement.minimumCategory?.backgroundColor ??
                            context.primary.withValues(alpha: 0.1)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: requirement.isFlexible
                          ? context.primary
                          : (requirement.minimumCategory?.borderColor ??
                              context.primary),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        requirement.isFlexible
                            ? Icons.check_circle_outline
                            : requirement.minimumCategory?.icon ??
                                Icons.directions_car,
                        size: 30,
                        color: requirement.isFlexible
                            ? context.primary
                            : (requirement.minimumCategory?.primaryColor ??
                                context.primary),
                      ),
                      SizedBox(width: PaddingConstants.spacingS),
                      AppText.caption(
                        requirement.isFlexible
                            ? 'Flexible'
                            : requirement.minimumCategory?.badgeText ??
                                'Vehicle',
                        color: requirement.isFlexible
                            ? context.primary
                            : (requirement.minimumCategory?.primaryColor ??
                                context.primary),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Action button styled identically to vehicle card action button
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showApplyMessage(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: PaddingConstants.spacingM,
                            vertical: PaddingConstants.spacingS,
                          ),
                          decoration: BoxDecoration(
                            color: context.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: context.primary.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: AppText.caption(
                            'Apply',
                            color: context.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: PaddingConstants.spacingL),

            // Vehicle information grid
            Row(
              children: [
                // Left column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (requirement.specificBrand != null)
                        _buildInfoRowCompact(
                          icon: Icons.branding_watermark,
                          label: 'Brand',
                          value: requirement.specificBrand!,
                          color: context.onSurface,
                        ),
                      if (requirement.specificBrand != null)
                        SizedBox(height: PaddingConstants.spacingM),
                      if (requirement.specificModel != null)
                        _buildInfoRowCompact(
                          icon: Icons.directions_car,
                          label: 'Model',
                          value: requirement.specificModel!,
                          color: context.onSurface,
                        ),
                      if (requirement.specificModel != null)
                        SizedBox(height: PaddingConstants.spacingM),
                      _buildInfoRowCompact(
                        icon: Icons.category,
                        label: 'Vehicle Type',
                        value: requirement.isFlexible
                            ? 'Any Vehicle'
                            : (requirement.specificVehicleType ??
                                requirement.getDescription()),
                        color: context.primary,
                      ),
                      SizedBox(height: PaddingConstants.spacingM),
                      if (requirement.specificExteriorColor != null)
                        _buildInfoRowCompact(
                          icon: Icons.format_color_fill,
                          label: 'Exterior Color',
                          value: requirement.specificExteriorColor!,
                          color: context.onSurface,
                        ),
                      if (requirement.specificExteriorColor != null)
                        SizedBox(height: PaddingConstants.spacingM),
                      if (requirement.specificInteriorColor != null)
                        _buildInfoRowCompact(
                          icon: Icons.format_color_text,
                          label: 'Interior Color',
                          value: requirement.specificInteriorColor!,
                          color: context.onSurface,
                        ),
                      if (requirement.specificInteriorColor != null)
                        SizedBox(height: PaddingConstants.spacingM),
                      if (requirement.minimumCategory != null)
                        _buildInfoRowCompact(
                          icon: Icons.layers,
                          label: 'Min Category',
                          value: requirement.minimumCategory!.displayName,
                          color: requirement.minimumCategory!.primaryColor,
                        ),
                    ],
                  ),
                ),

                // Right column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (requirement.minimumCapacity != null ||
                          requirement.maximumCapacity != null)
                        _buildInfoRowCompact(
                          icon: Icons.people_outline,
                          label: 'Capacity',
                          value: _getCapacityDisplayValue(requirement),
                          color: context.primary,
                        ),
                      if (requirement.minimumCapacity != null ||
                          requirement.maximumCapacity != null)
                        SizedBox(height: PaddingConstants.spacingM),
                      if (requirement.minimumYear != null ||
                          requirement.maximumYear != null)
                        _buildInfoRowCompact(
                          icon: Icons.calendar_today,
                          label: 'Year',
                          value: _getYearDisplayValue(requirement),
                          color: context.onSurface,
                        ),
                      if (requirement.minimumYear != null ||
                          requirement.maximumYear != null)
                        SizedBox(height: PaddingConstants.spacingM),
                      if (requirement.hourlyRate != null)
                        _buildInfoRowCompact(
                          icon: Icons.access_time,
                          label: 'Hourly Rate',
                          value: '\$${requirement.hourlyRate}/hr',
                          color: const Color(0xFF10B981),
                        ),
                      if (requirement.hourlyRate != null)
                        SizedBox(height: PaddingConstants.spacingM),
                      if (requirement.pricePerMile != null)
                        _buildInfoRowCompact(
                          icon: Icons.route,
                          label: 'Price per Mile',
                          value: '\$${requirement.pricePerMile}/mile',
                          color: const Color(0xFF10B981),
                        ),
                      if (requirement.pricePerMile != null)
                        SizedBox(height: PaddingConstants.spacingM),
                      _buildInfoRowCompact(
                        icon: Icons.check_circle_outline,
                        label: 'Flexible',
                        value: requirement.isFlexible ? 'Yes' : 'No',
                        color: context.onSurface,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (requirement.notes != null && requirement.notes!.isNotEmpty) ...[
              SizedBox(height: PaddingConstants.spacingM),
              _buildInfoRowCompact(
                icon: Icons.notes,
                label: 'Notes',
                value: requirement.notes!,
                color: context.onSurface,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper method to get capacity display value
  String _getCapacityDisplayValue(VehicleRequirement requirement) {
    if (requirement.minimumCapacity != null &&
        requirement.maximumCapacity != null) {
      if (requirement.minimumCapacity == requirement.maximumCapacity) {
        return '${requirement.minimumCapacity} people';
      } else {
        return '${requirement.minimumCapacity}-${requirement.maximumCapacity} people';
      }
    } else if (requirement.minimumCapacity != null) {
      return '${requirement.minimumCapacity}+ people';
    } else if (requirement.maximumCapacity != null) {
      return 'Up to ${requirement.maximumCapacity} people';
    }
    return 'Any capacity';
  }

  // Helper method to get year display value
  String _getYearDisplayValue(VehicleRequirement requirement) {
    if (requirement.minimumYear != null && requirement.maximumYear != null) {
      if (requirement.minimumYear == requirement.maximumYear) {
        return requirement.minimumYear.toString();
      } else {
        return '${requirement.minimumYear}-${requirement.maximumYear}';
      }
    } else if (requirement.minimumYear != null) {
      return '${requirement.minimumYear}+';
    } else if (requirement.maximumYear != null) {
      return 'Up to ${requirement.maximumYear}';
    }
    return 'Any year';
  }

  void _showApplyMessage(BuildContext context) {
    AppSnackbar.showInfo(context,
        message: 'Başvuru özelliği yakında eklenecek');
  }

  String _getJobTypeDisplayText(JobType? jobType) {
    switch (jobType) {
      case JobType.pointToPoint:
        return 'Nokta-Nokta';
      case JobType.fullDay:
        return 'Günlük Kiralama';
      case JobType.hourly:
        return 'Saatlik Kiralama';
      default:
        return 'Belirtilmemiş';
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
        Icon(
          icon,
          size: 20,
          color: color,
        ),
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
              AppText.body(
                value,
                color: context.onSurface,
              ),
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
          child: AppButton.secondary(
            'Contact',
            onPressed: () {
              AppSnackbar.showInfo(
                context,
                message: 'Contact information will be displayed',
              );
            },
            icon: Icons.phone,
            width: double.infinity,
            height: 52,
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
            height: 52,
          ),
        ),
      ],
    );
  }
}

/// Universal frame widget for all cards/sections
class _FramedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;

  const _FramedContainer({
    required this.child,
    this.margin,
    this.borderColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor ?? context.onSurface.withValues(alpha: 0.1),
          width: 1.0,
        ),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: child,
    );
  }
}
