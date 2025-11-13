import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:limo/shared/models/job_model.dart';

class MapLauncher {
  static Future<void> openExternal(JobModel job) async {
    final oLat = job.pickupLocation?.lat;
    final oLng = job.pickupLocation?.lng;
    final dLat = job.dropoffLocation?.lat;
    final dLng = job.dropoffLocation?.lng;

    final url = _googleUrl(oLat, oLng, dLat, dLng);
    await _safeLaunch(url);
  }

  static Future<void> openGoogle(JobModel job) async {
    await _safeLaunch(_googleUrl(
      job.pickupLocation?.lat,
      job.pickupLocation?.lng,
      job.dropoffLocation?.lat,
      job.dropoffLocation?.lng,
    ));
  }

  static Future<void> openApple(JobModel job) async {
    await _safeLaunch(_appleUrl(
      job.pickupLocation?.lat,
      job.pickupLocation?.lng,
      job.dropoffLocation?.lat,
      job.dropoffLocation?.lng,
    ));
  }

  static Future<void> openWaze(JobModel job) async {
    await _safeLaunch(_wazeUrl(
      job.pickupLocation?.lat,
      job.pickupLocation?.lng,
      job.dropoffLocation?.lat,
      job.dropoffLocation?.lng,
    ));
  }

  static String? _googleUrl(
    double? oLat,
    double? oLng,
    double? dLat,
    double? dLng,
  ) {
    if (oLat != null && oLng != null && dLat != null && dLng != null) {
      return 'https://www.google.com/maps/dir/?api=1&origin='
          '$oLat,$oLng&destination=$dLat,$dLng&travelmode=driving';
    }
    final lat = dLat ?? oLat;
    final lng = dLng ?? oLng;
    if (lat == null || lng == null) return null;
    return 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
  }

  static String? _appleUrl(
    double? oLat,
    double? oLng,
    double? dLat,
    double? dLng,
  ) {
    // Use universal link which works on Apple devices and falls back on web elsewhere
    if (oLat != null && oLng != null && dLat != null && dLng != null) {
      return 'https://maps.apple.com/?saddr=$oLat,$oLng&daddr=$dLat,$dLng&dirflg=d';
    }
    final lat = dLat ?? oLat;
    final lng = dLng ?? oLng;
    if (lat == null || lng == null) return null;
    return 'https://maps.apple.com/?ll=$lat,$lng&q=$lat,$lng';
  }

  static String? _wazeUrl(
    double? oLat,
    double? oLng,
    double? dLat,
    double? dLng,
  ) {
    // Prefer deep link; browser link also supported
    final lat = dLat ?? oLat;
    final lng = dLng ?? oLng;
    if (lat == null || lng == null) return null;
    // Deep link
    final deep = 'waze://?ll=$lat,$lng&navigate=yes';
    return deep;
  }

  static Future<void> _safeLaunch(String? url) async {
    if (url == null) return;
    try {
      // Try deep link first; if fails and it's Waze deep link, try web fallback
      final ok = await launchUrlString(url, mode: LaunchMode.externalApplication);
      if (!ok && url.startsWith('waze://')) {
        final web = url.replaceFirst('waze://?ll=', 'https://waze.com/ul?ll=');
        await launchUrlString(web, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('Failed to open maps: $e');
      }
    }
  }
}
