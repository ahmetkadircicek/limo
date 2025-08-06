import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel();

  final PageController _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void onItemTapped(int index) {
    _selectedIndex = index;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    notifyListeners();
  }

  void onPageChanged(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
