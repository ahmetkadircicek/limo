import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/radius_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/models/job_model.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job, this.onTap});

  final JobModel job;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final title =
        (job.title ?? '').trim().isEmpty ? 'Untitled job' : job.title!;
    final code = job.jobId != null ? 'JOB-${job.jobId}' : '';
    final jobType = job.jobType ?? '—';
    final isRoute = _isRoute(jobType);

    return Container(
      padding: PaddingConstants.horizontal16 + PaddingConstants.vertical12,
      decoration: BoxDecoration(
        color: context.surface,
        border: Border.all(color: context.outline),
        borderRadius: RadiusConstants.standard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, title: title, code: code, jobType: jobType),
          const SizedBox(height: 8),
          _buildTypeRow(context),
          const SizedBox(height: 8),
          _buildDateRow(context, isRoute: isRoute),
          const SizedBox(height: 8),
          _buildLocationRow(context, isRoute: isRoute),
        ],
      ),
    );
  }

  // ===== parts

  Widget _buildHeader(
    BuildContext context, {
    required String title,
    required String code,
    required String jobType,
    VoidCallback? onTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.body.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (code.isNotEmpty)
                Text(
                  code,
                  style: context.caption1.copyWith(
                    color: context.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: context.onSurface, // details tam siyah (onSurface)
          ),
          icon: const Icon(Icons.chevron_right),
          label: const Text('Details'),
          iconAlignment: IconAlignment.end,
        ),
      ],
    );
  }

  Widget _buildTypeRow(BuildContext context) {
    final type = job.jobType ?? '—';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.work_outline, color: context.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(child: _labeledValue(context, 'Job Type', type)),
      ],
    );
  }

  Widget _buildDateRow(BuildContext context, {required bool isRoute}) {
    final pickupTxt = _fmt(job.pickupDate);
    final dropoffTxt = _fmt(job.dropoffDate);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.event, color: context.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child:
              isRoute
                  ? Row(
                    children: [
                      Expanded(
                        child: _labeledValue(context, 'Pickup', pickupTxt),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _labeledValue(context, 'Drop-off', dropoffTxt),
                      ),
                    ],
                  )
                  : _labeledValue(context, 'Pickup', pickupTxt),
        ),
      ],
    );
  }

  Widget _buildLocationRow(BuildContext context, {required bool isRoute}) {
    final from = job.pickupLocation?.address ?? '—';
    final to = job.dropoffLocation?.address ?? '—';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.place_outlined, color: context.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child:
              isRoute
                  ? Row(
                    children: [
                      Expanded(child: _labeledValue(context, 'From', from)),
                      const SizedBox(width: 12),
                      Expanded(child: _labeledValue(context, 'To', to)),
                    ],
                  )
                  : _labeledValue(context, 'Pickup location', from),
        ),
      ],
    );
  }

  // ===== atoms

  Widget _labeledValue(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.caption1.copyWith(color: context.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: context.caption1,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // ===== helpers

  static bool _isRoute(String jobType) {
    final s = jobType.trim().toLowerCase();
    return s == 'route' || s == 'routed' || s.contains('route');
  }

  static final _fmtDate = DateFormat('d MMMM, HH:mm');
  static String _fmt(DateTime? d) => d == null ? '—' : _fmtDate.format(d);
}

// Job type chip removed; job type is shown like other properties.
