import 'package:flutter/material.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:provider/provider.dart';

/// Mixin for profile edit view functionality
mixin ProfileEditViewMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController fullNameController = TextEditingController();
  late final TextEditingController phoneController = TextEditingController();
  late final TextEditingController companyNameController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    companyNameController.dispose();
    super.dispose();
  }

  /// Initialize controllers with current user data
  void _initializeControllers() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final appState = Provider.of<AppStateProvider>(context, listen: false);
        final user = appState.currentUser;
        if (user != null) {
          fullNameController.text = user.userName;
          phoneController.text = user.phone ?? '';
          companyNameController.text = user.companyName ?? '';
        }
      }
    });
  }

  /// Reset form controllers
  void resetForm() {
    fullNameController.clear();
    phoneController.clear();
    companyNameController.clear();
  }
}
