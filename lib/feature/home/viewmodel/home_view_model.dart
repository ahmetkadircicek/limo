import 'package:flutter/material.dart';

/// ViewModel for managing home page state and navigation
class HomeViewModel extends ChangeNotifier {
  HomeViewModel();

  final PageController _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  /// Instantly jump to the selected page with a right-slide animation (no intermediate pages)
  void onItemTapped(int index) {
    if (index >= 0 && index <= 4) {
      _selectedIndex = index;
      notifyListeners();
      _pageController.jumpToPage(index);
    }
  }

  /// Navigate to drawer page and clear navbar selection
  void navigateToDrawerPage(int index) {
    if (index >= 5 && index <= 12) {
      _selectedIndex = -1;
      _pageController.jumpToPage(index);
      notifyListeners();
    }
  }

  /// Open the end drawer if available
  void openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
