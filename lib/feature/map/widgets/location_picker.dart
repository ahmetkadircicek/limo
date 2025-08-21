import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:limo/feature/map/models/location_model.dart';
import 'package:limo/feature/map/services/location_service.dart';
import 'package:limo/shared/app_button.dart';
import 'package:limo/shared/app_card.dart';
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
  Timer? _debounceTimer;

  // Cupertino, California, USA: 37.322998, -122.032182
  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(37.322998, -122.032182), // Cupertino, CA, USA
    zoom: 12, // Reasonable city-level zoom
  );

  final Set<Marker> _markers = {};
  String? _mapTheme;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _initializeStoredLocation();
    // Delay map theme loading to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMapTheme();
    });
  }

  // Initialize with current user location, fallback to stored location for centering only
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
          name: _tag,
        );
        return;
      }

      // Try to get current user location first
      try {
        final currentLocation = await LocationService.getCurrentLocation();
        if (currentLocation != null) {
          // Center map to current location but don't set it as selected
          _animateToLocation(currentLocation);
          developer.log(
            '📍 Using current user location for centering: ${currentLocation.placeName}',
            name: _tag,
          );
          return;
        }
      } catch (e) {
        developer.log('📍 Could not get current location: $e', name: _tag);
      }

      // If current location not available, try stored location for centering only
      final lastLocation = await LocationService.getLocationFromStorage();
      if (lastLocation != null) {
        // Center map to stored location but don't set it as selected
        _animateToLocation(lastLocation);
        developer.log(
          '📍 Using stored location for centering only: ${lastLocation.placeName}',
          name: _tag,
        );
      } else {
        // If no stored location, use the default position
        developer.log(
          '📍 No location available, using default position (Cupertino, CA, USA)',
          name: _tag,
        );
      }
    } catch (e) {
      developer.log('💥 Failed to initialize location: $e', name: _tag);
    }
  }

  // Load custom map theme from JSON file
  Future<void> _loadMapTheme() async {
    try {
      developer.log('🎨 Attempting to load map theme...', name: _tag);

      // First check if the asset exists in manifest
      try {
        final manifestContent = await rootBundle.loadString(
          'AssetManifest.json',
        );
        final Map<String, dynamic> manifestMap = json.decode(manifestContent);
        final assetPath = 'assets/json/map_theme.json';

        if (!manifestMap.containsKey(assetPath)) {
          developer.log(
            '💥 Asset not found in manifest: $assetPath',
            name: _tag,
          );
          _mapTheme = null;
          return;
        }

        developer.log('✅ Asset found in manifest: $assetPath', name: _tag);
      } catch (manifestError) {
        developer.log(
          '⚠️ Could not check asset manifest: $manifestError',
          name: _tag,
        );
      }

      // Use rootBundle instead of DefaultAssetBundle for more reliable asset loading
      final themeData = await rootBundle.loadString(
        'assets/json/map_theme.json',
      );

      // Validate JSON format before setting
      try {
        json.decode(themeData); // Test if JSON is valid
        if (mounted) {
          setState(() {
            _mapTheme = themeData;
          });
          developer.log('🎨 Map theme loaded successfully', name: _tag);
        }
      } catch (jsonError) {
        developer.log(
          '💥 Invalid JSON format in map theme: $jsonError',
          name: _tag,
        );
        _mapTheme = null;
      }
    } catch (e) {
      developer.log('💥 Failed to load map theme: $e', name: _tag);
      // Try alternative loading method
      try {
        developer.log('🔄 Trying fallback method...', name: _tag);
        final currentContext = context;
        final themeData = await DefaultAssetBundle.of(
          currentContext,
        ).loadString('assets/json/map_theme.json');
        if (mounted) {
          setState(() {
            _mapTheme = themeData;
          });
          developer.log('🎨 Map theme loaded with fallback method', name: _tag);
        }
      } catch (fallbackError) {
        developer.log(
          '💥 Fallback method also failed: $fallbackError',
          name: _tag,
        );
        _mapTheme = null;
      }
    }
  }

  @override
  void dispose() {
    // Safely dispose map controller
    if (_mapController != null) {
      _mapController!.dispose();
      _mapController = null;
      developer.log('🗺️ Map controller disposed', name: _tag);
    }

    _searchController.dispose();
    _debounceTimer?.cancel();

    // Clear any remaining state
    _searchResults.clear();
    _markers.clear();

    super.dispose();
  }

  // Handle map controller creation
  void _onMapCreated(GoogleMapController controller) {
    // Prevent multiple controller assignments
    if (_mapController != null) {
      developer.log(
        '⚠️ Map controller already exists, skipping...',
        name: _tag,
      );
      return;
    }

    _mapController = controller;
    developer.log('🗺️ Map controller created successfully', name: _tag);

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

  // Confirm location selection and navigate back
  void _confirmSelection() async {
    if (_selectedLocation != null) {
      // Save the location when user confirms selection
      await _saveLastLocation(_selectedLocation!);
      widget.onLocationSelected(_selectedLocation!);
      // Reset map state before navigating back
      _resetMapState();
      // Use Navigator.pop() to return to the parent page
      final currentContext = context;
      Navigator.of(currentContext).pop(_selectedLocation!);
    }
  }

  // Reset map state to initial values (without clearing stored location)
  void _resetMapState() {
    if (mounted) {
      setState(() {
        _selectedLocation = null;
        _searchResults.clear();
        _searchController.clear();
        _markers.clear();
      });
      developer.log('🗺️ Map state reset successfully', name: _tag);
    }
  }

  // Save last known location in persistent storage
  Future<void> _saveLastLocation(LocationModel location) async {
    final success = await LocationService.saveLocationToStorage(location);
    if (success) {
      developer.log(
        '📍 Last location saved to persistent storage: ${location.placeName}',
        name: _tag,
      );
    } else {
      developer.log(
        '❌ Failed to save location to persistent storage',
        name: _tag,
      );
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
        icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        onPressed: () {
          // Reset map state before going back
          _resetMapState();
          Navigator.of(context).pop();
        },
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // Build the Google Maps widget
  Widget _buildGoogleMap() {
    final initialPosition =
        _selectedLocation != null
            ? CameraPosition(
              target: LatLng(
                _selectedLocation!.latitude,
                _selectedLocation!.longitude,
              ),
              zoom: 15,
            )
            : _defaultPosition;

    // Log which position is being used
    if (_selectedLocation != null) {
      developer.log(
        '🗺️ Using stored location for map: ${_selectedLocation!.placeName}',
        name: _tag,
      );
    } else {
      developer.log(
        '🗺️ Using default position for map (Cupertino, CA, USA)',
        name: _tag,
      );
    }

    return GoogleMap(
      key: const ValueKey(
        'location_picker_map',
      ), // Add unique key to prevent recreation
      onMapCreated: _onMapCreated,
      initialCameraPosition: initialPosition,
      markers: _markers,
      onTap: _onMapTap,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      mapType: MapType.normal,
      style: _mapTheme,
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
          if (_searchResults.isNotEmpty || _isSearching)
            Container(
              margin: const EdgeInsets.only(top: 4),
              child: _buildSearchResults(),
            ),
        ],
      ),
    );
  }

  // Build the search bar
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
        ],
      ),
    );
  }

  // Build search results container
  Widget _buildSearchResults() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        child: Column(
          children: [_buildSearchResultsHeader(), _buildSearchResultsList()],
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
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
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
        ],
      ),
    );
  }

  // Build search results list
  Widget _buildSearchResultsList() {
    return Expanded(
      child:
          _isSearching
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
          const AppText.bodySmall('Searching...', color: Colors.grey),
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
      child: AppInfoCard(
        icon: Icons.location_on,
        label: location.placeName,
        value: location.address,
        iconColor: const Color(0xFF10B981), // Green color for location
        labelColor: const Color(0xFF1A1A1A),
        valueColor: Colors.grey[600],
        backgroundColor: Colors.white, // White background for search results
        onTap: () => _selectSearchResult(location),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey[400],
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
              color: Colors.black.withValues(alpha: 0.15),
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
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
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
