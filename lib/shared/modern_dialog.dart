import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/shared/general_button.dart';
import 'package:soforvarcom/shared/general_text.dart';
import 'package:soforvarcom/shared/general_text_field.dart';

enum DialogType {
  info,
  warning,
  error,
  success,
  confirmation,
  input,
  loading,
}

class ModernDialog extends StatefulWidget {
  final DialogType type;
  final String title;
  final String message;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final String? inputHint;
  final TextInputType? inputType;
  final String? Function(String?)? inputValidator;
  final TextEditingController? inputController;
  final bool isLoading;

  const ModernDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.inputHint,
    this.inputType,
    this.inputValidator,
    this.inputController,
    this.isLoading = false,
  });

  @override
  State<ModernDialog> createState() => _ModernDialogState();
}

class _ModernDialogState extends State<ModernDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.inputController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.inputController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: GeneralConstants.borderRadius,
      ),
      child: Container(
        padding: PaddingConstants.allLarge,
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: GeneralConstants.borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildContent(),
            if (widget.type == DialogType.input) ...[
              const SizedBox(height: 16),
              _buildInput(),
            ],
            const SizedBox(height: 24),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _getTypeColor().withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: widget.type == DialogType.loading
              ? CircularProgressIndicator(
                  color: _getTypeColor(),
                  strokeWidth: 3,
                )
              : Icon(
                  _getTypeIcon(),
                  size: 32,
                  color: _getTypeColor(),
                ),
        ),
        const SizedBox(height: 16),
        GeneralText(
          text: widget.title,
          fontSize: GeneralConstants.fontSizeLarge,
          fontWeight: GeneralConstants.fontWeightBold,
          color: context.onSurface,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        GeneralText(
          text: widget.message,
          fontSize: GeneralConstants.fontSizeSmall,
          fontWeight: GeneralConstants.fontWeightRegular,
          color: context.secondary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContent() {
    // For future use if we need custom content widgets
    return const SizedBox.shrink();
  }

  Widget _buildInput() {
    if (widget.type != DialogType.input) return const SizedBox.shrink();

    return Form(
      key: _formKey,
      child: GeneralTextField(
        controller: _controller,
        hintText: widget.inputHint ?? 'Enter value',
        prefixIcon: Icon(_getInputIcon()),
        keyboardType: widget.inputType ?? TextInputType.text,
        validator: widget.inputValidator,
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        if (widget.primaryButtonText != null)
          SizedBox(
            width: double.infinity,
            height: GeneralConstants.heightMedium,
            child: GeneralButton(
              onPressed: widget.isLoading ? null : () => _handlePrimaryAction(),
              text: widget.isLoading ? 'Loading...' : widget.primaryButtonText!,
              fontSize: GeneralConstants.fontSizeMedium,
              color: _getTypeColor(),
            ),
          ),
        if (widget.secondaryButtonText != null) ...[
          const SizedBox(height: 12),
          GeneralButton(
            onPressed:
                widget.onSecondaryPressed ?? () => Navigator.of(context).pop(),
            text: widget.secondaryButtonText!,
            fontSize: GeneralConstants.fontSizeSmall,
            color: context.surface,
            fontColor: context.secondary,
          ),
        ],
      ],
    );
  }

  void _handlePrimaryAction() {
    if (widget.type == DialogType.input && _formKey.currentState != null) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    if (widget.onPrimaryPressed != null) {
      widget.onPrimaryPressed!();
    } else {
      Navigator.of(context).pop(_controller.text);
    }
  }

  Color _getTypeColor() {
    switch (widget.type) {
      case DialogType.info:
        return const Color(0xFF2196F3); // Blue
      case DialogType.warning:
        return const Color(0xFFFF9800); // Orange
      case DialogType.error:
        return const Color(0xFFF44336); // Red
      case DialogType.success:
        return const Color(0xFF4CAF50); // Green
      case DialogType.confirmation:
        return const Color(0xFF9C27B0); // Purple
      case DialogType.input:
        return const Color(0xFF607D8B); // Blue Grey
      case DialogType.loading:
        return const Color(0xFF00BCD4); // Cyan
    }
  }

  IconData _getTypeIcon() {
    switch (widget.type) {
      case DialogType.info:
        return Icons.info_outline;
      case DialogType.warning:
        return Icons.warning_amber_outlined;
      case DialogType.error:
        return Icons.error_outline;
      case DialogType.success:
        return Icons.check_circle_outline;
      case DialogType.confirmation:
        return Icons.help_outline;
      case DialogType.input:
        return Icons.edit_outlined;
      case DialogType.loading:
        return Icons.hourglass_empty;
    }
  }

  IconData _getInputIcon() {
    switch (widget.inputType) {
      case TextInputType.emailAddress:
        return Icons.email_outlined;
      case TextInputType.phone:
        return Icons.phone_outlined;
      case TextInputType.number:
        return Icons.numbers_outlined;
      case TextInputType.url:
        return Icons.link_outlined;
      default:
        return Icons.text_fields_outlined;
    }
  }
}

// Extension methods for easy usage
extension ModernDialogExtension on BuildContext {
  Future<void> showInfoDialog({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: this,
      builder: (context) => ModernDialog(
        type: DialogType.info,
        title: title,
        message: message,
        primaryButtonText: buttonText ?? 'OK',
        onPrimaryPressed: onPressed,
      ),
    );
  }

  Future<void> showWarningDialog({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: this,
      builder: (context) => ModernDialog(
        type: DialogType.warning,
        title: title,
        message: message,
        primaryButtonText: buttonText ?? 'OK',
        onPrimaryPressed: onPressed,
      ),
    );
  }

  Future<void> showErrorDialog({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: this,
      builder: (context) => ModernDialog(
        type: DialogType.error,
        title: title,
        message: message,
        primaryButtonText: buttonText ?? 'OK',
        onPrimaryPressed: onPressed,
      ),
    );
  }

  Future<void> showSuccessDialog({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: this,
      builder: (context) => ModernDialog(
        type: DialogType.success,
        title: title,
        message: message,
        primaryButtonText: buttonText ?? 'OK',
        onPrimaryPressed: onPressed,
      ),
    );
  }

  Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => ModernDialog(
        type: DialogType.confirmation,
        title: title,
        message: message,
        primaryButtonText: confirmText ?? 'Confirm',
        secondaryButtonText: cancelText ?? 'Cancel',
        onPrimaryPressed: () {
          Navigator.of(context).pop(true);
          onConfirm?.call();
        },
        onSecondaryPressed: () {
          Navigator.of(context).pop(false);
          onCancel?.call();
        },
      ),
    );
  }

  Future<String?> showInputDialog({
    required String title,
    required String message,
    String? inputHint,
    TextInputType? inputType,
    String? Function(String?)? validator,
    String? confirmText,
    String? cancelText,
    bool isLoading = false,
    VoidCallback? onConfirm,
  }) {
    final controller = TextEditingController();

    return showDialog<String>(
      context: this,
      builder: (context) => ModernDialog(
        type: DialogType.input,
        title: title,
        message: message,
        inputHint: inputHint,
        inputType: inputType,
        inputValidator: validator,
        inputController: controller,
        primaryButtonText: confirmText ?? 'Submit',
        secondaryButtonText: cancelText ?? 'Cancel',
        isLoading: isLoading,
        onPrimaryPressed: () {
          Navigator.of(context).pop(controller.text);
          onConfirm?.call();
        },
      ),
    );
  }

  Future<void> showLoadingDialog({
    String? title,
    String? message,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => ModernDialog(
        type: DialogType.loading,
        title: title ?? 'Loading',
        message: message ?? 'Please wait...',
      ),
    );
  }
}
