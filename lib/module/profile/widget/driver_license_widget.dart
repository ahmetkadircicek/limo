import 'package:flutter/material.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/widgets/form/shared_read_only_field.dart';
import 'package:limo/shared/widgets/shared_info.dart';
import 'package:provider/provider.dart';

class DriverLicenseWidget extends StatelessWidget {
  const DriverLicenseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final licenseNumber = user?.driverLicense;
    final hasLicense = licenseNumber != null && licenseNumber.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: PaddingConstants.p8,
      children: [
        SharedReadOnlyField(
          label: 'Status',
          value: hasLicense ? 'Approved' : 'Missing',
        ),
        if (hasLicense)
          SharedReadOnlyField(label: 'License Number', value: licenseNumber),
        if (!hasLicense)
          const SharedInfo(
            icon: Icons.info,
            label: 'Info',
            value: 'No driver license uploaded yet. Please upload to continue.',
          ),
      ],
    );
  }
}
