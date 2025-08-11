import 'package:flutter/material.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/core/enums/vehicle_category_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/feature/job_list/widget/vehicle_selection_widget.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';

class JobDetailsPage extends StatelessWidget {
  final JobModel job;

  const JobDetailsPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
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
        padding: PaddingConstants.allM,
        child: Column(
          children: [
            _buildCompanyCard(context),
            const SizedBox(height: 16),
            _buildRouteCard(context),
            const SizedBox(height: 16),
            _buildJobInfoCard(context),
            const SizedBox(height: 16),
            if (job.description != null) ...[
              _buildDescriptionCard(),
              const SizedBox(height: 16),
            ],
            _buildVehicleRequirementsCard(),
            const SizedBox(height: 16),
            _buildVehicleSelectionCard(context),
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
              icon: Icons.business_outlined,
              label: 'Şirket Adı',
              value: job.companyName ?? 'Belirtilmemiş',
              color: context.primary,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.phone_outlined,
              label: 'İletişim',
              value: job.contactInfo ?? 'Belirtilmemiş',
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
                    color: context.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.route,
                    color: context.primary,
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
            const SizedBox(height: 20),

            // Route visualization
            Row(
              children: [
                // From location
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: context.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'BAŞLANGIÇ',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.fromProvince.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            if (job.fromCity != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                job.fromCity!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
                ),

                // To location
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: context.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'VARIŞ',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: context.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.toProvince.isNotEmpty
                                  ? job.toProvince.toUpperCase()
                                  : 'BELIRTILMEMIŞ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            if (job.toCity != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                job.toCity!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobInfoCard(BuildContext context) {
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
                    color: const Color(0xFFF59E0B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Color(0xFFF59E0B),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'İş Bilgileri',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Job type
            _buildInfoRow(
              icon: Icons.work_outline,
              label: 'İş Türü',
              value: _getJobTypeText(job.jobType),
              color: const Color(0xFF3B82F6),
            ),
            const SizedBox(height: 12),

            // Vehicle count
            _buildInfoRow(
              icon: Icons.local_shipping_outlined,
              label: 'Araç Sayısı',
              value: job.vehicleCount != null
                  ? '${job.vehicleCount} araç'
                  : 'Belirtilmemiş',
              color: const Color(0xFF8B5CF6),
            ),
            const SizedBox(height: 12),

            // Price
            _buildInfoRow(
              icon: Icons.attach_money,
              label: 'Fiyat',
              value: job.price != null
                  ? '₺${job.price!.toStringAsFixed(0)}'
                  : 'Teklif Bazlı',
              color: const Color(0xFF10B981),
            ),
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
              job.description ?? '',
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

  Widget _buildVehicleRequirementsCard() {
    if (job.vehicleRequirements.isEmpty) {
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
                      color: const Color(0xFF8B5CF6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.local_shipping,
                      color: Color(0xFF8B5CF6),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Araç Gereksinimleri',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Herhangi bir araç kabul edilir',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      );
    }

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
                    color: const Color(0xFF8B5CF6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_shipping,
                    color: Color(0xFF8B5CF6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Araç Gereksinimleri',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Show each vehicle requirement separately
            ...job.vehicleRequirements.map(
                (requirement) => _buildVehicleRequirementItem(requirement)),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleRequirementItem(VehicleRequirement requirement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category requirement
          if (requirement.minimumCategory != null) ...[
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Min: ${requirement.minimumCategory!.displayName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ID: ${requirement.minimumCategory!.id}',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Description
          Text(
            requirement.getDescription(),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),

          // Pricing
          if (requirement.hourlyRate != null ||
              requirement.pricePerMile != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.attach_money,
                    color: Color(0xFF10B981),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    requirement.getPricingSummary(),
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVehicleSelectionCard(BuildContext context) {
    // Mock available vehicles for demonstration
    // In a real app, this would come from a service or provider
    final mockAvailableVehicles = [
      VehicleModel(
        licencePlate: '34 ABC 123',
        brand: 'Mercedes',
        model: 'C-Class',
        year: 2022,
        capacity: 5,
        vehicleType: 'Sedan',
        interiorColor: 'Black',
        exteriorColor: 'White',
        category: VehicleCategory.luxurySedan,
        hourlyRate: 150.0,
        pricePerMile: 2.5,
      ),
      VehicleModel(
        licencePlate: '34 DEF 456',
        brand: 'BMW',
        model: '3 Series',
        year: 2021,
        capacity: 5,
        vehicleType: 'Sedan',
        interiorColor: 'Beige',
        exteriorColor: 'Blue',
        category: VehicleCategory.premiumSedan,
        hourlyRate: 120.0,
        pricePerMile: 2.0,
      ),
      VehicleModel(
        licencePlate: '34 GHI 789',
        brand: 'Volkswagen',
        model: 'Passat',
        year: 2020,
        capacity: 5,
        vehicleType: 'Sedan',
        interiorColor: 'Gray',
        exteriorColor: 'Silver',
        category: VehicleCategory.standardSedan,
        hourlyRate: 80.0,
        pricePerMile: 1.5,
      ),
    ];

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
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Araç Seçimi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            VehicleSelectionWidget(
              job: job,
              availableVehicles: mockAvailableVehicles,
              onVehicleSelected: (selectedVehicle, requirement) {
                // Handle vehicle selection
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Seçilen araç: ${selectedVehicle.brand} ${selectedVehicle.model}',
                    ),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
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
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1A1A1A),
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
        // Primary action - Make offer
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to make offer screen
              _showOfferDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A1A),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_offer, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Teklif Ver',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Secondary actions
        Row(
          children: [
            // Contact button
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    // Make phone call
                    _showContactDialog(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF10B981),
                    side: const BorderSide(color: Color(0xFF10B981)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone,
                          size: 20), // Icon rengi buton renginden gelecek
                      const SizedBox(width: 8),
                      const Text(
                        'İletişim',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Share button
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    // Share job details
                    _shareJob(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF3B82F6),
                    side: const BorderSide(color: Color(0xFF3B82F6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share,
                          size: 20), // Icon rengi buton renginden gelecek
                      const SizedBox(width: 8),
                      const Text(
                        'Paylaş',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showOfferDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Teklif Ver'),
        content: const Text('Teklif verme özelliği yakında eklenecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('İletişim'),
        content: Text('${job.contactInfo}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Here you would implement actual phone call
            },
            child: const Text('Ara'),
          ),
        ],
      ),
    );
  }

  void _shareJob(BuildContext context) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Paylaşma özelliği yakında eklenecek'),
        backgroundColor: Color(0xFF3B82F6),
      ),
    );
  }

  String _getJobTypeText(dynamic jobType) {
    if (jobType == null) return 'Belirtilmemiş';

    if (jobType is JobType) {
      switch (jobType) {
        case JobType.pointToPoint:
          return 'Nokta-Nokta';
        case JobType.fullDay:
          return 'Tam Gün';
        case JobType.hourly:
          return 'Saatlik';
      }
    }

    // Fallback for other enum types
    return jobType.toString().split('.').last;
  }
}
