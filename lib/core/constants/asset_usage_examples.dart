import 'package:flutter/material.dart';
import 'package:limo/core/constants/image_constants.dart';
import 'package:limo/core/init/util/asset_helper.dart';
import 'package:limo/core/init/util/asset_validator.dart';

/// Example usage of the asset management system
/// This file demonstrates how to use the centralized asset management
class AssetUsageExamples {
  /// Shows basic image usage with ImageAssets constants
  static Widget basicImageExample() {
    return Column(
      children: [
        // Using the centralized constants
        Image.asset(ImageAssets.logo),
        Image.asset(ImageAssets.loginImage),

        // Using the helper methods
        AssetHelper.logo(width: 100, height: 100),
        AssetHelper.loginImage(width: 200, height: 150),
      ],
    );
  }

  /// Shows styled image usage with AssetHelper
  static Widget styledImageExample() {
    return Column(
      children: [
        AssetHelper.image(
          assetPath: ImageAssets.logo,
          width: 120,
          height: 120,
          color: Colors.blue,
          colorBlendMode: BlendMode.modulate,
        ),

        AssetHelper.image(
          assetPath: ImageAssets.loginImage,
          width: 300,
          height: 200,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  /// Shows error handling and fallback examples
  static Widget errorHandlingExample() {
    return Column(
      children: [
        // Custom error widget
        AssetHelper.image(
          assetPath: ImageAssets.logo,
          width: 100,
          height: 100,
          errorWidget: Container(
            width: 100,
            height: 100,
            color: Colors.red[100],
            child: const Icon(Icons.error, color: Colors.red),
          ),
        ),

        // Network image with asset fallback
        AssetHelper.networkImageWithFallback(
          networkUrl: 'https://example.com/image.jpg',
          fallbackAsset: ImageAssets.logo,
          width: 150,
          height: 150,
        ),
      ],
    );
  }

  /// Shows asset validation examples
  static Future<Widget> validationExample() async {
    final allAssetsValid = await AssetValidator.validateAllAssets();
    final assetInfo = await AssetValidator.getAllAssetInfo();

    return Column(
      children: [
        Text('All assets valid: $allAssetsValid'),
        const SizedBox(height: 20),
        ...assetInfo.entries.map(
          (entry) => ListTile(
            title: Text(entry.key.split('/').last),
            subtitle: Text(
              '${entry.value['type']} - ${entry.value['formattedSize']}',
            ),
            trailing: Icon(
              entry.value['exists'] ? Icons.check_circle : Icons.error,
              color: entry.value['exists'] ? Colors.green : Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  /// Shows extension method usage examples
  static Widget extensionExample() {
    final logoPath = ImageAssets.logo;

    return Column(
      children: [
        Text('Is asset: ${logoPath.isAsset}'),
        Text('Asset type: ${logoPath.assetType}'),

        // This would work with any string
        Text('Is "random/path.png" an asset: ${"random/path.png".isAsset}'),
      ],
    );
  }

  /// Shows lottie animation examples
  static Widget lottieExample() {
    return Column(
      children: [
        AssetHelper.lottie(
          assetPath: ImageAssets.lottieLoader,
          width: 200,
          height: 200,
        ),

        AssetHelper.lottie(
          assetPath: ImageAssets.lottieLostConnection,
          width: 150,
          height: 150,
        ),
      ],
    );
  }

  /// Shows asset lists and iteration examples
  static Widget assetListsExample() {
    return Column(
      children: [
        Text('PNG Images:'),
        ...ImageAssets.allPngImages.map(
          (asset) => Text('  - ${asset.split('/').last}'),
        ),

        const SizedBox(height: 20),

        Text('Lottie Animations:'),
        ...ImageAssets.allLottieAnimations.map(
          (asset) => Text('  - ${asset.split('/').last}'),
        ),

        const SizedBox(height: 20),

        Text('Total Assets: ${ImageAssets.allAssets.length}'),
      ],
    );
  }
}

/// Example widget that demonstrates all features
class AssetManagementDemo extends StatefulWidget {
  const AssetManagementDemo({super.key});

  @override
  State<AssetManagementDemo> createState() => _AssetManagementDemoState();
}

class _AssetManagementDemoState extends State<AssetManagementDemo> {
  bool _showValidation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Management Demo'),
        actions: [
          IconButton(
            icon: Icon(_showValidation ? Icons.image : Icons.check_circle),
            onPressed: () => setState(() => _showValidation = !_showValidation),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_showValidation) ...[
              const Text(
                'Basic Examples:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              AssetUsageExamples.basicImageExample(),

              const SizedBox(height: 32),
              const Text(
                'Styled Examples:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              AssetUsageExamples.styledImageExample(),

              const SizedBox(height: 32),
              const Text(
                'Asset Lists:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              AssetUsageExamples.assetListsExample(),
            ] else ...[
              const Text(
                'Asset Validation:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              FutureBuilder<Widget>(
                future: AssetUsageExamples.validationExample(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return snapshot.data ??
                      const Text('Error loading validation');
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
