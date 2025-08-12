import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/splash/viewmodel/splash_view_model.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _initializeViewModel();
  }

  void _initializeViewModel() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<SplashViewModel>(context, listen: false);
      viewModel.initialize().then((isUserSignedIn) {
        _handleNavigation(isUserSignedIn);
      });
    });
  }

  void _handleNavigation(bool isUserSignedIn) async {
    if (!mounted) return;

    if (mounted) {
      if (isUserSignedIn) {
        debugPrint("Navigation to Home from Splash");
        context.go('/home');
      } else {
        debugPrint("Navigation to Login from Splash");
        context.go('/login');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Spacer(),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      context.onPrimary,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      'assets/png/image/image_logo.png',
                      width: context.width * 0.7,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Spacer(),
                  if (viewModel.isLoading)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(context.onPrimary),
                      ),
                    )
                  else
                    const SizedBox(
                      width: 24,
                      height: 24,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
