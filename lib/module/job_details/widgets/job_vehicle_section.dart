import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:limo/module/job_details/view_model/job_details_view_model.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/models/car_requirement_model.dart';

class JobVehicleSection extends StatefulWidget {
  const JobVehicleSection({super.key});

  @override
  State<JobVehicleSection> createState() => _JobVehicleSectionState();
}

class _JobVehicleSectionState extends State<JobVehicleSection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    // context.select kullanarak sadece 'cars' listesini dinliyoruz.
    final cars = context.select<JobDetailsViewModel, List<CarRequirementModel>>((vm) => vm.job.cars);

    if (cars.isEmpty) {
      return const SizedBox.shrink(); // Araç yoksa boş döner
    }

    final visibleCars = _showAll ? cars : cars.take(3).toList();

    return SharedCard(
      backgroundColor: context.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vehicle Requirements', style: context.headline),
          const SizedBox(height: 12),
          ...visibleCars.map((car) => _VehicleItem(car: car)),
          
          if (cars.length > 3)
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => setState(() => _showAll = !_showAll),
                child: Text(_showAll ? 'Show Less' : 'Show All (${cars.length})'),
              ),
            ),
        ],
      ),
    );
  }
}

class _VehicleItem extends StatelessWidget {
  const _VehicleItem({required this.car});
  final CarRequirementModel car;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
         border: Border(bottom: BorderSide(color: context.outline.withOpacity(0.1))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${car.brandName ?? ""} ${car.modelName ?? ""} ${car.categoryName ?? ""}',
            style: context.body.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _FeeBadge(text: 'Mile \$${car.mileFee}'),
              const SizedBox(width: 8),
              _FeeBadge(text: 'Hour \$${car.hourlyFee}'),
              const Spacer(),
              Text('${car.capacity} Seats', style: context.caption1),
            ],
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text, 
        style: context.caption1.copyWith(color: Colors.green.shade800, fontWeight: FontWeight.w600),
      ),
    );
  }
}