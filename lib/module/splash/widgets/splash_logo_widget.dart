import 'package:flutter/material.dart';
import 'package:limo/shared/constants/image_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_size_extension.dart';

/// Reusable widget for displaying the app logo in splash screens
class SplashLogoWidget extends StatelessWidget {
  const SplashLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(context.onPrimary, BlendMode.srcIn),
      child: Image.asset(
        ImageConstants.logo,
        width: context.width * 0.7,
        fit: BoxFit.contain,
      ),
    );
  }
}
