part of '../view/job_create_view.dart';

class _JobDetailsSection extends StatelessWidget {
  final String? Function(JobTypeModel?) jobTypeValidator;

  const _JobDetailsSection({required this.jobTypeValidator});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobCreateViewModel>();
    final theme = Theme.of(context);
    final pickup = vm.job.pickupDate;
    final dropoff = vm.job.dropoffDate;
    final requiresDropoff = vm.requiresDropoff;
    // final dropoffDateEnabled = requiresDropoff && pickup != null; // TODO: may use to disable dropoff input

    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: PaddingConstants.p20,
        children: [
          // Move section title to the top
          Text('Job Details', style: theme.textTheme.titleMedium),
          SharedTextField(
            key: ValueKey('job-title-${vm.formVersion}'),
            label: 'Job Title',
            initialValue: vm.job.title ?? '',
            onChanged: vm.setTitle,
            textInputAction: TextInputAction.next,
            isRequired: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Job title is required';
              }
              return null;
            },
          ),
          SharedTextField(
            key: ValueKey('job-description-${vm.formVersion}'),
            label: 'Description',
            initialValue: vm.job.description ?? '',
            onChanged: vm.setDescription,
            keyboardType: TextInputType.multiline,
            maxLines: 6,
            isRequired: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Description is required';
              }
              return null;
            },
          ),
          // Job Type
          Consumer<JobTypeProvider>(
            builder: (_, p, _) {
              return SharedAsyncStatusBuilder(
                status: p.status,
                errorMessage: p.errorMessage,
                idleBuilder:
                    (_) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                loadingBuilder:
                    (_) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                emptyBuilder:
                    (_) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('No job types available'),
                    ),
                errorBuilder:
                    (ctx, message) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            message ?? 'Failed to load job types.',
                            style: Theme.of(ctx).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed:
                                  () => ctx
                                      .read<JobTypeProvider>()
                                      .loadJobTypes(ctx),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ),
                        ],
                      ),
                    ),
                successBuilder: (_) {
                  final items =
                      p.jobTypes
                          .where(
                            (e) =>
                                e.jobTypeName.trim().isNotEmpty &&
                                e.jobTypeName != '-',
                          )
                          .toList();

                  final jobTypeValue =
                      _matchJobType(items, vm.selectedJobType) ??
                      _matchJobType(items, p.selected) ??
                      (items.isNotEmpty ? items.first : null);

                  if (jobTypeValue != null &&
                      vm.selectedJobType?.jobTypeId != jobTypeValue.jobTypeId) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      vm.setJobType(jobTypeValue, resetForm: false);
                    });
                  }

                  return SharedDropdownField<JobTypeModel>(
                    label: 'Job Type',
                    items: items,
                    value: jobTypeValue,
                    itemLabelBuilder: (type) => type.jobTypeName,
                    isRequired: true,
                    onChanged: (type) {
                      Provider.of<JobTypeProvider>(
                        context,
                        listen: false,
                      ).select(type);
                      vm.setJobType(type, resetForm: true);
                    },
                    validator: jobTypeValidator,
                  );
                },
              );
            },
          ),

          // Pickup Date
          _DateField(
            label: 'Pickup Date & Time',
            value: pickup,
            onPick: () async {
              final picked = await _pickDateTime(context, initial: pickup);
              if (picked != null) vm.setPickupDate(picked);
            },
            isRequired: true,
          ),

          LocationSearchField(
            key: ValueKey('pickup-location-${vm.formVersion}'),
            label: 'Pickup Location',
            initialLocation: vm.job.pickupLocation,
            onLocationSelected: vm.setPickupLocation,
          ),
          if (requiresDropoff) ...[
            _DateField(
              label: 'Dropoff Date & Time',
              value: dropoff,
              onPick: () async {
                final picked = await _pickDateTime(
                  context,
                  initial: dropoff ?? pickup,
                  firstDate: pickup,
                );
                if (picked != null) vm.setDropoffDate(picked);
              },
              // Match pickup required styling so hint colors are consistent
              isRequired: true,
            ),
            LocationSearchField(
              key: ValueKey('dropoff-location-${vm.formVersion}'),
              label: 'Dropoff Location',
              initialLocation: vm.job.dropoffLocation,
              onLocationSelected: vm.setDropoffLocation,
            ),
          ],
        ],
      ),
    );
  }
}

JobTypeModel? _matchJobType(List<JobTypeModel> items, JobTypeModel? target) {
  if (target == null) return null;
  for (final item in items) {
    if (item.jobTypeId == target.jobTypeId) {
      return item;
    }
  }
  return null;
}
