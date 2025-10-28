import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/widget_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';

class SharedTextField extends StatelessWidget {
  const SharedTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.textInputAction,
    this.focusNode,
    this.maxLength,
    this.readOnly = false,
    this.onTap,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.initialValue,
    this.onFieldSubmitted,
    this.isRequired = false,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final int? maxLength;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? prefix;
  final Widget? suffix;
  final int maxLines;
  final String? initialValue;
  final ValueChanged<String>? onFieldSubmitted;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxLines > 1 ? null : WidgetConstants.formFieldHeight,
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        enabled: enabled,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        validator: validator,
        textInputAction: textInputAction,
        focusNode: focusNode,
        maxLength: maxLength,
        readOnly: readOnly,
        onTap: onTap,
        cursorColor: context.primary,
        showCursor: true,
        maxLines: maxLines,
        onFieldSubmitted: onFieldSubmitted,
        style: context.callout,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          constraints: const BoxConstraints(
            minHeight: WidgetConstants.formFieldHeight,
          ),
          isCollapsed: true,
          labelText: isRequired ? null : label,
          label: isRequired ? _requiredLabel(context, label) : null,
          hintText: hint ?? 'Select $label',
          hintStyle: context.callout,
          prefixIcon: prefix,
          suffixIcon: suffix,
          contentPadding: PaddingConstants.all16,
          counterText: '',
        ),
      ),
    );
  }
}

Widget _requiredLabel(BuildContext context, String text) {
  return RichText(
    text: TextSpan(
      style: context.callout,
      children: [
        TextSpan(text: text),
        TextSpan(text: '*', style: context.body.copyWith(color: context.error)),
      ],
    ),
  );
}
