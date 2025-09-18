import 'package:flutter/material.dart';

/// ViewModel for managing home page state and navigation
class NavigationViewModel extends ChangeNotifier {
  NavigationViewModel();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  final PageController _pageController = PageController();
  PageController get pageController => _pageController;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void onItemTapped(int index) {
    if (index >= 0 && index <= 4) {
      _selectedIndex = index;
      notifyListeners();
      _pageController.jumpToPage(index);
    }
  }

  void navigateToDrawerPage(int index) {
    if (index >= 5 && index <= 12) {
      _selectedIndex = -1;
      _pageController.jumpToPage(index);
      notifyListeners();
    }
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
