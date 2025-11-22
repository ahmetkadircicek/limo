import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:limo/module/job_details/view_model/job_details_view_model.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/constants/padding_constants.dart';

class JobHeaderSection extends StatelessWidget {
  const JobHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Sadece Title, JobCode, Type ve Status değişirse burası render olur.
    return Selector<JobDetailsViewModel, _HeaderData>(
      selector: (_, vm) => _HeaderData(
        title: vm.displayTitle,
        code: vm.jobCode,
        type: vm.typeDisplay,
        status: vm.statusCapitalized,
      ),
      builder: (context, data, _) {
        final cs = Theme.of(context).colorScheme;
        return SharedCard(
          backgroundColor: context.surfaceContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: context.headline.copyWith(fontWeight: FontWeight.w600),
              ),
              if (data.code != null) ...[
                const SizedBox(height: PaddingConstants.p8),
                Text(
                  data.code!,
                  style: context.caption1.copyWith(color: context.onSurfaceVariant),
                ),
              ],
              const SizedBox(height: PaddingConstants.p8),
              Wrap(
                spacing: PaddingConstants.p8,
                runSpacing: PaddingConstants.p8,
                children: [
                  _StatusChip(text: data.type, bg: cs.secondary, fg: cs.onSecondary),
                  _StatusChip(text: data.status, bg: cs.secondary, fg: cs.onSecondary),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.text, required this.bg, required this.fg});
  final String text;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: context.caption1.copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// Selector için basit data class
class _HeaderData {
  final String title;
  final String? code;
  final String type;
  final String status;
  _HeaderData({required this.title, required this.code, required this.type, required this.status});
  
  @override
  bool operator ==(Object other) => other is _HeaderData && title == other.title && code == other.code && type == other.type && status == other.status;
  @override
  int get hashCode => Object.hash(title, code, type, status);
}