part of '../view/job_create_view.dart';

class _JobDetailsSection extends StatelessWidget {
  const _JobDetailsSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobCreateViewModel>();
    final theme = Theme.of(context);
    final pickup = vm.job.pickupDate;
    final dropoff = vm.job.dropoffDate;

    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: PaddingConstants.p12,
        children: [
          Text('Job Details', style: theme.textTheme.titleMedium),

          // Job Type
          Consumer<JobTypeProvider>(
            builder: (_, p, __) {
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

              return DropdownButtonFormField<String>(
                initialValue: vm.job.jobType, // model-tabanlı
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Job Type',
                  border: OutlineInputBorder(),
                ),
                items:
                    items
                        .map(
                          (name) =>
                              DropdownMenuItem(value: name, child: Text(name)),
                        )
                        .toList(),
                onChanged: vm.setJobType, // String? alıyor
                validator:
                    (v) =>
                        v == null || v.isEmpty
                            ? 'Please select job type'
                            : null,
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
        ],
      ),
    );
  }
}
