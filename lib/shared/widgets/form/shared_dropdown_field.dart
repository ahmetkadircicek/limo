import 'package:flutter/material.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/widget_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/widgets/form/shared_read_only_field.dart';

class FormDropdownLoadingState extends StatelessWidget {
  const FormDropdownLoadingState({
    super.key,
    required this.label,
    this.isRequired = false,
  });

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        SharedReadOnlyField(
          label: label,
          placeholder: 'Loading $label...',
          isRequired: isRequired,
        ),
        const Padding(
          padding: PaddingConstants.all16,
          child: SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ],
    );
  }
}

class FormDropdownEmptyState extends StatelessWidget {
  const FormDropdownEmptyState({
    super.key,
    required this.label,
    this.isRequired = false,
  });

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return SharedReadOnlyField(
      label: label,
      placeholder: 'No $label options available',
      isRequired: isRequired,
    );
  }
}

class FormDropdownDisabledState extends StatelessWidget {
  const FormDropdownDisabledState({
    super.key,
    required this.label,
    required this.message,
    this.isRequired = false,
  });

  final String label;
  final String message;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return SharedReadOnlyField(
      label: label,
      placeholder: message,
      isRequired: isRequired,
    );
  }
}

class FormDropdownErrorState extends StatelessWidget {
  const FormDropdownErrorState({
    super.key,
    required this.label,
    this.message,
    this.onRetry,
    this.isRequired = false,
  });

  final String label;
  final String? message;
  final VoidCallback? onRetry;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SharedReadOnlyField(
          label: label,
          placeholder: message ?? 'Failed to load $label',
          isRequired: isRequired,
        ),
        TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
        ),
      ],
    );
  }
}

/// SIMPLE DROPDOWN

typedef ItemLabelBuilder<T> = String Function(T item);

class SharedDropdownField<T> extends StatelessWidget {
  const SharedDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabelBuilder,
    this.value,
    this.onChanged,
    this.hint,
    this.enabled = true,
    this.validator,
    this.isRequired = false,
  });

  final String label;
  final List<T> items;
  final ItemLabelBuilder<T> itemLabelBuilder;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final bool enabled;
  final FormFieldValidator<T?>? validator;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: WidgetConstants.formFieldHeight,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        decoration: InputDecoration(
          constraints: const BoxConstraints(
            minHeight: WidgetConstants.formFieldHeight,
          ),
          isCollapsed: true,
          labelText: isRequired ? null : label,
          label: isRequired ? _requiredLabel(context, label) : null,
          enabled: enabled,
        ),
        errorBuilder: (context, errorText) {
          return const SizedBox.shrink();
        },
        hint:
            hint != null
                ? Text(hint!, style: context.callout)
                : Text('Select $label', style: context.callout),
        items:
            items
                .map(
                  (it) => DropdownMenuItem<T>(
                    value: it,
                    child: Text(
                      itemLabelBuilder(it),
                      overflow: TextOverflow.ellipsis,
                      style: context.callout,
                    ),
                  ),
                )
                .toList(),
        onChanged: enabled ? onChanged : null,
        validator: validator,
      ),
    );
  }
}

Widget _requiredLabel(BuildContext context, String text) {
  return RichText(
    text: TextSpan(
      style: context.callout,
      children: [
        TextSpan(text: text, style: context.callout),
        TextSpan(text: '*', style: context.body.copyWith(color: context.error)),
      ],
    ),
  );
}
