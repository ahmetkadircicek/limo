enum ApiResponseStatus { success, error }

class ApiResult<T> {
  ApiResult.success(this.data, {this.statusCode})
    : status = ApiResponseStatus.success,
      message = null;

  ApiResult.error(this.message, {this.statusCode})
    : status = ApiResponseStatus.error,
      data = null;

  final ApiResponseStatus status;
  final T? data;
  final String? message;
  final int? statusCode;

  bool get isSuccess => status == ApiResponseStatus.success;
  bool get isError => status == ApiResponseStatus.error;
}
