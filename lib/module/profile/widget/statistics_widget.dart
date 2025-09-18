import 'package:flutter/cupertino.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/radius_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:provider/provider.dart';

class StatisticsWidget extends StatelessWidget {
  const StatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Container(
      width: double.infinity,
      padding: PaddingConstants.all20,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: RadiusConstants.standard,
      ),
      child: Column(
        spacing: PaddingConstants.p16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context),
          _buildInfoRow(context, 'Provider', user?.provider),
          _buildInfoRow(context, 'ID', user?.userId),
          // _buildInfoRow(
          //   context,
          //   'Since',
          //   user?.createdAt ?? '',
          // ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Personal Information',
      style: context.headline.copyWith(color: context.onSurface),
    );
  }

  // Build info row for each field
  Widget _buildInfoRow(BuildContext context, String label, String? value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.footnote.copyWith(color: context.onSurfaceVariant),
          ),
        ),
        Text(
          value ?? '-',
          style: context.subhead.copyWith(color: context.onSurface),
        ),
      ],
    );
  }
}
