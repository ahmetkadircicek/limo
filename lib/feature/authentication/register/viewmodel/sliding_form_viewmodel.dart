import 'package:flutter/material.dart';

class SlidingFormViewModel with ChangeNotifier {
  double _formHeightRatio = 0.5; // Start at 50% of screen height
  bool _isExpanded = false;
  bool _hasAnyFocus = false;
  bool _isKeyboardVisible = false;
  bool _keyboardAwareMode = true; // Enable smart keyboard handling

  // Getters
  double get formHeightRatio => _formHeightRatio;
  bool get isExpanded => _isExpanded;
  bool get hasAnyFocus => _hasAnyFocus;
  bool get isKeyboardVisible => _isKeyboardVisible;

  // Animation duration for smooth transitions
  Duration get animationDuration => const Duration(milliseconds: 250);

  /// Expands the form to 80% of screen height
  void expandForm() {
    if (!_isExpanded) {
      _formHeightRatio = 0.8;
      _isExpanded = true;
      notifyListeners();
      debugPrint(
          'SlidingForm: Expanded to ${(_formHeightRatio * 100).round()}%');
    }
  }

  /// Collapses the form back to 50% of screen height
  void collapseForm() {
    if (_isExpanded) {
      _formHeightRatio = 0.5;
      _isExpanded = false;
      notifyListeners();
      debugPrint(
          'SlidingForm: Collapsed to ${(_formHeightRatio * 100).round()}%');
    }
  }

  /// Toggles between expanded and collapsed states
  void toggleForm() {
    if (_isExpanded) {
      collapseForm();
    } else {
      expandForm();
    }
  }

  /// Called when keyboard visibility changes
  void onKeyboardVisibilityChanged(bool isVisible) {
    _isKeyboardVisible = isVisible;

    if (_keyboardAwareMode) {
      if (isVisible) {
        // Keyboard opened - expand form for better visibility
        _smartExpandForm();
      } else {
        // Keyboard closed - collapse if no focus
        if (!_hasAnyFocus) {
          collapseForm();
        }
      }
    }

    debugPrint('SlidingForm: Keyboard ${isVisible ? "opened" : "closed"}');
  }

  /// Smart expand that considers keyboard state
  void _smartExpandForm() {
    if (!_isExpanded) {
      _formHeightRatio = 0.8;
      _isExpanded = true;
      notifyListeners();
      debugPrint('SlidingForm: Smart expanded due to keyboard');
    }
  }

  /// Called when any field gains focus
  void onFieldFocused() {
    _hasAnyFocus = true;

    // Only expand if keyboard is not visible (to avoid double animation)
    if (_keyboardAwareMode && !_isKeyboardVisible) {
      expandForm();
    } else if (!_keyboardAwareMode) {
      expandForm();
    }
  }

  /// Called when all fields lose focus
  void onFieldUnfocused() {
    _hasAnyFocus = false;

    // Smart delay - longer when keyboard might be visible
    int delayMs = _isKeyboardVisible ? 200 : 100;

    Future.delayed(Duration(milliseconds: delayMs), () {
      // Only collapse if:
      // 1. No focus AND
      // 2. (Keyboard is closed OR keyboard-aware mode is disabled)
      if (!_hasAnyFocus && (!_isKeyboardVisible || !_keyboardAwareMode)) {
        collapseForm();
      }
    });
  }

  /// Called when form is submitted successfully
  void onFormSubmitted() {
    _hasAnyFocus = false;
    collapseForm();
  }

  /// Called when user taps outside the form
  void onOutsideTap() {
    _hasAnyFocus = false;
    collapseForm();
  }

  /// Toggle keyboard-aware mode on/off
  void setKeyboardAwareMode(bool enabled) {
    _keyboardAwareMode = enabled;
    debugPrint(
        'SlidingForm: Keyboard-aware mode ${enabled ? "enabled" : "disabled"}');
  }

  /// Force expand (ignores keyboard state)
  void forceExpand() {
    _formHeightRatio = 0.8;
    _isExpanded = true;
    notifyListeners();
    debugPrint('SlidingForm: Force expanded');
  }

  /// Force collapse (ignores keyboard state)
  void forceCollapse() {
    _formHeightRatio = 0.5;
    _isExpanded = false;
    notifyListeners();
    debugPrint('SlidingForm: Force collapsed');
  }

  /// Reset form to initial state
  void reset() {
    _formHeightRatio = 0.5;
    _isExpanded = false;
    _hasAnyFocus = false;
    _isKeyboardVisible = false;
    notifyListeners();
  }

  @override
  void dispose() {
    debugPrint('SlidingFormViewModel disposed');
    super.dispose();
  }
}
