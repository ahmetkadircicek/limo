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
      appBar: AppBar(
        title: AppText.body(
          widget.title ?? 'Upload ${widget.purpose.title}',
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: context.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: context.onSurface),
        centerTitle: true,
      ),
      body: Consumer2<DocumentUploadViewModel, AppStateProvider>(
        builder: (context, viewModel, appState, child) {
          // Show messages using AppSnackbar
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (viewModel.errorMessage != null &&
                viewModel.errorMessage!.isNotEmpty) {
              context.showErrorTopSnackbar(viewModel.errorMessage!);
              viewModel.clearError();
            }
            if (viewModel.successMessage != null &&
                viewModel.successMessage!.isNotEmpty) {
              context.showSuccessTopSnackbar(viewModel.successMessage!);
              viewModel.clearSuccess();
            }
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upload Section
                _buildUploadSection(viewModel),
                const SizedBox(height: 24),

                // Info Section (only show when no document selected)
                if (viewModel.selectedDocument == null) ...[
                  _buildInfoSection(),
                  const SizedBox(height: 24),
                ],

                // Status Section (only show when document selected)
                if (viewModel.selectedDocument != null) ...[
                  _buildStatusSection(viewModel),
                  const SizedBox(height: 24),
                ],

                // Action Buttons
                _buildActionButtonsSection(viewModel, appState),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build upload section
  Widget _buildUploadSection(DocumentUploadViewModel viewModel) {
    return AppCard.primary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simple header
          Row(
            children: [
              Icon(widget.purpose.icon, color: context.primary, size: 24),
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
        ],
      ),
    );
  }

  /// Build info section with helpful tips
  Widget _buildInfoSection() {
    return AppCard.tertiary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: context.primary, size: 20),
              const SizedBox(width: 12),
              AppText.body(
                'Upload Requirements',
                fontWeight: FontWeight.w600,
                color: context.onSurface,
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppText.body(
            '• Clear image, max 5MB',
            color: context.onSurface.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 8),
          AppText.body(
            '• JPG, PNG, WebP supported',
            color: context.onSurface.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }

  /// Build status section for selected document
  Widget _buildStatusSection(DocumentUploadViewModel viewModel) {
    return AppCard.secondary(
      child: Row(
        children: [
          Icon(Icons.check_circle, color: context.success, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: AppText.body(
              'Document ready for upload',
              color: context.success,
            ),
          ),
        ],
      ),
    );
  }

  /// Build action buttons section
  Widget _buildActionButtonsSection(
    DocumentUploadViewModel viewModel,
    AppStateProvider appState,
  ) {
    return buildActionButtons(
      hasSelectedDocument: viewModel.selectedDocument != null,
      onUpload: () => _uploadDocument(appState),
    );
  }

  /// Upload selected document
  void _uploadDocument(AppStateProvider appState) {
    viewModel.uploadSelectedDocument(
      appState,
      onSuccess: () {
        // Navigate back after successful upload
        Navigator.of(context).pop();
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
