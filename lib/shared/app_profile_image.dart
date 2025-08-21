import 'dart:io'; // Added for File

import 'package:flutter/material.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/utils/image_helper.dart';

/// App Profile Image component for displaying user profile pictures
///
/// This component automatically handles:
/// - Google authentication profile images from network URLs
/// - Local uploaded profile images (when implemented)
/// - Placeholder user icon when no image is available
/// - Loading states while images are being fetched
/// - Error fallbacks if network images fail to load
///
/// Usage examples:
/// ```dart
/// // Basic usage with Google profile image
/// AppProfileImage(
///   imageUrl: user.profileImageUrl,
///   size: 70,
/// )
///
/// // With edit functionality
/// AppProfileImage(
///   imageUrl: user.profileImageUrl,
///   size: 70,
///   showEditIcon: true,
///   onTap: () => _pickImage(),
/// )
///
/// // Custom styling
/// AppProfileImage(
///   imageUrl: user.profileImageUrl,
///   size: 100,
///   backgroundColor: Colors.blue.shade100,
///   borderColor: Colors.blue.shade300,
///   borderWidth: 2,
/// )
/// ```
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
    final theme = Theme.of(context);
    final defaultBgColor =
        backgroundColor ?? theme.colorScheme.primary.withValues(alpha: 0.1);
    final defaultBorderColor =
        borderColor ?? theme.colorScheme.outline.withValues(alpha: 0.2);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Main profile image container
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
            child: ClipOval(child: _buildImageContent(theme)),
          ),

          // Edit icon positioned outside the circle
          if (showEditIcon)
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(DesignTokens.spacing1),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 2,
                  ),
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
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageContent(ThemeData theme) {
    // If no image URL or base64, show placeholder icon
    if ((imageUrl == null || imageUrl!.isEmpty) &&
        (imageBase64 == null || imageBase64!.isEmpty)) {
      return _buildPlaceholderIcon(theme);
    }

    // Priority 1: Show base64 image if available
    if (imageBase64 != null && imageBase64!.isNotEmpty) {
      return _buildBase64Image(theme);
    }

    // Priority 2: Try to load network image
    if (imageUrl != null &&
        imageUrl!.isNotEmpty &&
        (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://'))) {
      return _buildNetworkImage(theme);
    }

    // Priority 3: Handle local file paths (for images selected from gallery)
    if (imageUrl != null &&
        imageUrl!.isNotEmpty &&
        (imageUrl!.startsWith('/') || imageUrl!.contains('\\'))) {
      return _buildLocalImage(theme);
    }

    // Fallback to placeholder
    return _buildPlaceholderIcon(theme);
  }

  /// Build base64 image
  Widget _buildBase64Image(ThemeData theme) {
    return ImageHelper.base64ToImage(
      base64String: imageBase64,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorWidget: _buildPlaceholderIcon(theme),
      placeholder: _buildLoadingPlaceholder(theme),
    );
  }

  Widget _buildNetworkImage(ThemeData theme) {
    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to placeholder if network image fails
        return _buildPlaceholderIcon(theme);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingPlaceholder(theme);
      },
    );
  }

  Widget _buildLocalImage(ThemeData theme) {
    try {
      return Image.file(
        File(imageUrl!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to placeholder if local image fails
          return _buildPlaceholderIcon(theme);
        },
      );
    } catch (e) {
      // Fallback to placeholder if file doesn't exist
      return _buildPlaceholderIcon(theme);
    }
  }

  Widget _buildPlaceholderIcon(ThemeData theme) {
    return Icon(
      Icons.person,
      size: size * 0.4,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
    );
  }

  Widget _buildLoadingPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      child: Center(
        child: SizedBox(
          width: size * 0.3,
          height: size * 0.3,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
