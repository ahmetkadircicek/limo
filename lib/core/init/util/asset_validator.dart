import 'package:flutter/services.dart';
import 'package:limo/core/constants/image_constants.dart';
import 'package:limo/core/utils/logger_service.dart';

/// Utility class for asset validation and management
class AssetValidator {
  /// Checks if all assets exist and are accessible
  static Future<bool> validateAllAssets() async {
    try {
      for (final asset in ImageAssets.allAssets) {
        await rootBundle.load(asset);
      }
      return true;
    } catch (e) {
      LoggerService.error(
        'Asset validation failed: $e',
        tag: 'ASSET_VALIDATOR',
      );
      return false;
    }
  }

  /// Checks if a specific asset exists
  static Future<bool> validateAsset(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      LoggerService.error(
        'Asset validation failed for $assetPath: $e',
        tag: 'ASSET_VALIDATOR',
      );
      return false;
    }
  }

  /// Gets asset size in bytes
  static Future<int?> getAssetSize(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);
      return data.lengthInBytes;
    } catch (e) {
      LoggerService.error(
        'Failed to get asset size for $assetPath: $e',
        tag: 'ASSET_VALIDATOR',
      );
      return null;
    }
  }

  /// Gets formatted asset size (KB, MB, etc.)
  static Future<String?> getFormattedAssetSize(String assetPath) async {
    final sizeInBytes = await getAssetSize(assetPath);
    if (sizeInBytes == null) return null;

    if (sizeInBytes < 1024) {
      return '${sizeInBytes}B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }

  /// Gets all asset information including type, size, and existence
  static Future<Map<String, Map<String, dynamic>>> getAllAssetInfo() async {
    final Map<String, Map<String, dynamic>> assetInfo = {};

    for (final asset in ImageAssets.allAssets) {
      final size = await getAssetSize(asset);
      final formattedSize = await getFormattedAssetSize(asset);

      assetInfo[asset] = {
        'type': ImageAssets.getAssetType(asset),
        'sizeInBytes': size,
        'formattedSize': formattedSize,
        'exists': size != null,
      };
    }

    return assetInfo;
  }
}
