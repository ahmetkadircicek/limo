import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:limo/core/services/user_service.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/module/document_upload/enums/document_upload_purpose_enum.dart';

/// ViewModel for managing document upload operations
class DocumentUploadViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  String? _selectedImageBase64;
  static final ImagePicker _picker = ImagePicker();

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get selectedImageBase64 => _selectedImageBase64;
  bool get hasSelectedImage => _selectedImageBase64 != null;

  /// Pick image and convert to base64 - Üst kısımda kullanılır
  Future<void> pickImage() async {
    _setLoading(true);
    _clearMessages();

    try {
      LoggerService.info(
        'Starting image pick',
        tag: 'DOCUMENT_UPLOAD_VIEWMODEL',
      );

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) {
        LoggerService.info(
          'No image selected',
          tag: 'DOCUMENT_UPLOAD_VIEWMODEL',
        );
        return;
      }

      final file = File(image.path);
      final base64Data = await _convertToBase64(file);

      if (base64Data != null) {
        _selectedImageBase64 = base64Data;
        _setSuccess('Image selected successfully');
        LoggerService.success(
          'Image selected',
          tag: 'DOCUMENT_UPLOAD_VIEWMODEL',
        );
      } else {
        _setError('Failed to convert image');
      }
    } catch (e) {
      LoggerService.error(
        'Error picking image: $e',
        tag: 'DOCUMENT_UPLOAD_VIEWMODEL',
      );
      _setError('Failed to select image: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Convert file to base64
  Future<String?> _convertToBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      LoggerService.error(
        'Error converting to base64: $e',
        tag: 'DOCUMENT_UPLOAD_VIEWMODEL',
      );
      return null;
    }
  }

  Future<void> uploadDocument(
    BuildContext context,
    DocumentUploadPurpose purpose,
  ) async {
    if (_selectedImageBase64 == null) {
      _setError('No image selected for upload');
      return;
    }

    _setLoading(true);
    _clearMessages();

    try {
      bool success;

      switch (purpose.serviceType) {
        case UploadServiceType.userPhoto:
          success = await UserService.updateUser(
            context,
            userPhoto: _selectedImageBase64,
          );
          break;
        case UploadServiceType.driverLicense:
          success = await UserService.updateUser(
            context,
            driverLicence: _selectedImageBase64,
          );
          break;
        default:
          throw Exception('Invalid service type: ${purpose.serviceType}');
      }

      if (success) {
        _setSuccess('${purpose.title} uploaded successfully!');
        _selectedImageBase64 = null;
      } else {
        _setError('Failed to upload ${purpose.title}');
      }
    } catch (e) {
      _setError('Failed to upload ${purpose.title}: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Clear selected image
  void clearSelectedImage() {
    _selectedImageBase64 = null;
    _clearMessages();
    notifyListeners();
  }

  // Private methods for state management
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _successMessage = null;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      if (_errorMessage == message) clearError();
    });
  }

  void _setSuccess(String message) {
    _successMessage = message;
    _errorMessage = null;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      if (_successMessage == message) clearSuccess();
    });
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }
}
