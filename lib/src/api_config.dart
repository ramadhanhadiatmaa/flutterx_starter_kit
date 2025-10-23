import 'package:http/http.dart' as http;
import 'types.dart';

/// Immutable configuration for the [`ApiClient`].
class ApiConfig {
  /// Base URL used to build all request URLs.
  final String baseUrl;

  /// Request timeout for all HTTP calls.
  final Duration timeout;

  /// Provides an access token dynamically for each request.
  final TokenProvider? tokenProvider;

  /// Hook to refresh access tokens on `401 Unauthorized`.
  final RefreshToken? refreshToken;

  /// Provides default headers for each request.
  final DefaultHeadersBuilder? defaultHeaders;

  /// Called when the client remains unauthorized after a refresh attempt.
  final OnUnauthorized? onUnauthorized;

  /// Injects a custom HTTP client (useful for unit tests or logging).
  final http.Client? httpClient;

  /// Creates a configuration object for the API client.
  const ApiConfig({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 20),
    this.tokenProvider,
    this.refreshToken,
    this.defaultHeaders,
    this.onUnauthorized,
    this.httpClient,
  });

  /// Returns a copy with selectively overridden fields (immutable pattern).
  ApiConfig copyWith({
    String? baseUrl,
    Duration? timeout,
    TokenProvider? tokenProvider,
    RefreshToken? refreshToken,
    DefaultHeadersBuilder? defaultHeaders,
    OnUnauthorized? onUnauthorized,
    http.Client? httpClient,
  }) {
    return ApiConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      timeout: timeout ?? this.timeout,
      tokenProvider: tokenProvider ?? this.tokenProvider,
      refreshToken: refreshToken ?? this.refreshToken,
      defaultHeaders: defaultHeaders ?? this.defaultHeaders,
      onUnauthorized: onUnauthorized ?? this.onUnauthorized,
      httpClient: httpClient ?? this.httpClient,
    );
  }
}
