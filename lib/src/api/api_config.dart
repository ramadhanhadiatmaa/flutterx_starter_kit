import 'package:http/http.dart' as http;
import 'types.dart';

class ApiConfig {
  final String baseUrl;
  final Duration timeout;
  final TokenProvider? tokenProvider;
  final RefreshToken? refreshToken;
  final DefaultHeadersBuilder? defaultHeaders;
  final OnUnauthorized? onUnauthorized;
  final http.Client? httpClient;

  const ApiConfig({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 20),
    this.tokenProvider,
    this.refreshToken,
    this.defaultHeaders,
    this.onUnauthorized,
    this.httpClient,
  });

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
