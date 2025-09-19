part of '../view/job_create_view.dart';

class _JobDetailsSection extends StatelessWidget {
  final String? Function(String?) jobTypeValidator;

  const _JobDetailsSection({required this.jobTypeValidator});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobCreateViewModel>();
    final theme = Theme.of(context);
    final pickup = vm.job.pickupDate;
    final dropoff = vm.job.dropoffDate;

    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: PaddingConstants.p20,
        children: [
          Text('Job Details', style: theme.textTheme.titleMedium),
          // Job Type
          Consumer<JobTypeProvider>(
            builder: (_, p, _) {
              if (p.loading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final items =
                  p.jobTypes
                      .map((e) => e.jobTypeName)
                      .where((s) => s.trim().isNotEmpty && s != '-')
                      .cast<String>()
                      .toList();

              return SharedDropdownField<String>(
                label: 'Job Type',
                items: items,
                value: vm.job.jobType,
                itemLabelBuilder: (name) => name,
                onChanged: vm.setJobType,
                validator: jobTypeValidator,
                menuMaxHeight: 240,
              );
            },
          ),

          // Pickup Date
          _DateField(
            label: 'Pickup Date',
            value: pickup,
            onPick: () async {
              final picked = await _pickDate(context, initial: pickup);
              if (picked != null) vm.setPickupDate(picked);
            },
          ),

          // Dropoff Date (pickup olmadan seçilemesin)
          Opacity(
            opacity: pickup == null ? 0.6 : 1,
            child: IgnorePointer(
              ignoring: pickup == null,
              child: _DateField(
                label: 'Dropoff Date',
                value: dropoff,
                onPick: () async {
                  final picked = await _pickDate(
                    context,
                    initial: dropoff ?? pickup,
                    firstDate: pickup, // pickup'tan önce olmasın
                  );
                  if (picked != null) vm.setDropoffDate(picked);
                },
              ),
            ),
          ),

          SharedSelectableField(
            label: 'Pickup Location',
            value: vm.job.pickupLocation,
            placeholder: 'Select pickup location',
            onTap: () async {
              final picked = await Navigator.push<PickedLocation>(
                context,
                MaterialPageRoute(builder: (_) => const AddressPickerView()),
              );
              if (picked != null) {
                vm.setPickupLocation(picked.address);
              }
            },
          ),
          SharedSelectableField(
            label: 'Dropoff Location',
            value: vm.job.dropoffLocation,
            placeholder: 'Select dropoff location',
            onTap: () async {
              final picked = await Navigator.push<PickedLocation>(
                context,
                MaterialPageRoute(builder: (_) => const AddressPickerView()),
              );
              if (picked != null) {
                vm.setDropoffLocation(picked.address);
              }
            },
          ),
        ],
      ),
    );
  }
}
