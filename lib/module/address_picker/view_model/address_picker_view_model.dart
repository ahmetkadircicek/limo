import 'dart:async';

import 'package:flutter/material.dart';
import 'package:limo/core/services/google_places_service.dart';
import 'package:limo/module/address_picker/models/address_prediction.dart';
import 'package:limo/shared/models/picked_location_model.dart';

class AddressPickerViewModel extends ChangeNotifier {
  AddressPickerViewModel({GooglePlacesService? service})
    : _service = service ?? GooglePlacesService() {
    _sessionToken = _service.newSessionToken();
  }

  final GooglePlacesService _service;
  final TextEditingController searchController = TextEditingController();

  String _sessionToken = '';
  static const String _language = 'en';

  Timer? _debounceTimer;
  Duration debounceDuration = const Duration(milliseconds: 300);
  int _requestSeq = 0;
  String _lastQuery = '';

  List<AddressPrediction> _predictions = const [];
  bool _loadingPredictions = false;
  bool _resolvingSelection = false;

  double? _selectedLat;
  double? _selectedLng;
  String? _selectedAddress;
  String? _selectedPlaceId;

  List<AddressPrediction> get predictions => _predictions;
  bool get isLoadingPredictions => _loadingPredictions;
  bool get isResolvingSelection => _resolvingSelection;

  String get _resolvedAddress =>
      _selectedAddress ?? searchController.text.trim();

  String get buttonLabel =>
      _resolvedAddress.isEmpty
          ? 'Select a location'
          : 'Use "$_resolvedAddress"';

  bool get hasSelection => _resolvedAddress.isNotEmpty;

  void onSearchChanged(String value) {
    _debounceTimer?.cancel();
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      _clearPredictions(notify: true);
      _clearSelection(retainSearch: false, notify: true);
      return;
    }
    _clearSelection(retainSearch: true, notify: true);
    // Threshold to reduce calls
    if (trimmed.length < 3) {
      _clearPredictions(notify: true);
      return;
    }
    _debounceTimer = Timer(debounceDuration + const Duration(milliseconds: 200), () {
      if (trimmed == _lastQuery) return;
      _lastQuery = trimmed;
      _fetchPredictions(trimmed);
    });
  }

  void submitFirstPrediction() {
    if (_predictions.isEmpty) return;
    selectPrediction(_predictions.first);
  }

  Future<void> selectPrediction(AddressPrediction prediction) async {
    _setResolvingSelection(true);
    final details = await _service.placeDetails(
      placeId: prediction.placeId,
      sessionToken: _sessionToken,
      language: _language,
    );

    _renewSession();
    if (details != null) {
      _applySelection(
        lat: details.lat,
        lng: details.lng,
        address: details.address,
        placeId: details.placeId,
      );
      searchController
        ..text = details.address
        ..selection = TextSelection.collapsed(offset: details.address.length);
    } else {
      _applySelection(
        address: prediction.description,
        placeId: prediction.placeId,
      );
    }

    _clearPredictions();
    _setResolvingSelection(false);
  }

  void onClearSearchTapped() {
    if (searchController.text.isEmpty) return;
    searchController.clear();
    _clearPredictions(notify: true);
    _clearSelection(retainSearch: false, notify: true);
  }

  void clearSelection() {
    searchController.clear();
    _clearPredictions(notify: true);
    _clearSelection(retainSearch: false, notify: true);
  }

  LocationModel? buildResult() {
    final name = _resolvedAddress;
    if (name.isEmpty) return null;
    return LocationModel(
      address: name,
      lat: _selectedLat,
      lng: _selectedLng,
      placeId: _selectedPlaceId,
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPredictions(String query) async {
    final seq = ++_requestSeq;
    _setLoadingPredictions(true);
    final raw = await _service.autocomplete(
      input: query,
      sessionToken: _sessionToken,
      language: _language,
      components: 'country:us',
    );
    if (seq != _requestSeq) return; // stale
    _setLoadingPredictions(false);

    _predictions = raw
        .map(AddressPrediction.fromMap)
        .where((prediction) => prediction.placeId.isNotEmpty)
        .toList(growable: false);
    notifyListeners();
  }

  void _applySelection({
    double? lat,
    double? lng,
    required String address,
    String? placeId,
  }) {
    _selectedLat = lat;
    _selectedLng = lng;
    _selectedAddress = address;
    _selectedPlaceId = placeId;
    notifyListeners();
  }

  void _clearPredictions({bool notify = false}) {
    _predictions = const [];
    _setLoadingPredictions(false);
    if (notify) notifyListeners();
  }

  void _clearSelection({required bool retainSearch, bool notify = false}) {
    if (!retainSearch) {
      _selectedAddress = null;
    }
    _selectedLat = null;
    _selectedLng = null;
    _selectedPlaceId = null;
    if (notify) notifyListeners();
  }

  void _renewSession() {
    _sessionToken = _service.newSessionToken();
  }

  void _setLoadingPredictions(bool value) {
    if (_loadingPredictions == value) return;
    _loadingPredictions = value;
    notifyListeners();
  }

  void _setResolvingSelection(bool value) {
    if (_resolvingSelection == value) return;
    _resolvingSelection = value;
    notifyListeners();
  }
}
