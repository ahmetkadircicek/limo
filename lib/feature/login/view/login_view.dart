import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/login/widgets/logo_section.dart';
import 'package:limo/feature/login/widgets/oauth_buttons_section.dart';
import 'package:limo/feature/login/widgets/terms_section.dart';

/// Modern OAuth-only login screen with extracted widgets
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LoginViewBody();
  }
}

/// Main login view body with background and content
class _LoginViewBody extends StatelessWidget {
  const _LoginViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundSection(),
          _buildForegroundContent(context),
        ],
      ),
    );
  }

  /// Build the background section with image, blur and overlay
  Widget _buildBackgroundSection() {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundImage(),
          _buildBlurOverlay(),
          _buildDarkOverlay(),
        ],
      ),
    );
  }

  /// Build the background image
  Widget _buildBackgroundImage() {
    return Image.asset(
      'assets/png/image/image_login.png',
      fit: BoxFit.cover,
    );
  }

  /// Build the blur effect overlay
  Widget _buildBlurOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withValues(alpha: 0.45),
        ),
      ),
    );
  }

  /// Build the extra dark overlay
  Widget _buildDarkOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.35),
      ),
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
            SizedBox(height: 112),
          ],
        ),
      ),
    );
  }
}
