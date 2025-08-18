import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/splash/view/splash_view_mixin.dart';
import 'package:limo/feature/splash/viewmodel/splash_view_model.dart';
import 'package:limo/feature/splash/widgets/splash_loading_widget.dart';
import 'package:limo/feature/splash/widgets/splash_logo_widget.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SplashViewMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<SplashViewModel>(
      builder: (context, viewModel, child) {
        return _buildScaffold(viewModel);
      },
    );
  }

  /// Builds the main scaffold with splash content
  Widget _buildScaffold(SplashViewModel viewModel) {
    return Scaffold(
      backgroundColor: context.primary,
      body: _buildBody(viewModel),
    );
  }

  /// Builds the main body content
  Widget _buildBody(SplashViewModel viewModel) {
    return SafeArea(child: _buildContent(viewModel));
  }

  /// Builds the centered content layout
  Widget _buildContent(SplashViewModel viewModel) {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          _buildLogo(),
          const Spacer(),
          _buildLoadingIndicator(viewModel),
        ],
      ),
    );
  }

  /// Builds the app logo using reusable widget
  Widget _buildLogo() {
    return const SplashLogoWidget();
  }

  /// Builds the loading indicator using reusable widget
  Widget _buildLoadingIndicator(SplashViewModel viewModel) {
    return SplashLoadingWidget(
      isLoading: viewModel.isLoading,
      color: context.onPrimary,
    );
  }
}
