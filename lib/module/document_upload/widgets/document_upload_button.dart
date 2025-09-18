import 'package:flutter/material.dart';
import 'package:limo/module/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/module/document_upload/view_model/document_upload_view_model.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/widgets/shared_button.dart';
import 'package:provider/provider.dart';

class DocumentUploadButton extends StatelessWidget {
  final DocumentUploadPurpose purpose;

  const DocumentUploadButton({super.key, required this.purpose});

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentUploadViewModel>(
      builder: (context, viewModel, child) {
        final isLoading = viewModel.isLoading;
        final hasSelectedDocument = viewModel.hasSelectedImage;

        return SizedBox(
          width: double.infinity,
          child: SharedButton(
            text: 'Upload ${purpose.title}',
            isLoading: isLoading,
            backgroundColor:
                hasSelectedDocument ? context.primary : context.outline,

            foregroundColor:
                hasSelectedDocument ? context.onPrimary : context.disabled,
            onPressed:
                hasSelectedDocument
                    ? () => viewModel.uploadDocument(context, purpose)
                    : null,
          ),
        );
      },
    );
  }
}
