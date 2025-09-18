part of '../view/job_create_view.dart';

class _UserInfoSection extends StatelessWidget {
  const _UserInfoSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobCreateViewModel>();
    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: PaddingConstants.p12,
        children: [
          Text('User', style: Theme.of(context).textTheme.titleMedium),
          _ReadonlyField(label: 'User Name', value: vm.userName),
          _ReadonlyField(label: 'Company', value: vm.companyName),
          _ReadonlyField(label: 'Contact Info', value: vm.contactInfo),
        ],
      ),
    );
  }
}

class _ReadonlyField extends StatelessWidget {
  final String label;
  final String? value;

  const _ReadonlyField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final displayValue = value != null && value!.isNotEmpty ? value! : '-';

    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      child: Text(
        displayValue,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color:
              displayValue != '-'
                  ? Theme.of(context).textTheme.bodyMedium?.color
                  : Theme.of(context).hintColor,
        ),
      ),
    );
  }
}
