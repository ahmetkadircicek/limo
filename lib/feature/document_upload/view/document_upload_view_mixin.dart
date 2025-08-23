import 'package:flutter/material.dart';
import 'package:limo/core/constants/image_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/utils/image_helper.dart';
import 'package:limo/feature/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/feature/document_upload/viewmodel/document_upload_view_model.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

/// Mixin for document upload view functionality
mixin DocumentUploadViewMixin<T extends StatefulWidget> on State<T> {
  late DocumentUploadViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<DocumentUploadViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Show image picker dialog
  void _showImagePickerDialog(DocumentUploadPurpose purpose) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: context.paddingM,
                    decoration: BoxDecoration(
                      color: context.onSurface.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library, color: context.primary),
                    title: AppText.body('Choose from Gallery'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromGallery(purpose);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.camera_alt, color: context.primary),
                    title: AppText.body('Take Photo'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromCamera(purpose);
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            ),
          ),
    );
  }

  /// Pick image from gallery
  Future<void> _pickImageFromGallery(DocumentUploadPurpose purpose) async {
    try {
      await viewModel.pickImageAndConvert(purpose: purpose);
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, message: 'Failed to pick image: $e');
      }
    }
  }

  /// Pick image from camera
  Future<void> _pickImageFromCamera(DocumentUploadPurpose purpose) async {
    try {
      await viewModel.pickImageAndConvert(purpose: purpose);
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, message: 'Failed to take photo: $e');
      }
    }
  }

  /// Build upload area with modern design
  Widget buildUploadArea({
    required DocumentUploadPurpose purpose,
    String? vehiclePlate,
    VoidCallback? onTap,
    bool hasSelectedDocument = false,
  }) {
    return GestureDetector(
      onTap: onTap ?? () => _showImagePickerDialog(purpose),
      child: Container(
        decoration: BoxDecoration(
          color:
              hasSelectedDocument
                  ? context.success.withValues(alpha: 0.1)
                  : context.surfaceContainer,
          borderRadius: context.radiusMedium,
        ),
        width: double.infinity,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with background
            Container(
              padding: context.paddingM,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: context.radiusMedium,
              ),
              child: Image.asset(
                hasSelectedDocument ? ImageAssets.success : ImageAssets.addFile,
                width: 128,
                height: 128,
              ),
            ),

            // Main text - short and clear
            AppText.heading(
              hasSelectedDocument ? 'Successfully selected!' : 'Tap to select',
              textAlign: TextAlign.center,
              color:
                  hasSelectedDocument
                      ? context.success
                      : context.onSurface.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  /// Build selected document preview
  Widget buildSelectedDocumentPreview({
    required DocumentUploadPurpose purpose,
    String? vehiclePlate,
    VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.success.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: context.success.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image preview
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              color: context.success.withValues(alpha: 0.05),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child:
                  viewModel.selectedDocument != null
                      ? ImageHelper.base64ToImage(
                        base64String:
                            viewModel.selectedDocument!.base64Data ?? '',
                        fit: BoxFit.cover,
                        placeholder: Container(
                          color: context.surfaceContainer,
                          child: Icon(
                            Icons.image,
                            size: 48,
                            color: context.onSurface.withValues(alpha: 0.3),
                          ),
                        ),
                      )
                      : Container(
                        color: context.surfaceContainer,
                        child: Icon(
                          Icons.image,
                          size: 48,
                          color: context.onSurface.withValues(alpha: 0.3),
                        ),
                      ),
            ),
          ),

          // Action area
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: context.success, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppText.body(
                        '${purpose.title} Selected',
                        fontWeight: FontWeight.w600,
                        color: context.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppText.body(
                  'Tap to change or override this document',
                  color: context.onSurface.withValues(alpha: 0.7),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.secondary(
                    'Change Document',
                    onPressed: onTap ?? () => _showImagePickerDialog(purpose),
                    icon: Icons.edit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build action buttons
  Widget buildActionButtons({
    required bool hasSelectedDocument,
    required VoidCallback onUpload,
  }) {
    return SizedBox(
      width: double.infinity,
      child: AppButton.primary(
        'Upload Document',
        onPressed: hasSelectedDocument ? onUpload : null,
        isLoading: viewModel.isLoading,
        icon: hasSelectedDocument ? Icons.upload : null,
      ),
    );
  }

  /// Build purpose-specific instructions
  Widget buildPurposeSpecificInstructions(DocumentUploadPurpose purpose) {
    final instructions = purpose.specificInstructions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.heading('Specific Instructions', color: context.onSurface),
        const SizedBox(height: 16),
        ...instructions.map(
          (instruction) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: context.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AppText.caption('•', color: context.onPrimary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: AppText.body(instruction)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
