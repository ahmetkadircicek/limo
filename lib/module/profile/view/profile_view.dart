import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/module/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/module/profile/view_model/profile_view_model.dart';
import 'package:limo/module/profile/widget/driver_license_widget.dart';
import 'package:limo/module/profile/widget/personal_info_widget.dart';
import 'package:limo/module/profile/widget/profile_photo_widget.dart';
import 'package:limo/module/profile/widget/statistics_widget.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/widgets/shared_button.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: PaddingConstants.all20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: PaddingConstants.p16,
        children: [
          const Align(
            alignment: Alignment.center,
            child: ProfilePhotoWidget(),
          ),
          SharedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: PaddingConstants.p24,
              children: const [
                PersonalInfoWidget(),
                _ProfilePrimaryActions(),
              ],
            ),
          ),
          const SharedCard(child: StatisticsWidget()),
          SharedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: PaddingConstants.p16,
              children: const [DriverLicenseWidget(), _DriverLicenseAction()],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilePrimaryActions extends StatelessWidget {
  const _ProfilePrimaryActions();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      spacing: PaddingConstants.p12,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SharedButton(
          text: 'Edit Profile',
          backgroundColor: context.primary,
          foregroundColor: context.onPrimary,
          onPressed:
              () => context.read<ProfileViewModel>().onEditPressed(context),
        ),
        SharedButton(
          text: 'Change Photo',
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          onPressed: () {
            context.pushNamed(
              'documentUpload',
              extra: DocumentUploadPurpose.profilePhoto,
            );
          },
        ),
      ],
    );
  }
}

class _DriverLicenseAction extends StatelessWidget {
  const _DriverLicenseAction();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SharedButton(
      text: 'Upload Driver License',
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      onPressed: () {
        context.pushNamed(
          'documentUpload',
          extra: DocumentUploadPurpose.driverLicense,
        );
      },
    );
  }
}
