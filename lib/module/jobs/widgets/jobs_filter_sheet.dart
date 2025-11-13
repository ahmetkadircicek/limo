import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:limo/core/providers/job_type_provider.dart';
import 'package:limo/module/jobs/models/jobs_filter.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/widgets/form/shared_dropdown_field.dart';
import 'package:limo/shared/widgets/form/shared_read_only_field.dart';
import 'package:limo/shared/widgets/shared_button.dart';
import 'package:provider/provider.dart';

class JobsFilterSheet extends StatefulWidget {
  const JobsFilterSheet({super.key, required this.initial});
  final JobsFilterModel initial;

  @override
  State<JobsFilterSheet> createState() => _JobsFilterSheetState();
}

class _JobsFilterSheetState extends State<JobsFilterSheet> {
  DateTimeRange? _range;
  String? _jobType;

  @override
  void initState() {
    super.initState();
    _range = widget.initial.dateRange;
    _jobType = widget.initial.jobTypeName;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<JobTypeProvider>().loadJobTypes(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: PaddingConstants.all24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: PaddingConstants.p8,
                children: [
                  Text('Filter Jobs', style: context.headline),
                  _DateRangeField(
                    label: _rangeLabel(),
                    onPickRange: _pickRange,
                    onClear:
                        _range != null
                            ? () => setState(() => _range = null)
                            : null,
                  ),
                  _JobTypeField(
                    selectedJobType: _jobType,
                    onChanged: (value) {
                      setState(() => _jobType = value);
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: PaddingConstants.all24,
              decoration: BoxDecoration(
                color: context.surface200,
                border: Border(
                  top: BorderSide(color: context.outline.withOpacity(0.2)),
                ),
              ),
              child: Column(
                spacing: PaddingConstants.p8,
                children: [
                  SharedButton(
                    text: 'Apply',
                    backgroundColor: context.primary,
                    foregroundColor: context.onPrimary,
                    onPressed: () {
                      final result = JobsFilterModel(
                        dateRange: _range,
                        jobTypeName: _jobType,
                      );
                      Navigator.of(context).pop(result);
                    },
                  ),
                  SharedButton(
                    text: 'Clear filters',
                    backgroundColor: Colors.transparent,
                    foregroundColor: context.onSurface,
                    onPressed: () {
                      Navigator.of(context).pop(const JobsFilterModel());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _rangeLabel() {
    if (_range == null) return '';
    final s = _range!.start;
    final e = _range!.end;
    final fmt = DateFormat('MM/dd/yyyy', 'en_US');
    return '${fmt.format(s)} - ${fmt.format(e)}';
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final initial =
        _range ??
        DateTimeRange(start: now, end: now.add(const Duration(days: 7)));
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      initialDateRange: initial,
    );
    if (picked != null) {
      setState(() => _range = picked);
    }
  }
}

class _DateRangeField extends StatelessWidget {
  const _DateRangeField({
    required this.label,
    required this.onPickRange,
    this.onClear,
  });

  final String label;
  final VoidCallback onPickRange;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return SharedReadOnlyField(
      label: 'Date range',
      value: label.isEmpty ? null : label,
      placeholder: 'Any time',
      leading: Icon(
        Icons.calendar_today_outlined,
        color: context.onSurfaceVariant,
      ),
      trailing:
          onClear != null
              ? IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: onClear,
                tooltip: 'Clear',
                visualDensity: VisualDensity.compact,
              )
              : null,
    ).tap(onTap: onPickRange);
  }
}

extension _TapExtension on Widget {
  Widget tap({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: this,
    );
  }
}

class _JobTypeField extends StatelessWidget {
  const _JobTypeField({required this.selectedJobType, required this.onChanged});

  final String? selectedJobType;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final jobTypeProvider = context.watch<JobTypeProvider>();
    final types = jobTypeProvider.jobTypes.map((e) => e.jobTypeName).toList();

    final allTypes = ['', ...types];

    return SharedDropdownField<String>(
      label: 'Job type',
      items: allTypes,
      value: selectedJobType ?? '',
      itemLabelBuilder: (value) => value.isEmpty ? 'All types' : value,
      hint: 'All types',
      onChanged: (value) {
        onChanged((value ?? '').isEmpty ? null : value);
      },
    );
  }
}
