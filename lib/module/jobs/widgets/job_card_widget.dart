import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limo/shared/constants/radius_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/models/job_model.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job, this.onTap, this.dense = false});

  final JobModel job;
  final VoidCallback? onTap;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final pad = dense ? const EdgeInsets.all(12) : const EdgeInsets.all(16);
    final title =
        (job.title ?? '').trim().isEmpty ? 'Untitled job' : job.title!;
    final code = job.jobId != null ? 'JOB-${job.jobId}' : null;
    final type = job.jobType ?? '—';
    final isRoute = _isRoute(type);
    final from = job.pickupLocation?.address ?? '—';
    final to = job.dropoffLocation?.address ?? '—';
    final pickup = _fmt(job.pickupDate);
    final dropoff = _fmt(job.dropoffDate);
    final hasRange = job.pickupDate != null && job.dropoffDate != null;

    return Card(
      color: context.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: RadiusConstants.standard,
        side: BorderSide(color: context.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: pad,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _TitleBlock(title: title, code: code)),
                  _TypePill(text: type),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: context.onSurface),
                ],
              ),
              SizedBox(height: dense ? 8 : 12),

              // GRID
              _InfoGrid(
                isWide: MediaQuery.sizeOf(context).width >= 380,
                children: [
                  _InfoRow(
                    icon: Icons.event,
                    label: hasRange ? 'When' : 'Pickup',
                    value: hasRange ? '$pickup → $dropoff' : pickup,
                    onSurfaceVariant: context.onSurfaceVariant,
                    textStyle: context.caption1,
                  ),
                  _InfoRow(
                    icon: Icons.work_outline,
                    label: 'Job Type',
                    value: type,
                    onSurfaceVariant: context.onSurfaceVariant,
                    textStyle: context.caption1,
                  ),
                  if (isRoute)
                    _RouteRow(
                      from: from,
                      to: to,
                      onSurfaceVariant: context.onSurfaceVariant,
                      textStyle: context.caption1,
                    )
                  else
                    _InfoRow(
                      icon: Icons.place_outlined,
                      label: 'Pickup location',
                      value: from,
                      onSurfaceVariant: context.onSurfaceVariant,
                      textStyle: context.caption1,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static bool _isRoute(String jobType) {
    final s = jobType.trim().toLowerCase();
    return s.contains('route') || s == 'routed';
  }

  static final _fmtDate = DateFormat('MMM d, h:mm a', 'en_US');
  static String _fmt(DateTime? d) => d == null ? '—' : _fmtDate.format(d);
}

// === sub-widgets

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.title, this.code});
  final String title;
  final String? code;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.body.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (code != null)
            Text(
              code!,
              style: context.caption1.copyWith(color: context.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.outline),
      ),
      child: Text(
        text,
        style: context.caption1.copyWith(
          color: context.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.children, required this.isWide});
  final List<Widget> children;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _spaced(children, 8),
      );
    }
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children:
          children
              .map(
                (w) => SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 16 - 16 - 12) / 2,
                  child: w,
                ),
              )
              .toList(),
    );
  }

  List<Widget> _spaced(List<Widget> items, double h) {
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i != items.length - 1) out.add(SizedBox(height: h));
    }
    return out;
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onSurfaceVariant,
    required this.textStyle,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color onSurfaceVariant;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: onSurfaceVariant, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: textStyle.copyWith(color: onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(
                value,
                style: textStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({
    required this.from,
    required this.to,
    required this.onSurfaceVariant,
    required this.textStyle,
  });

  final String from;
  final String to;
  final Color onSurfaceVariant;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.place_outlined, color: onSurfaceVariant, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: textStyle.copyWith(color: onSurfaceVariant),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      from,
                      style: textStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: onSurfaceVariant,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To',
                      style: textStyle.copyWith(color: onSurfaceVariant),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      to,
                      style: textStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
