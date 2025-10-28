// lib/feature/address_picker/address_picker_view.dart
import 'package:flutter/material.dart';
import 'package:limo/module/address_picker/models/address_prediction.dart';
import 'package:limo/module/address_picker/view_model/address_picker_view_model.dart';
import 'package:provider/provider.dart';

class AddressPickerView extends StatelessWidget {
  const AddressPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddressPickerViewModel>(
      create: (_) => AddressPickerViewModel(),
      child: const _AddressPickerScaffold(),
    );
  }
}

class _AddressPickerScaffold extends StatelessWidget {
  const _AddressPickerScaffold();

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressPickerViewModel>(
      builder: (context, vm, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Pick a location'),
              actions: [
                if (vm.hasSelection)
                  IconButton(
                    tooltip: 'Clear',
                    onPressed: vm.clearSelection,
                    icon: const Icon(Icons.clear),
                  ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SearchField(viewModel: vm),
                  if (vm.isLoadingPredictions)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: LinearProgressIndicator(),
                    ),
                  const SizedBox(height: 12),
                  Expanded(
                    child:
                        vm.predictions.isEmpty
                            ? _EmptyState(query: vm.searchController.text)
                            : _PredictionList(
                              predictions: vm.predictions,
                              onSelected: vm.selectPrediction,
                            ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _ConfirmButton(viewModel: vm),
          ),
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.viewModel});

  final AddressPickerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: theme.colorScheme.surface,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: viewModel.searchController,
        builder: (context, value, _) {
          return TextField(
            controller: viewModel.searchController,
            decoration: InputDecoration(
              hintText: 'Search address',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  value.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: viewModel.onClearSearchTapped,
                      )
                      : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            textInputAction: TextInputAction.search,
            onChanged: viewModel.onSearchChanged,
            onSubmitted: (_) => viewModel.submitFirstPrediction(),
          );
        },
      ),
    );
  }
}

class _PredictionList extends StatelessWidget {
  const _PredictionList({required this.predictions, required this.onSelected});

  final List<AddressPrediction> predictions;
  final Future<void> Function(AddressPrediction) onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
      ),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: predictions.length,
        itemBuilder: (context, index) {
          final prediction = predictions[index];
          return ListTile(
            leading: const Icon(Icons.place_outlined),
            title: Text(
              prediction.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => onSelected(prediction),
          );
        },
        separatorBuilder: (context, _) => const Divider(height: 1),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return Center(
        child: Text('Search for a location', style: theme.textTheme.bodyMedium),
      );
    }

    return Center(
      child: Text(
        'No precise match found for "$trimmed". You can still use it as the location name.',
        style: theme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.viewModel});

  final AddressPickerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: ElevatedButton.icon(
          icon:
              viewModel.isResolvingSelection
                  ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Icon(Icons.check_circle_outline),
          label: Text(
            viewModel.buttonLabel,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onPressed:
              viewModel.hasSelection
                  ? () {
                    final result = viewModel.buildResult();
                    if (result != null) Navigator.pop(context, result);
                  }
                  : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            textStyle: theme.textTheme.labelLarge,
          ),
        ),
      ),
    );
  }
}
