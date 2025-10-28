import 'package:intl/intl.dart';
import 'package:limo/shared/models/job_model.dart';

class JobFormatters {
  static final _date = DateFormat('dd MMM yyyy, HH:mm');

  static String dateRange(JobModel job) {
    final p = job.pickupDate;
    final d = job.dropoffDate;
    if (p == null && d == null) return '—';
    if (p != null && d != null) {
      final sameDay = p.year == d.year && p.month == d.month && p.day == d.day;
      if (sameDay) {
        return '${_date.format(p)} → ${DateFormat('HH:mm').format(d)}';
      }
      return '${_date.format(p)} → ${_date.format(d)}';
    }
    if (p != null) return _date.format(p);
    return _date.format(d!);
  }

  static String durationLabel(JobModel job) {
    if (job.dropoffDate != null && job.pickupDate != null) {
      final mins = job.dropoffDate!.difference(job.pickupDate!).inMinutes;
      if (mins <= 0) return '';
      if (mins % (60 * 24) == 0) {
        final days = (mins / (60 * 24)).round();
        return '$days day${days > 1 ? 's' : ''}';
      }
      if (mins % 60 == 0) {
        final hours = (mins / 60).round();
        return '$hours hour${hours > 1 ? 's' : ''}';
      }
      return '$mins min';
    }
    if ((job.durationMinutes ?? 0) > 0) {
      final mins = job.durationMinutes!.round();
      if (mins % (60 * 24) == 0) {
        final days = (mins / (60 * 24)).round();
        return '$days day${days > 1 ? 's' : ''}';
      }
      if (mins % 60 == 0) {
        final hours = (mins / 60).round();
        return '$hours hour${hours > 1 ? 's' : ''}';
      }
      return '$mins min';
    }
    return '';
  }

  // /// Tries common fields: totalFee/budget/price + currency.
  // /// Returns null if not available.
  // static String? price(JobModel job) {
  //   final currency = job.currency ?? job.budgetCurrency ?? job.priceCurrency;
  //   final amount = job.totalFee ?? job.budget ?? job.price;
  //   if (amount == null) return null;
  //   if (currency == null || currency.isEmpty) return amount.toString();
  //   return '$amount $currency';
  // }
}
