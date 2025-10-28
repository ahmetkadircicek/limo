import 'package:flutter/material.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/widget_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';

class SharedStepperField extends StatelessWidget {
  final String label;
  final String valueText;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final bool canIncrement;
  final bool canDecrement;

  const SharedStepperField({
    super.key,
    required this.label,
    required this.valueText,
    required this.onIncrement,
    required this.onDecrement,
    this.canIncrement = true,
    this.canDecrement = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: WidgetConstants.formFieldHeight,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          enabled: true,
          contentPadding: PaddingConstants.vertical16 + PaddingConstants.left16,
        ),
        isEmpty: false,
        child: Row(
          children: [
            Expanded(child: Text(valueText, style: context.callout)),
            Row(
              spacing: 8,
              children: [
                _buildButton(
                  context,
                  icon: Icons.remove,
                  onPressed: canDecrement ? onDecrement : null,
                ),
                _buildButton(
                  context,
                  icon: Icons.add,
                  onPressed: canIncrement ? onIncrement : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(
        icon,
        size: 20,
        color: onPressed == null ? context.disabled : context.onSurface,
      ),
      onPressed: onPressed,
    );
  }
}
