import 'package:flutter/material.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/enums/job_type_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/shared/app_components.dart';

/// Job card widget displaying job information in a card format
class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;
  final int index;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.verticalS,
      child: AppCard.primary(
        padding: EdgeInsets.zero, // No internal padding for row layout
        height: GeneralConstants.heightLarge * 1.8, // Uber-style height
        child: Row(
          children: [
            Expanded(flex: 3, child: _buildLocationSection(context)),
            Expanded(flex: 3, child: _buildInformationSection(context)),
            Expanded(flex: 2, child: _buildDetailsButton(context)),
          ],
        ),
      ),
    );
  }

  /// Build the location section showing from/to provinces
  Widget _buildLocationSection(BuildContext context) {
    return Padding(
      padding: PaddingConstants.horizontalL, // Uber-style padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.body(
            (job.fromLocation?.placeName ?? 'LOCATION').toUpperCase(),
            color: context.onSurface,
          ),
          Padding(
            padding: PaddingConstants.verticalXs,
            child: Icon(
              Icons.south,
              color: context.secondary, // Uber green
              size: GeneralConstants.iconSizeSmall,
            ),
          ),
          AppText.body(
            (job.toLocation?.placeName ?? 'DESTINATION').toUpperCase(),
            color: context.onSurface,
          ),
        ],
      ),
    );
  }

  /// Build the information section showing job details
  Widget _buildInformationSection(BuildContext context) {
    return Row(
      children: [
        _buildSeparator(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (job.jobType != null) ...[_buildJobTypeRow(context)],
            if (job.vehicleCount != null) ...[_buildVehicleCountRow(context)],
            if (job.price == null) ...[
              _buildQuoteBasedRow(context),
            ] else ...[
              _buildPriceRow(context),
            ],
          ],
        ),
      ],
    );
  }

  /// Build the job type row with icon and text
  Widget _buildJobTypeRow(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.local_shipping,
          color: context.onSecondary,
          size: GeneralConstants.fontSizeExtraSmall,
        ),
        AppText.caption(
          _getJobTypeText(job.jobType!),
          color: context.onSurface,
        ),
      ],
    );
  }

  /// Build the vehicle count row with icon and text
  Widget _buildVehicleCountRow(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.directions_car,
          color: context.onSecondary,
          size: GeneralConstants.fontSizeExtraSmall,
        ),
        AppText.caption(
          '${job.vehicleCount} Vehicles',
          color: context.onSurface,
        ),
      ],
    );
  }

  /// Build the quote based row when price is not available
  Widget _buildQuoteBasedRow(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.local_offer,
          color: context.onSecondary,
          size: GeneralConstants.fontSizeExtraSmall,
        ),
        AppText.caption('QUOTE BASED', color: context.onSurface),
      ],
    );
  }

  /// Build the price row when price is available
  Widget _buildPriceRow(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.monetization_on,
          color: context.onSecondary,
          size: GeneralConstants.fontSizeExtraSmall,
        ),
        AppText.caption(
          '\$${job.price!.toStringAsFixed(0)}',
          color: context.onSurface,
        ),
      ],
    );
  }

  /// Build the details button for viewing job details
  Widget _buildDetailsButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.primary, // Black for Uber style
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        ),
      ),
      width: double.infinity,
      height: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: PaddingConstants.allM,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
        ),
        onPressed: onTap,
        child: AppText.body('VIEW', color: context.onPrimary),
      ),
    );
  }

  /// Build the separator line between sections
  Widget _buildSeparator() {
    return Padding(
      padding: PaddingConstants.symmetricVerticalSmall,
      child: const SizedBox(width: 1),
    );
  }

  /// Get the display text for job type enum
  String _getJobTypeText(JobType jobType) {
    switch (jobType) {
      case JobType.pointToPoint:
        return 'POINT TO POINT';
      case JobType.fullDay:
        return 'FULL DAY';
      case JobType.hourly:
        return 'HOURLY';
      case JobType.custom:
        return 'CUSTOM';
    }
  }
}
