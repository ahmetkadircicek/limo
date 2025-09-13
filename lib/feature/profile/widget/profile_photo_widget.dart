import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/feature/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/shared/constants/image_constants.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/widgets/shared_chip_button.dart';
import 'package:limo/shared/widgets/shared_info.dart';
import 'package:provider/provider.dart';

class ProfilePhotoWidget extends StatelessWidget {
  const ProfilePhotoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: PaddingConstants.p16,
        children: [
          _buildTitle(context),
          _buildProfileSection(context),
          _buildAppInfo(),
        ],
      ),
    );
  }

  Row _buildProfileSection(BuildContext context) {
    return Row(
      spacing: PaddingConstants.p16,
      children: [_buildProfilePicture(context), _buildUserGreeting(context)],
    );
  }

  Expanded _buildUserGreeting(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: PaddingConstants.p4,
        children: [
          Text(
            'Hello, ${_getFirstName(user?.userName ?? 'User')}!',
            style: context.headline.copyWith(color: context.onSurface),
          ),
          Text(
            'Welcome back to your profile',
            style: context.subhead.copyWith(color: context.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Container _buildProfilePicture(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final hasPhoto = user?.userPhoto?.isNotEmpty ?? false;
    final double size = 60.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child:
            hasPhoto
                ? Image.memory(
                  base64Decode(user?.userPhoto ?? ''),
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                )
                : Image.asset(
                  ImageConstants.profile,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                ),
      ),
    );
  }

  SharedInfo _buildAppInfo() {
    return SharedInfo(
      label: 'Complete your profile to get more job opportunities',
      value: 'Add a profile picture',
      icon: Icons.tips_and_updates,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Profile Picture',
          style: context.headline.copyWith(color: context.onSurface),
        ),
        SharedChipButton(
          text: 'Change',
          onPressed: () {
            context.pushNamed(
              'documentUpload',
              extra: DocumentUploadPurpose.profilePhoto,
            );
          },
          backgroundColor: context.primary,
          foregroundColor: context.onPrimary,
          icon: Icons.image_outlined,
        ),
      ],
    );
  }

  String _getFirstName(String fullName) {
    final parts = fullName.trim().split(' ');
    return parts.isNotEmpty ? parts.first : 'User';
  }
}
