import 'package:intl/intl.dart';

/// Formats DateTime values for API payloads.
class DateTimeFormatter {
  DateTimeFormatter._();

  static const String _apiPattern = 'yyyy-MM-dd HH:mm:ss';

  static String? formatApi(DateTime? value) {
    if (value == null) return null;
    return DateFormat(_apiPattern).format(value.toLocal());
  }
}
