part of '../view/job_create_view.dart';

class _UserInfoSection extends StatelessWidget {
  const _UserInfoSection();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<JobCreateViewModel>();
    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: PaddingConstants.p20,
        children: [
          Text(
            'User Information',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SharedSelectableField(
            label: 'User Name',
            value: viewModel.userName,
            enabled: false,
          ),
          SharedSelectableField(
            label: 'Company',
            value: viewModel.companyName,
            enabled: false,
          ),
          SharedSelectableField(
            label: 'Contact Info',
            value: viewModel.contactInfo,
            enabled: false,
          ),
        ],
      ),
    );
  }
}
