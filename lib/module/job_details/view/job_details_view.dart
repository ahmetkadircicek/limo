import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/model_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/module/job_details/view_model/job_details_view_model.dart';
import 'package:limo/module/job_details/widgets/job_details_body.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/models/brand_model.dart';
import 'package:limo/shared/models/car_requirement_model.dart';
import 'package:limo/shared/models/category_model.dart';
import 'package:limo/shared/models/job_model.dart';
import 'package:limo/shared/models/model_model.dart';
import 'package:limo/shared/utils/map_launcher.dart';
import 'package:limo/shared/widgets/shared_app_bar.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class JobDetailsView extends StatelessWidget {
  const JobDetailsView({super.key, required this.job});
  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        title: 'Job Details',
        actions: [
          if (_hasAnyCoordinates)
            PopupMenuButton<_MapChoice>(
              tooltip: 'Open in…',
              icon: const Icon(Icons.more_vert),
              onSelected: (choice) async {
                switch (choice) {
                  case _MapChoice.google:
                    await MapLauncher.openGoogle(job);
                    break;
                  case _MapChoice.apple:
                    await MapLauncher.openApple(job);
                    break;
                  case _MapChoice.waze:
                    await MapLauncher.openWaze(job);
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
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => JobDetailsViewModel(job: job),
        child: const JobDetailsBody(),
      ),
      // Per-vehicle apply buttons are shown under each vehicle requirement row.
    );
  }

  bool get _hasAnyCoordinates =>
      (job.pickupLocation?.lat != null && job.pickupLocation?.lng != null) ||
      (job.dropoffLocation?.lat != null && job.dropoffLocation?.lng != null);

  Widget _metaCard(BuildContext context) {
    final code = job.jobId != null ? 'JOB-${job.jobId}' : '—';
    final miles = job.distanceRoad;
    final minutes = job.durationMinutes;
    final jobType = job.jobType ?? job.jobTypeName ?? '—';

    // Contact: show if shareNumber true and we have data
    String? phone = job.contactPhone;
    String? email = job.contactEmail;
    final current = context.read<UserProvider>().user;
    if ((phone == null || phone.isEmpty) &&
        current != null &&
        current.userId == job.userId) {
      phone = current.phone;
    }
    if ((email == null || email.isEmpty) &&
        current != null &&
        current.userId == job.userId) {
      email = current.email;
    }

    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Details', style: context.headline),
          _kv(context, 'Code', code),
          _kv(context, 'Job Type', jobType),
          if (miles != null)
            _kv(context, 'Distance', '${miles.toStringAsFixed(2)} mi'),
          if (minutes != null) _kv(context, 'Duration', _fmtMinutes(minutes)),
          _kv(context, 'Status', job.status ?? 'active'),
          _kv(context, 'Created By', job.userId),
          _kv(context, 'Created On', _fmtDate(job.createdAt)),
          if (job.shareNumber) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    'Phone',
                    style: context.caption1.copyWith(
                      color: context.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:
                      (phone != null && phone.isNotEmpty)
                          ? OutlinedButton.icon(
                            onPressed: () => _launchTel(phone!),
                            icon: const Icon(Icons.call),
                            label: Text(phone),
                          )
                          : Text(
                            'Not shared',
                            style: context.caption1.copyWith(
                              color: context.onSurfaceVariant,
                            ),
                          ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    'Email',
                    style: context.caption1.copyWith(
                      color: context.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:
                      (email != null && email.isNotEmpty)
                          ? OutlinedButton.icon(
                            onPressed: () => _launchMail(email!),
                            icon: const Icon(Icons.email_outlined),
                            label: Text(email),
                          )
                          : Text(
                            'Not shared',
                            style: context.caption1.copyWith(
                              color: context.onSurfaceVariant,
                            ),
                          ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _scheduleCard(BuildContext context) {
    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Schedule', style: context.headline),
          _kv(context, 'Pickup', _fmtDate(job.pickupDate)),
          if (job.dropoffDate != null)
            _kv(context, 'Drop-off', _fmtDate(job.dropoffDate)),
        ],
      ),
    );
  }

  Widget _locationsCard(BuildContext context) {
    final pickup = job.pickupLocation?.address ?? '—';
    final dropoff = job.dropoffLocation?.address ?? '—';
    final hasPickup =
        job.pickupLocation?.lat != null && job.pickupLocation?.lng != null;
    final hasDrop =
        job.dropoffLocation?.lat != null && job.dropoffLocation?.lng != null;
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
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pickup', style: context.subhead),
                    const SizedBox(height: 2),
                    Text(pickup, style: context.callout),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _miniMap(
            context,
            lat: job.pickupLocation?.lat,
            lng: job.pickupLocation?.lng,
          ),
          if (job.dropoffLocation != null) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.flag_outlined, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Drop-off', style: context.subhead),
                      const SizedBox(height: 2),
                      Text(dropoff, style: context.callout),
                    ],
                  ),
                ),
              ],
            ),
          ],
          if (job.dropoffLocation != null) ...[
            const SizedBox(height: 8),
            _miniMap(
              context,
              lat: job.dropoffLocation?.lat,
              lng: job.dropoffLocation?.lng,
            ),
          ],
        ],
      ),
    );
  }

  Widget _miniMap(
    BuildContext context, {
    required double? lat,
    required double? lng,
  }) {
    final hasCoords = lat != null && lng != null;
    // Apple Park, Cupertino as placeholder center when no coords
    const placeholder = LatLng(37.3349, -122.0090);
    final target = hasCoords ? LatLng(lat, lng) : placeholder;
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
        border: Border.all(color: context.outline.withOpacity(0.3)),
        borderRadius: radius,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: [
            SizedBox(
              height: 180,
              width: double.infinity,
              child:
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
            ),
            if (!hasCoords)
              Positioned.fill(
                child: IgnorePointer(child: ColoredBox(color: Colors.white54)),
              ),
            IgnorePointer(
              child: Center(
                child:
                    hasCoords
                        ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.location_on,
                            size: 28,
                            color: cs.primary,
                          ),
                        )
                        : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Stack(
                                alignment: Alignment.center,
                                children: const [
                                  Icon(
                                    Icons.location_on,
                                    size: 28,
                                    color: Colors.grey,
                                  ),
                                  Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                    color: Colors.redAccent,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Location not shared',
                              textAlign: TextAlign.center,
                              style: context.caption1.copyWith(
                                color: context.onSurfaceVariant,
                              ),
                            ),
                          ],
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
                            await MapLauncher.openGoogle(job);
                            break;
                          case _MapChoice.apple:
                            await MapLauncher.openApple(job);
                            break;
                          case _MapChoice.waze:
                            await MapLauncher.openWaze(job);
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
    );
  }

  Widget _datesCard(BuildContext context) {
    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dates', style: context.headline),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.event, size: 18),
              const SizedBox(width: 8),
              Expanded(child: _kv(context, 'Pickup', _fmtDate(job.pickupDate))),
            ],
          ),
          if (job.dropoffDate != null) const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.event_available, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: _kv(context, 'Drop-off', _fmtDate(job.dropoffDate)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mapCard(BuildContext context) {
    final hasPickup =
        job.pickupLocation?.lat != null && job.pickupLocation?.lng != null;
    final hasDrop =
        job.dropoffLocation?.lat != null && job.dropoffLocation?.lng != null;

    LatLng? center;
    if (hasPickup && hasDrop) {
      center = LatLng(
        (job.pickupLocation!.lat! + job.dropoffLocation!.lat!) / 2,
        (job.pickupLocation!.lng! + job.dropoffLocation!.lng!) / 2,
      );
    } else if (hasPickup) {
      center = LatLng(job.pickupLocation!.lat!, job.pickupLocation!.lng!);
    } else if (hasDrop) {
      center = LatLng(job.dropoffLocation!.lat!, job.dropoffLocation!.lng!);
    }
    final initial = CameraPosition(
      target: center ?? const LatLng(0, 0),
      zoom: 11.5,
    );

    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Map', style: context.headline),
          SizedBox(
            height: 240,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GoogleMap(
                    initialCameraPosition: initial,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    liteModeEnabled: true,
                  ),
                  // Center pin overlay (stays centered as the map moves)
                  IgnorePointer(
                    child: Center(
                      child: Icon(
                        Icons.location_on,
                        size: 36,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionCard(BuildContext context) {
    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Details', style: context.headline),
          _ExpandableText(text: job.description ?? '-'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _LabeledValue(label: 'Created By', value: job.userId),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledValue(
                  label: 'Created',
                  value: DateFormat(
                    'MM/dd/yyyy h:mm a',
                  ).format(job.createdAt ?? DateTime.now()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _carRequirementsCard(BuildContext context) {
    final cars = job.cars;
    final brandProvider = context.read<BrandProvider>();
    final categoryProvider = context.read<CategoryProvider>();
    final modelProvider = context.read<ModelProvider>();
    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vehicle Requirements', style: context.headline),
          if (cars.isEmpty)
            Text(
              'Any vehicle',
              style: context.body.copyWith(color: context.onSurfaceVariant),
            )
          else
            ...cars.map((c) {
              final brandName =
                  c.brandName ??
                  brandProvider.brands
                      .firstWhere(
                        (b) => b.brandId == c.brandId,
                        orElse: () => BrandModel(),
                      )
                      .brandName;
              String? modelName = c.modelName;
              if (modelName == null &&
                  modelProvider.currentBrandId == c.brandId &&
                  modelProvider.models.isNotEmpty) {
                modelName =
                    modelProvider.models
                        .firstWhere(
                          (m) => m.modelId == c.modelId,
                          orElse: () => ModelModel(),
                        )
                        .modelName;
              }
              final categoryName =
                  c.categoryName ??
                  categoryProvider.categories
                      .firstWhere(
                        (cat) => cat.categoryId == c.categoryId,
                        orElse: () => CategoryModel(),
                      )
                      .categoryName;
              final title = [
                brandName ?? '#${c.brandId}',
                modelName ?? '#${c.modelId}',
                categoryName ?? '#${c.categoryId}',
              ].join(' • ');
              final subtitle =
                  '${c.capacity} seats • ${c.modelYear} • ${categoryName ?? ''}';
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.outline.withOpacity(0.15),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.body),
                    Text(
                      subtitle,
                      style: context.caption1.copyWith(
                        color: context.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _feeChip(
                          context,
                          Icons.straighten,
                          'Mile  \$${c.mileFee}',
                        ),
                        const SizedBox(width: 8),
                        _feeChip(
                          context,
                          Icons.schedule,
                          'Hour  \$${c.hourlyFee}',
                        ),
                        const Spacer(),
                        _ActionLink(
                          text: 'Apply',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Applied for this vehicle: ${modelName ?? c.modelId}',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // helpers
  Widget _feeChip(BuildContext context, IconData icon, String text) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: context.caption1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            k,
            style: context.caption1.copyWith(color: context.onSurfaceVariant),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(v, style: context.callout)),
      ],
    );
  }

  static final _fmt = DateFormat('MM/dd/yyyy h:mm a', 'en_US');
  String _fmtDate(DateTime? d) => d == null ? '—' : _fmt.format(d);
  String _fmtMinutes(double minutes) {
    final m = minutes.round();
    if (m % (60 * 24) == 0) {
      final days = (m / (60 * 24)).round();
      return '$days day${days > 1 ? 's' : ''}';
    }
    if (m % 60 == 0) {
      final hours = (m / 60).round();
      return '$hours hour${hours > 1 ? 's' : ''}';
    }
    return '$m min';
  }

  Future<void> _launchTel(String phone) async {
    final uri = 'tel:$phone';
    await launchUrlString(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _launchMail(String email) async {
    final uri = 'mailto:$email';
    await launchUrlString(uri, mode: LaunchMode.externalApplication);
  }
}

enum _MapChoice { google, apple, waze }

// ====== NEW: Micro widgets for redesigned layout ======

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.job});
  final JobModel job;

  @override
  Widget build(BuildContext context) {
    final title = (job.title ?? '').trim().isEmpty ? 'Job Title' : job.title!;
    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.headline.copyWith(fontWeight: FontWeight.w600),
          ),
          if (job.jobId != null) ...[
            const SizedBox(height: 4),
            Text(
              'JOB-${job.jobId}',
              style: context.caption1.copyWith(color: context.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 8),
          _HeaderChipsRow(job: job),
        ],
      ),
    );
  }
}

class _HeaderChipsRow extends StatelessWidget {
  const _HeaderChipsRow({required this.job});
  final JobModel job;
  @override
  Widget build(BuildContext context) {
    final statusRaw = (job.status ?? 'active').toString();
    final status =
        statusRaw.isEmpty
            ? 'Active'
            : statusRaw[0].toUpperCase() + statusRaw.substring(1).toLowerCase();
    final type = job.jobType ?? job.jobTypeName ?? '—';
    final cs = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _InfoChip(
          text: type,
          background: cs.secondary,
          foreground: cs.onSecondary,
        ),
        _InfoChip(
          text: status,
          background: cs.secondary,
          foreground: cs.onSecondary,
        ),
      ],
    );
  }
}

class _KeyInfoBand extends StatelessWidget {
  const _KeyInfoBand({required this.job});
  final JobModel job;

  @override
  Widget build(BuildContext context) {
    final items = <_KeyItem>[
      (
        icon: Icons.login,
        label: 'Pickup',
        value: _fmtDateFancy(job.pickupDate),
      ),
      if (job.dropoffDate != null)
        (
          icon: Icons.logout,
          label: 'Drop-off',
          value: _fmtDateFancy(job.dropoffDate),
        ),
      if (job.durationMinutes != null)
        (
          icon: Icons.schedule,
          label: 'Duration',
          value: _fmtDuration(job.durationMinutes!),
        ),
    ];
    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 520;
          final crossAxisCount = isNarrow ? 2 : 3;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                items
                    .map(
                      (e) => SizedBox(
                        width:
                            (constraints.maxWidth - (crossAxisCount - 1) * 12) /
                            crossAxisCount,
                        child: Row(
                          children: [
                            Icon(
                              e.icon,
                              size: 18,
                              color: context.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.label,
                                    style: context.caption1.copyWith(
                                      color: context.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(e.value, style: context.callout),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
          );
        },
      ),
    );
  }

  static String _fmtDateFancy(DateTime? d) {
    if (d == null) return '—';
    return DateFormat('MMM d, yyyy · h:mm a').format(d);
  }

  static String _fmtDuration(double minutes) {
    final m = minutes.round();
    if (m % (60 * 24) == 0) {
      final days = (m / (60 * 24)).round();
      return '$days days';
    }
    if (m % 60 == 0) {
      final hours = (m / 60).round();
      return '$hours hours';
    }
    return '$m min';
  }
}

class _DetailsGrid extends StatelessWidget {
  const _DetailsGrid({required this.job});
  final JobModel job;
  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      _LabeledValue(label: 'Created By', value: job.userId),
      _LabeledValue(
        label: 'Created',
        value: DateFormat(
          'MM/dd/yyyy h:mm a',
        ).format(job.createdAt ?? DateTime.now()),
      ),
    ];
    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: items.map((w) => SizedBox(width: 320, child: w)).toList(),
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({required this.job});
  final JobModel job;
  @override
  Widget build(BuildContext context) {
    String? phone = job.contactPhone;
    String? email = job.contactEmail;
    final current = context.read<UserProvider>().user;
    if ((phone == null || phone.isEmpty) &&
        current != null &&
        current.userId == job.userId) {
      phone = current.phone;
    }
    if ((email == null || email.isEmpty) &&
        current != null &&
        current.userId == job.userId) {
      email = current.email;
    }
    final share = job.shareNumber;
    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text('Contact', style: context.headline),
          _ContactRow(
            icon: Icons.call,
            label: 'Phone',
            value: share ? (phone ?? '') : _maskPhone(phone),
            actionLabel: share ? 'Call' : 'Request number',
            onAction:
                share && (phone != null && phone.isNotEmpty)
                    ? () => launchUrlString(
                      'tel:$phone',
                      mode: LaunchMode.externalApplication,
                    )
                    : () {},
          ),
          _ContactRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: email ?? '',
            actionLabel: 'Email',
            onAction:
                (email != null && email.isNotEmpty)
                    ? () => launchUrlString(
                      'mailto:$email',
                      mode: LaunchMode.externalApplication,
                    )
                    : null,
          ),
        ],
      ),
    );
  }

  String _maskPhone(String? p) {
    final s = p ?? '';
    if (s.isEmpty) return 'Not shared';
    return '••• •• •• ${s.substring(s.length - (s.length >= 2 ? 2 : 1))}';
  }
}

class _VehicleList extends StatefulWidget {
  const _VehicleList({required this.job, required this.canApply});
  final JobModel job;
  final bool canApply;
  @override
  State<_VehicleList> createState() => _VehicleListState();
}

class _VehicleListState extends State<_VehicleList> {
  bool _showAll = false;
  @override
  Widget build(BuildContext context) {
    final cars = widget.job.cars;
    if (cars.isEmpty) {
      return SharedCard(
        backgroundColor: context.surfaceContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text('Vehicle Requirements', style: context.headline),
            Text(
              'No vehicle requirements',
              style: context.callout.copyWith(color: context.onSurfaceVariant),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Contact poster'),
              ),
            ),
          ],
        ),
      );
    }
    final visible = _showAll ? cars : cars.take(3).toList();
    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text('Vehicle Requirements', style: context.headline),
          ...visible.map(
            (c) => _VehicleCard(requirement: c, canApply: widget.canApply),
          ),
          if (cars.length > 3)
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => setState(() => _showAll = !_showAll),
                child: Text(_showAll ? 'View less' : 'View all vehicles'),
              ),
            ),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.requirement, required this.canApply});
  final CarRequirementModel requirement;
  final bool canApply;

  @override
  Widget build(BuildContext context) {
    final brand = requirement.brandName ?? '#${requirement.brandId}';
    final model = requirement.modelName ?? '#${requirement.modelId}';
    final cat = requirement.categoryName ?? '#${requirement.categoryId}';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.outline.withValues(alpha: 0.15)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text('$brand • $model • $cat', style: context.body),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    _LabeledValue(
                      label: 'Seats',
                      value: '${requirement.capacity}',
                    ),
                    _LabeledValue(
                      label: 'Year',
                      value: '${requirement.modelYear}',
                    ),
                    _LabeledValue(label: 'Category', value: cat),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 8,
                children: [
                  _FeeBadge(text: 'Mile \$${requirement.mileFee}'),
                  _FeeBadge(text: 'Hour \$${requirement.hourlyFee}'),
                  ElevatedButton(
                    onPressed: canApply ? () {} : null,
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.text, this.background, this.foreground});
  final String text;
  final Color? background;
  final Color? foreground;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background ?? cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: context.caption1.copyWith(
          color: foreground ?? cs.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.caption1.copyWith(color: context.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(value, style: context.callout),
      ],
    );
  }
}

