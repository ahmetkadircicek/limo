import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:limo/feature/map/models/location_model.dart';
import 'package:limo/feature/map/services/location_service.dart';
import 'package:limo/shared/app_button.dart';
import 'package:limo/shared/app_text.dart';

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
  static const String _tag = 'LocationPicker';

  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  LocationModel? _selectedLocation;
  List<LocationModel> _searchResults = [];
  bool _isSearching = false;
  bool _isLoadingCurrentLocation = false;
  Timer? _debounceTimer;

  // Cupertino, California, USA: 37.322998, -122.032182
  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(37.322998, -122.032182), // Cupertino, CA, USA
    zoom: 12, // Reasonable city-level zoom
  );

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _initializeStoredLocation();
  }

  // Initialize with stored location instead of automatically getting current location
  Future<void> _initializeStoredLocation() async {
    try {
      // First check if an initial location was passed to the widget
      if (widget.initialLocation != null) {
        setState(() {
          _selectedLocation = widget.initialLocation;
        });
        _addMarker(widget.initialLocation!);
        _animateToLocation(widget.initialLocation!);
        developer.log(
            '📍 Using initial location from widget: ${widget.initialLocation!.placeName}',
            name: _tag);
        return;
      }

      // If no initial location, try to get the last saved location
      final lastLocation = await _getLastLocation();

      if (lastLocation != null) {
        setState(() {
          _selectedLocation = lastLocation;
        });
        _addMarker(lastLocation);
        _animateToLocation(lastLocation);
        developer.log('📍 Using stored location: ${lastLocation.placeName}',
            name: _tag);
      } else {
        // If no stored location, use the default position but don't set it as selected
        developer.log(
            '📍 No stored location found, using default position (Cupertino, CA, USA)',
            name: _tag);
      }
    } catch (e) {
      developer.log('💥 Failed to initialize stored location: $e', name: _tag);
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();

    // Clear any remaining state
    _searchResults.clear();
    _markers.clear();

    super.dispose();
  }

  // Handle map controller creation
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_selectedLocation != null) {
      _animateToLocation(_selectedLocation!);
    }
  }

  // Handle search input changes with debouncing
  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      if (_searchController.text.isNotEmpty) {
        _searchPlaces(_searchController.text);
      } else {
        setState(() {
          _searchResults.clear();
        });
      }
    });
  }

  // Search for places using the location service
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

  // Handle map tap to select location
  void _onMapTap(LatLng position) {
    final location = LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      placeName: 'Selected Location',
      address:
          '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}',
      placeId: 'manual_${position.latitude}_${position.longitude}',
    );
    _selectLocation(location);
  }

  // Select a search result and clear search
  void _selectSearchResult(LocationModel location) {
    _selectLocation(location);
    setState(() {
      _searchResults.clear();
      _searchController.clear();
    });
  }

  // Select a location and update UI
  void _selectLocation(LocationModel location) {
    setState(() {
      _selectedLocation = location;
    });
    _addMarker(location);
    _animateToLocation(location);
  }

  // Add marker to the map
  void _addMarker(LocationModel location) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: MarkerId(location.placeName),
        position: LatLng(location.latitude, location.longitude),
        infoWindow: InfoWindow(
          title: location.placeName,
          snippet: location.address,
        ),
      ),
    );
  }

  // Animate camera to selected location
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

  // Get current location from device without automatically saving
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingCurrentLocation = true;
    });

    try {
      final location = await LocationService.getCurrentLocation();
      if (location != null) {
        _selectLocation(location);
        // Don't automatically save current location as the default
        // Only save when user explicitly confirms selection
        developer.log('📍 Current location obtained: ${location.placeName}',
            name: _tag);
      }
    } catch (e) {
      developer.log('💥 Failed to get current location: $e', name: _tag);
    } finally {
      setState(() {
        _isLoadingCurrentLocation = false;
      });
    }
  }

  // Manually save current location as default (user-initiated action)
  Future<void> _saveCurrentLocationAsDefault() async {
    try {
      final location = await LocationService.getCurrentLocation();
      if (location != null) {
        await _saveLastLocation(location);
        _selectLocation(location);
        developer.log(
            '📍 Current location saved as default: ${location.placeName}',
            name: _tag);
      }
    } catch (e) {
      developer.log('💥 Failed to save current location as default: $e',
          name: _tag);
    }
  }

  // Confirm location selection and navigate back
  void _confirmSelection() async {
    if (_selectedLocation != null) {
      // Save the location when user confirms selection
      await _saveLastLocation(_selectedLocation!);
      widget.onLocationSelected(_selectedLocation!);
      // Reset map state before navigating back
      _resetMapState();
      // Use Navigator.pop() to return to the parent page
      Navigator.of(context).pop(_selectedLocation!);
    }
  }

  // Reset map state to initial values (without clearing stored location)
  void _resetMapState() {
    setState(() {
      _selectedLocation = null;
      _searchResults.clear();
      _searchController.clear();
      _markers.clear();
    });
  }

  // Save last known location in persistent storage
  Future<void> _saveLastLocation(LocationModel location) async {
    final success = await LocationService.saveLocationToStorage(location);
    if (success) {
      developer.log(
          '📍 Last location saved to persistent storage: ${location.placeName}',
          name: _tag);
    } else {
      developer.log('❌ Failed to save location to persistent storage',
          name: _tag);
    }
  }

  Future<LocationModel?> _getLastLocation() async {
    final location = await LocationService.getLocationFromStorage();
    if (location != null) {
      developer.log('📍 Stored location found: ${location.placeName}',
          name: _tag);
      return location;
    }
    developer.log('📍 No stored location found', name: _tag);
    return null;
  }

  // Manually clear stored location
  Future<void> _clearStoredLocation() async {
    try {
      await LocationService.clearLocationFromStorage();
      setState(() {
        _selectedLocation = null;
        _markers.clear();
      });
      developer.log('🗑️ Stored location cleared manually', name: _tag);

      // Show a snackbar to inform the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stored location cleared'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      developer.log('💥 Failed to clear stored location: $e', name: _tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildGoogleMap(),
          _buildSearchSection(),
          if (_selectedLocation != null) _buildLocationInfoCard(),
        ],
      ),
    );
  }

  // Build the app bar with title and back button
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: AppText.body(
        widget.title,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF1A1A1A),
      ),
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1A1A1A),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          size: 20,
        ),
        onPressed: () {
          // Reset map state before going back
          _resetMapState();
          Navigator.of(context).pop();
        },
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      actions: [
        if (_selectedLocation != null)
          IconButton(
            icon: const Icon(
              Icons.clear,
              size: 20,
            ),
            onPressed: _clearStoredLocation,
            tooltip: 'Clear stored location',
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }

  // Build the Google Maps widget
  Widget _buildGoogleMap() {
    final initialPosition = _selectedLocation != null
        ? CameraPosition(
            target: LatLng(
                _selectedLocation!.latitude, _selectedLocation!.longitude),
            zoom: 15,
          )
        : _defaultPosition;

    // Log which position is being used
    if (_selectedLocation != null) {
      developer.log(
          '🗺️ Using stored location for map: ${_selectedLocation!.placeName}',
          name: _tag);
    } else {
      developer.log('🗺️ Using default position for map (Cupertino, CA, USA)',
          name: _tag);
    }

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: initialPosition,
      markers: _markers,
      onTap: _onMapTap,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  // Build the search section with search bar and results
  Widget _buildSearchSection() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 8),
          if (_searchResults.isNotEmpty || _isSearching) _buildSearchResults(),
        ],
      ),
    );
  }

  // Build the search bar with current location button
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 44,
              height: 44,
              child: _isLoadingCurrentLocation
                  ? _buildLoadingIndicator()
                  : _buildCurrentLocationButton(),
            ),
          ),
        ],
      ),
    );
  }

  // Build loading indicator for current location button
  Widget _buildLoadingIndicator() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  // Build current location button
  Widget _buildCurrentLocationButton() {
    return Tooltip(
      message: 'Tap to get current location\nLong press to save as default',
      child: GestureDetector(
        onTap: _getCurrentLocation,
        onLongPress: _saveCurrentLocationAsDefault,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: IconButton(
            onPressed: null, // Disabled since we're using GestureDetector
            icon: Icon(
              Icons.my_location_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 22,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }

  // Build search results container
  Widget _buildSearchResults() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            _buildSearchResultsHeader(),
            _buildSearchResultsList(),
          ],
        ),
      ),
    );
  }

  // Build search results header
  Widget _buildSearchResultsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.body(
                'Search Results',
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
              AppText.bodySmall(
                '${_searchResults.length} results found',
                color: Colors.grey[600],
              ),
            ],
          ),
          const Spacer(),
          _buildClearButton(),
        ],
      ),
    );
  }

  /// Builds a chip-style clear button for search results
  Widget _buildClearButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            setState(() {
              _searchResults.clear();
              _searchController.clear();
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 4),
                AppText.body(
                  'Clear',
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build search results list
  Widget _buildSearchResultsList() {
    return Expanded(
      child: _isSearching
          ? _buildSearchingIndicator()
          : _buildSearchResultsItems(),
    );
  }

  // Build searching indicator
  Widget _buildSearchingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
              strokeWidth: 2,
            ),
          ),
          const SizedBox(height: 16),
          const AppText.bodySmall(
            'Searching...',
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  // Build search results items list
  Widget _buildSearchResultsItems() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final location = _searchResults[index];
        return _buildSearchResultItem(location);
      },
    );
  }

  // Build individual search result item
  Widget _buildSearchResultItem(LocationModel location) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[100]!,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _selectSearchResult(location),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText.body(
                        location.placeName,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A1A),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      AppText.bodySmall(
                        location.address,
                        color: Colors.grey[600],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build location info card with confirm button
  Widget _buildLocationInfoCard() {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationInfoRow(),
              const SizedBox(height: 20),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Build location info row with icon and text
  Widget _buildLocationInfoRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.location_on_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.body(
                _selectedLocation!.placeName,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              AppText.bodySmall(
                _selectedLocation!.address,
                color: Colors.grey[600],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build confirm location button
  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: AppButton.primary(
        'Confirm Location',
        onPressed: _confirmSelection,
        width: double.infinity,
        height: 52,
      ),
    );
  }
}
