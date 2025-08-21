import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';

class SplashLoadingWidget extends StatelessWidget {
  static const double _defaultSize = 24.0;
  static const double _defaultStrokeWidth = 2.5;

  const SplashLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSpinner(context);
  }

  /// Builds the circular progress indicator
  Widget _buildSpinner(BuildContext context) {
    return SizedBox(
      width: _defaultSize,
      height: _defaultSize,
      child: CircularProgressIndicator(
        strokeWidth: _defaultStrokeWidth,
        valueColor: AlwaysStoppedAnimation(context.onPrimary),
      ),
    );
  }
}
