part of '../view/job_create_view.dart';

class _CarRequirementsSection extends StatelessWidget {
  const _CarRequirementsSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobCreateViewModel>();
    final cars = vm.carRequirements;

    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: PaddingConstants.p20,
        children: [
          _Header(onAddPressed: () => vm.onAddCarRequirement(context)),
          if (cars.isEmpty)
            const _AnyCarTile()
          else
            ...cars.asMap().entries.map(
              (entry) => _CarRequirementTile(
                index: entry.key,
                car: entry.value,
                onRemove: () => vm.removeCarRequirement(entry.key),
              ),
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onAddPressed});

  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Car Requirements',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        OutlinedButton.icon(
          onPressed: onAddPressed,
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
      ],
    );
  }
}

class _AnyCarTile extends StatelessWidget {
  const _AnyCarTile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 60,
      padding: PaddingConstants.horizontal12,
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: RadiusConstants.standard,
        border: Border.all(color: context.outline.withValues(alpha: 0.2)),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        'Any vehicle',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: context.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _CarRequirementTile extends StatelessWidget {
  const _CarRequirementTile({
    required this.index,
    required this.car,
    required this.onRemove,
  });

  final int index;
  final CarRequirementModel car;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 60,
      padding: PaddingConstants.horizontal12,
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: RadiusConstants.standard,
        border: Border.all(color: context.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Builder(
                  builder: (_) {
                    final brandProvider = context.read<BrandProvider>();
                    final categoryProvider = context.read<CategoryProvider>();
                    final modelProvider = context.read<ModelProvider>();
                    final brands = brandProvider.brands;
                    final categories = categoryProvider.categories;
                    final models = modelProvider.models;
                    final currentBrandId = modelProvider.currentBrandId;

                    final brandName = brands
                        .firstWhere(
                          (b) => b.brandId == car.brandId,
                          orElse: () => BrandModel(),
                        )
                        .brandName;

                    String? modelName;
                    if (currentBrandId == car.brandId && models.isNotEmpty) {
                      modelName = models
                          .firstWhere(
                            (m) => m.modelId == car.modelId,
                            orElse: () => ModelModel(),
                          )
                          .modelName;
                    }

                    final categoryName = categories
                        .firstWhere(
                          (c) => c.categoryId == car.categoryId,
                          orElse: () => CategoryModel(),
                        )
                        .categoryName;

                    final title = [
                      brandName ?? '#${car.brandId}',
                      modelName ?? '#${car.modelId}',
                      categoryName ?? '#${car.categoryId}',
                    ].join(' • ');

                    return Text(
                      title,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
                Text(
                  '${car.capacity} seats • ${car.modelYear} • Mile: \$${car.mileFee} • Hour: \$${car.hourlyFee}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: context.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Remove vehicle requirement',
          ),
        ],
      ),
    );
  }
}
