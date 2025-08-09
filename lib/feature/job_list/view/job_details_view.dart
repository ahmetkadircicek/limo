import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/enums/pickup_type_enum.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/feature/job_list/model/job_model.dart';
import 'package:soforvarcom/shared/general_list_tile.dart';
import 'package:soforvarcom/shared/general_text.dart';

class JobDetailsBottomSheet extends StatelessWidget {
  final JobModel job;

  const JobDetailsBottomSheet({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 8),

          // Arrow down icon
          Icon(
            Icons.keyboard_arrow_down,
            size: 24,
            color: context.onSurface.withValues(alpha: 0.6),
          ),

          const SizedBox(height: 8),

          // Title
          GeneralText(
            text: 'JOB DETAILS',
            fontSize: GeneralConstants.fontSizeLarge,
            fontWeight: GeneralConstants.fontWeightBold,
            color: context.onSurface,
          ),

          const SizedBox(height: 4),

          // Subtitle
          GeneralText(
            text: 'Swipe down to close',
            fontSize: GeneralConstants.fontSizeSmall,
            color: context.onSurface.withValues(alpha: 0.6),
          ),

          const SizedBox(height: 24),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: PaddingConstants.allLarge,
              child: Column(
                children: [
                  GeneralListTile(
                    label: 'JOB ID',
                    value: job.id,
                    isDark: false,
                  ),
                  GeneralListTile(
                    label: 'JOB TYPE',
                    value: job.pickupType != null
                        ? _getJobTypeText(job.pickupType!)
                        : 'Not specified',
                    isDark: true,
                  ),
                  GeneralListTile(
                    label: 'PRICE',
                    value: job.price != null
                        ? '\$${job.price!.toStringAsFixed(0)}'
                        : 'Quote Based',
                    isDark: false,
                  ),
                  GeneralListTile(
                    label: 'COMPANY NAME',
                    value: job.companyName ?? 'Not specified',
                    isDark: true,
                  ),
                  GeneralListTile(
                    label: 'CONTACT INFO',
                    value: job.contactInfo ?? 'Not specified',
                    isDark: false,
                  ),
                  GeneralListTile(
                    label: 'FROM',
                    value:
                        '${job.fromProvince}${job.fromCity != null ? ' - ${job.fromCity}' : ''}',
                    isDark: true,
                  ),
                  GeneralListTile(
                    label: 'TO',
                    value:
                        '${job.toProvince}${job.toCity != null ? ' - ${job.toCity}' : ''}',
                    isDark: false,
                  ),
                  GeneralListTile(
                    label: 'VEHICLE COUNT',
                    value: job.vehicleCount?.toString() ?? 'Not specified',
                    isDark: true,
                  ),
                  if (job.vehicleRequirements.isNotEmpty) ...[
                    GeneralListTile(
                      label: 'VEHICLE REQUIREMENTS',
                      value: job.vehicleRequirements.length == 1
                          ? job.vehicleRequirements.first.getDescription()
                          : '${job.vehicleRequirements.length} different vehicle types required',
                      isDark: false,
                    ),
                    ...job.vehicleRequirements.asMap().entries.map((entry) {
                      final index = entry.key;
                      final requirement = entry.value;
                      return GeneralListTile(
                        label: 'VEHICLE TYPE ${index + 1}',
                        value: requirement.getDescription(),
                        isDark: index % 2 == 1,
                      );
                    }),
                  ],
                  if (job.pricing != null && job.pricing!.hasAnyPrice) ...[
                    GeneralListTile(
                      label: 'PRICING',
                      value: job.pricing!.getPricingSummary(),
                      isDark: false,
                    ),
                    if (job.pricing!.pricePerMile != null)
                      GeneralListTile(
                        label: 'PRICE PER MILE',
                        value:
                            '\$${job.pricing!.pricePerMile!.toStringAsFixed(2)}',
                        isDark: true,
                      ),
                    if (job.pricing!.hourlyPrice != null)
                      GeneralListTile(
                        label: 'HOURLY RATE',
                        value:
                            '\$${job.pricing!.hourlyPrice!.toStringAsFixed(2)}',
                        isDark: false,
                      ),
                    if (job.pricing!.dailyPrice != null)
                      GeneralListTile(
                        label: 'DAILY RATE',
                        value:
                            '\$${job.pricing!.dailyPrice!.toStringAsFixed(2)}',
                        isDark: true,
                      ),
                    if (job.pricing!.extraChargeAmount != null)
                      GeneralListTile(
                        label: 'EXTRA CHARGES',
                        value:
                            '\$${job.pricing!.extraChargeAmount!.toStringAsFixed(2)}',
                        isDark: false,
                      ),
                  ],
                  if (job.description != null)
                    GeneralListTile(
                      label: 'DESCRIPTION',
                      value: job.description!,
                      isDark: false,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getJobTypeText(JobType jobType) {
    switch (jobType) {
      case JobType.pointToPoint:
        return 'Point to Point';
      case JobType.fullDay:
        return 'Full Day';
      case JobType.hourly:
        return 'Hourly';
    }
  }
}
