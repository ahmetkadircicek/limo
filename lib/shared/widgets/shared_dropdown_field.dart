import 'package:flutter/material.dart';

import 'package:limo/shared/constants/widget_constants.dart';

typedef ItemLabelBuilder<T> = String Function(T item);

class SharedDropdownField<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final ItemLabelBuilder<T> itemLabelBuilder;
  final bool enabled;
  final Widget? leading;
  final FormFieldValidator<T?>? validator;
  final FormFieldSetter<T?>? onSaved;
  final AutovalidateMode? autovalidateMode;
  final double? menuMaxHeight;

  const SharedDropdownField({
    super.key,
    required this.label,
    this.hint,
    required this.items,
    this.value,
    this.onChanged,
    required this.itemLabelBuilder,
    this.enabled = true,
    this.leading,
    this.validator,
    this.onSaved,
    this.autovalidateMode,
    this.menuMaxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: WidgetConstants.formFieldHeight,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: leading,
          floatingLabelBehavior:
              hint != null && hint!.isNotEmpty
                  ? FloatingLabelBehavior.always
                  : FloatingLabelBehavior.auto,
        ),
        items:
            items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(itemLabelBuilder(item)),
                  ),
                )
                .toList(),
        onChanged: enabled ? onChanged : null,
        validator: validator,
        onSaved: onSaved,
        autovalidateMode: autovalidateMode,
        menuMaxHeight: menuMaxHeight,
      ),
    );
  }
}
