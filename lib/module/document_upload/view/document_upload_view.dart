import 'package:flutter/material.dart';
import 'package:limo/module/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/module/document_upload/view_model/document_upload_view_model.dart';
import 'package:limo/module/document_upload/widgets/document_upload_area.dart';
import 'package:limo/module/document_upload/widgets/document_upload_button.dart';
import 'package:limo/module/document_upload/widgets/document_upload_header.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/widgets/shared_app_bar.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/widgets/shared_info.dart';
import 'package:provider/provider.dart';

class DocumentUploadView extends StatelessWidget {
  final DocumentUploadPurpose purpose;

  const DocumentUploadView({super.key, required this.purpose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(title: purpose.title),
      body: Consumer<DocumentUploadViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: PaddingConstants.all20,
            child: SharedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: PaddingConstants.p20,
                children: [
                  DocumentUploadHeader(title: purpose.title),
                  DocumentUploadArea(purpose: purpose),
                  _buildInfoStatus(viewModel, purpose),
                  DocumentUploadButton(purpose: purpose),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: context.surfaceContainer,
    );
  }

  Widget _buildInfoStatus(
    DocumentUploadViewModel viewModel,
    DocumentUploadPurpose purpose,
  ) {
    if (viewModel.errorMessage != null) {
      return SharedInfo(
        icon: Icons.error,
        label: 'Error',
        value: viewModel.errorMessage!,
      );
    } else if (viewModel.successMessage != null) {
      return SharedInfo(
        icon: Icons.check_circle,
        label: 'Success',
        value: viewModel.successMessage!,
      );
    } else if (!viewModel.hasSelectedImage) {
      return SharedInfo(
        icon: Icons.info,
        label: 'Info',
        value: purpose.description,
      );
    } else {
      return SharedInfo(
        icon: Icons.check_circle_outline,
        label: 'Ready',
        value: 'Document successfully selected. Click upload.',
      );
    }
  }
}
