import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_search/viewmodel/job_search_view_model.dart';
import 'package:limo/shared/app_components.dart';

/// Job search view for displaying search results
class JobSearchView extends StatefulWidget {
  final String? searchQuery;

  const JobSearchView({super.key, this.searchQuery});

  @override
  State<JobSearchView> createState() => _JobSearchViewState();
}

class _JobSearchViewState extends State<JobSearchView> {
  late final JobSearchViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = JobSearchViewModel();
    if (widget.searchQuery != null) {
      _searchController.text = widget.searchQuery!;
      _viewModel.initializeSearch(widget.searchQuery!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      appBar: AppAppBar.secondary(title: 'Search Jobs'),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchSection(),
            Expanded(child: _buildSearchResults()),
          ],
        ),
      ),
    );
  }

  /// Build the search section with search field and clear button
  Widget _buildSearchSection() {
    return Container(
      padding: EdgeInsets.all(context.spacingL),
      child: AppCard.primary(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: context.spacingL,
          children: [
            // Header section with title and search info
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: context.spacingS,
                    children: [
                      AppText.heading('Search Jobs'),
                      AppText.bodySmall(
                        _viewModel.searchQuery.isEmpty
                            ? 'Enter keywords to find jobs'
                            : '${_viewModel.searchResults.length} results found',
                        color: context.textSecondary,
                      ),
                    ],
                  ),
                ),
                AppButton.chip(
                  'Clear',
                  onPressed: () => _clearSearch(),
                  icon: Icons.close,
                ),
              ],
            ),
            // Search input
            AppInput.search(
              hintText: 'Search jobs...',
              controller: _searchController,
              onSubmitted: (value) => _performSearch(),
              onSuffixIconTap: _performSearch,
            ),
          ],
        ),
      ),
    );
  }

  /// Perform search
  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _viewModel.initializeSearch(query);
      setState(() {});
    }
  }

  /// Clear search and reset results
  void _clearSearch() {
    _searchController.clear();
    _viewModel.clearSearch();
    setState(() {});
  }

  /// Build the search results section
  Widget _buildSearchResults() {
    if (_viewModel.searchQuery.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: context.onSurface.withValues(alpha: 0.5),
            ),
            SizedBox(height: context.spacingM),
            Text(
              'Enter a search term to find jobs',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Search results for: ${_viewModel.searchQuery}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: context.spacingM),
          Text(
            'Found ${_viewModel.searchResults.length} results',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
