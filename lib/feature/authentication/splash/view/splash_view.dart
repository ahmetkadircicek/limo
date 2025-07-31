import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soforvarcom/core/constants/image_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/feature/authentication/splash/viewmodel/splash_viewmodel.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Provider.of<SplashViewModel>(context, listen: false)
          .getValidation(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoadingPage());
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              ImageConstants.imageSoforvarcom,
              width: context.width * 0.6,
            ),
          ),
          // Loading indicator removed
          // Padding(
          //   padding: PaddingConstants.onlyBottomLarge,
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Lottie.asset(
          //       ImageConstants.loading,
          //       width: context.width * 0.1,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
