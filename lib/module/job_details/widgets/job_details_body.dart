import 'package:flutter/material.dart';
import 'package:limo/module/job_details/widgets/job_location_section.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'job_header_section.dart';
import 'job_dates_section.dart';
import 'job_description_section.dart';
import 'job_vehicle_section.dart';

class JobDetailsBody extends StatelessWidget {
  const JobDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: PaddingConstants.all24,
          children: const [
            JobHeaderSection(),
            SizedBox(height: PaddingConstants.p16),
            JobDatesSection(),
            SizedBox(height: PaddingConstants.p16),
            JobLocationsSection(), // İçinde Map var, izole edildi
            SizedBox(height: PaddingConstants.p16),
            JobVehicleSection(),
            SizedBox(height: PaddingConstants.p16),
            JobDescriptionSection(),
            SizedBox(height: PaddingConstants.p24), // Alt boşluk
          ],
        ),
      ),
    );
  }
}