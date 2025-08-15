import 'package:intl/intl.dart';

// extension StringLocalization on String {
//   String get locale => this.tr();
// }

extension StringExtensions on String {
  String capitalizeEachWord() {
    if (isEmpty) return '';

    List<String> words = split(' ');
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        words[i] =
            '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCaseTr()}';
      }
    }
    return words.join(' ');
  }

  String capitalizeSentences() {
    if (isEmpty) return '';

    List<String> sentences = trim().split(RegExp(r'(?<=[.?!])\s+'));
    List<String> capitalizedSentences = [];
    for (String sentence in sentences) {
      if (sentence.isNotEmpty) {
        capitalizedSentences.add(
            '${sentence.substring(0, 1).toUpperCaseTr()}${sentence.substring(1).toLowerCaseTr()}');
      }
    }
    return capitalizedSentences.join(' ');
  }

  String formatPhoneNumber() {
    String cleaned = replaceAll(RegExp(r'\s+'), '');
    if (cleaned.startsWith('0')) {
      cleaned = '+90${cleaned.substring(1)}';
    }
    return cleaned;
  }

  String revertFormatPhoneNumber() {
    String cleaned = replaceAll(RegExp(r'\s+'), '');
    if (cleaned.startsWith('+90')) {
      cleaned = '0${cleaned.substring(3)}';
    }
    return cleaned;
  }

  String formatName() {
    if (isEmpty) return '';

    List<String> nameParts = split(' ');
    for (int i = 0; i < nameParts.length - 1; i++) {
      String word = nameParts[i];
      if (word.isNotEmpty) {
        nameParts[i] =
            '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCaseTr()}';
      }
    }
    if (nameParts.isNotEmpty) {
      String lastWord = nameParts.last;
      if (lastWord.isNotEmpty) {
        nameParts[nameParts.length - 1] = lastWord.toUpperCase();
      }
    }
    return nameParts.join(' ');
  }

  String toTurkishDateFormat() {
    // Input date format
    final inputFormat = DateFormat('dd-MM-yyyy');
    // Output date format
    final outputFormat = DateFormat('d MMMM yyyy', 'tr_TR');

    try {
      // Parse the date
      final date = inputFormat.parse(this);
      // Return in desired format
      return outputFormat.format(date);
    } catch (e) {
      // Message to return in case of error
      return 'Invalid date';
    }
  }

  String formatAsCurrency() {
    if (isEmpty) {
      return '₺0,00';
    }

    String newValueText = replaceAll(RegExp(r'[^0-9]'), '');
    int newValueNumber = int.tryParse(newValueText) ?? 0;

    if (newValueText.isEmpty ||
        newValueText == '00' ||
        newValueText == '0,00') {
      return '₺0,00';
    }

    if (newValueNumber > 9999999) {
      return '₺${NumberFormat('#,##0.00', 'tr_TR').format(9999999 / 100)}';
    }

    final formattedValue = NumberFormat.currency(
      locale: 'tr_TR',
      symbol: '₺',
      decimalDigits: 2,
    ).format(newValueNumber / 100);

    return formattedValue;
  }

  String formatPlateNumber() {
    String cleanedPlate = replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();

    // Ensure the length is appropriate for a Turkish license plate
    if (cleanedPlate.length < 6 || cleanedPlate.length > 8) {
      return '';
    }

    // Identify the parts of the plate
    String provinceCode = cleanedPlate.substring(0, 2);
    String letterSection;
    String numberSection;

    if (cleanedPlate.length == 6) {
      // Format: 34 A 1234
      letterSection = cleanedPlate.substring(2, 3);
      numberSection = cleanedPlate.substring(3);
    } else if (cleanedPlate.length == 7) {
      // Format: 34 AB 123 or 34 A 12345
      if (RegExp(r'[A-Z]{2}').hasMatch(cleanedPlate.substring(2, 4))) {
        letterSection = cleanedPlate.substring(2, 4);
        numberSection = cleanedPlate.substring(4);
      } else {
        letterSection = cleanedPlate.substring(2, 3);
        numberSection = cleanedPlate.substring(3);
      }
    } else if (cleanedPlate.length == 8) {
      // Format: 34 ABC 123 or 34 AB 1234
      if (RegExp(r'[A-Z]{3}').hasMatch(cleanedPlate.substring(2, 5))) {
        letterSection = cleanedPlate.substring(2, 5);
        numberSection = cleanedPlate.substring(5);
      } else if (RegExp(r'[A-Z]{2}').hasMatch(cleanedPlate.substring(2, 4))) {
        letterSection = cleanedPlate.substring(2, 4);
        numberSection = cleanedPlate.substring(4);
      } else {
        letterSection = cleanedPlate.substring(2, 3);
        numberSection = cleanedPlate.substring(3);
      }
    } else {
      // Default to the most common format
      letterSection = cleanedPlate.substring(2, 3);
      numberSection = cleanedPlate.substring(3);
    }

    // Format the plate correctly
    return '$provinceCode $letterSection $numberSection';
  }
}

extension TurkishStrings on String {
  String toLowerCaseTr() {
    final _Turkish turkish = _Turkish();
    return turkish.toLowerCase(this);
  }

  String toUpperCaseTr() {
    final _Turkish turkish = _Turkish();
    return turkish.toUpperCase(this);
  }

  String toTitleCaseTr() {
    final _Turkish turkish = _Turkish();
    return turkish.toTitleCase(this);
  }
}

class _Turkish {
  final int _latinCapitalLetterICode = 0x49;
  final int _latinSmallLetterICode = 0x69;

  String toUpperCase(String input) {
    if (input.isEmpty) return "";
    if (input.length == 1) return _toUpper1Length(input);
    final buffer = StringBuffer();
    final toAppend = <int>[];
    for (final codeUnit in input.codeUnits) {
      if (codeUnit == _latinSmallLetterICode) {
        if (toAppend.isNotEmpty) {
          buffer.write(String.fromCharCodes(toAppend).toUpperCase());
          toAppend.clear();
        }
        buffer.write("İ");
      } else {
        toAppend.add(codeUnit);
      }
    }
    if (toAppend.isNotEmpty) {
      buffer.write(String.fromCharCodes(toAppend).toUpperCase());
    }
    return buffer.toString();
  }

  String _toUpper1Length(String input) =>
      (input.codeUnitAt(0) == _latinSmallLetterICode)
          ? "İ"
          : input.toUpperCase();

  String toLowerCase(String input) {
    if (input.isEmpty) return "";
    if (input.length == 1) return _toLower1Length(input);
    final buffer = StringBuffer();
    final toAppend = <int>[];
    for (final codeUnit in input.codeUnits) {
      if (codeUnit == _latinCapitalLetterICode) {
        if (toAppend.isNotEmpty) {
          buffer.write(String.fromCharCodes(toAppend).toLowerCase());
          toAppend.clear();
        }
        buffer.write("ı");
      } else {
        toAppend.add(codeUnit);
      }
    }
    if (toAppend.isNotEmpty) {
      buffer.write(String.fromCharCodes(toAppend).toLowerCase());
    }
    return buffer.toString();
  }

  String _toLower1Length(String input) =>
      (input.codeUnitAt(0) == _latinCapitalLetterICode)
          ? "ı"
          : input.toLowerCase();

  String toTitleCase(String input) {
    if (input.isEmpty) return "";
    if (input.length == 1) return _toUpper1Length(input);
    return "${_toUpper1Length(input.substring(0, 1))}${toLowerCase(input.substring(1))}";
  }
}
