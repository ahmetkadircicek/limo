import 'package:flutter/services.dart';

class PlateInputFormatter extends TextInputFormatter {
  static final _allowed = RegExp(r'[A-Z0-9]');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final upper = newValue.text.toUpperCase();
    final filtered =
        upper.split('').where((ch) => _allowed.hasMatch(ch)).join();

    final limited = filtered.length > 7 ? filtered.substring(0, 7) : filtered;

    return TextEditingValue(
      text: limited,
      selection: TextSelection.collapsed(offset: limited.length),
    );
  }
}
