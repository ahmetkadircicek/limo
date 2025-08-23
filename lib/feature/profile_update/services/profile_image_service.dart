import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:limo/core/utils/image_helper.dart';
import 'package:limo/core/utils/logger_service.dart';

/// Service for handling profile image operations
class ProfileImageService {
  static const String _tag = 'PROFILE_IMAGE_SERVICE';
  static final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      LoggerService.info('Starting image picker from gallery', tag: _tag);

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, // Resize for better performance
        maxHeight: 800,
        imageQuality: 85, // Good quality with reasonable file size
      );

      if (image != null) {
        LoggerService.success(
          'Image selected from gallery: ${image.path}',
          tag: _tag,
        );
        return File(image.path);
      } else {
        LoggerService.info('No image selected from gallery', tag: _tag);
        return null;
      }
    } catch (e) {
      LoggerService.error('Error picking image from gallery: $e', tag: _tag);
      return null;
    }
  }

  /// Show image source selection dialog
  static Future<File?> showImageSourceDialog(BuildContext context) async {
    return showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final image = await pickImageFromGallery();
                  if (context.mounted) {
                    Navigator.of(context).pop(image);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Validate image file
  static bool isValidImageFile(File file) {
    try {
      final path = file.path.toLowerCase();
      final validExtensions = ['.jpg', '.jpeg', '.png', '.webp'];

      return validExtensions.any((ext) => path.endsWith(ext));
    } catch (e) {
      LoggerService.error('Error validating image file: $e', tag: _tag);
      return false;
    }
  }

  /// Get file size in MB
  static double getFileSizeInMB(File file) {
    try {
      final bytes = file.lengthSync();
      return bytes / (1024 * 1024);
    } catch (e) {
      LoggerService.error('Error getting file size: $e', tag: _tag);
      return 0.0;
    }
  }

  /// Check if file size is acceptable (max 5MB)
  static bool isFileSizeAcceptable(File file) {
    final sizeInMB = getFileSizeInMB(file);
    return sizeInMB <= 5.0; // Max 5MB
  }

  /// Convert image file to base64 string
  static Future<String?> convertImageToBase64(File imageFile) async {
    try {
      LoggerService.info('Converting image to base64', tag: _tag);

      final base64String = await ImageHelper.imageToBase64Compressed(
        imageFile: imageFile,
        maxWidth: 800,
        maxHeight: 800,
        quality: 85,
      );

      if (base64String != null) {
        LoggerService.success(
          'Image converted to base64 successfully',
          tag: _tag,
        );
        return base64String;
      } else {
        LoggerService.error('Failed to convert image to base64', tag: _tag);
        return null;
      }
    } catch (e) {
      LoggerService.error('Error converting image to base64: $e', tag: _tag);
      return null;
    }
  }
}
