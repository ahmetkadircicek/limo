import 'package:flutter/material.dart';
import 'package:limo/feature/map/models/location_model.dart';
import 'package:limo/feature/map/widgets/location_picker.dart';

class LocationPickerPage extends StatelessWidget {
  final String title;
  final Function(LocationModel) onLocationSelected;
  final LocationModel? selectedLocation;

  const LocationPickerPage({
    super.key,
    required this.title,
    required this.onLocationSelected,
    this.selectedLocation,
  });

  @override
  Widget build(BuildContext context) {
    return LocationPicker(
      title: title,
      initialLocation: selectedLocation,
      onLocationSelected: onLocationSelected,
    );
  }
}
