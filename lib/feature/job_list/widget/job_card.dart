import 'package:flutter/material.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/shared/app_components.dart';

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
            Expanded(flex: 3, child: _LocationSection(job: job)),
            Expanded(flex: 3, child: _InformationSection(job: job)),
            Expanded(flex: 2, child: _DetailsButton(onTap: onTap)),
          ],
        ),
      ),
    );
  }
}

class _LocationSection extends StatelessWidget {
  const _LocationSection({
    required this.job,
  });

  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.horizontalL, // Uber-style padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.body(
            job.fromProvince.toUpperCase(),
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
            job.toProvince.toUpperCase(),
            color: context.onSurface,
          ),
        ],
      ),
    );
  }
}

class _InformationSection extends StatelessWidget {
  const _InformationSection({
    required this.job,
  });

  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _Seperator(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (job.jobType != null) ...[
              Row(
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
              ),
            ],
            if (job.vehicleCount != null) ...[
              Row(
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
              ),
            ],
            if (job.price == null) ...[
              Row(
                children: [
                  Icon(
                    Icons.local_offer,
                    color: context.onSecondary,
                    size: GeneralConstants.fontSizeExtraSmall,
                  ),
                  AppText.caption(
                    'QUOTE BASED',
                    color: context.onSurface,
                  ),
                ],
              ),
            ] else ...[
              Row(
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
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _DetailsButton extends StatelessWidget {
  const _DetailsButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
        child: AppText.body(
          'VIEW',
          color: context.onPrimary,
        ),
      ),
    );
  }
}

String _getJobTypeText(JobType jobType) {
  switch (jobType) {
    case JobType.pointToPoint:
      return 'POINT TO POINT';
    case JobType.fullDay:
      return 'FULL DAY';
    case JobType.hourly:
      return 'HOURLY';
  }
}

class _Seperator extends StatelessWidget {
  const _Seperator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.symmetricVerticalSmall,
      child: const SizedBox(width: 1),
    );
  }
}
