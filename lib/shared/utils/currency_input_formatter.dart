import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  CurrencyInputFormatter({this.maxDecimalPlaces = 2});

  final int maxDecimalPlaces;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final rawText = newValue.text.replaceAll(RegExp(r'[^0-9.,]'), '');

    if (rawText.isEmpty) {
      return const TextEditingValue();
    }

    var normalized = _normalize(rawText);

    if (normalized.startsWith('.')) {
      normalized = '0$normalized';
    }

    final parts = normalized.split('.');
    var integerPart = parts[0];
    var decimalPart = parts.length > 1 ? parts[1] : '';

    if (decimalPart.length > maxDecimalPlaces) {
      decimalPart = decimalPart.substring(0, maxDecimalPlaces);
    }

    if (integerPart.isEmpty) {
      integerPart = '0';
    }

    final intValue = int.tryParse(integerPart);
    if (intValue == null) {
      return oldValue;
    }

    final formattedInt = NumberFormat.decimalPattern('en_US').format(intValue);
    final formattedText =
        decimalPart.isNotEmpty ? '$formattedInt.$decimalPart' : formattedInt;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _normalize(String input) {
    var result = input;

    if (result.contains('.')) {
      return result.replaceAll(',', '');
    }

    if (result.contains(',')) {
      final lastComma = result.lastIndexOf(',');
      final decimalsLength = result.length - lastComma - 1;

      if (decimalsLength > 0 && decimalsLength <= maxDecimalPlaces) {
        result = result.replaceRange(lastComma, lastComma + 1, '.');
      }

      result = result.replaceAll(',', '');
    }

    return result;
  }
}
