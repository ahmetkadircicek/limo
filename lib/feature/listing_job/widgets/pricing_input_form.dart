import 'package:flutter/material.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/pricing_model.dart';
import 'package:limo/shared/app_components.dart';

class PricingInputForm extends StatefulWidget {
  final PricingModel? initialPricing;
  final Function(PricingModel) onPricingChanged;
  final bool enabled;
  final JobType? jobType; // Added to determine which pricing to show

  const PricingInputForm({
    super.key,
    this.initialPricing,
    required this.onPricingChanged,
    this.enabled = true,
    this.jobType,
  });

  @override
  State<PricingInputForm> createState() => _PricingInputFormState();
}

class _PricingInputFormState extends State<PricingInputForm> {
  final TextEditingController _pricePerMileController = TextEditingController();
  final TextEditingController _hourlyPriceController = TextEditingController();
  final TextEditingController _dailyPriceController = TextEditingController();
  final TextEditingController _extraChargeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFromPricing();
  }

  void _initializeFromPricing() {
    if (widget.initialPricing != null) {
      final pricing = widget.initialPricing!;

      if (pricing.pricePerMile != null) {
        _pricePerMileController.text = pricing.pricePerMile.toString();
      }
      if (pricing.hourlyPrice != null) {
        _hourlyPriceController.text = pricing.hourlyPrice.toString();
      }
      if (pricing.dailyPrice != null) {
        _dailyPriceController.text = pricing.dailyPrice.toString();
      }
      if (pricing.extraChargeAmount != null) {
        _extraChargeController.text = pricing.extraChargeAmount.toString();
      }
    }
  }

  void _updatePricing() {
    final pricing = PricingModel(
      pricePerMile: _pricePerMileController.text.isNotEmpty
          ? double.tryParse(_pricePerMileController.text)
          : null,
      hourlyPrice: _hourlyPriceController.text.isNotEmpty
          ? double.tryParse(_hourlyPriceController.text)
          : null,
      dailyPrice: _dailyPriceController.text.isNotEmpty
          ? double.tryParse(_dailyPriceController.text)
          : null,
      extraChargeAmount: _extraChargeController.text.isNotEmpty
          ? double.tryParse(_extraChargeController.text)
          : null,
    );

    widget.onPricingChanged(pricing);
  }

  String _getPrimaryPriceHint() {
    switch (widget.jobType) {
      case JobType.pointToPoint:
        return 'Enter price per mile (e.g., 2.50)';
      case JobType.hourly:
        return 'Enter hourly rate (e.g., 25.00)';
      case JobType.fullDay:
        return 'Enter daily rate (e.g., 200.00)';
      default:
        return 'Enter price';
    }
  }

  IconData _getPrimaryPriceIcon() {
    switch (widget.jobType) {
      case JobType.pointToPoint:
        return Icons.route;
      case JobType.hourly:
        return Icons.access_time;
      case JobType.fullDay:
        return Icons.calendar_today;
      default:
        return Icons.monetization_on;
    }
  }

  TextEditingController _getPrimaryController() {
    switch (widget.jobType) {
      case JobType.pointToPoint:
        return _pricePerMileController;
      case JobType.hourly:
        return _hourlyPriceController;
      case JobType.fullDay:
        return _dailyPriceController;
      default:
        return _pricePerMileController;
    }
  }

  @override
  void dispose() {
    _pricePerMileController.dispose();
    _hourlyPriceController.dispose();
    _dailyPriceController.dispose();
    _extraChargeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.jobType != null) ...[
          // Primary price based on job type
          AppInput.primary(
            controller: _getPrimaryController(),
            hintText: _getPrimaryPriceHint(),
            prefixIcon: _getPrimaryPriceIcon(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            enabled: widget.enabled,
            onChanged: (value) => _updatePricing(),
          ),
          SizedBox(height: PaddingConstants.spacingM),

          // Pricing info
          Container(
            height: 48.0, // Same as text fields
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: context.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: context.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 24.0,
                  color: context.primary.withOpacity(0.7),
                ),
                SizedBox(width: PaddingConstants.spacingM),
                Expanded(
                  child: Text(
                    _getJobTypePricingInfo(),
                    style: TextStyle(
                      // Same as text fields
                      color: context.onSurface.withOpacity(0.7),
                      height: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: PaddingConstants.spacingM),

          // Extra charge (always available)
          AppInput.primary(
            controller: _extraChargeController,
            hintText: 'Extra charges (optional, e.g., 50.00)',
            prefixIcon: Icons.add_circle_outline,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            enabled: widget.enabled,
            onChanged: (value) => _updatePricing(),
          ),
        ],
      ],
    );
  }

  String _getJobTypePricingInfo() {
    switch (widget.jobType) {
      case JobType.pointToPoint:
        return 'Set the price per mile for point-to-point transportation. This will be multiplied by the total distance.';
      case JobType.hourly:
        return 'Set the hourly rate for time-based services. This will be multiplied by the number of hours worked.';
      case JobType.fullDay:
        return 'Set the daily rate for full-day services. This is a fixed rate per day regardless of hours.';
      default:
        return 'Configure pricing based on your job requirements.';
    }
  }
}
