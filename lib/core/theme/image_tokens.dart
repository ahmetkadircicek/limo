class ImageTokens {
  static const String _pngBase = 'assets/png';
  static const String _svgBase = 'assets/svg';
  static const String _lottieBase = 'assets/lottie';
  static const String _jsonBase = 'assets/json';
  static const String _fontsBase = 'assets/fonts';

  static String png(String name) => '$_pngBase/$name.png';
  static String svg(String name) => '$_svgBase/$name.svg';
  static String lottie(String name) => '$_lottieBase/$name.json';
  static String json(String name) => '$_jsonBase/$name.json';
  static String font(String name) => '$_fontsBase/$name';

  // Logical names mapping (avoid hardcoded paths in UI)
  static final String logo = 'assets/png/image/image_logo.png';
  static final String loginImage = 'assets/png/image/image_login.png';
  static final String carRepair = 'assets/png/image/image_car_repair.png';
  static final String profile = 'assets/png/image/image_profile.png';
  static final String dashboard = 'assets/png/image/image_dashboard.png';
  static final String addFile = 'assets/png/image/image_add_file.png';
  static final String confirmed = 'assets/png/image/image_confirmed.png';
  static final String success = 'assets/png/image/image_success.png';

  static final String lottieLoader = 'assets/lottie/lottie_loader.json';
  static final String lottieLoaderReplace =
      'assets/lottie/lottie_loader_replace.json';
  static final String lottieLostConnection =
      'assets/lottie/lottie_lost_connetion.json';
}
