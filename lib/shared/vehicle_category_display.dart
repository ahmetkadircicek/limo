import 'package:flutter/material.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/enums/vehicle_category_enum.dart';

/// Widget to display vehicle category information with design elements
class VehicleCategoryDisplay extends StatelessWidget {
  final VehicleCategory category;
  final bool showIcon;
  final bool showBadge;
  final bool showDescription;
  final bool showTier;
  final VoidCallback? onTap;
  final bool isSelected;

  const VehicleCategoryDisplay({
    super.key,
    required this.category,
    this.showIcon = true,
    this.showBadge = true,
    this.showDescription = false,
    this.showTier = true,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacing3),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withOpacity(0.2)
              : category.lightColor,
          border: Border.all(
            color: isSelected ? category.color : category.borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (showIcon) ...[
                  Icon(
                    category.icon,
                    color: category.color,
                    size: DesignTokens.iconMedium,
                  ),
                  const SizedBox(width: DesignTokens.spacing2),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.displayName,
                        style: DesignTokens.h3.copyWith(
                          color: category.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (showTier) ...[
                        const SizedBox(height: DesignTokens.spacing1),
                        _buildTierBadge(),
                      ],
                    ],
                  ),
                ),
                if (showBadge) ...[
                  const SizedBox(width: DesignTokens.spacing2),
                  _buildCategoryBadge(),
                ],
              ],
            ),
            if (showDescription) ...[
              const SizedBox(height: DesignTokens.spacing2),
              Text(
                category.description,
                style: DesignTokens.bodySmall.copyWith(
                  color: DesignTokens.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTierBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing2,
        vertical: DesignTokens.spacing1,
      ),
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: DesignTokens.iconSmall,
            color: category.color,
          ),
          const SizedBox(width: DesignTokens.spacing1),
          Text(
            'Tier ${category.tier}',
            style: DesignTokens.caption.copyWith(
              color: category.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing2,
        vertical: DesignTokens.spacing1,
      ),
      decoration: BoxDecoration(
        color: category.color,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
      child: Text(
        category.badgeText,
        style: DesignTokens.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Widget to display a list of vehicle categories
class VehicleCategoryList extends StatelessWidget {
  final List<VehicleCategory> categories;
  final VehicleCategory? selectedCategory;
  final ValueChanged<VehicleCategory>? onCategorySelected;
  final bool showDescriptions;
  final bool showTiers;

  const VehicleCategoryList({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onCategorySelected,
    this.showDescriptions = false,
    this.showTiers = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: DesignTokens.spacing2),
          child: VehicleCategoryDisplay(
            category: category,
            showDescription: showDescriptions,
            showTier: showTiers,
            isSelected: selectedCategory == category,
            onTap: onCategorySelected != null
                ? () => onCategorySelected!(category)
                : null,
          ),
        );
      },
    );
  }
}

/// Widget to display vehicle categories grouped by tier
class VehicleCategoryTierView extends StatelessWidget {
  final VehicleCategory? selectedCategory;
  final ValueChanged<VehicleCategory>? onCategorySelected;

  const VehicleCategoryTierView({
    super.key,
    this.selectedCategory,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // 5 tiers
      itemBuilder: (context, index) {
        final tier = 5 - index; // Start from tier 5 (highest)
        final tierCategories = VehicleCategory.getCategoriesByTier(tier);

        if (tierCategories.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacing3),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: _getTierColor(tier),
                    size: DesignTokens.iconMedium,
                  ),
                  const SizedBox(width: DesignTokens.spacing2),
                  Text(
                    'Tier $tier - ${_getTierName(tier)}',
                    style: DesignTokens.h3.copyWith(
                      color: _getTierColor(tier),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            ...tierCategories.map((category) => Padding(
                  padding: const EdgeInsets.only(
                    left: DesignTokens.spacing6,
                    right: DesignTokens.spacing3,
                    bottom: DesignTokens.spacing2,
                  ),
                  child: VehicleCategoryDisplay(
                    category: category,
                    showDescription: true,
                    showTier: false,
                    isSelected: selectedCategory == category,
                    onTap: onCategorySelected != null
                        ? () => onCategorySelected!(category)
                        : null,
                  ),
                )),
            if (index < 4) const Divider(height: DesignTokens.spacing6),
          ],
        );
      },
    );
  }

  Color _getTierColor(int tier) {
    switch (tier) {
      case 5:
        return Colors.amber.shade700;
      case 4:
        return Colors.blue.shade700;
      case 3:
        return Colors.green.shade700;
      case 2:
        return Colors.orange.shade700;
      case 1:
        return Colors.grey.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String _getTierName(int tier) {
    switch (tier) {
      case 5:
        return 'Ultra Premium';
      case 4:
        return 'Premium';
      case 3:
        return 'Standard';
      case 2:
        return 'Economy';
      case 1:
        return 'Basic';
      default:
        return 'Basic';
    }
  }
}

/// Widget to display vehicle category statistics
class VehicleCategoryStats extends StatelessWidget {
  const VehicleCategoryStats({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = VehicleCategory.getCategoryStats();

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        color: DesignTokens.surface200,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori İstatistikleri',
            style: DesignTokens.h2,
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Toplam Kategori',
                  '${stats['totalCategories']}',
                  Icons.category,
                  DesignTokens.accent500,
                ),
              ),
              const SizedBox(width: DesignTokens.spacing3),
              Expanded(
                child: _buildStatCard(
                  'Tier Dağılımı',
                  '5 Seviye',
                  Icons.star,
                  DesignTokens.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing3),
          Text(
            'Tier Dağılımı:',
            style: DesignTokens.h3,
          ),
          const SizedBox(height: DesignTokens.spacing2),
          ...List.generate(5, (index) {
            final tier = index + 1;
            final count = stats['tierDistribution'][tier] ?? 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacing1),
              child: Row(
                children: [
                  Text(
                    'Tier $tier:',
                    style: DesignTokens.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacing2),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: count / stats['totalCategories'],
                      backgroundColor: DesignTokens.surface200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getTierColor(tier),
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacing2),
                  Text(
                    '$count',
                    style: DesignTokens.bodySmall,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing3),
      decoration: BoxDecoration(
        color: DesignTokens.surface100,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: DesignTokens.iconLarge),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            value,
            style: DesignTokens.h2.copyWith(color: color),
          ),
          Text(
            title,
            style: DesignTokens.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getTierColor(int tier) {
    switch (tier) {
      case 5:
        return Colors.amber.shade700;
      case 4:
        return Colors.blue.shade700;
      case 3:
        return Colors.green.shade700;
      case 2:
        return Colors.orange.shade700;
      case 1:
        return Colors.grey.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}
