import 'package:limo/feature/job_list/model/job_application_model.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';
import 'package:limo/core/services/json_data_service.dart';

/// Result class for job application operations
class JobApplicationResult {
  final bool success;
  final String message;
  final JobApplication? application;

  const JobApplicationResult({
    required this.success,
    required this.message,
    this.application,
  });
}

class JobApplicationService {
  static final JobApplicationService instance = JobApplicationService._internal();
  JobApplicationService._internal();

  /// Submit a new job application
  Future<JobApplicationResult> submitApplication({
    required String jobId,
    required String vehicleRequirementId,
    required String driverId,
    required String driverName,
    required String driverEmail,
    required String driverPhone,
    required VehicleModel vehicle,
    String? notes,
    double? proposedHourlyRate,
    double? proposedPricePerMile,
  }) async {
    try {
      // Load job data
      final jobs = await JsonDataService.loadJobsData();
      
      final jobJson = jobs.firstWhere(
        (job) => job['id'] == jobId,
        orElse: () => <String, dynamic>{},
      );
      
      if (jobJson.isEmpty) {
        return JobApplicationResult(
          success: false,
          message: 'İş bulunamadı',
          application: null,
        );
      }

      final job = JobModel.fromJson(jobJson);
      
      // Check if vehicle requirement exists
      final requirement = job.vehicleRequirements.firstWhere(
        (req) => req.id == vehicleRequirementId,
        orElse: () => VehicleRequirement.anyVehicle(),
      );
      
      if (requirement.id == 'any_vehicle') {
        return JobApplicationResult(
          success: false,
          message: 'Araç gereksinimi bulunamadı',
          application: null,
        );
      }

      // Check if vehicle meets requirements
      final vehicleMeetsRequirements = requirement.matchesVehicle(vehicle);
      
      if (!vehicleMeetsRequirements) {
        return JobApplicationResult(
          success: false,
          message: 'Araç bu gereksinimleri karşılamıyor',
          application: null,
        );
      }

      // Check if driver already applied to this requirement
      final existingApplications = job.getApplicationsForRequirement(vehicleRequirementId);
      final alreadyApplied = existingApplications.any(
        (app) => app.driverId == driverId
      );
      
      if (alreadyApplied) {
        return JobApplicationResult(
          success: false,
          message: 'Bu gereksinim için zaten başvuru yapmışsınız',
          application: null,
        );
      }

      // Create new application
      final application = JobApplication(
        id: 'app_${DateTime.now().millisecondsSinceEpoch}',
        jobId: jobId,
        vehicleRequirementId: vehicleRequirementId,
        driverId: driverId,
        driverName: driverName,
        driverEmail: driverEmail,
        driverPhone: driverPhone,
        appliedVehicle: vehicle,
        applicationDate: DateTime.now(),
        status: ApplicationStatus.pending,
        notes: notes,
        proposedHourlyRate: proposedHourlyRate,
        proposedPricePerMile: proposedPricePerMile,
        vehicleMeetsRequirements: vehicleMeetsRequirements,
        vehicleCompatibilityNotes: vehicleMeetsRequirements 
            ? 'Araç tüm gereksinimleri karşılıyor'
            : 'Araç bazı gereksinimleri karşılamıyor',
      );

      // Calculate total proposed price
      final totalPrice = application.calculateTotalProposedPrice(job, requirement);
      final updatedApplication = application.copyWith(
        totalProposedPrice: totalPrice,
      );

      return JobApplicationResult(
        success: true,
        message: 'Başvuru başarıyla gönderildi',
        application: updatedApplication,
      );

    } catch (e) {
      return JobApplicationResult(
        success: false,
        message: 'Başvuru gönderilirken hata oluştu: $e',
        application: null,
      );
    }
  }

  /// Get all applications for a specific driver
  static Future<List<JobApplication>> getDriverApplications(String driverId) async {
    try {
      final jobs = await JsonDataService.loadJobsData();
      
      final allApplications = <JobApplication>[];
      
      for (final jobJson in jobs) {
        final job = JobModel.fromJson(jobJson);
        
        for (final requirement in job.vehicleRequirements) {
          final applications = job.getApplicationsForRequirement(requirement.id);
          final driverApplications = applications.where(
            (app) => app.driverId == driverId
          );
          allApplications.addAll(driverApplications);
        }
      }
      
      return allApplications;
    } catch (e) {
      return [];
    }
  }

  /// Get all applications for a specific job
  static Future<List<JobApplication>> getJobApplications(String jobId) async {
    try {
      final jobs = await JsonDataService.loadJobsData();
      
      final jobJson = jobs.firstWhere(
        (job) => job['id'] == jobId,
        orElse: () => <String, dynamic>{},
      );
      
      if (jobJson.isEmpty) return [];
      
      final job = JobModel.fromJson(jobJson);
      return job.getAllApplications();
    } catch (e) {
      return [];
    }
  }

  /// Get applications for a specific vehicle requirement
  static Future<List<JobApplication>> getRequirementApplications(
    String jobId,
    String vehicleRequirementId,
  ) async {
    try {
      final jobs = await JsonDataService.loadJobsData();
      
      final jobJson = jobs.firstWhere(
        (job) => job['id'] == jobId,
        orElse: () => <String, dynamic>{},
      );
      
      if (jobJson.isEmpty) return [];
      
      final job = JobModel.fromJson(jobJson);
      return job.getApplicationsForRequirement(vehicleRequirementId);
    } catch (e) {
      return [];
    }
  }

  /// Get application statistics for a specific job
  static Future<Map<String, dynamic>> getJobApplicationStats(String jobId) async {
    try {
      final jobs = await JsonDataService.loadJobsData();
      
      final jobJson = jobs.firstWhere(
        (job) => job['id'] == jobId,
        orElse: () => <String, dynamic>{},
      );
      
      if (jobJson.isEmpty) return {};
      
      final job = JobModel.fromJson(jobJson);
      
      // Return basic statistics
      final allApplications = job.getAllApplications();
      final totalApplications = allApplications.length;
      
      final statusCounts = <ApplicationStatus, int>{};
      for (final status in ApplicationStatus.values) {
        statusCounts[status] = allApplications.where((app) => app.status == status).length;
      }
      
      return {
        'totalApplications': totalApplications,
        'statusCounts': statusCounts.map((key, value) => MapEntry(key.name, value)),
        'pendingCount': statusCounts[ApplicationStatus.pending] ?? 0,
        'acceptedCount': statusCounts[ApplicationStatus.accepted] ?? 0,
        'rejectedCount': statusCounts[ApplicationStatus.rejected] ?? 0,
      };
    } catch (e) {
      return {};
    }
  }

  /// Update application status
  Future<bool> updateApplicationStatus({
    required String applicationId,
    required ApplicationStatus newStatus,
    String? rejectionReason,
  }) async {
    try {
      // In a real app, this would update the database
      // For now, we'll just return success
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete an application
  Future<bool> deleteApplication(String applicationId) async {
    try {
      // In a real app, this would delete from the database
      // For now, we'll just return success
      return true;
    } catch (e) {
      return false;
    }
  }
}
