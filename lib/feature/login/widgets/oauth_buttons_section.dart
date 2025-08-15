import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/login/viewmodel/login_view_model.dart';
import 'package:limo/feature/login/widgets/oauth_button.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

/// OAuth authentication buttons section for login view
class OAuthButtonsSection extends StatelessWidget {
  const OAuthButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            _buildSectionTitle(context),
            SizedBox(height: context.spacingXl),
            _buildGoogleButton(context, viewModel),
            SizedBox(height: context.spacingL),
            _buildAppleButton(context, viewModel),
            SizedBox(height: context.spacingXl),
            _buildDivider(context),
            SizedBox(height: context.spacingXl),
            _buildGuestButton(context, viewModel),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return AppText.subtitle(
      'Sign in to your account',
      color: Colors.white,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildGoogleButton(BuildContext context, LoginViewModel viewModel) {
    return OAuthButton(
      icon: FontAwesomeIcons.google,
      text: 'Continue with Google',
      backgroundColor: const Color(0xFFEA4335),
      borderColor: const Color(0xFFEA4335),
      textColor: Colors.white,
      iconColor: Colors.white,
      isLoading: viewModel.isGoogleLoading,
      onPressed: () => viewModel.signInWithGoogle(context),
    );
  }

  Widget _buildAppleButton(BuildContext context, LoginViewModel viewModel) {
    return OAuthButton(
      icon: FontAwesomeIcons.apple,
      text: 'Continue with Apple',
      backgroundColor: Colors.white,
      borderColor: Colors.white,
      textColor: Colors.black,
      iconColor: Colors.black,
      isLoading: viewModel.isAppleLoading,
      onPressed: () => viewModel.signInWithApple(context),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white.withValues(alpha: 0.15),
            thickness: 1,
          ),
        ),
        Padding(
          padding: context.horizontalL,
          child: AppText.bodySmall(
            'OR',
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.white.withValues(alpha: 0.15),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildGuestButton(BuildContext context, LoginViewModel viewModel) {
    return OAuthButton(
      icon: Icons.person_outline_rounded,
      text: 'Continue as Guest',
      backgroundColor: Colors.white.withValues(alpha: 0.08),
      borderColor: Colors.white.withValues(alpha: 0.18),
      textColor: Colors.white,
      iconColor: Colors.white.withValues(alpha: 0.85),
      isLoading: viewModel.isGuestLoading,
      onPressed: () => viewModel.continueAsGuest(context),
    );
  }
}
