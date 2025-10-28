import 'package:flutter/material.dart';
import 'package:limo/shared/state/async_status.dart';

typedef AsyncErrorBuilder = Widget Function(
  BuildContext context,
  String? message,
);

class SharedAsyncStatusBuilder extends StatelessWidget {
  const SharedAsyncStatusBuilder({
    super.key,
    required this.status,
    required this.successBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.idleBuilder,
    this.errorMessage,
  });

  final AsyncStatus status;
  final WidgetBuilder successBuilder;
  final AsyncErrorBuilder? errorBuilder;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? emptyBuilder;
  final WidgetBuilder? idleBuilder;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AsyncStatus.loading:
        return (loadingBuilder ?? _defaultLoadingBuilder)(context);
      case AsyncStatus.empty:
        return (emptyBuilder ?? _defaultEmptyBuilder)(context);
      case AsyncStatus.error:
        final builder = errorBuilder ?? _defaultErrorBuilder;
        return builder(context, errorMessage);
      case AsyncStatus.success:
        return successBuilder(context);
      case AsyncStatus.idle:
        return (idleBuilder ?? _defaultIdleBuilder)(context);
    }
  }

  static Widget _defaultLoadingBuilder(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  static Widget _defaultEmptyBuilder(BuildContext context) {
    return const SizedBox.shrink();
  }

  static Widget _defaultIdleBuilder(BuildContext context) {
    return const SizedBox.shrink();
  }

  static Widget _defaultErrorBuilder(BuildContext context, String? message) {
    return Center(
      child: Text(message ?? 'Something went wrong'),
    );
  }
}
