import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih formatı için
import 'package:provider/provider.dart';
import 'package:limo/module/job_details/view_model/job_details_view_model.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/constants/padding_constants.dart';

class JobDatesSection extends StatelessWidget {
  const JobDatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Sadece tarih verilerini dinleyen Selector
    // Record (tuple) yapısı kullanarak iki veriyi tek seferde çekiyoruz.
    final dates = context.select<JobDetailsViewModel, ({DateTime? pickup, DateTime? dropoff})>(
      (vm) => (pickup: vm.job.pickupDate, dropoff: vm.job.dropoffDate),
    );

    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dates', style: context.headline),
          const SizedBox(height: PaddingConstants.p16),
          
          _DateRow(
            icon: Icons.event,
            label: 'Pickup',
            date: dates.pickup,
          ),

          if (dates.dropoff != null) ...[
            const SizedBox(height: PaddingConstants.p12),
            _DateRow(
              icon: Icons.event_available,
              label: 'Drop-off',
              date: dates.dropoff,
            ),
          ],
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.icon,
    required this.label,
    required this.date,
  });

  final IconData icon;
  final String label;
  final DateTime? date;

  // Basit tarih formatlayıcı
  String _fmtDate(DateTime? d) {
    if (d == null) return '—';
    return DateFormat('MM/dd/yyyy h:mm a').format(d);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: context.onSurfaceVariant),
        const SizedBox(width: PaddingConstants.p12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.caption1.copyWith(color: context.onSurfaceVariant),
              ),
              const SizedBox(height: 2),
              Text(
                _fmtDate(date),
                style: context.callout.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}