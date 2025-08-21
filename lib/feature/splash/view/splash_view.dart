import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/app_state_provider.dart';
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
    return Consumer2<SplashViewModel, AppStateProvider>(
      builder: (context, viewModel, appState, child) {
        return _buildScaffold(viewModel, appState);
      },
    );
  }

  /// Builds the main scaffold with splash content
  Widget _buildScaffold(SplashViewModel viewModel, AppStateProvider appState) {
    return Scaffold(
      backgroundColor: context.primary,
      body: _buildBody(viewModel, appState),
    );
  }

  /// Builds the main body content
  Widget _buildBody(SplashViewModel viewModel, AppStateProvider appState) {
    return SafeArea(child: _buildContent(viewModel, appState));
  }

  /// Builds the centered content layout
  Widget _buildContent(SplashViewModel viewModel, AppStateProvider appState) {
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
