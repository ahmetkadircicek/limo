/// Profile ViewModel for managing profile display data
class ProfileViewModel {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  /// Set error message
  void _setError(String message) {
    _errorMessage = message;
  }

  /// Set success message
  void _setSuccess(String message) {
    _successMessage = message;
  }

  /// Clear all messages
  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
  }

  /// Clear success message
  void clearSuccess() {
    _successMessage = null;
  }
}