class _LabeledChip extends StatelessWidget {
  const _LabeledChip({
    required this.label,
    required this.text,
    this.background,
    this.foreground,
  });
  final String label;
  final String text;
  final Color? background;
  final Color? foreground;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.caption1.copyWith(color: context.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        _InfoChip(text: text, background: background, foreground: foreground),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text);
  final String text;
  factory _Badge.mono(BuildContext context, String text) => _Badge(text);
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: context.caption1.copyWith(
          color: cs.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FeeBadge extends StatelessWidget {
  const _FeeBadge({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: context.caption1.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionLink extends StatelessWidget {
  const _ActionLink({required this.text, this.onPressed, this.enabled = true});
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: const SizedBox.shrink(),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right),
        ],
      ),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        minimumSize: const Size(44, 40),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.actionLabel,
    this.onAction,
  });
  final IconData icon;
  final String label;
  final String value;
  final String actionLabel;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: context.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.caption1.copyWith(
                  color: context.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isEmpty ? 'Not shared' : value,
                style: context.callout,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _ActionLink(text: actionLabel, onPressed: onAction),
      ],
    );
  }
}

typedef _KeyItem = ({IconData icon, String label, String value});

({Color bg, Color fg}) _statusColors(BuildContext context, String status) {
  final cs = Theme.of(context).colorScheme;
  switch (status.toLowerCase()) {
    case 'active':
      return (bg: cs.secondaryContainer, fg: cs.onSecondaryContainer);
    case 'pending':
      return (bg: cs.tertiaryContainer, fg: cs.onTertiaryContainer);
    case 'closed':
      return (bg: cs.errorContainer, fg: cs.onErrorContainer);
    default:
      return (bg: cs.surfaceContainerHighest, fg: cs.onSurface);
  }
}

class _ExpandableText extends StatefulWidget {
  const _ExpandableText({required this.text, this.maxLines = 3});
  final String text;
  final int maxLines;
  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final text = Text(
      widget.text,
      style: context.callout,
      maxLines: _expanded ? null : widget.maxLines,
      overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text,
        if (widget.text.length > 120)
          TextButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            child: Text(_expanded ? 'Show less' : 'Show more'),
          ),
      ],
    );
  }
}
