import 'package:flutter/material.dart';
import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/job_application_service.dart';
import 'package:limo/core/services/json_data_service.dart';
import 'package:limo/feature/job_list/model/job_application_model.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';
import 'package:provider/provider.dart';

class JobDetailsPage extends StatefulWidget {
  final JobModel job;

  const JobDetailsPage({super.key, required this.job});

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  final Map<String, VehicleModel?> _selectedVehicles = {};
  final Map<String, bool> _isApplying = {};
  final Map<String, JobApplication?> _userApplications = {};
  List<VehicleModel> _availableVehicles = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableVehicles();
  }

  Future<void> _loadAvailableVehicles() async {
    try {
      final vehicleData = await JsonDataService.loadVehicleData();
      if (vehicleData.containsKey('availableVehicles')) {
        final vehiclesList = vehicleData['availableVehicles'] as List<dynamic>;
        final parsedVehicles = vehiclesList
            .map((vehicleJson) {
              try {
                return VehicleModel.fromJson(vehicleJson);
              } catch (e) {
                return null;
              }
            })
            .where((vehicle) => vehicle != null)
            .cast<VehicleModel>()
            .toList();

        setState(() {
          _availableVehicles = parsedVehicles;
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (widget.job.id.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('İş Detayları'),
        backgroundColor: context.surface,
        foregroundColor: context.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: context.surfaceContainer,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCompanyCard(context),
            const SizedBox(height: 16),
            _buildRouteCard(context),
            const SizedBox(height: 16),
            _buildJobInfoCard(context),
            const SizedBox(height: 16),
            if (widget.job.description != null) ...[
              _buildDescriptionCard(),
              const SizedBox(height: 16),
            ],
            _buildVehicleRequirementsAndSelectionCard(context),
            const SizedBox(height: 16),
            _buildActionButtons(context),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.business,
                    color: context.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Şirket Bilgileri',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: context.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.business,
              label: 'Şirket Adı',
              value: widget.job.companyName ?? 'Belirtilmemiş',
              color: context.primary,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.phone,
              label: 'İletişim',
              value: widget.job.contactInfo ?? 'Belirtilmemiş',
              color: context.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.route,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Rota Bilgileri',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: context.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.location_on,
              label: 'Başlangıç',
              value: '${widget.job.fromCity ?? ''}, ${widget.job.fromProvince}',
              color: const Color(0xFF3B82F6),
            ),
            const SizedBox(height: 16),
            if (widget.job.toCity != null || widget.job.toProvince!.isNotEmpty)
              _buildInfoRow(
                icon: Icons.location_on_outlined,
                label: 'Varış',
                value: '${widget.job.toCity ?? ''}, ${widget.job.toProvince}',
                color: const Color(0xFF3B82F6),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobInfoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.work,
                    color: Color(0xFF8B5CF6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'İş Bilgileri',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: context.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.category,
              label: 'İş Türü',
              value: _getJobTypeDisplayText(widget.job.jobType),
              color: const Color(0xFF8B5CF6),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.local_shipping,
              label: 'Araç Sayısı',
              value:
                  '${widget.job.vehicleCount ?? widget.job.vehicleRequirements.length}',
              color: const Color(0xFF8B5CF6),
            ),
            if (widget.job.price != null) ...[
              const SizedBox(height: 16),
              _buildInfoRow(
                icon: Icons.attach_money,
                label: 'Fiyat',
                value: '₺${widget.job.price!.toStringAsFixed(2)}',
                color: const Color(0xFF8B5CF6),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B7280).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: Color(0xFF6B7280),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Açıklama',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.job.description ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF374151),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleRequirementsAndSelectionCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_shipping,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Araç Gereksinimleri ve Başvuru',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: context.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (widget.job.vehicleRequirements.isNotEmpty) ...[
              ...widget.job.vehicleRequirements.map((requirement) {
                return _buildRequirementSection(requirement, context);
              }),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bu iş için özel araç gereksinimi bulunmuyor. Tüm araç kategorileri kabul ediliyor.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementSection(
      VehicleRequirement requirement, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.onSurface.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.assignment,
                  color: context.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gereksinim ${requirement.id}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: context.onSurface,
                      ),
                    ),
                    Text(
                      requirement.getDescription(),
                      style: TextStyle(
                        fontSize: 14,
                        color: context.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (requirement.isFlexible)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Esnek',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (requirement.hourlyRate != null ||
              requirement.pricePerMile != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    color: const Color(0xFFF59E0B),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      requirement.getPricingSummary(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          _buildVehicleSelectionForRequirement(requirement, context),
          const SizedBox(height: 20),
          _buildApplyButton(requirement, context),
        ],
      ),
    );
  }

  Widget _buildVehicleSelectionForRequirement(
      VehicleRequirement requirement, BuildContext context) {
    final eligibleVehicles = _availableVehicles.where((vehicle) {
      return requirement.matchesVehicle(vehicle);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.directions_car,
              color: context.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Araç Seçimi',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: eligibleVehicles.isNotEmpty
                    ? context.primary.withOpacity(0.1)
                    : context.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                eligibleVehicles.isNotEmpty
                    ? '${eligibleVehicles.length} uygun araç'
                    : 'Uygun araç yok',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: eligibleVehicles.isNotEmpty
                      ? context.primary
                      : context.error,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (eligibleVehicles.isEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: context.error.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: context.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Bu gereksinim için uygun araç bulunmuyor. Araç kategorinizi yükseltmeyi düşünebilirsiniz.',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.error.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.onSurface.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              Text(
                eligibleVehicles.isNotEmpty
                    ? 'Bu gereksinim için uygun araçlarınız:'
                    : 'Mevcut araçlarınız (gereksinimlerle uyumsuz):',
                style: TextStyle(
                  fontSize: 14,
                  color: context.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
              ..._availableVehicles.map((vehicle) {
                final isEligible = eligibleVehicles.contains(vehicle);
                final isSelected =
                    _selectedVehicles[requirement.id]?.licencePlate ==
                        vehicle.licencePlate;
                return ListTile(
                  title: Text('${vehicle.brand} ${vehicle.model}'),
                  subtitle: Text(
                      '${vehicle.year} • ${vehicle.capacity} kişi • ${vehicle.licencePlate}'),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: context.primary)
                      : null,
                  onTap: isEligible
                      ? () {
                          setState(() {
                            _selectedVehicles[requirement.id] = vehicle;
                          });
                        }
                      : null,
                  enabled: isEligible,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApplyButton(
      VehicleRequirement requirement, BuildContext context) {
    final selectedVehicle = _selectedVehicles[requirement.id];
    final isApplying = _isApplying[requirement.id] ?? false;
    final isVehicleEligible =
        selectedVehicle != null && requirement.matchesVehicle(selectedVehicle);
    final canApply =
        selectedVehicle != null && isVehicleEligible && !isApplying;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canApply
            ? () => _applyToRequirement(requirement, selectedVehicle)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              canApply ? context.primary : context.onSurface.withOpacity(0.1),
          foregroundColor:
              canApply ? Colors.white : context.onSurface.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isApplying
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                selectedVehicle == null
                    ? 'Önce Araç Seçin'
                    : !isVehicleEligible
                        ? 'Seçilen Araç Uygun Değil'
                        : 'Bu Gereksinim İçin Başvuru Yap',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _applyToRequirement(
      VehicleRequirement requirement, VehicleModel vehicle) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (!userProvider.isLoggedIn) {
      _showErrorSnackbar('Başvuru yapmak için giriş yapmalısınız');
      return;
    }

    setState(() {
      _isApplying[requirement.id] = true;
    });

    try {
      final result = await JobApplicationService.instance.submitApplication(
        jobId: widget.job.id,
        vehicleRequirementId: requirement.id,
        driverId: userProvider.currentUser!.id,
        driverName: userProvider.currentUser!.displayName,
        driverEmail: userProvider.currentUser!.email,
        driverPhone: '',
        vehicle: vehicle,
        notes: 'Otomatik başvuru',
      );

      if (result.success) {
        setState(() {
          _userApplications[requirement.id] = result.application;
        });
        _showSuccessSnackbar('Başvuru başarıyla gönderildi!');
      } else {
        _showErrorSnackbar(result.message);
      }
    } catch (e) {
      _showErrorSnackbar('Başvuru gönderilirken hata oluştu: $e');
    } finally {
      setState(() {
        _isApplying[requirement.id] = false;
      });
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _getJobTypeDisplayText(JobType? jobType) {
    switch (jobType) {
      case JobType.pointToPoint:
        return 'Nokta-Nokta';
      case JobType.fullDay:
        return 'Günlük Kiralama';
      case JobType.hourly:
        return 'Saatlik Kiralama';
      default:
        return 'Belirtilmemiş';
    }
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: context.onSurface.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: context.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('İletişim bilgileri gösterilecek'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            icon: const Icon(Icons.phone, size: 20),
            label: const Text('İletişim'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF3B82F6),
              side: const BorderSide(color: Color(0xFF3B82F6)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Paylaşım seçenekleri gösterilecek'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Icons.share, size: 20),
            label: const Text('Paylaş'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF10B981),
              side: const BorderSide(color: Color(0xFF10B981)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
