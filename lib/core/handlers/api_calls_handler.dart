class ApiResult<T> {
  const ApiResult._({
    required this.isSucceeded,
    this.resultData,
    this.errorMessage,
  });

  factory ApiResult.succeeded(T data) => ApiResult._(
        isSucceeded: true,
        resultData: data,
      );

  factory ApiResult.failed(String message) => ApiResult._(
        isSucceeded: false,
        errorMessage: message,
      );

  final bool isSucceeded;
  final T? resultData;
  final String? errorMessage;
}

/// Wraps async service calls with consistent success/failure handling.
mixin ApiCallsHandler {
  Future<ApiResult<T>> handleApiCall<T>(Future<T> Function() call) async {
    try {
      final data = await call();
      return ApiResult.succeeded(data);
    } catch (error) {
      return ApiResult.failed(error.toString());
    }
  }
}
