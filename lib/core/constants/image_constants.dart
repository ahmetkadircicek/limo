/// Centralized image asset management for the entire app
///
/// This class provides easy access to all image assets used in the app.
/// All image paths are defined here to avoid hardcoding paths throughout the codebase.
class ImageAssets {
  // Private constructor to prevent instantiation
  ImageAssets._();

  // Base paths
  static const String _pngPath = 'assets/png';
  static const String _lottiePath = 'assets/lottie';
  static const String _jsonPath = 'assets/json';

  // PNG Images
  static const String logo = '$_pngPath/image/image_logo.png';
  static const String loginImage = '$_pngPath/image/image_login.png';

  // Lottie Animations
  static const String lottieLoader = '$_lottiePath/lottie_loader.json';
  static const String lottieLoaderReplace =
      '$_lottiePath/lottie_loader_replace.json';
  static const String lottieLostConnection =
      '$_lottiePath/lottie_lost_connetion.json';

  // JSON Files
  static const String mapTheme = '$_jsonPath/map_theme.json';

  // Convenience getters for commonly used assets
  static const List<String> allPngImages = [logo, loginImage];

  static const List<String> allLottieAnimations = [
    lottieLoader,
    lottieLoaderReplace,
    lottieLostConnection,
  ];

  static const List<String> allJsonFiles = [mapTheme];

  /// Gets all image assets as a single list
  static List<String> get allAssets => [
    ...allPngImages,
    ...allLottieAnimations,
    ...allJsonFiles,
  ];

  /// Checks if an asset path is valid
  static bool isValidAsset(String path) {
    return allAssets.contains(path);
  }

  /// Gets asset type based on file extension
  static String getAssetType(String path) {
    if (path.endsWith('.png')) return 'PNG Image';
    if (path.endsWith('.json')) {
      if (path.contains('lottie')) return 'Lottie Animation';
      return 'JSON File';
    }
    return 'Unknown';
  }
}

/// Extension methods for easier asset usage
extension ImageAssetsExtension on String {
  /// Checks if this string is a valid asset path
  bool get isAsset => ImageAssets.isValidAsset(this);

  /// Gets the asset type for this path
  String get assetType => ImageAssets.getAssetType(this);
}
