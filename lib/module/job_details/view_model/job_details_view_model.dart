import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limo/shared/models/job_model.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:limo/shared/utils/map_launcher.dart';

class JobDetailsViewModel extends ChangeNotifier {
  JobDetailsViewModel({required this.job});
  final JobModel job;

  // Derived values
  String get displayTitle => (job.title ?? '').trim().isEmpty ? 'Job Title' : job.title!;
  String? get jobCode => job.jobId != null ? 'JOB-${job.jobId}' : null;
  String get statusCapitalized {
    final raw = (job.status ?? 'active').toString();
    if (raw.isEmpty) return 'Active';
    return raw[0].toUpperCase() + raw.substring(1).toLowerCase();
  }

  String get typeDisplay => job.jobType ?? job.jobTypeName ?? '—';

  bool get hasPickupCoords => job.pickupLocation?.lat != null && job.pickupLocation?.lng != null;
  bool get hasDropoffCoords => job.dropoffLocation?.lat != null && job.dropoffLocation?.lng != null;
  bool get hasAnyCoordinates => hasPickupCoords || hasDropoffCoords;

  // Formatting
  static final _fmt = DateFormat('MM/dd/yyyy h:mm a', 'en_US');
  String fmtDate(DateTime? d) => d == null ? '—' : _fmt.format(d);
  String fmtMinutes(double minutes) {
    final m = minutes.round();
    if (m % (60 * 24) == 0) {
      final days = (m / (60 * 24)).round();
      return '$days day${days > 1 ? 's' : ''}';
    }
    if (m % 60 == 0) {
      final hours = (m / 60).round();
      return '$hours hour${hours > 1 ? 's' : ''}';
    }
    return '$m min';
  }

  // Contact (derive from current user when allowed)
  (String? phone, String? email) deriveContact(BuildContext context) {
    String? phone = job.contactPhone;
    String? email = job.contactEmail;
    final current = context.read<UserProvider>().user;
    if ((phone == null || phone.isEmpty) && current != null && current.userId == job.userId) {
      phone = current.phone;
    }
    if ((email == null || email.isEmpty) && current != null && current.userId == job.userId) {
      email = current.email;
    }
    return (phone, email);
  }

  // External actions
  Future<void> openGoogle() async => MapLauncher.openGoogle(job);
  Future<void> openApple() async => MapLauncher.openApple(job);
  Future<void> openWaze() async => MapLauncher.openWaze(job);
}

