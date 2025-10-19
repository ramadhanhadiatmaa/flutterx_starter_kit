typedef TokenProvider = Future<String?> Function();
typedef RefreshToken = Future<String?> Function(String? oldToken);
typedef DefaultHeadersBuilder = Future<Map<String, String>> Function();
typedef OnUnauthorized = Future<void> Function(int statusCode, String body);
