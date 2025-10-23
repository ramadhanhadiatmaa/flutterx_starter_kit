import 'dart:convert';
import 'package:flutterx_starter_kit/src/api_config.dart';
import 'package:flutterx_starter_kit/src/exceptions.dart';
import 'package:http/http.dart' as http;

/// Per-request overrides for an HTTP call.
class ApiRequestOptions {
  /// Overrides the default [`ApiConfig.baseUrl`] for this single request.
  final String? baseUrl;

  /// Extra headers to attach for this request.
  final Map<String, String>? headers;

  /// When `true`, the client will **not** add an `Authorization` header.
  final bool skipAuth;

  /// Extra query parameters for this request.
  final Map<String, dynamic>? query;

  /// Creates a new per-request options object.
  const ApiRequestOptions({
    this.baseUrl,
    this.headers,
    this.skipAuth = false,
    this.query,
  });

  /// Returns a copy with selectively overridden fields (immutable pattern).
  ApiRequestOptions copyWith({
    String? baseUrl,
    Map<String, String>? headers,
    bool? skipAuth,
    Map<String, dynamic>? query,
  }) {
    return ApiRequestOptions(
      baseUrl: baseUrl ?? this.baseUrl,
      headers: headers ?? this.headers,
      skipAuth: skipAuth ?? this.skipAuth,
      query: query ?? this.query,
    );
  }
}

/// A normalized HTTP response returned by the client.
class ApiResponse<T> {
  /// HTTP status code.
  final int statusCode;

  /// Parsed payload.
  final T? data;

  /// Raw response headers.
  final Map<String, String> headers;

  /// Creates a response wrapper.
  ApiResponse({required this.statusCode, this.data, required this.headers});
}

/// A minimal, testable HTTP client for calling REST APIs.
class ApiClient {
  static ApiClient? _instance;

  /// Initializes the global singleton with the provided configuration.
  static void init(ApiConfig config) {
    _instance = ApiClient(config);
  }

  /// Returns the initialized singleton instance.
  static ApiClient get instance {
    final i = _instance;
    if (i == null) {
      throw StateError('ApiClient not initialize.');
    }
    return i;
  }

  /// Deprecated to encourage a clearer, more idiomatic name.
  @Deprecated('Use ApiClient.instance instead')
  static ApiClient get I => instance;

  /// The client’s base configuration.
  final ApiConfig _config;

  /// The underlying HTTP client (injectable for tests).
  final http.Client _client;

  /// Internal flag to indicate an ongoing refresh-token attempt.
  bool _isRefreshing = false;

  /// Creates a client instance directly (useful for unit tests).
  /// In production apps, prefer [`init`] + [`instance`].
  ApiClient(this._config) : _client = _config.httpClient ?? http.Client();

  /// Builds the final URL from `base`, `endpoint`, and optional `query`.
  String _buildUrl(String base, String endpoint, Map<String, dynamic>? query) {
    final b = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final e = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final uri = Uri.parse('$b$e');

    if (query == null || query.isEmpty) {
      return uri.toString();
    }

    final qp = query.map((k, v) => MapEntry(k, v?.toString()));
    return uri.replace(queryParameters: qp).toString();
  }

  /// Builds headers for the current request.
  Future<Map<String, String>> _buildHeaders({
    required bool skipAuth,
    Map<String, String>? extra,
  }) async {
    final Map<String, String> h = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_config.defaultHeaders != null) {
      h.addAll(await _config.defaultHeaders!());
    }

    if (!skipAuth && _config.tokenProvider != null) {
      final t = await _config.tokenProvider!.call();
      if (t != null && t.isNotEmpty) {
        h['Authorization'] = t.startsWith('Bearer ') ? t : 'Bearer $t';
      }
    }

