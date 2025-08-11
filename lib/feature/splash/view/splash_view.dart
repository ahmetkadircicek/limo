import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/splash/viewmodel/splash_view_model.dart';
import 'package:provider/provider.dart';

/// Splash Screen with MVVM pattern
/// Checks user authentication and navigates accordingly
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeViewModel();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  void _initializeViewModel() {
    _viewModel = SplashViewModel();

    // Start the initialization process
    _viewModel.initialize().then((_) {
      _handleNavigation();
    });
  }

  void _handleNavigation() async {
    if (!mounted) return;

    final destination = await _viewModel.getNavigationDestination();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => destination,
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<SplashViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        context
                            .primary, // Splash sayfasında primary renk üzerinde logo
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        'assets/png/image/image_logo.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: context.spacingXxxl),

                    // Loading Indicator
                    if (viewModel.isLoading)
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(context.primary),
                        ),
                      )
                    else if (viewModel.isInitialized)
                      // Show checkmark when initialization is complete
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: context.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
