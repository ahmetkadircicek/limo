import 'package:flutter/material.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/widgets/shared_chip_button.dart';

class JobsHeaderWidget extends StatelessWidget {
  const JobsHeaderWidget({
    super.key,
    required this.activeCount,
    required this.onFilter,
  });

  final int activeCount;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    final countLabel =
        activeCount == 0
            ? 'No active jobs'
            : '$activeCount active ${activeCount == 1 ? 'job' : 'jobs'}';

    return Padding(
      padding: PaddingConstants.bottom20,
      child: SharedCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jobs', style: context.headline),
                Text(
                  countLabel,
                  style: context.subhead.copyWith(
                    color: context.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SharedChipButton(
              text: 'Filter',
              icon: Icons.filter_list_rounded,
              onPressed: onFilter,
              backgroundColor: context.primary,
              foregroundColor: context.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

