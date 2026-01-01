class AppException implements Exception {
  final String message;
  final int? code;
  final int? statusCode;

  AppException({
    required this.message,
    this.code,
    this.statusCode,
  });

  @override
  String toString() => "AppException(message: $message, code: $code)";
}
