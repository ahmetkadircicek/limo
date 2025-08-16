import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_input.dart';
import 'package:limo/shared/app_text.dart';

/// Header widget for job list with title, count, search, and filter
class JobListHeaderWidget extends StatelessWidget {
  final int jobCount;
  final TextEditingController searchController;
  final VoidCallback onFilterTap;

  const JobListHeaderWidget({
    super.key,
    required this.jobCount,
    required this.searchController,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        context.spacingL,
        context.spacingL,
        context.spacingL,
        0,
      ),
      decoration: _buildHeaderCardDecoration(context),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.spacingL,
          context.spacingL,
          context.spacingL,
          context.spacingXl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderTitleSection(context),
            SizedBox(height: context.spacingL),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  /// Build the header card decoration with theme-aware colors
  BoxDecoration _buildHeaderCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.surface,
      borderRadius: context.radiusLarge,
      boxShadow: [
        BoxShadow(
          color: context.onSurface.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Build the header title section with title and filter button
  Widget _buildHeaderTitleSection(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildTitleAndCount(context)),
        _buildFilterButton(context),
      ],
    );
  }

  /// Build the title and job count display
  Widget _buildTitleAndCount(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.heading('Available Jobs', color: context.onSurface),
        SizedBox(height: context.spacingXs),
        AppText.bodySmall(
          '$jobCount jobs found',
          color: context.onSurface.withValues(alpha: 0.6),
        ),
      ],
    );
  }

  /// Build the filter button with theme-aware styling
  Widget _buildFilterButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Filtering feature will be added soon'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
        borderRadius: context.radiusMedium,
        child: Container(
          padding: context.paddingM,
          decoration: BoxDecoration(
            color: context.surfaceContainer,
            borderRadius: context.radiusMedium,
          ),
          child: Icon(
            Icons.tune,
            color: context.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  /// Build the search bar input field
  Widget _buildSearchBar() {
    return AppInput.primary(
      labelText: 'Search',
      controller: searchController,
      hintText: 'City, route or company...',
    );
  }
}
