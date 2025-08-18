import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_components.dart';

class DocumentUploadView extends StatefulWidget {
  final String
  documentType; // 'insurance', 'license', 'inspection', 'driver_license', etc.
  final String? vehiclePlate; // Optional for non-vehicle documents
  final String? title; // Custom title override
  final String? description; // Custom description override

  const DocumentUploadView({
    super.key,
    required this.documentType,
    this.vehiclePlate,
    this.title,
    this.description,
  });

  @override
  State<DocumentUploadView> createState() => _DocumentUploadViewState();
}

class _DocumentUploadViewState extends State<DocumentUploadView> {
  File? _selectedPdfFile;
  bool _isUploading = false;
  String _verificationStatus = 'pending'; // pending, approved, rejected

  String get _documentTypeTitle {
    if (widget.title != null) return widget.title!;

    switch (widget.documentType) {
      case 'insurance':
        return 'Insurance Document';
      case 'license':
        return 'Vehicle Registration';
      case 'inspection':
        return 'Vehicle Inspection';
      case 'driver_license':
        return 'Driver License';
      default:
        return 'Document';
    }
  }

  String get _documentTypeDescription {
    if (widget.description != null) return widget.description!;

    switch (widget.documentType) {
      case 'insurance':
        return 'Upload your vehicle insurance documents for verification';
      case 'license':
        return 'Upload your vehicle registration documents for verification';
      case 'inspection':
        return 'Upload your vehicle inspection documents for verification';
      case 'driver_license':
        return 'Upload your driver license for verification';
      default:
        return 'Upload your documents for verification';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      appBar: AppBar(
        title: AppText.body('Document Upload', fontWeight: FontWeight.w600),
        backgroundColor: context.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: context.onSurface),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Upload Section
                  _buildUploadSection(),
                  const SizedBox(height: 24),

                  // Instructions Section
                  _buildInstructionsSection(),
                  const SizedBox(height: 24),

                  // Action Buttons
                  if (_verificationStatus == 'pending' &&
                      _selectedPdfFile != null)
                    _buildSubmitButton(),
                  if (_verificationStatus == 'approved') _buildApprovedCard(),
                  if (_verificationStatus == 'rejected') _buildRejectedCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.zero,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.body(
            _documentTypeTitle,
            fontWeight: FontWeight.w600,
            color: context.onSurface,
          ),
          const SizedBox(height: 8),
          AppText.caption(
            _documentTypeDescription,
            color: context.onSurface.withValues(alpha: 0.7),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.body(
            'Quick Guide',
            fontWeight: FontWeight.w600,
            color: context.onSurface,
          ),
          const SizedBox(height: 16),
          _buildInstructionItem('1', 'Select PDF file'),
          const SizedBox(height: 12),
          _buildInstructionItem('2', 'Verify content is readable'),
          const SizedBox(height: 12),
          _buildInstructionItem('3', 'Upload for review'),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String number, String text) {
    return Row(
      children: [
        AppText.body(
          '$number.',
          fontWeight: FontWeight.w600,
          color: context.primary,
        ),
        const SizedBox(width: 16),
        Expanded(child: AppText.body(text, color: context.onSurface)),
      ],
    );
  }

  Widget _buildUploadSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: context.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: AppText.body(
              'Upload PDF',
              fontWeight: FontWeight.w600,
              color: context.onSurface,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Upload Area
          _buildUploadArea(),

          const SizedBox(height: 16),

          // Upload Button
          SizedBox(
            width: double.infinity,
            child: AppButton.primary(
              'Upload Document',
              onPressed: _selectedPdfFile != null ? _uploadPdf : null,
              isLoading: _isUploading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _selectPdfFile,
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          color: context.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                _selectedPdfFile != null
                    ? context.success.withValues(alpha: 0.3)
                    : context.onSurface.withValues(alpha: 0.15),
            width: 1.5,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child:
            _selectedPdfFile != null
                ? _buildSelectedPdfDisplay()
                : _buildEmptyUploadState(),
      ),
    );
  }

  Widget _buildEmptyUploadState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Icon(
            Icons.cloud_upload_outlined,
            size: 32,
            color: context.primary,
          ),
        ),
        const SizedBox(height: 12),
        AppText.body(
          'Select PDF file',
          color: context.onSurface,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 4),
        AppText.caption(
          'Tap to browse',
          color: context.onSurface.withValues(alpha: 0.6),
        ),
      ],
    );
  }

  Widget _buildSelectedPdfDisplay() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(Icons.picture_as_pdf, size: 28, color: context.success),
          ),
          const SizedBox(height: 12),
          AppText.body(
            _selectedPdfFile!.path.split('/').last,
            color: context.onSurface,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          AppText.caption('PDF selected', color: context.success),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: AppButton.primary(
        'Submit for Verification',
        onPressed: _isUploading ? null : _submitForVerification,
        isLoading: _isUploading,
      ),
    );
  }

  Widget _buildApprovedCard() {
    return Container(
      padding: PaddingConstants.allL,
      decoration: BoxDecoration(
        color: context.success.withValues(alpha: 0.1),
        borderRadius: GeneralConstants.borderRadius,
        border: Border.all(color: context.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: context.success, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.heading(
                  'Verification Complete!',
                  color: context.success,
                ),
                const SizedBox(height: 8),
                AppText.body(
                  'Your $_documentTypeTitle has been verified successfully.',
                  color: context.success.withValues(alpha: 0.8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedCard() {
    return Container(
      padding: PaddingConstants.allL,
      decoration: BoxDecoration(
        color: context.error.withValues(alpha: 0.1),
        borderRadius: GeneralConstants.borderRadius,
        border: Border.all(color: context.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: context.error, size: 32),
              const SizedBox(width: 16),
              AppText.heading('Verification Failed', color: context.error),
            ],
          ),
          const SizedBox(height: 16),
          AppText.body(
            'Your documents were not approved. Please ensure:',
            color: context.error.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 12),
          _buildRejectionReason('• Images are clear and readable'),
          _buildRejectionReason('• All text, numbers and dates are visible'),
          _buildRejectionReason('• Documents are not expired'),
          _buildRejectionReason('• Both sides are uploaded'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AppButton.primary(
              'Try Again',
              onPressed: () {
                setState(() {
                  _verificationStatus = 'pending';
                  _selectedPdfFile = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionReason(String reason) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppText.body(reason, color: context.error.withValues(alpha: 0.7)),
    );
  }

  Future<void> _submitForVerification() async {
    if (_selectedPdfFile == null) {
      _showErrorSnackBar('Please upload a PDF file first');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // API call not implemented yet
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _verificationStatus = 'pending';
      });
      _showSuccessSnackBar('Verification not implemented yet');
    } catch (e) {
      _showErrorSnackBar('Failed to submit verification: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    AppSnackbar.showSuccess(context, message: message);
  }

  void _showErrorSnackBar(String message) {
    AppSnackbar.showError(context, message: message);
  }

  Future<void> _selectPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedPdfFile = File(result.files.first.path!);
        });
        _showSuccessSnackBar('PDF file selected successfully!');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to select PDF file: $e');
    }
  }

  Future<void> _uploadPdf() async {
    if (_selectedPdfFile == null) {
      _showErrorSnackBar('Please select a PDF file first');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // PDF upload not implemented yet
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _verificationStatus = 'pending';
      });

      _showSuccessSnackBar(
        'PDF uploaded successfully! Verification in progress.',
      );
    } catch (e) {
      _showErrorSnackBar('Failed to upload PDF: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }
}
