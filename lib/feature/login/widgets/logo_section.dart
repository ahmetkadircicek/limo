import 'package:flutter/material.dart';
import 'package:limo/shared/constants/image_constants.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_size_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';

/// Logo and welcome section widget for login view
class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PaddingConstants.p8,
      children: [_buildAppLogo(context), _buildWelcomeMessage(context)],
    );
  }

  /// Builds the app logo with proper sizing and color filtering
  Widget _buildAppLogo(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(context.onPrimary, BlendMode.srcIn),
      child: Image.asset(ImageConstants.logo, width: context.width * 0.8),
    );
  }

  /// Builds the welcome message text below the logo
  Widget _buildWelcomeMessage(BuildContext context) {
    return Text(
      'Fast and secure work.',
      style: context.body.copyWith(color: context.onSurface),
      textAlign: TextAlign.center,
    );
  }
}
