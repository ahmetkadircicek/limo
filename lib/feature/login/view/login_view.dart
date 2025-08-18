import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/constants/image_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/feature/login/viewmodel/login_view_model.dart';
import 'package:limo/feature/login/widgets/logo_section.dart';
import 'package:limo/feature/login/widgets/oauth_buttons_section.dart';
import 'package:limo/feature/login/widgets/terms_section.dart';
import 'package:provider/provider.dart';

/// Modern OAuth-only login screen with extracted widgets
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LoginViewBody();
  }
}

/// Main login view body with background and content
class _LoginViewBody extends StatefulWidget {
  const _LoginViewBody();

  @override
  State<_LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<_LoginViewBody> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<LoginViewModel, AppStateProvider>(
      builder: (context, loginViewModel, appStateProvider, child) {




        // Re-enable authentication state change handling
        _handleAuthenticationStateChange(loginViewModel);

        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              _buildBackgroundSection(context),
              _buildForegroundContent(context),
            ],
          ),
        );
      },
    );
  }

  /// Handles authentication state changes and navigates accordingly
  void _handleAuthenticationStateChange(LoginViewModel viewModel) {
    if (viewModel.isAuthenticated) {
      // Navigate to home when authenticated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/home');
        }
      });
    }
  }

  /// Build the background section with image, blur and overlay
  Widget _buildBackgroundSection(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundImage(),
          _buildBlurOverlay(context),
          _buildDarkOverlay(context),
        ],
      ),
    );
  }

  /// Build the background image
  Widget _buildBackgroundImage() {
    return Image.asset(ImageAssets.loginImage, fit: BoxFit.cover);
  }

  /// Build the blur effect overlay
  Widget _buildBlurOverlay(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(color: context.onSurface.withValues(alpha: 0.4)),
      ),
    );
  }

  /// Build the extra dark overlay
  Widget _buildDarkOverlay(BuildContext context) {
    return Positioned.fill(
      child: Container(color: context.onSurface.withValues(alpha: 0.4)),
    );
  }

  /// Build the foreground content with SafeArea and padding
  Widget _buildForegroundContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.responsivePadding,
        child: Column(
          children: [
            SizedBox(height: context.spacingXxxl),
            const LogoSection(),
            const Spacer(),
            const OAuthButtonsSection(),
            SizedBox(height: context.spacingL),
            const TermsSection(),
          ],
        ),
      ),
    );
  }
}
