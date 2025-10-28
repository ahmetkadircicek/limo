import 'dart:async';

import 'package:flutter/material.dart';
import 'package:limo/core/services/google_places_service.dart';
import 'package:limo/module/address_picker/models/address_prediction.dart';
import 'package:limo/shared/models/picked_location_model.dart';

Future<PickedLocation?> showLocationSearchSheet(
  BuildContext context, {
  String? initialQuery,
}) {
  return showModalBottomSheet<PickedLocation>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _LocationSearchSheet(initialQuery: initialQuery),
  );
}

class _LocationSearchSheet extends StatefulWidget {
  const _LocationSearchSheet({this.initialQuery});

  final String? initialQuery;

  @override
  State<_LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<_LocationSearchSheet> {
  late final TextEditingController _controller;
  final GooglePlacesService _service = GooglePlacesService();
  final List<AddressPrediction> _predictions = [];
  String _sessionToken = '';
  bool _loading = false;
  bool _resolving = false;
  Timer? _debounce;
  int _requestSeq = 0;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    _sessionToken = _service.newSessionToken();
    final initial = _controller.text.trim();
    if (initial.isNotEmpty) {
      _fetchPredictions(initial);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Search location',
                        hintText: 'Type to find a place',
                        prefixIcon: Icon(Icons.search),
                      ),
                      textInputAction: TextInputAction.search,
                      onChanged: _onSearchChanged,
                      onSubmitted: (_) => _submitFirstPrediction(),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.clear),
                    onPressed:
                        _controller.text.isEmpty
                            ? null
                            : () {
                              setState(() {
                                _controller.clear();
                                _predictions.clear();
                              });
                            },
                  ),
                ],
              ),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: LinearProgressIndicator(),
                ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child:
                    _predictions.isEmpty
                        ? _EmptyState(query: _controller.text)
                        : ListView.separated(
                          shrinkWrap: true,
                          itemCount: _predictions.length,
                          separatorBuilder:
                              (context, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final prediction = _predictions[index];
                            return ListTile(
                              leading: const Icon(Icons.place_outlined),
                              title: Text(
                                prediction.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () => _selectPrediction(prediction),
                            );
                          },
                        ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed:
                    _resolving
                        ? null
                        : () {
                          final name = _controller.text.trim();
                          if (name.isEmpty) return;
                          Navigator.of(
                            context,
                          ).pop(PickedLocation(address: name));
                        },
                icon:
                    _resolving
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.check_circle_outline),
                label: Text(
                  _controller.text.trim().isEmpty
                      ? 'Select a location'
                      : 'Use "${_controller.text.trim()}"',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _predictions.clear();
        _loading = false;
      });
      return;
    }
    if (trimmed.length < 3) {
      setState(() {
        _predictions.clear();
        _loading = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (trimmed == _lastQuery) return;
      _lastQuery = trimmed;
      _fetchPredictions(trimmed);
    });
  }

  void _submitFirstPrediction() {
    if (_predictions.isNotEmpty) {
      _selectPrediction(_predictions.first);
    }
  }

  Future<void> _fetchPredictions(String query) async {
    final seq = ++_requestSeq;
    setState(() {
      _loading = true;
    });
    final results = await _service.autocomplete(
      input: query,
      sessionToken: _sessionToken,
      language: 'en',
      components: 'country:us',
    );
    if (!mounted) return;
    if (seq != _requestSeq) return;
    setState(() {
      _predictions
        ..clear()
        ..addAll(
          results
              .map(AddressPrediction.fromMap)
              .where((prediction) => prediction.placeId.isNotEmpty),
        );
      _loading = false;
    });
  }

  Future<void> _selectPrediction(AddressPrediction prediction) async {
    setState(() {
      _resolving = true;
    });
    final details = await _service.placeDetails(
      placeId: prediction.placeId,
      sessionToken: _sessionToken,
      language: 'en',
    );
    _sessionToken = _service.newSessionToken();

    if (!mounted) return;

    if (details != null) {
      Navigator.of(context).pop(
        PickedLocation(
          address: details.address,
          lat: details.lat,
          lng: details.lng,
          placeId: details.placeId,
        ),
      );
    } else {
      Navigator.of(context).pop(
        PickedLocation(
          address: prediction.description,
          placeId: prediction.placeId,
        ),
      );
    }
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
        'No results for "$trimmed". You can still use it as the location name.',
        style: theme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
