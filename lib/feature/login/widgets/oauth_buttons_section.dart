import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/feature/login/services/apple_auth_service.dart';
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
  // Local loading states for both providers
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;

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
          spacing: context.spacingL,
          children: [
            _buildGoogleButton(context, viewModel, googleRed),
            _buildAppleButton(context, viewModel),
          ],
        );
      },
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
  Widget _buildAppleButton(BuildContext context, LoginViewModel viewModel) {
    return FutureBuilder<bool>(
      future: AppleAuthService.instance.isAvailable(),
      builder: (context, snapshot) {
        final isAvailable = snapshot.data ?? false;
        final currentContext = context;

        return OAuthButton(
          icon: FontAwesomeIcons.apple,
          text: 'Continue with Apple',
          backgroundColor: isAvailable ? currentContext.surface : Colors.grey,
          borderColor: isAvailable ? currentContext.surface : Colors.grey,
          textColor: isAvailable ? currentContext.onSurface : Colors.white,
          iconColor: isAvailable ? currentContext.onSurface : Colors.white,
          isLoading: _isAppleLoading,
          onPressed:
              (isAvailable && !_isAppleLoading)
                  ? () => _handleAppleSignIn(currentContext, viewModel)
                  : null,
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
    } catch (e) {
      // Log any unexpected errors during Google Sign-In
      LoggerService.error(
        'Unexpected error during Google Sign-In: $e',
        tag: 'OAUTH_BUTTONS',
      );

      // Show user-friendly error message
      if (mounted) {
        final currentContext = context;
        AppSnackbar.showError(
          currentContext,
          message: 'Google Sign-In failed. Please try again.',
        );
      }
    } finally {
      setState(() => _isGoogleLoading = false);
    }
  }

  /// Handles Apple sign-in with local loading state
  Future<void> _handleAppleSignIn(
    BuildContext context,
    LoginViewModel viewModel,
  ) async {
    setState(() => _isAppleLoading = true);
    try {
      // Check Apple Sign-In availability first
      final isAvailable = await AppleAuthService.instance.isAvailable();

      if (isAvailable) {
        await viewModel.signInWithApple();
      } else if (mounted) {
        final currentContext = context;
        AppSnackbar.showError(
          currentContext,
          message: 'Apple Sign-In is not available on this device.',
        );
      }
    } finally {
      setState(() => _isAppleLoading = false);
    }
  }
}
