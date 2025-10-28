import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/models/user_model.dart';
import 'package:provider/provider.dart';

class ProfilePhotoWidget extends StatelessWidget {
  const ProfilePhotoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    if (user == null) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildProfilePicture(context, user),
        const SizedBox(height: 12),
        Text(user.userName, textAlign: TextAlign.center, style: context.title3),
        Text(
          'Welcome back to your profile',
          textAlign: TextAlign.center,
          style: context.body.copyWith(color: context.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildProfilePicture(BuildContext context, UserModel user) {
    const double size = 200.0;
    final imageBytes = _decodePhoto(user.userPhoto);
    final hasPhoto = imageBytes != null;
    final initials = _getInitials(user.userName);

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: context.surface,
      backgroundImage: hasPhoto ? MemoryImage(imageBytes) : null,
      child:
          hasPhoto
              ? null
              : Text(
                initials,
                style: context.title3.copyWith(
                  color: context.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
    );
  }

  String _getInitials(String fullName) {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) {
      return 'U';
    }

    final parts =
        trimmed.split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) {
      return 'U';
    }

    String initialOf(String value) => value.isEmpty ? '' : value[0];

    final firstInitial = initialOf(parts.first);
    final lastInitial = parts.length > 1 ? initialOf(parts.last) : '';
    final initials = (firstInitial + lastInitial).toUpperCase();
    return initials.isEmpty ? 'U' : initials;
  }

  Uint8List? _decodePhoto(String? base64Photo) {
    if (base64Photo == null || base64Photo.isEmpty) {
      return null;
    }
    try {
      return base64Decode(base64Photo);
    } catch (_) {
      return null;
    }
  }
}
