import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_components.dart';

/// Logo and welcome section widget for login view
class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppLogo(context),
        SizedBox(height: context.spacingM),
        _buildWelcomeMessage(context),
      ],
    );
  }

  Widget _buildAppLogo(BuildContext context) {
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        Colors.white,
        BlendMode.srcIn,
      ),
      child: Image.asset(
        'assets/png/image/image_logo.png',
        width: context.width * 0.7,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildWelcomeMessage(BuildContext context) {
    return AppText.body(
      'Hızlı ve güvenli yolculuklar sizi bekliyor.',
      color: Colors.white.withValues(alpha: 0.85),
      textAlign: TextAlign.center,
      maxLines: 2,
    );
  }
}
