import 'package:flutter/material.dart';

import '../extensions/general_extensions.dart';

enum AlertType { basic, success, error, info, warning, confirmation }

class AlertUtils {
  static IconData getIcon(AlertType type) {
    switch (type) {
      case AlertType.basic:
        return Icons.local_shipping;
      case AlertType.success:
        return Icons.check_circle;
      case AlertType.error:
        return Icons.error;
      case AlertType.info:
        return Icons.info;
      case AlertType.warning:
        return Icons.warning;
      case AlertType.confirmation:
        return Icons.help;
    }
  }

  static Color getColor(BuildContext context, AlertType type) {
    switch (type) {
      case AlertType.basic:
        return context.primary;
      case AlertType.success:
        return Colors.green;
      case AlertType.error:
        return Colors.orange;
      case AlertType.info:
        return context.secondary;
      case AlertType.warning:
        return context.error;
      case AlertType.confirmation:
        return Colors.purple;
    }
  }
}
