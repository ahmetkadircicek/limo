import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/navigation/route_paths.dart';
import 'package:limo/module/login/widgets/oauth_button.dart';
import 'package:limo/shared/constants/color_constants.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/widgets/app_snackbar.dart';
import 'package:provider/provider.dart';

import '../view_model/login_view_model.dart';

class OAuthButtonsSection extends StatelessWidget {
  const OAuthButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Column(
      spacing: PaddingConstants.p16,
      children: [
        OAuthButton(
          text: "Sign in with Google",
          icon: FontAwesomeIcons.google,
          color: ColorConstants.google,
          textColor: context.onPrimary,
          isLoading: viewModel.isLoading,
          onPressed: () async {
            final user = await viewModel.signInWithGoogle(context);
            if (user != null && context.mounted) {
              context.go(RoutePaths.home);
            }
          },
        ),
        OAuthButton(
          text: "Sign in with Apple",
          icon: FontAwesomeIcons.apple,
          color: context.onPrimary,
          textColor: ColorConstants.apple,
          onPressed: () {
            AppSnackbar.warning(message: "Apple sign-in is not supported yet.");
          },
        ),
      ],
    );
  }
}
