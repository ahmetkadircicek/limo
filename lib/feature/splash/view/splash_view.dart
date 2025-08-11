import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/home/view/home_view.dart';
import 'package:limo/feature/login/view/login_view.dart';
import 'package:limo/feature/splash/viewmodel/splash_view_model.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _initializeViewModel();
  }

  void _initializeViewModel() {
    _viewModel = SplashViewModel();

    _viewModel.initialize().then((isUserSignedIn) {
      _handleNavigation(isUserSignedIn);
    });
  }

  void _handleNavigation(bool isUserSignedIn) async {
    if (!mounted) return;

    final destination = isUserSignedIn ? const HomeView() : const LoginView();

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
      ),
    );
  }
}
