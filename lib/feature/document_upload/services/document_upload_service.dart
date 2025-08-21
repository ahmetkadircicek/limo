import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:limo/core/models/user_model.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/feature/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/feature/document_upload/model/document_model.dart';
import 'package:limo/feature/profile/services/user_update_service.dart';

/// Service for handling document upload operations
class DocumentUploadService {
  static const String _tag = 'DOCUMENT_UPLOAD_SERVICE';
  static final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery and convert to base64
  static Future<DocumentModel?> pickImageAndConvert({
    required DocumentUploadPurpose purpose,
    String? vehiclePlate,
  }) async {
    try {
      LoggerService.info('📱 Starting picker: ${purpose.title}', tag: _tag);

      // Get validation rules for this purpose
      final maxSizeMB = _getMaxSizeMB(purpose);
      final allowedFormats = _getAllowedFormats(purpose);

      LoggerService.info(
        '📋 Validation: max ${maxSizeMB.toStringAsFixed(1)}MB | formats: ${allowedFormats.join(', ').toUpperCase()}',
        tag: _tag,
      );

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: _getMaxWidth(purpose).toDouble(),
        maxHeight: _getMaxHeight(purpose).toDouble(),
        imageQuality: _getImageQuality(purpose),
      );

      if (image == null) {
        LoggerService.info('❌ No image selected', tag: _tag);
        return null;
      }

      LoggerService.info('🖼️ Image selected: ${image.name}', tag: _tag);

      // Process image: convert to base64 and compress if needed
      LoggerService.info('🔄 Processing image...', tag: _tag);

      final processedImageData = await _processImageForUpload(
        image.path,
        purpose,
        maxSizeMB,
        allowedFormats,
      );

      if (processedImageData == null) {
        throw Exception('Failed to process image for upload');
      }

      // Create document model with processed data
      final document = DocumentModel.fromFile(
        purpose: purpose,
        documentName: image.name,
        base64Data: processedImageData.base64Data,
        fileExtension: processedImageData.fileExtension,
        fileSizeBytes: processedImageData.fileSizeBytes,
        vehiclePlate: vehiclePlate,
      );

      LoggerService.success(
        '✅ Image processed: ${document.id} | ${(document.fileSizeBytes / (1024 * 1024)).toStringAsFixed(2)}MB',
        tag: _tag,
      );
      return document;
    } catch (e) {
      LoggerService.error('Error picking and converting image: $e', tag: _tag);
      rethrow;
    }
  }

  /// Process image for upload: convert to base64 and compress if needed
  static Future<_ProcessedImageData?> _processImageForUpload(
    String imagePath,
    DocumentUploadPurpose purpose,
    double maxSizeMB,
    List<String> allowedFormats,
  ) async {
    try {
      final File imageFile = File(imagePath);

      // Get file extension and validate
      final String fileExtension = imagePath.split('.').last.toLowerCase();
      if (!_isValidImageExtension(fileExtension, allowedFormats)) {
        LoggerService.error(
          'Invalid file extension: $fileExtension',
          tag: _tag,
        );
        throw Exception(
          'Invalid file format. Allowed formats: ${allowedFormats.join(', ').toUpperCase()}',
        );
      }

      // Check file size
      final int fileSizeBytes = await imageFile.length();
      final double fileSizeMB = fileSizeBytes / (1024 * 1024);

      LoggerService.info(
        'Original image size: ${fileSizeMB.toStringAsFixed(2)}MB',
        tag: _tag,
      );

      if (fileSizeMB > maxSizeMB) {
        LoggerService.warning(
          'Image size ${fileSizeMB.toStringAsFixed(2)}MB exceeds limit ${maxSizeMB.toStringAsFixed(1)}MB',
          tag: _tag,
        );
        throw Exception(
          'Image size ${fileSizeMB.toStringAsFixed(2)}MB exceeds maximum allowed size ${maxSizeMB.toStringAsFixed(1)}MB',
        );
      }

      LoggerService.info(
        '✅ Size OK: ${fileSizeMB.toStringAsFixed(2)}MB ≤ ${maxSizeMB.toStringAsFixed(1)}MB',
        tag: _tag,
      );

      // Convert to base64
      final String base64Data = await _convertImageToBase64(imageFile);

      return _ProcessedImageData(
        base64Data: base64Data,
        fileExtension: fileExtension,
        fileSizeBytes: fileSizeBytes,
      );
    } catch (e) {
      LoggerService.error('Error processing image: $e', tag: _tag);
      rethrow;
    }
  }

  /// Convert image file to base64 string
  static Future<String> _convertImageToBase64(File imageFile) async {
    try {
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64String = base64Encode(imageBytes);
      return base64String;
    } catch (e) {
      LoggerService.error('Error converting image to base64: $e', tag: _tag);
      rethrow;
    }
  }

  /// Validate file extension
  static bool _isValidImageExtension(
    String extension,
    List<String> allowedFormats,
  ) {
    return allowedFormats.contains(extension.toLowerCase());
  }

  /// Get max size in MB for the purpose
  static double _getMaxSizeMB(DocumentUploadPurpose purpose) {
    switch (purpose) {
      case DocumentUploadPurpose.profilePhoto:
        return 5.0;
      case DocumentUploadPurpose.driverLicense:
        return 10.0;
    }
  }

  /// Get allowed formats for the purpose
  static List<String> _getAllowedFormats(DocumentUploadPurpose purpose) {
    switch (purpose) {
      case DocumentUploadPurpose.profilePhoto:
        return ['jpg', 'jpeg', 'png', 'heif', 'heic'];
      case DocumentUploadPurpose.driverLicense:
        return ['jpg', 'jpeg', 'png', 'heif', 'heic'];
    }
  }

  /// Get max width for the purpose
  static int _getMaxWidth(DocumentUploadPurpose purpose) {
    switch (purpose) {
      case DocumentUploadPurpose.profilePhoto:
        return 400;
      case DocumentUploadPurpose.driverLicense:
        return 800;
    }
  }

  /// Get max height for the purpose
  static int _getMaxHeight(DocumentUploadPurpose purpose) {
    switch (purpose) {
      case DocumentUploadPurpose.profilePhoto:
        return 400;
      case DocumentUploadPurpose.driverLicense:
        return 600;
    }
  }

  /// Get image quality for the purpose
  static int _getImageQuality(DocumentUploadPurpose purpose) {
    switch (purpose) {
      case DocumentUploadPurpose.profilePhoto:
        return 85;
      case DocumentUploadPurpose.driverLicense:
        return 90;
    }
  }

  /// Upload document to backend using UserUpdateService
  static Future<Map<String, dynamic>?> uploadDocument(
    DocumentModel document,
    AppStateProvider appState,
  ) async {
    try {
      LoggerService.info(
        '📤 Starting upload: ${document.purpose.title} (${document.id})',
        tag: _tag,
      );

      LoggerService.info(
        '🔄 Using UserUpdateService for ${document.purpose.title}',
        tag: _tag,
      );

      // Get current user from AppState
      final currentUser = appState.currentUser;

      if (currentUser == null) {
        throw Exception('No current user found for profile update');
      }

      // Create updated user model based on document purpose
      UserModel updatedUser;
      switch (document.purpose) {
        case DocumentUploadPurpose.profilePhoto:
          updatedUser = currentUser.copyWith(userPhoto: document.base64Data);
          break;
        case DocumentUploadPurpose.driverLicense:
          updatedUser = currentUser.copyWith(
            driverLicense: document.base64Data,
            approved: false, // Set to pending
          );
          break;
      }

      LoggerService.info(
        '📊 Upload data: ${document.fileExtension?.toUpperCase()} | ${(document.fileSizeBytes / (1024 * 1024)).toStringAsFixed(2)}MB',
        tag: _tag,
      );

      // Use UserUpdateService instead of direct API call
      final response = await UserUpdateService.updateUser(updatedUser);

      if (response != null) {
        // Update local AppState
        appState.updateCurrentUser(updatedUser);

        LoggerService.success(
          '✅ Upload successful: ${document.purpose.title} via UserUpdateService',
          tag: _tag,
        );
      } else {
        throw Exception('Failed to update user profile via UserUpdateService');
      }

      return response;
    } catch (e) {
      LoggerService.error(
        '❌ Upload failed: ${document.purpose.title} - $e',
        tag: _tag,
      );
      rethrow;
    }
  }
}

/// Data class for processed image information
class _ProcessedImageData {
  final String base64Data;
  final String fileExtension;
  final int fileSizeBytes;

  _ProcessedImageData({
    required this.base64Data,
    required this.fileExtension,
    required this.fileSizeBytes,
  });
}
