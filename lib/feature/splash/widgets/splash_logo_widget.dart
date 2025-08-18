import 'package:flutter/material.dart';
import 'package:limo/core/constants/image_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';

/// Reusable widget for displaying the app logo in splash screens
class SplashLogoWidget extends StatelessWidget {
  const SplashLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(context.onPrimary, BlendMode.srcIn),
      child: Image.asset(
        ImageAssets.logo,
        width: context.width * 0.7,
        fit: BoxFit.contain,
      ),
    );
  }
}
