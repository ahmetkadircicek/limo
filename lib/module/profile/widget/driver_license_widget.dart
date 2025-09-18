import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/module/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/widgets/shared_chip_button.dart';
import 'package:limo/shared/widgets/shared_info.dart';
import 'package:provider/provider.dart';

class DriverLicenseWidget extends StatelessWidget {
  const DriverLicenseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final hasLicense =
        user?.driverLicense != null && user!.driverLicense!.isNotEmpty;

    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: PaddingConstants.p16,
        children: [
          _buildTitleRow(context),
          _buildStatusRow(context, hasLicense),
          if (!hasLicense)
            const SharedInfo(
              icon: Icons.info,
              label: 'Info',
              value:
                  'No driver license uploaded yet. Please upload to continue.',
            ),
        ],
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Driver License',
          style: context.headline.copyWith(color: context.onSurface),
        ),
        SharedChipButton(
          text: 'Upload',
          onPressed: () {
            context.pushNamed(
              'documentUpload',
              extra: DocumentUploadPurpose.driverLicense,
            );
          },
          backgroundColor: context.primary,
          foregroundColor: context.onPrimary,
          icon: CupertinoIcons.doc_text,
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context, bool hasLicense) {
    return Row(
      children: [
        const Expanded(flex: 2, child: Text('Status')),
        Text(
          hasLicense ? 'Approved' : 'Empty',
          style: context.subhead.copyWith(color: context.onSurface),
        ),
      ],
    );
  }
}
