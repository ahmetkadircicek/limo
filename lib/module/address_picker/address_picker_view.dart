// lib/feature/address_picker/address_picker_view.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:limo/module/address_picker/services/google_places_service.dart';
import 'package:limo/shared/constants/widget_constants.dart';
import 'package:limo/shared/models/picked_location_model.dart';

class AddressPickerView extends StatefulWidget {
  const AddressPickerView({super.key});

  @override
  State<AddressPickerView> createState() => _AddressPickerViewState();
}

class _AddressPickerViewState extends State<AddressPickerView> {
  // static const _apiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Removed unused field
  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(41.0082, 28.9784),
    zoom: 12,
  );

  /// UI / servis
  late final GooglePlacesService _svc;
  late String _sessionToken;
  final _searchCtrl = TextEditingController();
  final _debounce = const Duration(milliseconds: 300);
  Timer? _timer;

  GoogleMapController? _mapCtrl;

  /// State
  List<Map<String, dynamic>> _predictions = [];
  Marker? _marker;
  LatLng? _pickedLatLng;
  String? _pickedAddress;
  String? _pickedPlaceId;

  /// Dil (istiyorsan sabit 'en' yerine Locale’den çekip kullanabilirsin)
  static const _language = 'en';

  @override
  void initState() {
    super.initState();
    _svc = GooglePlacesService();
    _sessionToken = _svc.newSessionToken();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchCtrl.dispose();
    _mapCtrl = null;
    super.dispose();
  }

  void _renewSession() {
    _sessionToken = _svc.newSessionToken();
  }

  // ————— Autocomplete —————
  void _onSearchChanged(String v) {
    _timer?.cancel();
    _timer = Timer(_debounce, () async {
      if (!mounted) return;
      final q = v.trim();
      if (q.isEmpty) {
        setState(() => _predictions = []);
        return;
      }
      final list = await _svc.autocomplete(
        input: q,
        sessionToken: _sessionToken,
        language: _language,
        types: 'geocode',
      );
      if (!mounted) return;
      setState(() => _predictions = list);
    });
  }

  Future<void> _pickFromPrediction(Map<String, dynamic> p) async {
    FocusScope.of(context).unfocus();
    final placeId = p['place_id'] as String?;
    if (placeId == null) return;

    final d = await _svc.placeDetails(
      placeId: placeId,
      sessionToken: _sessionToken,
      language: _language,
    );

    // Yeni arama için session yenile (Google önerisi)
    _renewSession();

    if (!mounted || d == null) return;

    final pos = LatLng(d.lat, d.lng);
    _moveAndMark(pos, d.address, placeId: d.placeId);

    setState(() {
      _searchCtrl.text = d.address;
      _predictions = [];
    });
  }

  // ————— Haritadan seçim —————
  Future<void> _onMapTap(LatLng pos) async {
    FocusScope.of(context).unfocus();
    setState(() => _predictions = []);

    final g = await _svc.reverseGeocode(lat: pos.latitude, lng: pos.longitude);
    final addr = g?.formattedAddress ?? 'Selected location';
    _moveAndMark(pos, addr, placeId: g?.placeId);
  }

  void _moveAndMark(LatLng pos, String address, {String? placeId}) {
    _mapCtrl?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 16)),
    );
    setState(() {
      _pickedLatLng = pos;
      _pickedAddress = address;
      _pickedPlaceId = placeId;
      _marker = Marker(
        markerId: const MarkerId('picked'),
        position: pos,
        infoWindow: InfoWindow(title: address),
      );
    });
  }

  void _confirm() {
    if (_pickedLatLng == null || _pickedAddress == null) return;

    final model = PickedLocation(
      address: _pickedAddress!,
      lat: _pickedLatLng!.latitude,
      lng: _pickedLatLng!.longitude,
      placeId: _pickedPlaceId,
    );

    Navigator.pop(context, model);
  }

  void _clearSelection() {
    setState(() {
      _pickedLatLng = null;
      _pickedAddress = null;
      _pickedPlaceId = null;
      _marker = null;
      _searchCtrl.clear();
      _predictions = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final markers = _marker != null ? {_marker!} : <Marker>{};

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pick a location'),
          actions: [
            if (_pickedLatLng != null)
              IconButton(
                tooltip: 'Clear',
                onPressed: _clearSelection,
                icon: const Icon(Icons.clear),
              ),
          ],
        ),
        body: Stack(
          children: [
            // Tam ekran harita
            GoogleMap(
              initialCameraPosition: _initialCamera,
              onMapCreated: (c) => _mapCtrl = c,
              onTap: _onMapTap,
              markers: markers,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              zoomControlsEnabled: false,
            ),

            // Üstte arama + tahmin listesi
            Positioned(
              left: 16,
              right: 16,
              top: 16,
              child: Column(
                children: [
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: WidgetConstants.formFieldHeight,
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Search address',
                          prefixIcon: const Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                        textInputAction: TextInputAction.search,
                        onChanged: _onSearchChanged,
                        onSubmitted: (_) {
                          if (_predictions.isNotEmpty) {
                            _pickFromPrediction(_predictions.first);
                          }
                        },
                      ),
                    ),
                  ),
                  if (_predictions.isNotEmpty)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 260),
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(blurRadius: 8, color: Colors.black12),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _predictions.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final p = _predictions[i];
                            return ListTile(
                              leading: const Icon(Icons.place_outlined),
                              title: Text(
                                p['description'] ?? '-',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () => _pickFromPrediction(p),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Altta onay butonu
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: SafeArea(
                top: false,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(
                    _pickedAddress ?? 'Select this location',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: (_pickedLatLng != null) ? _confirm : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    textStyle: theme.textTheme.labelLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
