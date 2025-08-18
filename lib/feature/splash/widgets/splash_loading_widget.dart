import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';

class SplashLoadingWidget extends StatelessWidget {
  final bool isLoading;
  final Color? color;

  static const double _defaultSize = 24.0;
  static const double _defaultStrokeWidth = 2.5;

  const SplashLoadingWidget({super.key, required this.isLoading, this.color});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildSpinner(context);
    }
    return _buildPlaceholder();
  }

  /// Builds the circular progress indicator
  Widget _buildSpinner(BuildContext context) {
    return SizedBox(
      width: _defaultSize,
      height: _defaultSize,
      child: CircularProgressIndicator(
        strokeWidth: _defaultStrokeWidth,
        valueColor: AlwaysStoppedAnimation(color ?? context.onPrimary),
      ),
    );
  }

  /// Builds the placeholder when not loading
  Widget _buildPlaceholder() {
    return SizedBox(width: _defaultSize, height: _defaultSize);
  }
}