    if (extra != null) h.addAll(extra);
    return h;
  }

  /// Executes the HTTP request, parses the body, performs a single
  Future<ApiResponse<dynamic>> _handle(
    Future<http.Response> Function() doCall, {
    bool allowRefresh = true,
  }) async {
    http.Response res;
    try {
      res = await doCall().timeout(_config.timeout);
    } catch (e) {
      throw NetworkException('Connection failed: $e');
    }

    final status = res.statusCode;
    final body = res.body;
    final headers = res.headers;

    dynamic data;
    try {
      data = body.isNotEmpty ? jsonDecode(body) : null;
    } catch (_) {
      data = body;
    }

    if (status == 401 && allowRefresh && _config.refreshToken != null) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          final old = await _config.tokenProvider?.call();
          final newToken = await _config.refreshToken!.call(old);
          _isRefreshing = false;
          if (newToken != null && newToken.isNotEmpty) {
            return _handle(doCall, allowRefresh: false);
          }
        } catch (_) {
          _isRefreshing = false;
        }
      }
      if (_config.onUnauthorized != null) {
        await _config.onUnauthorized!(status, body);
      }
      throw ApiException('Unauthorized', statusCode: status, data: data);
    }

    if (status < 200 || status >= 300) {
      throw ApiException('HTTP $status', statusCode: status, data: data);
    }

    return ApiResponse(statusCode: status, data: data, headers: headers);
  }

  /// Performs an HTTP **GET** request.
  Future<ApiResponse<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? query,
    ApiRequestOptions opts = const ApiRequestOptions(),
  }) async {
    final mergedQuery = {...?query, ...?opts.query};
    final q = mergedQuery.isEmpty ? null : mergedQuery;
    final base = opts.baseUrl ?? _config.baseUrl;
    final url = _buildUrl(base, endpoint, q);
    final headers = await _buildHeaders(
      skipAuth: opts.skipAuth,
      extra: opts.headers,
    );

    return _handle(() => _client.get(Uri.parse(url), headers: headers));
  }

  /// Performs an HTTP **POST** request with `body` (Map/List/primitive/String).
  Future<ApiResponse<dynamic>> post(
    String endpoint,
    dynamic body, {
    Map<String, dynamic>? query,
    ApiRequestOptions opts = const ApiRequestOptions(),
  }) async {
    final mergedQuery = {...?query, ...?opts.query};
    final q = mergedQuery.isEmpty ? null : mergedQuery;
    final base = opts.baseUrl ?? _config.baseUrl;
    final url = _buildUrl(base, endpoint, q);
    final headers = await _buildHeaders(
      skipAuth: opts.skipAuth,
      extra: opts.headers,
    );
    final payload = body is String ? body : jsonEncode(body);

    return _handle(
      () => _client.post(Uri.parse(url), headers: headers, body: payload),
    );
  }

  /// Performs an HTTP **PUT** request with `body` (Map/List/primitive/String).
  Future<ApiResponse<dynamic>> put(
    String endpoint,
    dynamic body, {
    Map<String, dynamic>? query,
    ApiRequestOptions opts = const ApiRequestOptions(),
  }) async {
    final mergedQuery = {...?query, ...?opts.query};
    final q = mergedQuery.isEmpty ? null : mergedQuery;
    final base = opts.baseUrl ?? _config.baseUrl;
    final url = _buildUrl(base, endpoint, q);
    final headers = await _buildHeaders(
      skipAuth: opts.skipAuth,
      extra: opts.headers,
    );
    final payload = body is String ? body : jsonEncode(body);

    return _handle(
      () => _client.put(Uri.parse(url), headers: headers, body: payload),
    );
  }

  /// Performs an HTTP **PATCH** request with `body` (Map/List/primitive/String).
  Future<ApiResponse<dynamic>> patch(
    String endpoint,
    dynamic body, {
    Map<String, dynamic>? query,
    ApiRequestOptions opts = const ApiRequestOptions(),
  }) async {
    final mergedQuery = {...?query, ...?opts.query};
    final q = mergedQuery.isEmpty ? null : mergedQuery;
    final base = opts.baseUrl ?? _config.baseUrl;
    final url = _buildUrl(base, endpoint, q);
    final headers = await _buildHeaders(
      skipAuth: opts.skipAuth,
      extra: opts.headers,
    );
    final payload = body is String ? body : jsonEncode(body);

    return _handle(
      () => _client.patch(Uri.parse(url), headers: headers, body: payload),
    );
  }

  /// Performs an HTTP **DELETE** request.
  Future<ApiResponse<dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? query,
    ApiRequestOptions opts = const ApiRequestOptions(),
    dynamic body,
  }) async {
    final mergedQuery = {...?query, ...?opts.query};
    final q = mergedQuery.isEmpty ? null : mergedQuery;
    final base = opts.baseUrl ?? _config.baseUrl;
    final url = _buildUrl(base, endpoint, q);
    final headers = await _buildHeaders(
      skipAuth: opts.skipAuth,
      extra: opts.headers,
    );

    if (body != null) {
      final req = http.Request('DELETE', Uri.parse(url))
        ..headers.addAll(headers)
        ..body = body is String ? body : jsonEncode(body);
      return _handle(
        () async => http.Response.fromStream(await _client.send(req)),
      );
    }

    return _handle(() => _client.delete(Uri.parse(url), headers: headers));
  }
}
