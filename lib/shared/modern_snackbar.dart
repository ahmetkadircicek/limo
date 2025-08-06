import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/shared/general_text.dart';

enum SnackbarType {
  info,
  success,
  warning,
  error,
}

class ModernSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    String? title,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _ModernSnackbarWidget(
        message: message,
        type: type,
        title: title,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto dismiss after duration
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

class _ModernSnackbarWidget extends StatefulWidget {
  final String message;
  final SnackbarType type;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final VoidCallback onDismiss;

  const _ModernSnackbarWidget({
    required this.message,
    required this.type,
    this.title,
    this.actionLabel,
    this.onActionPressed,
    required this.onDismiss,
  });

  @override
  State<_ModernSnackbarWidget> createState() => _ModernSnackbarWidgetState();
}

class _ModernSnackbarWidgetState extends State<_ModernSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            elevation: 8,
            borderRadius: GeneralConstants.borderRadius,
            child: Container(
              padding: PaddingConstants.allMedium,
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: GeneralConstants.borderRadius,
                border: Border.all(
                  color: _getTypeColor(context),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getTypeColor(context).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getTypeColor(context).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getTypeIcon(),
                      color: _getTypeColor(context),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.title != null) ...[
                          GeneralText(
                            text: widget.title!,
                            fontSize: GeneralConstants.fontSizeSmall,
                            fontWeight: GeneralConstants.fontWeightBold,
                            color: context.onSurface,
                          ),
                          const SizedBox(height: 4),
                        ],
                        GeneralText(
                          text: widget.message,
                          fontSize: GeneralConstants.fontSizeExtraSmall,
                          fontWeight: GeneralConstants.fontWeightRegular,
                          color: context.secondary,
                        ),
                      ],
                    ),
                  ),
                  if (widget.actionLabel != null) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        widget.onActionPressed?.call();
                        _dismiss();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: _getTypeColor(context),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                      ),
                      child: GeneralText(
                        text: widget.actionLabel!,
                        fontSize: GeneralConstants.fontSizeExtraSmall,
                        fontWeight: GeneralConstants.fontWeightBold,
                        color: _getTypeColor(context),
                      ),
                    ),
                  ],
                  IconButton(
                    onPressed: _dismiss,
                    icon: Icon(
                      Icons.close,
                      color: context.secondary,
                      size: 18,
                    ),
                    padding: const EdgeInsets.all(4),
                    constraints:
                        const BoxConstraints(minWidth: 24, minHeight: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _dismiss() async {
    await _animationController.reverse();
    widget.onDismiss();
  }

  Color _getTypeColor(BuildContext context) {
    switch (widget.type) {
      case SnackbarType.info:
        return const Color(0xFF2196F3); // Blue
      case SnackbarType.success:
        return const Color(0xFF4CAF50); // Green
      case SnackbarType.warning:
        return const Color(0xFFFF9800); // Orange
      case SnackbarType.error:
        return const Color(0xFFF44336); // Red
    }
  }

  IconData _getTypeIcon() {
    switch (widget.type) {
      case SnackbarType.info:
        return Icons.info_outline;
      case SnackbarType.success:
        return Icons.check_circle_outline;
      case SnackbarType.warning:
        return Icons.warning_amber_outlined;
      case SnackbarType.error:
        return Icons.error_outline;
    }
  }
}

// Extension methods for easy usage
extension ModernSnackbarExtension on BuildContext {
  void showInfoSnackbar({
    required String message,
    String? title,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    ModernSnackbar.show(
      this,
      message: message,
      type: SnackbarType.info,
      title: title,
      duration: duration ?? const Duration(seconds: 3),
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  void showSuccessSnackbar({
    required String message,
    String? title,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    ModernSnackbar.show(
      this,
      message: message,
      type: SnackbarType.success,
      title: title,
      duration: duration ?? const Duration(seconds: 3),
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  void showWarningSnackbar({
    required String message,
    String? title,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    ModernSnackbar.show(
      this,
      message: message,
      type: SnackbarType.warning,
      title: title,
      duration: duration ?? const Duration(seconds: 3),
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  void showErrorSnackbar({
    required String message,
    String? title,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    ModernSnackbar.show(
      this,
      message: message,
      type: SnackbarType.error,
      title: title,
      duration: duration ?? const Duration(seconds: 3),
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}
