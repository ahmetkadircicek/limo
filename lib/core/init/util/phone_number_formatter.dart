import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit to 10 digits
    if (digits.length > 10) {
      digits = digits.substring(0, 10);
    }

    // Format based on length
    String formatted = '';
    if (digits.isNotEmpty) {
      formatted =
          '(${digits.substring(0, digits.length > 3 ? 3 : digits.length)}';
      if (digits.length > 3) {
        formatted +=
            ') ${digits.substring(3, digits.length > 6 ? 6 : digits.length)}';
        if (digits.length > 6) {
          formatted += '-${digits.substring(6)}';
        }
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
