import 'package:flutter/cupertino.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/widgets/form/shared_read_only_field.dart';
import 'package:provider/provider.dart';

class StatisticsWidget extends StatelessWidget {
  const StatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Column(
      spacing: PaddingConstants.p8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SharedReadOnlyField(label: 'Provider', value: user?.provider),
        SharedReadOnlyField(label: 'User ID', value: user?.userId),
      ],
    );
  }
}
