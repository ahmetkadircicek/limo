import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/feature/map/models/location_model.dart';
import 'package:soforvarcom/feature/map/services/location_service.dart';
import 'package:soforvarcom/shared/elevated_material.dart';
import 'package:soforvarcom/shared/general_button.dart';
import 'package:soforvarcom/shared/general_text.dart';
import 'package:soforvarcom/shared/general_text_field.dart';

class LocationPicker extends StatefulWidget {
  final String title;
  final LocationModel? initialLocation;
  final Function(LocationModel) onLocationSelected;

  const LocationPicker({
    super.key,
    required this.title,
    this.initialLocation,
    required this.onLocationSelected,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  LocationModel? _selectedLocation;
  List<LocationModel> _searchResults = [];
  bool _isSearching = false;
  bool _isLoadingCurrentLocation = false;
  Timer? _debounceTimer;

  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(39.9334, 32.8597), // Ankara, Turkey
    zoom: 10,
  );

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _addMarker(_selectedLocation!);
    }
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_selectedLocation != null) {
      _animateToLocation(_selectedLocation!);
    }
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _searchPlaces(_searchController.text);
      } else {
        setState(() {
          _searchResults.clear();
        });
      }
    });
  }

  Future<void> _searchPlaces(String query) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final results = await LocationService.searchPlaces(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
    }
  }

  void _onMapTap(LatLng position) async {
    final location = await LocationService.getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (location != null) {
      setState(() {
        _selectedLocation = location;
        _addMarker(location);
      });
      _animateToLocation(location);
    }
  }

  void _addMarker(LocationModel location) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: location.placeName,
            snippet: location.address,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  void _animateToLocation(LocationModel location) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 15,
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingCurrentLocation = true;
    });

    try {
      final location = await LocationService.getCurrentLocation();
      if (location != null) {
        setState(() {
          _selectedLocation = location;
          _addMarker(location);
        });
        _animateToLocation(location);
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoadingCurrentLocation = false;
      });
    }
  }

  void _selectSearchResult(LocationModel location) {
    setState(() {
      _selectedLocation = location;
      _searchResults.clear();
      _searchController.clear();
      _addMarker(location);
    });
    _animateToLocation(location);
  }

  void _confirmSelection() {
    if (_selectedLocation != null) {
      widget.onLocationSelected(_selectedLocation!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GeneralText(
          text: widget.title,
          fontSize: GeneralConstants.fontSizeMedium,
          fontWeight: GeneralConstants.fontWeightMedium,
        ),
        backgroundColor: context.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Google Map (Full Screen)
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _selectedLocation != null
                ? CameraPosition(
                    target: LatLng(_selectedLocation!.latitude,
                        _selectedLocation!.longitude),
                    zoom: 15,
                  )
                : _defaultPosition,
            markers: _markers,
            onTap: _onMapTap,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Search Bar and Results
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                ElevatedMaterial(
                  child: Row(
                    children: [
                      Expanded(
                        child: GeneralTextField(
                          controller: _searchController,
                          hintText: 'Search for a location...',
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                      context.spacerWidth(1),
                      SizedBox(
                        width: 50,
                        height: GeneralConstants.heightMedium,
                        child: _isLoadingCurrentLocation
                            ? Container(
                                decoration: BoxDecoration(
                                  color: context.primary,
                                  borderRadius: GeneralConstants.borderRadius,
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              )
                            : GeneralButton(
                                onPressed: _getCurrentLocation,
                                color: context.primary,
                                text: '',
                                fontSize: GeneralConstants.fontSizeSmall,
                                icon: Icon(Icons.my_location,
                                    color: context.onPrimary, size: 20),
                              ),
                      ),
                    ],
                  ),
                ),

                // Search Results
                if (_searchResults.isNotEmpty || _isSearching)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ElevatedMaterial(
                      child: _isSearching
                          ? const Padding(
                              padding: PaddingConstants.allMedium,
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final location = _searchResults[index];
                                return ListTile(
                                  leading: Icon(Icons.location_on,
                                      color: context.primary),
                                  title: GeneralText(
                                    text: location.placeName,
                                    fontSize: GeneralConstants.fontSizeSmall,
                                    fontWeight:
                                        GeneralConstants.fontWeightMedium,
                                  ),
                                  subtitle: GeneralText(
                                    text: location.address,
                                    fontSize:
                                        GeneralConstants.fontSizeExtraSmall,
                                    fontWeight:
                                        GeneralConstants.fontWeightLight,
                                  ),
                                  onTap: () => _selectSearchResult(location),
                                );
                              },
                            ),
                    ),
                  ),
              ],
            ),
          ),

          // Selected Location Info and Confirm Button
          if (_selectedLocation != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedMaterial(
                child: Padding(
                  padding: PaddingConstants.allMedium,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: context.primary),
                          context.spacerWidth(1),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GeneralText(
                                  text: _selectedLocation!.placeName,
                                  fontSize: GeneralConstants.fontSizeSmall,
                                  fontWeight: GeneralConstants.fontWeightMedium,
                                ),
                                GeneralText(
                                  text: _selectedLocation!.address,
                                  fontSize: GeneralConstants.fontSizeExtraSmall,
                                  fontWeight: GeneralConstants.fontWeightLight,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      context.spacerHeight(2),
                      SizedBox(
                        width: double.infinity,
                        height: GeneralConstants.heightMedium,
                        child: GeneralButton(
                          text: 'Confirm Location',
                          fontSize: GeneralConstants.fontSizeSmall,
                          color: context.primary,
                          onPressed: _confirmSelection,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
