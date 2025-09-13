import 'dart:async';

import 'package:flutter/material.dart';
import 'package:limo/main.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/radius_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_size_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';

class AppSnackbar {
  static void show({
    required String message,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = rootNavigatorKey.currentState?.overlay;
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return SnackbarWidget(
          message: message,
          backgroundColor: backgroundColor,
          duration: duration,
          onDismissed: () {
            if (entry.mounted) entry.remove();
          },
        );
      },
    );
    overlay.insert(entry);
  }

  static void success({required String message}) =>
      show(message: message, backgroundColor: Colors.green);

  static void error({required String message}) =>
      show(message: message, backgroundColor: Colors.red);

  static void info({required String message}) =>
      show(message: message, backgroundColor: Colors.blue);

  static void warning({required String message}) =>
      show(message: message, backgroundColor: Colors.orange);
}

class SnackbarWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Duration duration;
  final VoidCallback onDismissed;

  const SnackbarWidget({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.duration,
    required this.onDismissed,
  });

  @override
  State<SnackbarWidget> createState() => _SnackbarWidgetState();
}

class _SnackbarWidgetState extends State<SnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offset = Tween(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    _dismissTimer = Timer(widget.duration, _dismiss);
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    if (mounted) {
      widget.onDismissed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SlideTransition(
          position: _offset,
          child: GestureDetector(
            onTap: _dismiss,
            child: Container(
              width: context.width,
              margin: PaddingConstants.all16,
              padding: PaddingConstants.all16,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: RadiusConstants.standard,
              ),
              child: Text(
                widget.message,
                style: context.body.copyWith(color: context.onPrimary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
