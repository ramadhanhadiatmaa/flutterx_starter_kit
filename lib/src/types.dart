/// Common function type aliases used by the API client.
typedef TokenProvider = Future<String?> Function();

/// Refreshes and returns a **new** access token when given the previous one.
typedef RefreshToken = Future<String?> Function(String? oldToken);

/// Builds default headers for each request.
typedef DefaultHeadersBuilder = Future<Map<String, String>> Function();

/// Called when the client remains unauthorized **after** a refresh attempt.
typedef OnUnauthorized = Future<void> Function(int statusCode, String body);
