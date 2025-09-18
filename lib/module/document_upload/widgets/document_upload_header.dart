import 'package:flutter/material.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';

class DocumentUploadHeader extends StatelessWidget {
  final String title;

  const DocumentUploadHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: PaddingConstants.p12,
      children: [
        Icon(Icons.upload, color: context.primary, size: 24),
        Text('Upload $title', style: context.body),
      ],
    );
  }
}
