import 'package:flutter/material.dart';
import 'package:limo/core/constants/image_constants.dart';

/// Helper class for easier asset usage in widgets
class AssetHelper {
  /// Displays an image asset with error handling and loading states
  static Widget image({
    required String assetPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    BlendMode? colorBlendMode,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: Icon(
                Icons.error_outline,
                color: Colors.grey[600],
                size: width != null ? width * 0.3 : 24,
              ),
            );
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
    );
  }

  /// Displays a logo image with consistent styling
  static Widget logo({
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    return image(
      assetPath: ImageAssets.logo,
      width: width,
      height: height,
      color: color,
      fit: fit,
    );
  }

  /// Displays a login image with consistent styling
  static Widget loginImage({
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return image(
      assetPath: ImageAssets.loginImage,
      width: width,
      height: height,
      fit: fit,
    );
  }

  /// Displays a lottie animation (placeholder implementation)
  static Widget lottie({
    required String assetPath,
    double? width,
    double? height,
    bool repeat = true,
    bool animate = true,
  }) {
    // Lottie implementation not available yet
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Text(
          'Lottie not available',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  /// Gets a network image with asset fallback
  static Widget networkImageWithFallback({
    required String networkUrl,
    required String fallbackAsset,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Image.network(
      networkUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                ),
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        return image(
          assetPath: fallbackAsset,
          width: width,
          height: height,
          fit: fit,
          errorWidget: errorWidget,
        );
      },
    );
  }
}
