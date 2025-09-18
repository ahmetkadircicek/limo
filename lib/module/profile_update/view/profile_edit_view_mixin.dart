import 'package:flutter/material.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/module/profile_update/view_model/profile_update_view_model.dart';
import 'package:limo/shared/models/user_model.dart';
import 'package:provider/provider.dart';

/// Mixin for profile edit view functionality
mixin ProfileEditViewMixin<T extends StatefulWidget> on State<T> {
  late final ProfileUpdateViewModel viewModel;
  late final UserModel user;

  @override
  void initState() {
    super.initState();
    viewModel = ProfileUpdateViewModel();
    user = context.read<UserProvider>().user!;
    initializeWithUser(viewModel, user);
  }

  void initializeWithUser(ProfileUpdateViewModel vm, UserModel user) {
    vm.fullNameController.text = user.userName ?? '';
    vm.phoneController.text = user.phone ?? '';
    vm.companyNameController.text = user.companyName ?? '';
  }

  @override
  void dispose() {
    viewModel.disposeControllers();
    super.dispose();
  }
}
