import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/models/job_model.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:provider/provider.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/model_provider.dart';
import 'package:limo/shared/models/brand_model.dart';
import 'package:limo/shared/models/category_model.dart';
import 'package:limo/shared/models/model_model.dart';

class JobDetailsView extends StatelessWidget {
  const JobDetailsView({super.key, required this.job});
  final JobModel job;

  @override
  Widget build(BuildContext context) {
    final title = (job.title ?? '').trim().isEmpty ? 'Untitled job' : job.title!;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: PaddingConstants.all16,
        children: [
          _summaryCard(context),
          const SizedBox(height: 12),
          _scheduleCard(context),
          const SizedBox(height: 12),
          _locationsCard(context),
          const SizedBox(height: 12),
          if ((job.description ?? '').isNotEmpty) _descriptionCard(context),
          const SizedBox(height: 12),
          _carRequirementsCard(context),
        ],
      ),
    );
  }

  Widget _summaryCard(BuildContext context) {
    final code = job.jobId != null ? 'JOB-${job.jobId}' : '—';
    final jobType = job.jobType ?? '—';
    final miles = job.distanceRoad;
    final minutes = job.durationMinutes;
    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text('Summary', style: Theme.of(context).textTheme.titleMedium),
          _kv(context, 'Code', code),
          _kv(context, 'Job Type', jobType),
          if (miles != null) _kv(context, 'Distance', '${miles.toStringAsFixed(2)} mi'),
          if (minutes != null) _kv(context, 'Duration', _fmtMinutes(minutes)),
          _kv(context, 'Status', job.status ?? 'active'),
          _kv(context, 'Share Contact', job.shareNumber ? 'Yes' : 'No'),
        ],
      ),
    );
  }

  Widget _scheduleCard(BuildContext context) {
    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text('Schedule', style: Theme.of(context).textTheme.titleMedium),
          _kv(context, 'Pickup', _fmtDate(job.pickupDate)),
          if (job.dropoffDate != null)
            _kv(context, 'Drop-off', _fmtDate(job.dropoffDate)),
        ],
      ),
    );
  }

  Widget _locationsCard(BuildContext context) {
    final pickup = job.pickupLocation?.address ?? '—';
    final dropoff = job.dropoffLocation?.address ?? '—';
    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text('Locations', style: Theme.of(context).textTheme.titleMedium),
          _kv(context, 'Pickup Location', pickup),
          if (job.dropoffLocation != null)
            _kv(context, 'Drop-off Location', dropoff),
        ],
      ),
    );
  }

  Widget _descriptionCard(BuildContext context) {
    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text('Description', style: Theme.of(context).textTheme.titleMedium),
          Text(job.description ?? '-', style: context.body),
        ],
      ),
    );
  }

  Widget _carRequirementsCard(BuildContext context) {
    final cars = job.cars;
    final brandProvider = context.read<BrandProvider>();
    final categoryProvider = context.read<CategoryProvider>();
    final modelProvider = context.read<ModelProvider>();
    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text('Vehicle Requirements', style: Theme.of(context).textTheme.titleMedium),
          if (cars.isEmpty)
            Text('Any vehicle', style: context.body.copyWith(color: context.onSurfaceVariant))
          else
            ...cars.map((c) {
              final brandName = brandProvider.brands
                  .firstWhere((b) => b.brandId == c.brandId, orElse: () => BrandModel())
                  .brandName;
              String? modelName;
              if (modelProvider.currentBrandId == c.brandId && modelProvider.models.isNotEmpty) {
                modelName = modelProvider.models
                    .firstWhere((m) => m.modelId == c.modelId, orElse: () => ModelModel())
                    .modelName;
              }
              final categoryName = categoryProvider.categories
                  .firstWhere((cat) => cat.categoryId == c.categoryId, orElse: () => CategoryModel())
                  .categoryName;
              final title = [
                brandName ?? '#${c.brandId}',
                modelName ?? '#${c.modelId}',
                categoryName ?? '#${c.categoryId}',
              ].join(' • ');
              final subtitle = '${c.capacity} seats • ${c.modelYear} • Mile: \$${c.mileFee} • Hour: \$${c.hourlyFee}';
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: context.outline.withValues(alpha: 0.15))),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(title, style: context.body),
                    Text(subtitle, style: context.caption1.copyWith(color: context.onSurfaceVariant)),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // helpers
  Widget _kv(BuildContext context, String k, String v) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 120, child: Text(k, style: context.caption1.copyWith(color: context.onSurfaceVariant))),
        const SizedBox(width: 8),
        Expanded(child: Text(v, style: context.caption1)),
      ],
    );
  }

  static final _fmt = DateFormat('MM/dd/yyyy h:mm a', 'en_US');
  String _fmtDate(DateTime? d) => d == null ? '—' : _fmt.format(d);
  String _fmtMinutes(double minutes) {
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
}

