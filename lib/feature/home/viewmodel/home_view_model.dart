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

  // Additional pages from drawer
  final int _vehicleManagementIndex = 3;
  final int _profileIndex = 4;

  int get vehicleManagementIndex => _vehicleManagementIndex;
  int get profileIndex => _profileIndex;

  /// Handle navigation item tap and update selected index
  void onItemTapped(int index) {
    _selectedIndex = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  /// Navigate to vehicle management page
  void navigateToVehicleManagement() {
    _selectedIndex = _vehicleManagementIndex;
    _pageController.jumpToPage(_vehicleManagementIndex);
    notifyListeners();
  }

  /// Navigate to profile page
  void navigateToProfile() {
    _selectedIndex = _profileIndex;
    _pageController.jumpToPage(_profileIndex);
    notifyListeners();
  }

  /// Handle page change from PageView
  void onPageChanged(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  /// Open the end drawer if available
  void openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  /// Notify that a job was created and refresh the job list
  void onJobCreated() {
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
