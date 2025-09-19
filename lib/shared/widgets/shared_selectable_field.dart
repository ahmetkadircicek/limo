import 'package:flutter/material.dart';
import 'package:limo/shared/constants/radius_constants.dart';
import 'package:limo/shared/constants/widget_constants.dart';

class SharedSelectableField extends StatelessWidget {
  final String label;
  final String? value;
  final String? placeholder;
  final VoidCallback? onTap;
  final Widget? leading;
  final bool enabled;

  const SharedSelectableField({
    super.key,
    required this.label,
    this.value,
    this.placeholder,
    this.onTap,
    this.leading,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = value == null || value!.isEmpty;
    final display = isEmpty ? placeholderText : value!;
    final theme = Theme.of(context);

    Widget field = InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: leading,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      isEmpty: isEmpty,
      child: Text(
        display,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: enabled
              ? (isEmpty
                  ? theme.colorScheme.onSurfaceVariant
                  : theme.colorScheme.onSurface)
              : theme.disabledColor,
        ),
      ),
    );

    if (enabled && onTap != null) {
      field = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RadiusConstants.standardRadius),
        child: field,
      );
    }

    return SizedBox(height: WidgetConstants.formFieldHeight, child: field);
  }

  String get placeholderText =>
      (placeholder != null && placeholder!.isNotEmpty)
          ? placeholder!
          : 'Select $label';
}
