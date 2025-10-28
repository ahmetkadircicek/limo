import 'package:flutter/material.dart';

import 'package:limo/core/navigation/route_paths.dart';
import 'package:limo/module/profile_update/view/profile_edit_view_mixin.dart';
import 'package:limo/module/profile_update/view_model/profile_update_view_model.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/widgets/form/shared_text_field.dart';
import 'package:limo/shared/widgets/shared_app_bar.dart';
import 'package:limo/shared/widgets/shared_button.dart';
import 'package:limo/shared/widgets/shared_card.dart';

/// Profile edit view with all UI elements in a single build method
class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView>
    with ProfileEditViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(
        title: 'Edit Profile',
        backPath: RoutePaths.profile,
      ),
      backgroundColor: context.surfaceContainer,
      body: Padding(
        padding: PaddingConstants.all20,
        child: Form(
          key: profileFormKey,
          child: SharedCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: PaddingConstants.p20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserUpdateForm(viewModel),
                _buildSaveButton(viewModel, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildUserUpdateForm(ProfileUpdateViewModel vm) {
    return Column(
      spacing: PaddingConstants.p16,
      children: [
        SharedTextField(
          controller: vm.fullNameController,
          label: 'Full Name',
          validator:
              (value) => validateRequiredField(value, fieldName: 'Full name'),
        ),
        // Phone
        SharedTextField(
          controller: vm.phoneController,
          label: 'Phone',
          validator:
              (value) =>
                  validateRequiredField(value, fieldName: 'Phone number'),
        ),
        // Company Name
        SharedTextField(
          controller: vm.companyNameController,
          label: 'Company Name',
          validator:
              (value) =>
                  validateRequiredField(value, fieldName: 'Company name'),
        ),
      ],
    );
  }

  Widget _buildSaveButton(
    ProfileUpdateViewModel profileUpdateViewModel,
    BuildContext context,
  ) {
    return SharedButton(
      text: 'Save Changes',
      isLoading: profileUpdateViewModel.isLoading,
      backgroundColor: context.primary,
      foregroundColor: context.onPrimary,
      onPressed: () {
        if (!validateProfileForm()) return;
        profileUpdateViewModel.onSavePressed(context);
      },
    );
  }
}
