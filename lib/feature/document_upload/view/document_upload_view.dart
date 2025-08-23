import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/feature/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/feature/document_upload/view/document_upload_view_mixin.dart';
import 'package:limo/feature/document_upload/viewmodel/document_upload_view_model.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

/// Main document upload view for handling various document types
class DocumentUploadView extends StatefulWidget {
  final DocumentUploadPurpose purpose;
  final String? vehiclePlate;
  final String? title;
  final String? description;

  const DocumentUploadView({
    super.key,
    required this.purpose,
    this.vehiclePlate,
    this.title,
    this.description,
  });

  @override
  State<DocumentUploadView> createState() => _DocumentUploadViewState();
}

class _DocumentUploadViewState extends State<DocumentUploadView>
    with DocumentUploadViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      appBar: AppAppBar.secondary(
        title: widget.title ?? 'Upload ${widget.purpose.title}',
      ),
      body: Consumer2<DocumentUploadViewModel, AppStateProvider>(
        builder: (context, viewModel, appState, child) {
          // Show messages using AppSnackbar
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (viewModel.errorMessage != null &&
                viewModel.errorMessage!.isNotEmpty) {
              AppSnackbar.showError(context, message: viewModel.errorMessage!);
              viewModel.clearError();
            }
            if (viewModel.successMessage != null &&
                viewModel.successMessage!.isNotEmpty) {
              AppSnackbar.showSuccess(
                context,
                message: viewModel.successMessage!,
              );
              viewModel.clearSuccess();
            }
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upload Section (now includes upload button and info/status)
                _buildUploadSection(viewModel, appState),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build upload section with upload button inside card
  Widget _buildUploadSection(
    DocumentUploadViewModel viewModel,
    AppStateProvider appState,
  ) {
    return AppCard.primary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simple header
          Row(
            children: [
              Icon(Icons.upload, color: context.primary, size: 24),
              const SizedBox(width: 12),
              AppText.body(
                'Upload ${widget.purpose.title}',
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Upload area
          buildUploadArea(
            purpose: widget.purpose,
            vehiclePlate: widget.vehiclePlate,
            onTap: () => _pickDocumentImage(widget.purpose),
            hasSelectedDocument: viewModel.selectedDocument != null,
          ),
          const SizedBox(height: 20),

          // Info/Status message above upload button
          if (viewModel.selectedDocument == null)
            AppInfo.info(
              message:
                  'Please select a document to upload. The document should be clearly readable.',
            )
          else
            AppInfo.success(
              message:
                  'Document successfully selected. After uploading to the system, the approval process will be initiated.',
            ),
          const SizedBox(height: 20),

          // Upload button inside card
          SizedBox(
            width: double.infinity,
            child: AppButton.primary(
              'Upload Document',
              onPressed:
                  viewModel.selectedDocument != null
                      ? () => _uploadDocument(appState)
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  /// Upload selected document
  void _uploadDocument(AppStateProvider appState) {
    viewModel.uploadSelectedDocument(
      appState,
      onSuccess: () {
        // Navigate back after successful upload with success result
        Navigator.of(context).pop(true);
      },
    );
  }

  /// Pick document image from gallery
  void _pickDocumentImage(DocumentUploadPurpose purpose) {
    viewModel.pickImageAndConvert(
      purpose: purpose,
      vehiclePlate: widget.vehiclePlate,
    );
  }
}
