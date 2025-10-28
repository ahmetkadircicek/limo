enum AsyncStatus { idle, loading, empty, success, error }

extension AsyncStatusX on AsyncStatus {
  bool get isIdle => this == AsyncStatus.idle;
  bool get isLoading => this == AsyncStatus.loading;
  bool get isEmpty => this == AsyncStatus.empty;
  bool get isSuccess => this == AsyncStatus.success;
  bool get isError => this == AsyncStatus.error;
}
