import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/feature/map/models/location_model.dart';
import 'package:limo/feature/map/widgets/location_field.dart';
import 'package:limo/shared/app_button.dart';
import 'package:limo/shared/app_text.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: AppText.heading(title),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: PaddingConstants.allXl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20), // Daha yuvarlak köşeler
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(12), // Daha yuvarlak köşeler
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Color(0xFF10B981),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.heading(
                            title,
                            color: const Color(0xFF1A1A1A),
                          ),
                          const SizedBox(height: 4),
                          AppText.bodySmall(
                            'Lokasyon seçimi yapın',
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Location Field
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20), // Daha yuvarlak köşeler
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: LocationField(
                    hintText: title,
                    prefixIcon: const Icon(Icons.location_on),
                    pickerTitle: title,
                    selectedLocation: selectedLocation,
                    onLocationSelected: (location) {
                      onLocationSelected(location);
                      context.pop();
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton.secondary(
                      'İptal',
                      onPressed: () => context.pop(),
                      height: 52,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton.primary(
                      'Konum Seç',
                      onPressed: () {
                        // This will be handled by the LocationField widget
                        // when a location is selected
                      },
                      height: 52,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
