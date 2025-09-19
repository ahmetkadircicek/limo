import 'package:flutter/material.dart';

import 'package:limo/shared/constants/widget_constants.dart';

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
    final decoration = InputDecoration(labelText: label);

    return SizedBox(
      height: WidgetConstants.formFieldHeight,
      child: InputDecorator(
        decoration: decoration,
        isEmpty: false,
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  valueText,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildButton(
                  context,
                  icon: Icons.remove,
                  onPressed: canDecrement ? onDecrement : null,
                ),
                const SizedBox(width: 8),
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
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline;
    final onSurface = theme.colorScheme.onSurface;

    return SizedBox(
      width: 40,
      height: 36,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          side: BorderSide(color: outline),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onPressed == null ? theme.disabledColor : onSurface,
        ),
      ),
    );
  }
}
