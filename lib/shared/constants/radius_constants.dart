import 'package:flutter/material.dart';

class RadiusConstants {
  static const double zeroRadius = 0.0;
  static const double standardRadius = 12.0;
  static const double roundRadius = 9999.0;

  static const BorderRadius standard =
      BorderRadius.all(Radius.circular(standardRadius));
  static const BorderRadius round =
      BorderRadius.all(Radius.circular(roundRadius));
  static const BorderRadius no = BorderRadius.all(Radius.circular(zeroRadius));
}
