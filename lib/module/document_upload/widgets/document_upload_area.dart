import 'package:flutter/material.dart';
import 'package:limo/module/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/module/document_upload/view_model/document_upload_view_model.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/radius_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:provider/provider.dart';

class DocumentUploadArea extends StatelessWidget {
  final DocumentUploadPurpose purpose;

  const DocumentUploadArea({super.key, required this.purpose});

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentUploadViewModel>(
      builder: (context, viewModel, child) {
        final hasSelectedDocument = viewModel.hasSelectedImage;

        void onTap() {
          viewModel.pickImage();
        }

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: PaddingConstants.all20,
            decoration: BoxDecoration(
              color:
                  hasSelectedDocument
                      ? context.surface
                      : context.surfaceContainer,
              border: Border.all(
                color: hasSelectedDocument ? context.primary : context.outline,
                width: 2,
              ),
              borderRadius: RadiusConstants.standard,
            ),
            child: Column(
              spacing: PaddingConstants.p8,
              children: [
                Icon(
                  hasSelectedDocument ? Icons.check_circle : Icons.upload_file,
                  color:
                      hasSelectedDocument
                          ? context.primary
                          : context.onSurfaceVariant,
                  size: 48,
                ),
                Text(
                  hasSelectedDocument
                      ? '${purpose.title} Selected'
                      : 'Tap to select ${purpose.title.toLowerCase()}',
                  style: context.body.copyWith(
                    color:
                        hasSelectedDocument
                            ? context.primary
                            : context.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
