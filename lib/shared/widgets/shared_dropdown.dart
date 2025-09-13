import 'package:flutter/material.dart';

class SharedDropdown<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final List<T> items;
  final T? value;
  final String Function(T) itemToString;
  final ValueChanged<T?> onChanged;
  final FormFieldValidator<T?>? validator;
  final bool enabled;

  const SharedDropdown({
    super.key,
    required this.label,
    this.hint,
    required this.items,
    required this.value,
    required this.itemToString,
    required this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items:
          items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(itemToString(e), overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      menuMaxHeight: 240,
    );
  }
}
