import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:limo/module/job_details/view_model/job_details_view_model.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:provider/provider.dart';

class JobDetailsBody extends StatelessWidget {
  const JobDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: PaddingConstants.all24,
          children: const [
            _HeaderCard(),
            SizedBox(height: PaddingConstants.p16),
            _DatesCard(),
            SizedBox(height: PaddingConstants.p16),
            _LocationsCard(),
            SizedBox(height: PaddingConstants.p16),
            _DescriptionDetailsCard(),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobDetailsViewModel>();
    final cs = Theme.of(context).colorScheme;
    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vm.displayTitle,
            style: context.headline.copyWith(fontWeight: FontWeight.w600),
          ),
          if (vm.jobCode != null) ...[
            const SizedBox(height: PaddingConstants.p8),
            Text(
              vm.jobCode!,
              style: context.caption1.copyWith(color: context.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: PaddingConstants.p8),
          Wrap(
            spacing: PaddingConstants.p8,
            runSpacing: PaddingConstants.p8,
            children: [
              _Chip(text: vm.typeDisplay, bg: cs.secondary, fg: cs.onSecondary),
              _Chip(
                text: vm.statusCapitalized,
                bg: cs.secondary,
                fg: cs.onSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, required this.bg, required this.fg});
  final String text;
  final Color bg;
  final Color fg;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: context.caption1.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DatesCard extends StatelessWidget {
  const _DatesCard();
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobDetailsViewModel>();
    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dates', style: context.headline),
          const SizedBox(height: PaddingConstants.p8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.event, size: 18),
              const SizedBox(width: PaddingConstants.p8),
              Expanded(
                child: _kv(context, 'Pickup', vm.fmtDate(vm.job.pickupDate)),
              ),
            ],
          ),
          if (vm.job.dropoffDate != null)
            const SizedBox(height: PaddingConstants.p8),
          if (vm.job.dropoffDate != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.event_available, size: 18),
                const SizedBox(width: PaddingConstants.p8),
                Expanded(
                  child: _kv(
                    context,
                    'Drop-off',
                    vm.fmtDate(vm.job.dropoffDate),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _LocationsCard extends StatelessWidget {
  const _LocationsCard();
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobDetailsViewModel>();
    final pickup = vm.job.pickupLocation?.address ?? '—';
    final dropoff = vm.job.dropoffLocation?.address ?? '—';
    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Locations', style: context.headline),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.place_outlined, size: 20),
              const SizedBox(width: PaddingConstants.p8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pickup', style: context.subhead),
                    const SizedBox(height: PaddingConstants.p8),
                    Text(pickup, style: context.callout),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: PaddingConstants.p8),
          _MiniMap(
            lat: vm.job.pickupLocation?.lat,
            lng: vm.job.pickupLocation?.lng,
          ),
          if (vm.job.dropoffLocation != null) ...[
            const SizedBox(height: PaddingConstants.p8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.flag_outlined, size: 20),
                const SizedBox(width: PaddingConstants.p8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Drop-off', style: context.subhead),
                      const SizedBox(height: PaddingConstants.p8),
                      Text(dropoff, style: context.callout),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: PaddingConstants.p8),
            _MiniMap(
              lat: vm.job.dropoffLocation?.lat,
              lng: vm.job.dropoffLocation?.lng,
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniMap extends StatelessWidget {
  const _MiniMap({required this.lat, required this.lng});
  final double? lat;
  final double? lng;
  @override
  Widget build(BuildContext context) {
    final vm = context.read<JobDetailsViewModel>();
    final hasCoords = lat != null && lng != null;
    const placeholder = LatLng(37.3349, -122.0090);
    final target = hasCoords ? LatLng(lat!, lng!) : placeholder;
    final cs = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(12);
    final baseMap = GoogleMap(
      initialCameraPosition: CameraPosition(
        target: target,
        zoom: hasCoords ? 13 : 12,
      ),
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      liteModeEnabled: true,
      compassEnabled: false,
      mapToolbarEnabled: false,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
      tiltGesturesEnabled: false,
      zoomGesturesEnabled: false,
    );
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.outline, width: 1),
        borderRadius: radius,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          height: 180,
          width: double.infinity,
          child: Stack(
            children: [
              hasCoords
                  ? baseMap
                  : Opacity(
                    opacity: 0.7,
                    child: ImageFiltered(
                      imageFilter: ui.ImageFilter.blur(
                        sigmaX: 2.5,
                        sigmaY: 2.5,
                      ),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          cs.surfaceContainerHighest.withOpacity(0.06),
                          BlendMode.srcATop,
                        ),
                        child: baseMap,
                      ),
                    ),
                  ),
              if (!hasCoords)
                Positioned.fill(
                  child: IgnorePointer(
                    child: ColoredBox(color: Colors.white.withOpacity(0.6)),
                  ),
                ),
              IgnorePointer(
                child: Center(
                  child:
                      hasCoords
                          ? Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.location_on,
                              size: 28,
                              color: cs.primary,
                            ),
                          )
                          : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_off_outlined,
                                  size: 28,
                                  color: context.onSurfaceVariant,
                                ),
                                const SizedBox(height: PaddingConstants.p8),
                                Text(
                                  'Location not shared',
                                  textAlign: TextAlign.center,
                                  style: context.caption1.copyWith(
                                    color: context.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ),
              if (hasCoords)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    type: MaterialType.circle,
                    color: Colors.white,
                    elevation: 1,
                    shadowColor: Colors.black.withOpacity(0.08),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: PopupMenuButton<_MapChoice>(
                        tooltip: 'Open in…',
                        icon: const Icon(Icons.share, color: Colors.black87),
                        onSelected: (choice) async {
                          switch (choice) {
                            case _MapChoice.google:
                              await vm.openGoogle();
                              break;
                            case _MapChoice.apple:
                              await vm.openApple();
                              break;
                            case _MapChoice.waze:
                              await vm.openWaze();
                              break;
                          }
                        },
                        itemBuilder:
                            (context) => const [
                              PopupMenuItem(
                                value: _MapChoice.google,
                                child: ListTile(
                                  leading: Icon(Icons.map_outlined),
                                  title: Text('Google Maps'),
                                ),
                              ),
                              PopupMenuItem(
                                value: _MapChoice.apple,
                                child: ListTile(
                                  leading: Icon(Icons.pin_drop_outlined),
                                  title: Text('Apple Maps'),
                                ),
                              ),
                              PopupMenuItem(
                                value: _MapChoice.waze,
                                child: ListTile(
                                  leading: Icon(Icons.navigation_outlined),
                                  title: Text('Waze'),
                                ),
                              ),
                            ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DescriptionDetailsCard extends StatelessWidget {
  const _DescriptionDetailsCard();
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobDetailsViewModel>();
    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Details', style: context.headline),
          Text(
            vm.job.description?.isNotEmpty == true ? vm.job.description! : '-',
            style: context.callout,
          ),
          const SizedBox(height: PaddingConstants.p8),
          Row(
            children: [
              Expanded(child: _kv(context, 'Created By', vm.job.userId)),
              const SizedBox(width: PaddingConstants.p8),
              Expanded(
                child: _kv(context, 'Created', vm.fmtDate(vm.job.createdAt)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _kv(BuildContext context, String k, String v) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        k,
        style: context.caption1.copyWith(color: context.onSurfaceVariant),
      ),
      const SizedBox(height: 2),
      Text(v, style: context.callout),
    ],
  );
}

enum _MapChoice { google, apple, waze }
