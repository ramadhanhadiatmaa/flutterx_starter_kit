/// A normalized API error thrown for non-2xx HTTP responses
class ApiException implements Exception {
  /// Optional HTTP status code (e.g., 400, 401, 500).
  final int? statusCode;

  /// Human-readable error message.
  final String message;

  /// Optional server-provided data (decoded JSON or raw String).
  final dynamic data;

  /// Creates a normalized API exception.
  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() {
    final code = statusCode != null ? '$statusCode' : 'null';
    return 'ApiException($code): $message';
  }
}

/// A transport-level error (connectivity, DNS, TLS, timeout, etc.).
class NetworkException extends ApiException {
  /// Creates a network-level exception with a human-readable [message].
  NetworkException(super.message);
}
