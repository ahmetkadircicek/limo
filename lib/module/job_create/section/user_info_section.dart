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
          Text('User Information', style: context.callout),
          SharedReadOnlyField(label: 'User Name', value: viewModel.userName),
          SharedReadOnlyField(label: 'Company', value: viewModel.companyName),
          SharedReadOnlyField(
            label: 'Contact Info',
            value: viewModel.maskedContactInfo,
            trailing:
                (viewModel.contactInfo == null ||
                        viewModel.contactInfo!.isEmpty)
                    ? null
                    : IconButton(
                      icon: Icon(
                        viewModel.shareNumber
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      tooltip:
                          viewModel.shareNumber
                              ? 'Hide contact info'
                              : 'Show contact info',
                      onPressed: viewModel.toggleShareNumber,
                    ),
          ),
        ],
      ),
    );
  }
}
