import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';

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
    this.size = 96,
    this.onTap,
    this.showEditIcon = false,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    final img = _resolveImage();
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            backgroundColor ??
            Theme.of(context).colorScheme.surfaceContainerHighest,
        border:
            borderWidth > 0
                ? Border.all(
                  color: borderColor ?? Theme.of(context).dividerColor,
                  width: borderWidth,
                )
                : null,
      ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: img,
        child:
            img == null
                ? Icon(
                  Icons.person,
                  size: size * 0.45,
                  color: context.onSurface.withValues(alpha: 0.6),
                )
                : null,
      ),
    );

    final content = Stack(
      alignment: Alignment.center,
      children: [
        avatar,
        if (showEditIcon)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(.25),
              ),
              child: Icon(Icons.edit, size: size * 0.28, color: Colors.white),
            ),
          ),
      ],
    );

    return GestureDetector(onTap: onTap, child: content);
  }

  ImageProvider? _resolveImage() {
    if (imageBase64 != null && imageBase64!.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(imageBase64!));
      } catch (_) {}
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      final u = imageUrl!;
      if (u.startsWith('http')) return NetworkImage(u);
      if (u.startsWith('/') || u.contains('\\')) return FileImage(File(u));
    }
    return null;
  }
}
