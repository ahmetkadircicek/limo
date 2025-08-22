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

  /// Handle navigation item tap and update selected index
  void onItemTapped(int index) {
    // Only allow navigation between main pages (0-4)
    if (index >= 0 && index <= 4) {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
      notifyListeners();
    }
  }

  /// Handle page change from PageView
  void onPageChanged(int index) {
    // Only allow navigation between main pages (0-4)
    if (index >= 0 && index <= 4) {
      _selectedIndex = index;
      notifyListeners();
    } else {
      // If user tries to swipe to drawer-only pages, revert to last valid page
      _pageController.jumpToPage(_selectedIndex);
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
