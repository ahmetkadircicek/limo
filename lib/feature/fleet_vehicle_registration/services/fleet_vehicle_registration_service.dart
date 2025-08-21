import 'package:limo/core/services/api_client.dart';
import 'package:limo/core/utils/logger_service.dart';

class FleetVehicleRegistrationService {
  static const String _tag = 'FleetVehicleRegistrationService';

  // Submit vehicle to fleet
  Future<void> submitVehicle(Map<String, dynamic> vehicleData) async {
    try {
      LoggerService.info('Submitting vehicle to fleet: $vehicleData', tag: _tag);

      // TODO: Replace with actual endpoint when available
      await ApiClient.post('/api/fleet/vehicles', data: vehicleData);

      LoggerService.info('Vehicle submitted to fleet successfully', tag: _tag);
    } catch (e) {
      LoggerService.error('Failed to submit vehicle to fleet: $e', tag: _tag);
      rethrow;
    }
  }
}
