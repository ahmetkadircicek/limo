import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:limo/shared/constants/widget_constants.dart';

class SharedTextField extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: WidgetConstants.formFieldHeight,
      child: TextFormField(
        controller: controller,
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
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          floatingLabelBehavior:
              hint != null && hint!.isNotEmpty
                  ? FloatingLabelBehavior.always
                  : FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}
