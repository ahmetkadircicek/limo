import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:limo/module/job_details/view_model/job_details_view_model.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/constants/padding_constants.dart';

class JobDescriptionSection extends StatelessWidget {
  const JobDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Description, UserId ve CreatedAt değişirse rebuild olur
    final info = context.select<JobDetailsViewModel, ({String? desc, String? user, DateTime? created})>(
      (vm) => (
        desc: vm.job.description,
        user: vm.job.userId,
        created: vm.job.createdAt,
      ),
    );

    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Details', style: context.headline),
          const SizedBox(height: PaddingConstants.p8),
          
          // Uzun metinler için genişleyebilir text widget'ı
          _ExpandableDescription(text: info.desc ?? '-'),
          
          const SizedBox(height: PaddingConstants.p16),
          const Divider(height: 1, thickness: 0.5), // İsteğe bağlı ince çizgi
          const SizedBox(height: PaddingConstants.p16),

          Row(
            children: [
              Expanded(
                child: _MetaInfo(
                  label: 'Created By', 
                  value: info.user ?? 'Unknown',
                ),
              ),
              const SizedBox(width: PaddingConstants.p8),
              Expanded(
                child: _MetaInfo(
                  label: 'Created On', 
                  value: info.created != null 
                      ? DateFormat('MM/dd/yyyy').format(info.created!) 
                      : '—',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Metin genişletme/daraltma state'ini izole ettik.
class _ExpandableDescription extends StatefulWidget {
  const _ExpandableDescription({required this.text});
  final String text;

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _isExpanded = false;
  static const int _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    // Metin kısaysa buton göstermeye gerek yok
    final isLongText = widget.text.length > 120; 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: context.callout,
          maxLines: _isExpanded ? null : _maxLines,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (isLongText)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Text(
                _isExpanded ? 'Show less' : 'Show more',
                style: context.caption1.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MetaInfo extends StatelessWidget {
  const _MetaInfo({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.caption1.copyWith(color: context.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(value, style: context.callout),
      ],
    );
  }
}