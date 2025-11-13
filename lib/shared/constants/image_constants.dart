import 'package:flutter/material.dart';
import 'package:limo/core/theme/image_tokens.dart';

@immutable
final class ImageConstants {
  const ImageConstants._();

  // Centralized tokens
  static final String logo = ImageTokens.logo;
  static final String loginImage = ImageTokens.loginImage;
  static final String carRepair = ImageTokens.carRepair;
  static final String profile = ImageTokens.profile;
  static final String dashboard = ImageTokens.dashboard;
  static final String addFile = ImageTokens.addFile;
  static final String confirmed = ImageTokens.confirmed;
  static final String success = ImageTokens.success;
  static final String background = ImageTokens.background;

  static final String lottieLoader = ImageTokens.lottieLoader;
  static final String lottieLoaderReplace = ImageTokens.lottieLoaderReplace;
  static final String lottieLostConnection = ImageTokens.lottieLostConnection;
}
