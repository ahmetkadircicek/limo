import 'package:flutter/material.dart';
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

  /// Build the background section with image, blur and overlay
  Widget _buildBackgroundSection(BuildContext context) {
    return Positioned.fill(
      child: Stack(
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
    return Image.asset(
      ImageAssets.loginImage,
      fit: BoxFit.fitHeight, // Ekranı tamamen kapla
      width: double.infinity,
      height: double.infinity,
    );
  }

  /// Build the blur overlay
  Widget _buildBlurOverlay(BuildContext context) {
    return Container(color: Colors.black.withValues(alpha: 0.6));
  }

  /// Build the dark overlay
  Widget _buildDarkOverlay(BuildContext context) {
    return Container(color: Colors.black.withValues(alpha: 0.6));
  }

  /// Build the foreground content with SafeArea and padding
  Widget _buildForegroundContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.horizontalL,
        child: Column(
          spacing: context.spacingXl,
          children: [
            const LogoSection(),
            const Spacer(),
            const OAuthButtonsSection(),
            const TermsSection(),
          ],
        ),
      ),
    );
  }
}
