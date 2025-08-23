import 'dart:io';

import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/utils/image_helper.dart';

class AppProfileImage extends StatelessWidget {
  final String? imageUrl;
  final String? imageBase64;
  final double? size;
  final VoidCallback? onTap;
  final bool showEditIcon;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;

  const AppProfileImage({
    super.key,
    this.imageUrl,
    this.imageBase64,
    this.size,
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

    final double resolvedSize = size ?? MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: resolvedSize,
            height: resolvedSize,
            decoration: BoxDecoration(
              color: defaultBgColor,
              borderRadius: BorderRadius.circular(
                resolvedSize / 2,
              ), // TODO: move radius to theme
              border:
                  borderWidth > 0
                      ? Border.all(
                        color: defaultBorderColor,
                        width: borderWidth,
                      )
                      : null,
            ),
            child: _buildImageContent(context, resolvedSize),
          ),
          if (showEditIcon)
            Positioned.fill(
              child: Container(
                padding: context.paddingS,
                decoration: BoxDecoration(
                  color: context.primary.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  size: context.iconMedium,
                  color: context.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageContent(BuildContext context, double resolvedSize) {
    if ((imageUrl == null || imageUrl!.isEmpty) &&
        (imageBase64 == null || imageBase64!.isEmpty)) {
      return _buildPlaceholderIcon(context, resolvedSize);
    }

    if (imageBase64 != null && imageBase64!.isNotEmpty) {
      return _buildBase64Image(context, resolvedSize);
    }

    if (imageUrl != null &&
        imageUrl!.isNotEmpty &&
        (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://'))) {
      return _buildNetworkImage(context, resolvedSize);
    }

    if (imageUrl != null &&
        imageUrl!.isNotEmpty &&
        (imageUrl!.startsWith('/') || imageUrl!.contains('\\'))) {
      return _buildLocalImage(context, resolvedSize);
    }

    return _buildPlaceholderIcon(context, resolvedSize);
  }

  Widget _buildBase64Image(BuildContext context, double resolvedSize) {
    return ImageHelper.base64ToImage(
      base64String: imageBase64,
      width: resolvedSize,
      height: resolvedSize,
      fit: BoxFit.cover,
      errorWidget: _buildPlaceholderIcon(context, resolvedSize),
      placeholder: _buildLoadingPlaceholder(context, resolvedSize),
    );
  }

  Widget _buildNetworkImage(BuildContext context, double resolvedSize) {
    return Image.network(
      imageUrl!,
      width: resolvedSize,
      height: resolvedSize,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholderIcon(context, resolvedSize);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingPlaceholder(context, resolvedSize);
      },
    );
  }

  Widget _buildLocalImage(BuildContext context, double resolvedSize) {
    try {
      return Image.file(
        File(imageUrl!),
        width: resolvedSize,
        height: resolvedSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderIcon(context, resolvedSize);
        },
      );
    } catch (e) {
      return _buildPlaceholderIcon(context, resolvedSize);
    }
  }

  Widget _buildPlaceholderIcon(BuildContext context, double resolvedSize) {
    return Icon(
      Icons.person,
      size: resolvedSize * 0.4,
      color: context.onSurface.withValues(alpha: 0.6),
    );
  }

  Widget _buildLoadingPlaceholder(BuildContext context, double resolvedSize) {
    return Container(
      color: context.surface,
      child: Center(
        child: SizedBox(
          width: resolvedSize * 0.3,
          height: resolvedSize * 0.3,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(context.primary),
          ),
        ),
      ),
    );
  }
}
