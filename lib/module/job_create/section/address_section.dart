part of '../view/job_create_view.dart';

class _LocationsSection extends StatelessWidget {
  const _LocationsSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobCreateViewModel>();

    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: PaddingConstants.p12,
        children: [
          Text('Locations', style: Theme.of(context).textTheme.titleMedium),

          // Pickup (JobModel pickupLocation: String?)
          _LocationField(
            label: 'Pickup Location',
            value: vm.job.pickupLocation,
            onPick: () async {
              final picked = await Navigator.push<PickedLocation>(
                context,
                MaterialPageRoute(builder: (_) => const AddressPickerView()),
              );
              if (picked != null) {
                vm.setPickupLocation(
                  picked.address,
                ); // VM: setPickupLocation(String)
              }
            },
          ),

          // Dropoff (JobModel dropoffLocation: String?)
          _LocationField(
            label: 'Dropoff Location',
            value: vm.job.dropoffLocation,
            onPick: () async {
              final picked = await Navigator.push<PickedLocation>(
                context,
                MaterialPageRoute(builder: (_) => const AddressPickerView()),
              );
              if (picked != null) {
                vm.setDropoffLocation(
                  picked.address,
                ); // VM: setDropoffLocation(String)
              }
            },
          ),
        ],
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onPick;

  const _LocationField({
    required this.label,
    required this.value,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return Row(
      children: [
        Expanded(
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
            child: Text(
              hasValue ? value! : 'Select $label',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    hasValue
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).hintColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 48,
          child: OutlinedButton.icon(
            onPressed: onPick,
            icon: const Icon(Icons.place_outlined),
            label: Text(hasValue ? 'Change' : 'Pick'),
          ),
        ),
      ],
    );
  }
}
