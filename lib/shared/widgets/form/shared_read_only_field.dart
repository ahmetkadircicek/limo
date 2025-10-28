import 'package:flutter/material.dart';
import 'package:limo/shared/constants/widget_constants.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';

class SharedReadOnlyField extends StatelessWidget {
  const SharedReadOnlyField({
    super.key,
    required this.label,
    this.value,
    this.placeholder,
    this.leading,
    this.trailing,
    this.isRequired = false,
  });

  final String label;
  final String? value;
  final String? placeholder;
  final Widget? leading;
  final Widget? trailing;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final isEmpty = value == null || value!.isEmpty;
    final hint = placeholder ?? 'Select $label';

    return SizedBox(
      height: WidgetConstants.formFieldHeight,
      child: InputDecorator(
        decoration: InputDecoration(
          constraints: const BoxConstraints(
            minHeight: WidgetConstants.formFieldHeight,
          ),
          isCollapsed: true,
          labelText: label,
          hintText: hint,
          prefixIcon: leading,
          suffixIcon: trailing,
        ),
        isEmpty: isEmpty,
        child:
            isEmpty
                ? const SizedBox.shrink()
                : Text(value!, style: context.callout),
      ),
    );
  }
}
