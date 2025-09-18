import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:limo/module/login/view/login_view_mixin.dart';
import 'package:limo/shared/constants/image_constants.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:provider/provider.dart';

import '../view_model/login_view_model.dart';
import '../widgets/logo_section.dart';
import '../widgets/oauth_buttons_section.dart';
import '../widgets/terms_section.dart';

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

class _LoginViewBodyState extends State<_LoginViewBody> with LoginViewMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
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
      ImageConstants.loginImage,
      fit: BoxFit.fitHeight,
      width: double.infinity,
      height: double.infinity,
    );
  }

  /// Build the blur overlay
  Widget _buildBlurOverlay(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(color: context.primary.withValues(alpha: 0.6)),
    );
  }

  /// Build the dark gradient overlay
  Widget _buildDarkOverlay(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, context.primary],
        ),
      ),
    );
  }

  /// Build the foreground content with SafeArea and padding
  Widget _buildForegroundContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: PaddingConstants.horizontal20,
        child: Column(
          spacing: PaddingConstants.p20,
          children: [
            const Spacer(),
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
