import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soforvarcom/core/constants/image_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/feature/authentication/register/widget/sliding_register_form.dart';

import '../viewmodel/register_view_model.dart';

final class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the RegisterViewModel to the widget tree
    return ChangeNotifierProvider(
      create: (context) => RegisterViewModel(context),
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(context),
            const SlidingRegisterForm(),
          ],
        ),
      ),
    );
  }
}

// Builds the background of the register view
Widget _buildBackground(BuildContext context) {
  return SafeArea(
    child: Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          SizedBox(
            width: context.width * 0.7,
            child: Image.asset(
              ImageConstants.imageSoforvarcom,
              fit: BoxFit.fitWidth,
            ),
          ),
          context.spacerHeight(2),
          SizedBox(
            child: Image.asset(
              width: context.width * 0.7,
              ImageConstants.imageOnboard,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    ),
  );
}
