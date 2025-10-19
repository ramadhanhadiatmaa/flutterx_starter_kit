import 'package:http/http.dart' as http;
import 'types.dart';

class ApiConfig {
  /// Base URL tanpa trailing slash. Contoh: https://api.example.com
  final String baseUrl;

  /// Timeout request (default 20s)
  final Duration timeout;

  /// Provider untuk mengambil access token dinamis setiap request.
  final TokenProvider? tokenProvider;

  /// Opsional: refresh token saat 401. Return token baru atau null bila gagal.
  final RefreshToken? refreshToken;

  /// Header global tambahan yang dipanggil setiap request.
  final DefaultHeadersBuilder? defaultHeaders;

  /// Dipanggil saat tetap 401 setelah percobaan refresh (mis. logout).
  final OnUnauthorized? onUnauthorized;

  /// http.Client kustom (untuk mocking/testing/logging).
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
