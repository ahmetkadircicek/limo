import 'package:flutter/cupertino.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/widgets/form/shared_read_only_field.dart';
import 'package:provider/provider.dart';

class PersonalInfoWidget extends StatelessWidget {
  const PersonalInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Column(
      spacing: PaddingConstants.p16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SharedReadOnlyField(label: 'Full Name', value: user?.userName),
        SharedReadOnlyField(label: 'Email', value: user?.email),
        SharedReadOnlyField(label: 'Phone', value: user?.phone),
        SharedReadOnlyField(label: 'Company Name', value: user?.companyName),
      ],
    );
  }
}
