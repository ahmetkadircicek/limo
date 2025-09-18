import 'package:flutter/cupertino.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/module/profile/view_model/profile_view_model.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/widgets/shared_chip_button.dart';
import 'package:provider/provider.dart';

class PersonalInfoWidget extends StatelessWidget {
  const PersonalInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return SharedCard(
      child: Column(
        spacing: PaddingConstants.p16,
        children: [
          _buildTitle(context),
          _buildInfoRow(context, 'Full Name', user?.userName),
          _buildInfoRow(context, 'Email', user?.email),
          _buildInfoRow(context, 'Phone', user?.phone),
          _buildInfoRow(context, 'Company Name', user?.companyName),
        ],
      ),
    );
  }

  Row _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Personal Information',
          style: context.headline.copyWith(color: context.onSurface),
        ),
        SharedChipButton(
          text: 'Edit',

          onPressed: () {
            context.read<ProfileViewModel>().onEditPressed(context);
          },
          icon: CupertinoIcons.pencil,
          backgroundColor: context.primary,
          foregroundColor: context.onPrimary,
        ),
      ],
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
