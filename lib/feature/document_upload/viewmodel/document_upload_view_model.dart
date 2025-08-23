import 'package:flutter/foundation.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/feature/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/feature/document_upload/model/document_model.dart';
import 'package:limo/feature/document_upload/services/document_upload_service.dart';

/// ViewModel for managing document upload operations
class DocumentUploadViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  DocumentModel? _selectedDocument;
  final bool _wasCompressed = false;
  final double _originalSizeMB = 0.0;
  final double _finalSizeMB = 0.0;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  DocumentModel? get selectedDocument => _selectedDocument;
  bool get wasCompressed => _wasCompressed;
  double get originalSizeMB => _originalSizeMB;
  double get finalSizeMB => _finalSizeMB;

  /// Pick image from gallery and convert to base64
  Future<void> pickImageAndConvert({
    required DocumentUploadPurpose purpose,
    String? vehiclePlate,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      LoggerService.info(
        'Starting image pick and convert for: ${purpose.title}',
        tag: 'DOCUMENT_UPLOAD_VIEWMODEL',
      );

      final document = await DocumentUploadService.pickImageAndConvert(
        purpose: purpose,
        vehiclePlate: vehiclePlate,
      );

      if (document != null) {
        _selectedDocument = document;

        // Check if compression was applied (this would need to be passed from service)
        // For now, we'll show a generic success message
        _setSuccess(
          'Document selected successfully: ${(document.fileSizeBytes / (1024 * 1024)).toStringAsFixed(2)}MB',
        );

        LoggerService.success(
          'Document selected: ${document.id}',
          tag: 'DOCUMENT_UPLOAD_VIEWMODEL',
        );
      } else {
        _setError('No document selected');
      }
    } catch (e) {
      LoggerService.error(
        'Error picking image: $e',
        tag: 'DOCUMENT_UPLOAD_VIEWMODEL',
      );
      _setError('Failed to select document: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Upload selected document to backend
  Future<void> uploadSelectedDocument(
    AppStateProvider appState, {
    VoidCallback? onSuccess,
  }) async {
    if (_selectedDocument == null) {
      _setError('No document selected for upload');
      return;
    }

    _setLoading(true);
    _clearMessages();

    // Store document reference before clearing
    final documentToUpload = _selectedDocument!;

    try {
      LoggerService.info(
        '📤 Starting upload: ${documentToUpload.purpose.title}',
        tag: 'DOCUMENT_UPLOAD_VIEWMODEL',
      );

      final response = await DocumentUploadService.uploadDocument(
        documentToUpload,
        appState,
      );

      if (response) {
        // Clear selected document after successful upload
        _selectedDocument = null;

        // Create enhanced success message based on document purpose
        String successMessage = documentToUpload.purpose.successMessage;

        // Add profile update info for relevant document types
        if (documentToUpload.purpose == DocumentUploadPurpose.profilePhoto) {
          successMessage =
              'Profile photo uploaded and profile updated successfully!';
        } else if (documentToUpload.purpose ==
            DocumentUploadPurpose.driverLicense) {
          successMessage =
              'Driver license uploaded and profile updated successfully!';
        }

        _setSuccess(successMessage);
        LoggerService.success(
          '✅ Upload completed: ${documentToUpload.purpose.title}',
          tag: 'DOCUMENT_UPLOAD_VIEWMODEL',
        );

        // Call success callback if provided
        onSuccess?.call();
      } else {
        // Use purpose-specific error message for failed upload
        _setError(documentToUpload.purpose.errorMessage);
      }
    } catch (e) {
      LoggerService.error(
        '❌ Upload error: ${documentToUpload.purpose.title} - $e',
        tag: 'DOCUMENT_UPLOAD_VIEWMODEL',
      );
      // Use purpose-specific error message
      _setError(documentToUpload.purpose.errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  /// Clear selected document
  void clearSelectedDocument() {
    _selectedDocument = null;
    _clearMessages();
    notifyListeners();
  }

  /// Get purpose-specific instructions
  List<String> getSpecificInstructions(DocumentUploadPurpose purpose) {
    return purpose.specificInstructions;
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
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_errorMessage == message) clearError();
    });
  }

  void _setSuccess(String message) {
    _successMessage = message;
    _errorMessage = null;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 100), () {
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
