import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/feature/login/viewmodel/login_view_model.dart';
import 'package:limo/feature/login/widgets/oauth_button.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

/// OAuth authentication buttons section for login view
class OAuthButtonsSection extends StatefulWidget {
  const OAuthButtonsSection({super.key});

  @override
  State<OAuthButtonsSection> createState() => _OAuthButtonsSectionState();
}

class _OAuthButtonsSectionState extends State<OAuthButtonsSection> {
  // Local loading states - only Google is active
  bool _isGoogleLoading = false;

  @override
  Widget build(BuildContext context) {
    const googleRed = Color(0xFFEA4335);

    return Consumer2<LoginViewModel, AppStateProvider>(
      builder: (context, viewModel, appStateProvider, child) {
        // Set the AppStateProvider in the LoginViewModel
        viewModel.setAppStateProvider(appStateProvider);

        // Set the BuildContext in the LoginViewModel for snackbars
        viewModel.setContext(context);

        return Column(
          children: [
            _buildSectionTitle(context),
            SizedBox(height: context.spacingXl),
            _buildGoogleButton(context, viewModel, googleRed),
            SizedBox(height: context.spacingL),
            _buildAppleButton(context),
            SizedBox(height: context.spacingXl),
            _buildDivider(context),
            SizedBox(height: context.spacingXl),
            _buildGuestButton(context),
          ],
        );
      },
    );
  }

  /// Builds the section title text with improved formatting
  Widget _buildSectionTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppText.title('Welcome back!', color: context.onPrimary),
        AppText.body("Let's get you moving.", color: context.onPrimary),
      ],
    );
  }

  /// Builds the Google sign-in button
  Widget _buildGoogleButton(
    BuildContext context,
    LoginViewModel viewModel,
    Color googleRed,
  ) {
    return OAuthButton(
      icon: FontAwesomeIcons.google,
      text: 'Continue with Google',
      backgroundColor: googleRed,
      borderColor: googleRed,
      textColor: context.onPrimary,
      iconColor: context.onPrimary,
      isLoading: _isGoogleLoading,
      onPressed:
          _isGoogleLoading
              ? null
              : () => _handleGoogleSignIn(context, viewModel),
    );
  }

  /// Builds the Apple sign-in button
  Widget _buildAppleButton(BuildContext context) {
    return OAuthButton(
      icon: FontAwesomeIcons.apple,
      text: 'Continue with Apple',
      backgroundColor: context.onPrimary.withValues(
        alpha: 0.3,
      ), // Dimmed background
      borderColor: context.onPrimary.withValues(alpha: 0.3), // Dimmed border
      textColor: context.onPrimary.withValues(alpha: 0.6), // Dimmed text
      iconColor: context.onPrimary.withValues(alpha: 0.6), // Dimmed icon
      isLoading: false, // Never loading since it's disabled
      onPressed: () {
        // Show info message that Apple Sign-In is not available
        AppSnackbar.showInfo(
          context,
          message:
              'Apple Sign-In is not available yet. Please use Google Sign-In.',
        );
      },
    );
  }

  /// Builds the divider between OAuth and guest options
  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 0.5)),
        Padding(
          padding: context.horizontalL,
          child: AppText.bodySmall('OR', color: context.onPrimary),
        ),
        Expanded(child: Divider(thickness: 0.5)),
      ],
    );
  }

  /// Builds the guest mode button
  Widget _buildGuestButton(BuildContext context) {
    return OAuthButton(
      icon: Icons.person_outline_rounded,
      text: 'Continue as Guest',
      backgroundColor: context.onPrimary.withValues(
        alpha: 0.3,
      ), // Dimmed background
      borderColor: context.onPrimary.withValues(alpha: 0.3), // Dimmed border
      textColor: context.onPrimary.withValues(alpha: 0.6), // Dimmed text
      iconColor: context.onPrimary.withValues(alpha: 0.6), // Dimmed icon
      isLoading: false, // Never loading since it's disabled
      onPressed: () {
        // Show info message that guest mode is not available
        AppSnackbar.showInfo(
          context,
          message:
              'Guest mode is not available yet. Please sign in with Google.',
        );
      },
    );
  }

  /// Handles Google sign-in with local loading state
  Future<void> _handleGoogleSignIn(
    BuildContext context,
    LoginViewModel viewModel,
  ) async {
    setState(() => _isGoogleLoading = true);
    try {
      await viewModel.signInWithGoogle();
    } finally {
      setState(() => _isGoogleLoading = false);
    }
  }
}
