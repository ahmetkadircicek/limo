import 'package:flutter/material.dart';

/// Enum defining the purpose of document upload
/// This determines the page content, service calls, and behavior
enum DocumentUploadPurpose {
  // Profile related documents
  profilePhoto('profile_photo', 'Profile Photo', 'Upload a profile photo'),

  // Driver related documents
  driverLicense(
    'driver_license',
    'Driver License',
    'Upload your driver license for verification',
  );

  const DocumentUploadPurpose(this.value, this.title, this.description);

  final String value;
  final String title;
  final String description;

  /// Get appropriate icon for the document type
  IconData get icon {
    switch (this) {
      case DocumentUploadPurpose.profilePhoto:
        return Icons.person;
      case DocumentUploadPurpose.driverLicense:
        return Icons.credit_card;
    }
  }

  /// Get success message for this document type
  String get successMessage {
    switch (this) {
      case DocumentUploadPurpose.profilePhoto:
        return 'Profile photo uploaded successfully!';
      case DocumentUploadPurpose.driverLicense:
        return 'Driver license uploaded successfully!';
    }
  }

  /// Get error message for this document type
  String get errorMessage {
    switch (this) {
      case DocumentUploadPurpose.profilePhoto:
        return 'Failed to upload profile photo';
      case DocumentUploadPurpose.driverLicense:
        return 'Failed to upload driver license';
    }
  }

  /// Get specific instructions for this document type
  List<String> get specificInstructions {
    switch (this) {
      case DocumentUploadPurpose.profilePhoto:
        return [
          'Use a clear, recent photo',
          'Ensure good lighting',
          'Face should be clearly visible',
        ];
      case DocumentUploadPurpose.driverLicense:
        return [
          'Ensure all text is readable',
          'Include front and back if needed',
          'Check expiration date is visible',
        ];
    }
  }
}
