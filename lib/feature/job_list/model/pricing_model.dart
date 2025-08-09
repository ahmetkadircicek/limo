class PricingModel {
  final double? pricePerMile;
  final double? hourlyPrice;
  final double? dailyPrice;
  final double? extraChargeAmount;

  const PricingModel({
    this.pricePerMile,
    this.hourlyPrice,
    this.dailyPrice,
    this.extraChargeAmount,
  });

  /// Factory constructor for empty pricing
  factory PricingModel.empty() {
    return const PricingModel();
  }

  /// Check if all pricing fields are empty
  bool get isEmpty =>
      pricePerMile == null &&
      hourlyPrice == null &&
      dailyPrice == null &&
      extraChargeAmount == null;

  /// Check if at least one pricing field has a value
  bool get hasAnyPrice => !isEmpty;

  /// Get a summary of available pricing options
  String getPricingSummary() {
    if (isEmpty) return 'No pricing specified';

    List<String> availablePricing = [];

    if (pricePerMile != null) {
      availablePricing.add('\$${pricePerMile!.toStringAsFixed(2)}/mile');
    }
    if (hourlyPrice != null) {
      availablePricing.add('\$${hourlyPrice!.toStringAsFixed(2)}/hour');
    }
    if (dailyPrice != null) {
      availablePricing.add('\$${dailyPrice!.toStringAsFixed(2)}/day');
    }
    if (extraChargeAmount != null) {
      availablePricing.add('\$${extraChargeAmount!.toStringAsFixed(2)} extra');
    }

    return availablePricing.join(', ');
  }

  /// Get the primary price (first available price option)
  double? get primaryPrice {
    return pricePerMile ?? hourlyPrice ?? dailyPrice ?? extraChargeAmount;
  }

  /// Get the primary price type label
  String get primaryPriceLabel {
    if (pricePerMile != null) return 'per mile';
    if (hourlyPrice != null) return 'per hour';
    if (dailyPrice != null) return 'per day';
    if (extraChargeAmount != null) return 'extra charge';
    return 'no price';
  }

  /// Copy with method for updating individual values
  PricingModel copyWith({
    double? pricePerMile,
    double? hourlyPrice,
    double? dailyPrice,
    double? extraChargeAmount,
  }) {
    return PricingModel(
      pricePerMile: pricePerMile ?? this.pricePerMile,
      hourlyPrice: hourlyPrice ?? this.hourlyPrice,
      dailyPrice: dailyPrice ?? this.dailyPrice,
      extraChargeAmount: extraChargeAmount ?? this.extraChargeAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pricePerMile': pricePerMile,
      'hourlyPrice': hourlyPrice,
      'dailyPrice': dailyPrice,
      'extraChargeAmount': extraChargeAmount,
    };
  }

  factory PricingModel.fromJson(Map<String, dynamic> json) {
    return PricingModel(
      pricePerMile: json['pricePerMile']?.toDouble(),
      hourlyPrice: json['hourlyPrice']?.toDouble(),
      dailyPrice: json['dailyPrice']?.toDouble(),
      extraChargeAmount: json['extraChargeAmount']?.toDouble(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PricingModel &&
        other.pricePerMile == pricePerMile &&
        other.hourlyPrice == hourlyPrice &&
        other.dailyPrice == dailyPrice &&
        other.extraChargeAmount == extraChargeAmount;
  }

  @override
  int get hashCode {
    return pricePerMile.hashCode ^
        hourlyPrice.hashCode ^
        dailyPrice.hashCode ^
        extraChargeAmount.hashCode;
  }

  @override
  String toString() {
    return 'PricingModel(pricePerMile: $pricePerMile, hourlyPrice: $hourlyPrice, dailyPrice: $dailyPrice, extraChargeAmount: $extraChargeAmount)';
  }
}
