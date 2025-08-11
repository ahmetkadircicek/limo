import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/map/models/location_model.dart';
import 'package:limo/feature/map/services/location_service.dart';
import 'package:limo/shared/app_components.dart';

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
      // Don't clear search results immediately - keep them visible
      _addMarker(location);
    });
    _animateToLocation(location);
  }

  void _confirmSelection() {
    if (_selectedLocation != null) {
      // Clear search results and controller when confirming
      setState(() {
        _searchResults.clear();
        _searchController.clear();
      });
      widget.onLocationSelected(_selectedLocation!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.body(
          widget.title,
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
                AppCard.primary(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                16), // Daha yuvarlak köşeler
                            border: Border.all(
                              color: context.onSurface.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search for a location...',
                              hintStyle: TextStyle(
                                color: context.onSurface.withOpacity(0.5),
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: context.primary,
                                size: 24,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              color: context.onSurface,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: _isLoadingCurrentLocation
                            ? Container(
                                decoration: BoxDecoration(
                                  color: context.primary,
                                  borderRadius: BorderRadius.circular(12),
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
                            : IconButton(
                                onPressed: _getCurrentLocation,
                                icon: Icon(
                                  Icons.my_location,
                                  color: context.primary,
                                  size: 24,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      context.primary.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),

                // Search Results
                if (_searchResults.isNotEmpty || _isSearching)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    constraints: const BoxConstraints(maxHeight: 350),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: GeneralConstants
                          .borderRadius, // Daha yuvarlak köşeler
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: GeneralConstants
                          .borderRadius, // Daha yuvarlak köşeler
                      child: _isSearching
                          ? const Padding(
                              padding: PaddingConstants.allMedium,
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        size: 20,
                                        color: context.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Search Results (${_searchResults.length})',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: context.onSurface,
                                        ),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _searchResults.clear();
                                            _searchController.clear();
                                          });
                                        },
                                        child: Text(
                                          'Clear',
                                          style: TextStyle(
                                            color: context.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _searchResults.length,
                                  itemBuilder: (context, index) {
                                    final location = _searchResults[index];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            16), // Daha yuvarlak köşeler
                                        border: Border.all(
                                          color: context.onSurface
                                              .withOpacity(0.1),
                                          width: 1,
                                        ),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(12),
                                        leading: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: context.primary
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.location_on,
                                            color: context.primary,
                                            size: 20,
                                          ),
                                        ),
                                        title: Text(
                                          location.placeName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: context.onSurface,
                                          ),
                                        ),
                                        subtitle: Text(
                                          location.address,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: context.onSurface
                                                .withOpacity(0.7),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: context.onSurface
                                              .withOpacity(0.3),
                                        ),
                                        onTap: () =>
                                            _selectSearchResult(location),
                                      ),
                                    );
                                  },
                                ),
                              ],
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
              child: AppCard.primary(
                child: Padding(
                  padding: PaddingConstants.allMedium,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: context.primary),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.body(
                                  _selectedLocation!.placeName,
                                ),
                                AppText.body(
                                  _selectedLocation!.address,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: GeneralConstants.heightMedium,
                        child: AppButton.primary(
                          'Confirm Location',
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
