import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:limo/shared/models/picked_location_model.dart';
import 'package:provider/provider.dart';
import 'package:limo/module/job_details/view_model/job_details_view_model.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/constants/padding_constants.dart';

// Bu enum sadece burada kullanıldığı için private kalabilir veya genel bir yere taşınabilir
enum _MapApp { google, apple, waze }

class JobLocationsSection extends StatelessWidget {
  const JobLocationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Pickup ve Dropoff lokasyonlarını dinliyoruz
    final locations = context.select<JobDetailsViewModel, ({LocationModel? pickup, LocationModel? dropoff})>(
      (vm) => (pickup: vm.job.pickupLocation, dropoff: vm.job.dropoffLocation),
    );

    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Locations', style: context.headline),
          const SizedBox(height: PaddingConstants.p16),
          
          _LocationRow(title: 'Pickup', address: locations.pickup?.address),
          const SizedBox(height: PaddingConstants.p8),
          // Harita + Buton (Pickup için)
          JobMiniMap(lat: locations.pickup?.lat, lng: locations.pickup?.lng),

          if (locations.dropoff != null) ...[
            const SizedBox(height: PaddingConstants.p16),
            _LocationRow(title: 'Drop-off', address: locations.dropoff?.address),
            const SizedBox(height: PaddingConstants.p8),
            // Harita + Buton (Dropoff için)
            JobMiniMap(lat: locations.dropoff?.lat, lng: locations.dropoff?.lng),
          ],
        ],
      ),
    );
  }
}

class JobMiniMap extends StatelessWidget {
  const JobMiniMap({super.key, required this.lat, required this.lng});
  final double? lat;
  final double? lng;

  @override
  Widget build(BuildContext context) {
    final hasCoords = lat != null && lng != null;
    if (!hasCoords) return const _NoLocationPlaceholder();

    return Container(
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: context.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // 1. Zemin: Harita
            GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(lat!, lng!), zoom: 13),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              liteModeEnabled: true, // Performans için
              rotateGesturesEnabled: false,
              scrollGesturesEnabled: false,
              tiltGesturesEnabled: false,
              zoomGesturesEnabled: false,
              mapToolbarEnabled: false, // Google'ın kendi toolbar'ını kapatıyoruz
            ),
            
            // 2. Orta: Pin İkonu
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
                ),
                child: Icon(Icons.location_on, size: 24, color: context.primary),
              ),
            ),

            // 3. Sağ Üst: Harita Açma Butonu (Floating Action Style)
            Positioned(
              top: 8,
              right: 8,
              child: _MapActionButton(lat: lat!, lng: lng!), // Lat/Lng null değil burada
            ),
          ],
        ),
      ),
    );
  }
}

class _MapActionButton extends StatelessWidget {
  const _MapActionButton({required this.lat, required this.lng});
  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shape: const CircleBorder(),
      child: PopupMenuButton<_MapApp>(
        tooltip: 'Open in Maps',
        icon: const Icon(Icons.near_me, color: Colors.black87, size: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (choice) {
          // ViewModel fonksiyonlarını tetikliyoruz.
          // Not: Eğer VM fonksiyonları parametre almıyorsa VM'deki job verisini kullanır.
          // Eğer spesifik (pickup/dropoff) ayrımı yapılacaksa VM metodları güncellenmeli.
          // Burada genel Job verisi üzerinden açtığını varsayıyoruz.
          final vm = context.read<JobDetailsViewModel>();
          switch (choice) {
            case _MapApp.google:
              vm.openGoogle();
              break;
            case _MapApp.apple:
              vm.openApple();
              break;
            case _MapApp.waze:
              vm.openWaze();
              break;
          }
        },
        itemBuilder: (context) => const [
          PopupMenuItem(
            value: _MapApp.google,
            child: _PopupItem(icon: Icons.map, text: 'Google Maps'),
          ),
          PopupMenuItem(
            value: _MapApp.apple,
            child: _PopupItem(icon: Icons.apple, text: 'Apple Maps'),
          ),
          PopupMenuItem(
            value: _MapApp.waze,
            child: _PopupItem(icon: Icons.directions_car, text: 'Waze'),
          ),
        ],
      ),
    );
  }
}

class _PopupItem extends StatelessWidget {
  const _PopupItem({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700], size: 20),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ... _LocationRow ve _NoLocationPlaceholder (önceki cevapla aynı) ...
class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.title, this.address});
  final String title;
  final String? address;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.subhead),
        const SizedBox(height: 2),
        Text(address ?? '—', style: context.callout),
      ],
    );
  }
}

class _NoLocationPlaceholder extends StatelessWidget {
  const _NoLocationPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.surfaceContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.outline.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, color: context.onSurfaceVariant),
          const SizedBox(height: 8),
          Text('Location not shared', style: context.caption1.copyWith(color: context.onSurfaceVariant)),
        ],
      ),
    );
  }
}