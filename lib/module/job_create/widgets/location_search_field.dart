import 'dart:async';

import 'package:flutter/material.dart';
import 'package:limo/core/services/google_places_service.dart';
import 'package:limo/module/address_picker/models/address_prediction.dart';
import 'package:limo/shared/models/picked_location_model.dart';
import 'package:limo/shared/widgets/form/shared_text_field.dart';

class LocationSearchField extends StatefulWidget {
  const LocationSearchField({
    super.key,
    required this.label,
    this.initialLocation,
    required this.onLocationSelected,
    this.enabled = true,
  });

  final String label;
  final LocationModel? initialLocation;
  final ValueChanged<LocationModel> onLocationSelected;
  final bool enabled;

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final GooglePlacesService _service = GooglePlacesService();
  final List<AddressPrediction> _predictions = [];
  String _sessionToken = '';
  bool _loading = false;
  bool _resolving = false;
  Timer? _debounce;
  late final AnimationController _spinController;
  int _requestSeq = 0;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialLocation?.address ?? '',
    );
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // On blur, if user typed text but didn't pick a suggestion, accept it.
        final trimmed = _controller.text.trim();
        if (trimmed.isNotEmpty) {
          _useTypedQuery();
        }
      }
    });
    _sessionToken = _service.newSessionToken();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _spinController.stop();
  }

  @override
  void didUpdateWidget(covariant LocationSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldAddress = oldWidget.initialLocation?.address;
    final newAddress = widget.initialLocation?.address;
    if (oldAddress != newAddress) {
      _controller.text = newAddress ?? '';
    } else if (oldWidget.enabled && !widget.enabled) {
      _controller.text = widget.initialLocation?.address ?? '';
    }
    if (!widget.enabled && (_predictions.isNotEmpty || _loading)) {
      setState(() {
        _predictions.clear();
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();
    final showList = widget.enabled && _predictions.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SharedTextField(
          label: widget.label,
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          onChanged: _onQueryChanged,
          onFieldSubmitted: (_) => _useTypedQuery(),
          textInputAction: TextInputAction.search,
          // Suffix animates between idle and loading (spinning location indicator)
          suffix:
              widget.enabled
                  ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder:
                          (child, anim) =>
                              FadeTransition(opacity: anim, child: child),
                      child:
                          _loading
                              ? RotationTransition(
                                key: const ValueKey('loading'),
                                turns: _spinController,
                                child: const Icon(Icons.my_location_outlined),
                              )
                              : const Icon(
                                key: ValueKey('idle'),
                                Icons.my_location_outlined,
                              ),
                    ),
                  )
                  : null,
        ),
        if (showList) const SizedBox(height: 8),
        if (showList)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(blurRadius: 8, color: Colors.black12),
                ],
              ),
              child: _buildSuggestionList(query),
            ),
          ),
      ],
    );
  }

  Widget _buildSuggestionList(String query) {
    final items = <Widget>[];

    for (var i = 0; i < _predictions.length; i++) {
      final prediction = _predictions[i];
      items.add(
        ListTile(
          leading: const Icon(Icons.place_outlined),
          title: Text(
            prediction.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => _selectPrediction(prediction),
        ),
      );
      if (i != _predictions.length - 1) {
        items.add(const Divider(height: 1));
      }
    }

    return ListView(shrinkWrap: true, children: items);
  }

  void _onQueryChanged(String value) {
    if (!widget.enabled) return;
    _debounce?.cancel();
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _predictions.clear();
        _loading = false;
      });
      return;
    }
    // Minimum 3 characters to reduce API calls
    if (trimmed.length < 3) {
      setState(() {
        _predictions.clear();
        _loading = false;
      });
      return;
    }
    // Debounce a bit more for map searches
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (trimmed == _lastQuery) return; // avoid duplicate query
      _lastQuery = trimmed;
      _fetchPredictions(trimmed);
    });
  }

  Future<void> _fetchPredictions(String query) async {
    if (!widget.enabled) return;
    final seq = ++_requestSeq;
    setState(() {
      _loading = true;
      _spinController.repeat();
    });
    final results = await _service.autocomplete(
      input: query,
      sessionToken: _sessionToken,
      language: 'en',
      components: 'country:us',
    );
    if (!mounted) return;
    if (seq != _requestSeq) return; // stale response, drop it
    setState(() {
      _predictions
        ..clear()
        ..addAll(
          results
              .map(AddressPrediction.fromMap)
              .where((prediction) => prediction.placeId.isNotEmpty),
        );
      _loading = false;
      _spinController.stop();
    });
  }

  Future<void> _selectPrediction(AddressPrediction prediction) async {
    if (!widget.enabled) return;
    setState(() {
      _resolving = true;
      _spinController.repeat();
    });
    final details = await _service.placeDetails(
      placeId: prediction.placeId,
      sessionToken: _sessionToken,
      language: 'en',
    );
    _sessionToken = _service.newSessionToken();

    if (!mounted) return;

    setState(() {
      _resolving = false;
      _predictions.clear();
      _spinController.stop();
    });

    if (details != null) {
      _controller.text = details.address;
      widget.onLocationSelected(
        LocationModel(
          address: details.address,
          lat: details.lat,
          lng: details.lng,
          placeId: details.placeId,
        ),
      );
    } else {
      _controller.text = prediction.description;
      widget.onLocationSelected(
        LocationModel(
          address: prediction.description,
          placeId: prediction.placeId,
        ),
      );
    }
  }

  void _useTypedQuery() {
    if (!widget.enabled) return;
    final trimmed = _controller.text.trim();
    if (trimmed.isEmpty || _resolving) return;
    setState(() {
      _predictions.clear();
    });
    widget.onLocationSelected(LocationModel(address: trimmed));
  }
}
