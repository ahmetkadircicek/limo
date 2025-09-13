import 'package:flutter/material.dart';
import 'package:limo/feature/splash/view/splash_view_mixin.dart';
import 'package:limo/feature/splash/widgets/splash_loading_widget.dart';
import 'package:limo/feature/splash/widgets/splash_logo_widget.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SplashMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primary,
      body: SafeArea(child: _buildContent()),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          SplashLogoWidget(),
          const Spacer(),
          SplashLoadingWidget(),
        ],
      ),
    );
  }
}
