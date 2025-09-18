import 'package:flutter/material.dart';
import 'package:limo/module/profile/widget/driver_license_widget.dart';
import 'package:limo/module/profile/widget/personal_info_widget.dart';
import 'package:limo/module/profile/widget/profile_photo_widget.dart';
import 'package:limo/module/profile/widget/statistics_widget.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: PaddingConstants.p16,
        children: [
          ProfilePhotoWidget(),
          PersonalInfoWidget(),
          StatisticsWidget(),
          DriverLicenseWidget(),
        ],
      ),
    );
  }
}
