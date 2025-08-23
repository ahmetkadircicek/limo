import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:limo/core/constants/design_tokens.dart';

/// Helper utility for handling base64 image conversion and display
class ImageHelper {
  static Widget base64ToImage({
    required String? base64String,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
    Widget? placeholder,
  }) {
    // Return placeholder if no base64 data
    if (base64String == null || base64String.isEmpty) {
      return placeholder ?? _buildDefaultPlaceholder(width, height);
    }

    try {
      // Decode base64 to bytes
      final Uint8List bytes = base64Decode(base64String);

      // Create memory image
      final image = MemoryImage(bytes);

      // Return Image widget
      return Image(
        image: image,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildDefaultErrorWidget(width, height);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? _buildDefaultPlaceholder(width, height);
        },
      );
    } catch (e) {
      // Return error widget if base64 decoding fails
      return errorWidget ?? _buildDefaultErrorWidget(width, height);
    }
  }

  /// Convert base64 string to Image widget with circular shape
  ///
  /// [base64String] - Base64 encoded image string
  /// [radius] - Radius of the circular image
  /// [fit] - How the image should be fitted (default: BoxFit.cover)
  /// [errorWidget] - Widget to show if image loading fails
  /// [placeholder] - Widget to show while image is loading
  static Widget base64ToCircularImage({
    required String? base64String,
    required double radius,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
    Widget? placeholder,
  }) {
    return ClipOval(
      child: base64ToImage(
        base64String: base64String,
        width: radius * 2,
        height: radius * 2,
        fit: fit,
        errorWidget: errorWidget,
        placeholder: placeholder,
      ),
    );
  }

  /// Convert image file to base64 string
  ///
  /// [imageFile] - Image file to convert
  /// Returns base64 encoded string or null if conversion fails
  static Future<String?> imageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      return base64String;
    } catch (e) {
      return null;
    }
  }

  /// Convert image file to base64 string with compression
  ///
  /// [imageFile] - Image file to convert
  /// [maxWidth] - Maximum width for compression (default: 800)
  /// [maxHeight] - Maximum height for compression (default: 800)
  /// [quality] - Image quality 0-100 (default: 85)
  /// Returns base64 encoded string or null if conversion fails
  static Future<String?> imageToBase64Compressed({
    required File imageFile,
    int maxWidth = 800,
    int maxHeight = 800,
    int quality = 85,
  }) async {
    try {
      // For now, return the original image converted to base64
      // In the future, you can add image compression logic here
      return await imageToBase64(imageFile);
    } catch (e) {
      return null;
    }
  }

  /// Convert base64 string to Image widget with rounded corners
  ///
  /// [base64String] - Base64 encoded image string
  /// [width] - Optional width for the image
  /// [height] - Optional height for the image
  /// [borderRadius] - Border radius for rounded corners
  /// [fit] - How the image should be fitted (default: BoxFit.cover)
  /// [errorWidget] - Widget to show if image loading fails
  /// [placeholder] - Widget to show while image is loading
  static Widget base64ToRoundedImage({
    required String? base64String,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
    Widget? placeholder,
  }) {
    return ClipRRect(
      borderRadius:
          borderRadius ?? BorderRadius.circular(DesignTokens.radiusMedium),
      child: base64ToImage(
        base64String: base64String,
        width: width,
        height: height,
        fit: fit,
        errorWidget: errorWidget,
        placeholder: placeholder,
      ),
    );
  }

  /// Convert base64 string to Image widget with fallback to network image
  ///
  /// [base64String] - Base64 encoded image string (priority)
  /// [networkUrl] - Network image URL as fallback
  /// [width] - Optional width for the image
  /// [height] - Optional height for the image
  /// [fit] - How the image should be fitted (default: BoxFit.cover)
  /// [errorWidget] - Widget to show if both base64 and network fail
  /// [placeholder] - Widget to show while image is loading
  static Widget base64OrNetworkImage({
    String? base64String,
    String? networkUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
    Widget? placeholder,
  }) {
    // Try base64 first if available
    if (base64String != null && base64String.isNotEmpty) {
      return base64ToImage(
        base64String: base64String,
        width: width,
        height: height,
        fit: fit,
        errorWidget: errorWidget,
        placeholder: placeholder,
      );
    }

    // Fallback to network image if URL available
    if (networkUrl != null && networkUrl.isNotEmpty) {
      return Image.network(
        networkUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildDefaultErrorWidget(width, height);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? _buildDefaultPlaceholder(width, height);
        },
      );
    }

    // Return placeholder if neither base64 nor network available
    return placeholder ?? _buildDefaultPlaceholder(width, height);
  }

  /// Convert base64 string to Image widget with circular shape and fallback to network
  ///
  /// [base64String] - Base64 encoded image string (priority)
  /// [networkUrl] - Network image URL as fallback
  /// [radius] - Radius of the circular image
  /// [fit] - How the image should be fitted (default: BoxFit.cover)
  /// [errorWidget] - Widget to show if both base64 and network fail
  /// [placeholder] - Widget to show while image is loading
  static Widget base64OrNetworkCircularImage({
    String? base64String,
    String? networkUrl,
    required double radius,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
    Widget? placeholder,
  }) {
    return ClipOval(
      child: base64OrNetworkImage(
        base64String: base64String,
        networkUrl: networkUrl,
        width: radius * 2,
        height: radius * 2,
        fit: fit,
        errorWidget: errorWidget,
        placeholder: placeholder,
      ),
    );
  }

  /// Check if base64 string is valid image data
  ///
  /// [base64String] - Base64 string to validate
  /// Returns true if valid, false otherwise
  static bool isValidBase64Image(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return false;
    }

    try {
      final bytes = base64Decode(base64String);
      return bytes.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get image dimensions from base64 string
  ///
  /// [base64String] - Base64 encoded image string
  /// Returns Map with 'width' and 'height' keys, or null if failed
  static Future<Map<String, int>?> getBase64ImageDimensions(
    String base64String,
  ) async {
    try {
      final bytes = base64Decode(base64String);
      final codec = await ui.instantiateImageCodec(bytes);
      final frameInfo = await codec.getNextFrame();
      final image = frameInfo.image;

      return {'width': image.width, 'height': image.height};
    } catch (e) {
      return null;
    }
  }

  // Private helper methods

  /// Build default placeholder widget
  static Widget _buildDefaultPlaceholder(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
      child: Icon(
        Icons.image,
        color: Colors.grey[600],
        size: (width ?? 40) * 0.3,
      ),
    );
  }

  /// Build default error widget
  static Widget _buildDefaultErrorWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Icon(
        Icons.broken_image,
        color: Colors.grey[500],
        size: (width ?? 40) * 0.3,
      ),
    );
  }
}
