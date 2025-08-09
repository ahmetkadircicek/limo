import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/enums/pickup_type_enum.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/feature/job_list/model/job_model.dart';
import 'package:soforvarcom/shared/elevated_material.dart';
import 'package:soforvarcom/shared/general_text.dart';

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
      padding: PaddingConstants.symmetricVerticalSmall / 2,
      child: ElevatedMaterial(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: GeneralConstants.borderRadius,
            color: index.isEven
                ? context.secondary.withValues(alpha: 0.01)
                : context.secondary.withValues(alpha: 0.06),
          ),
          height: GeneralConstants.heightMedium * 2,
          child: Row(
            children: [
              Expanded(flex: 2, child: _LocationSection(job: job)),
              Expanded(flex: 2, child: _InformationSection(job: job)),
              Expanded(flex: 1, child: _DetailsButton(onTap: onTap)),
            ],
          ),
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
      padding: PaddingConstants.symmetricHorizontalSmall,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: GeneralText(
              text: job.fromProvince.toUpperCase(),
              fontSize: GeneralConstants.fontSizeSmall,
              fontWeight: GeneralConstants.fontWeightBold,
              color: context.onSurface,
            ),
          ),
          Icon(
            Icons.arrow_downward_sharp,
            color: context.primary,
            size: GeneralConstants.fontSizeSmall,
          ),
          FittedBox(
            child: GeneralText(
              text: job.toProvince.toUpperCase(),
              fontSize: GeneralConstants.fontSizeSmall,
              fontWeight: GeneralConstants.fontWeightBold,
              color: context.onSurface,
            ),
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
            context.spacerHeight(0.5),
            if (job.pickupType != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.local_shipping,
                    color: context.onSecondaryContainer,
                    size: GeneralConstants.fontSizeExtraSmall,
                  ),
                  context.spacerWidth(1),
                  GeneralText(
                    fontSize: GeneralConstants.fontSizeExtraSmall,
                    color: context.onSurface,
                    fontWeight: GeneralConstants.fontWeightLight,
                    text: _getJobTypeText(job.pickupType!),
                  ),
                ],
              ),
            ],
            if (job.vehicleCount != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.directions_car,
                    color: context.onSecondaryContainer,
                    size: GeneralConstants.fontSizeExtraSmall,
                  ),
                  context.spacerWidth(1),
                  GeneralText(
                    fontSize: GeneralConstants.fontSizeExtraSmall,
                    color: context.onSurface,
                    fontWeight: GeneralConstants.fontWeightLight,
                    text: '${job.vehicleCount} Vehicles',
                  ),
                ],
              ),
            ],
            if (job.price == null) ...[
              Row(
                children: [
                  Icon(
                    Icons.local_offer,
                    color: context.onSecondaryContainer,
                    size: GeneralConstants.fontSizeExtraSmall,
                  ),
                  context.spacerWidth(1),
                  GeneralText(
                    fontSize: GeneralConstants.fontSizeExtraSmall,
                    color: context.onSurface,
                    fontWeight: GeneralConstants.fontWeightLight,
                    text: 'QUOTE BASED',
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: context.onSecondaryContainer,
                    size: GeneralConstants.fontSizeExtraSmall,
                  ),
                  context.spacerWidth(1),
                  GeneralText(
                    fontSize: GeneralConstants.fontSizeExtraSmall,
                    color: context.onSurface,
                    fontWeight: GeneralConstants.fontWeightLight,
                    text: '\$${job.price!.toStringAsFixed(0)}',
                  ),
                ],
              ),
            ],
            context.spacerHeight(0.5),
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
      color: context.primary,
      width: double.infinity,
      height: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: PaddingConstants.allSmall,
        ),
        onPressed: onTap,
        child: FittedBox(
          child: GeneralText(
            text: 'DETAILS',
            color: context.onPrimary,
            fontWeight: GeneralConstants.fontWeightBold,
            fontSize: GeneralConstants.fontSizeMedium,
          ),
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
      child: context.spacerWidth(1),
    );
  }
}
