import 'package:limo/feature/document_upload/enums/document_upload_purpose_enum.dart';

/// Image document model for upload operations
class DocumentModel {
  final String id;
  final DocumentUploadPurpose purpose;
  final String? documentName;
  final String? base64Data;
  final String? fileExtension;
  final int fileSizeBytes;
  final String? vehiclePlate; // Optional for vehicle-related images

  const DocumentModel({
    required this.id,
    required this.purpose,
    this.documentName,
    this.base64Data,
    this.fileExtension,
    required this.fileSizeBytes,
    this.vehiclePlate,
  });

  /// Create image document from file data
  factory DocumentModel.fromFile({
    required DocumentUploadPurpose purpose,
    required String documentName,
    required String base64Data,
    required String fileExtension,
    required int fileSizeBytes,
    String? vehiclePlate,
  }) {
    return DocumentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      purpose: purpose,
      documentName: documentName,
      base64Data: base64Data,
      fileExtension: fileExtension,
      fileSizeBytes: fileSizeBytes,
      vehiclePlate: vehiclePlate,
    );
  }

  /// Create image document from JSON data
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    // For now, default to driverLicense since we only have 2 purposes
    DocumentUploadPurpose purpose = DocumentUploadPurpose.driverLicense;
    final documentType = json['document_type'] as String?;

    if (documentType == 'profile_photo') {
      purpose = DocumentUploadPurpose.profilePhoto;
    }

    return DocumentModel(
      id: json['id'] as String,
      purpose: purpose,
      documentName: json['document_name'] as String?,
      base64Data: json['base64_data'] as String?,
      fileExtension: json['file_extension'] as String?,
      fileSizeBytes: json['file_size_bytes'] as int? ?? 0,
      vehiclePlate: json['vehicle_plate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'document_type': purpose.value,
      'document_name': documentName,
      'base64_data': base64Data,
      'file_extension': fileExtension,
      'file_size_bytes': fileSizeBytes,
      'vehicle_plate': vehiclePlate,
    };
  }

  DocumentModel copyWith({
    String? id,
    DocumentUploadPurpose? purpose,
    String? documentName,
    String? base64Data,
    String? fileExtension,
    int? fileSizeBytes,
    String? vehiclePlate,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      purpose: purpose ?? this.purpose,
      documentName: documentName ?? this.documentName,
      base64Data: base64Data ?? this.base64Data,
      fileExtension: fileExtension ?? this.fileExtension,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
    );
  }

  @override
  String toString() {
    return 'DocumentModel(id: $id, purpose: ${purpose.title}, documentName: $documentName, fileSizeBytes: $fileSizeBytes)';
  }
}
