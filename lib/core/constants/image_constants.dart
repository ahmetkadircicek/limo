class ImageAssets {
  ImageAssets._();

  // Base paths
  static const String _pngPath = 'assets/png';
  static const String _lottiePath = 'assets/lottie';

  // PNG Images
  static const String logo = '$_pngPath/image/image_logo.png';
  static const String loginImage = '$_pngPath/image/image_login.png';

  // Lottie Animations
  static const String lottieLoader = '$_lottiePath/lottie_loader.json';
  static const String lottieLoaderReplace =
      '$_lottiePath/lottie_loader_replace.json';
  static const String lottieLostConnection =
      '$_lottiePath/lottie_lost_connetion.json';
}
