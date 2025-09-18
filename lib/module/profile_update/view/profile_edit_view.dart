import 'package:flutter/material.dart';
import 'package:limo/module/profile_update/view/profile_edit_view_mixin.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/widgets/shared_app_bar.dart';
import 'package:limo/shared/widgets/shared_button.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/widgets/shared_input.dart';

import '../viewmodel/profile_update_view_model.dart';

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
      appBar: SharedAppBar(title: 'Edit Profile'),
      backgroundColor: context.surfaceContainer,
      body: Padding(
        padding: PaddingConstants.all20,
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
    );
  }

  Column _buildUserUpdateForm(ProfileUpdateViewModel vm) {
    return Column(
      spacing: PaddingConstants.p16,
      children: [
        SharedInput(
          controller: vm.fullNameController,
          label: 'Full Name',
          hint: 'John Doe ',
        ),
        // Phone
        SharedInput(
          controller: vm.phoneController,
          label: 'Phone',
          hint: '1234567890',
        ),
        // Company Name
        SharedInput(
          controller: vm.companyNameController,
          label: 'Company Name',
          hint: 'Company Name',
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
      onPressed: () => profileUpdateViewModel.onSavePressed(context),
    );
  }
}
