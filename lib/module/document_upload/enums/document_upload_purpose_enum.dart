import 'package:flutter/material.dart';

import '../viewmodel/document_upload_view_model.dart';

enum DocumentUploadPurpose {
  profilePhoto(
    title: 'Profile Photo',
    description: 'Please select a clear profile photo.',
    serviceType: UploadServiceType.userPhoto,
  ),
  driverLicense(
    title: 'Driver License',
    description: 'Please select a clear image of your driver license.',
    serviceType: UploadServiceType.driverLicense,
  ),
  carRegistration(
    title: 'Car Registration',
    description: 'Upload your car registration document.',
    serviceType: UploadServiceType.carDocument,
  );

  final String title;
  final String description;
  final UploadServiceType serviceType;

  const DocumentUploadPurpose({
    required this.title,
    required this.description,
    required this.serviceType,
  });
}

enum UploadServiceType { userPhoto, driverLicense, carDocument }

extension DocumentUploadPurposeExtension on DocumentUploadPurpose {
  void onTap(DocumentUploadViewModel viewModel) {
    switch (this) {
      case DocumentUploadPurpose.profilePhoto:
      case DocumentUploadPurpose.driverLicense:
      case DocumentUploadPurpose.carRegistration:
        viewModel.pickImage();
    }
  }

  Future<void> upload(
    DocumentUploadViewModel viewModel,
    BuildContext context,
  ) async {
    await viewModel.uploadDocument(context, this);
  }
}
