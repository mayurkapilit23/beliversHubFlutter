class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ApiResponse.success(T data, {String? message}) => ApiResponse(
    success: true,
    data: data,
    message: message,
  );

  factory ApiResponse.error(String message) => ApiResponse(
    success: false,
    message: message,
  );
}