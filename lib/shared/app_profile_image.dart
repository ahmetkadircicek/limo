import 'dart:io'; // Added for File

import 'package:flutter/material.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/utils/image_helper.dart';

class AppProfileImage extends StatelessWidget {
  final String? imageUrl;
  final String? imageBase64;
  final double size;
  final VoidCallback? onTap;
  final bool showEditIcon;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;

  const AppProfileImage({
    super.key,
    this.imageUrl,
    this.imageBase64,
    this.size = 70.0,
    this.onTap,
    this.showEditIcon = false,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBgColor =
        backgroundColor ?? context.primary.withValues(alpha: 0.1);
    final defaultBorderColor =
        borderColor ?? context.onSurface.withValues(alpha: 0.2);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: defaultBgColor,
              borderRadius: BorderRadius.circular(size / 2),
              border:
                  borderWidth > 0
                      ? Border.all(
                        color: defaultBorderColor,
                        width: borderWidth,
                      )
                      : null,
            ),
            child: ClipOval(child: _buildImageContent(context)),
          ),

          // Edit icon positioned outside the circle
          if (showEditIcon)
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(DesignTokens.spacing1),
                decoration: BoxDecoration(
                  color: context.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.surface, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit,
                  size: size * 0.25,
                  color: context.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageContent(BuildContext context) {
    // If no image URL or base64, show placeholder icon
    if ((imageUrl == null || imageUrl!.isEmpty) &&
        (imageBase64 == null || imageBase64!.isEmpty)) {
      return _buildPlaceholderIcon(context);
    }

    // Priority 1: Show base64 image if available
    if (imageBase64 != null && imageBase64!.isNotEmpty) {
      return _buildBase64Image(context);
    }

    // Priority 2: Try to load network image
    if (imageUrl != null &&
        imageUrl!.isNotEmpty &&
        (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://'))) {
      return _buildNetworkImage(context);
    }

    // Priority 3: Handle local file paths (for images selected from gallery)
    if (imageUrl != null &&
        imageUrl!.isNotEmpty &&
        (imageUrl!.startsWith('/') || imageUrl!.contains('\\'))) {
      return _buildLocalImage(context);
    }

    // Fallback to placeholder
    return _buildPlaceholderIcon(context);
  }

  /// Build base64 image
  Widget _buildBase64Image(BuildContext context) {
    return ImageHelper.base64ToImage(
      base64String: imageBase64,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorWidget: _buildPlaceholderIcon(context),
      placeholder: _buildLoadingPlaceholder(context),
    );
  }

  Widget _buildNetworkImage(BuildContext context) {
    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to placeholder if network image fails
        return _buildPlaceholderIcon(context);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingPlaceholder(context);
      },
    );
  }

  Widget _buildLocalImage(BuildContext context) {
    try {
      return Image.file(
        File(imageUrl!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to placeholder if local image fails
          return _buildPlaceholderIcon(context);
        },
      );
    } catch (e) {
      // Fallback to placeholder if file doesn't exist
      return _buildPlaceholderIcon(context);
    }
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    return Icon(
      Icons.person,
      size: size * 0.4,
      color: context.onSurface.withValues(alpha: 0.6),
    );
  }

  Widget _buildLoadingPlaceholder(BuildContext context) {
    return Container(
      color: context.surface,
      child: Center(
        child: SizedBox(
          width: size * 0.3,
          height: size * 0.3,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(context.primary),
          ),
        ),
      ),
    );
  }
}
