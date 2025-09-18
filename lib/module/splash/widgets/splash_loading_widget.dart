import 'package:flutter/material.dart';
import 'package:limo/shared/constants/icon_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';

class SplashLoadingWidget extends StatelessWidget {
  const SplashLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: IconConstants.medium,
      height: IconConstants.medium,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation(context.onPrimary),
      ),
    );
  }
}
