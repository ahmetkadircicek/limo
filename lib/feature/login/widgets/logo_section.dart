import 'package:flutter/material.dart';
import 'package:limo/core/constants/image_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_components.dart';

/// Logo and welcome section widget for login view
class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.spacingS,
      children: [_buildAppLogo(context), _buildWelcomeMessage(context)],
    );
  }

  /// Builds the app logo with proper sizing and color filtering
  Widget _buildAppLogo(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(context.onPrimary, BlendMode.srcIn),
      child: Image.asset(ImageAssets.logo, width: context.width * 0.8),
    );
  }

  /// Builds the welcome message text below the logo
  Widget _buildWelcomeMessage(BuildContext context) {
    return AppText.body('Fast and secure work.', color: context.onPrimary);
  }
}
