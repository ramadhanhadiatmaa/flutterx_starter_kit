import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'exceptions.dart';

class ApiRequestOptions {
  /// Override baseUrl per request (opsional)
  final String? baseUrl;

  /// Header tambahan/override per request
  final Map<String, String>? headers;

  /// Jika true, jangan kirim Authorization header
  final bool skipAuth;

  /// Query params
  final Map<String, dynamic>? query;

  const ApiRequestOptions({
    this.baseUrl,
    this.headers,
    this.skipAuth = false,
    this.query,
  });

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

class ApiResponse<T> {
  final int statusCode;
  final T? data;
  final Map<String, String> headers;
  ApiResponse({required this.statusCode, this.data, required this.headers});
}

class ApiClient {
  // ===== Singleton support =====
  static ApiClient? _instance;

  /// Init singleton
  static void init(ApiConfig config) {
    _instance = ApiClient(config);
  }

  /// Ambil singleton
  static ApiClient get I {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'ApiClient belum di-init. Panggil ApiClient.init(...) terlebih dahulu.',
      );
    }
    return i;
  }

  // ===== Instance =====
  final ApiConfig _config;
  final http.Client _client;
  bool _isRefreshing = false;

  /// Unnamed constructor (supaya bisa instantiate langsung, mis. di unit-test)
  ApiClient(this._config) : _client = _config.httpClient ?? http.Client();

  // ===== Utils =====
  String _buildUrl(String base, String endpoint, Map<String, dynamic>? query) {
    final b = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final e = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final uri = Uri.parse('$b$e');

    // Jangan tambahkan '?' jika query null/empty
    if (query == null || query.isEmpty) {
      return uri.toString();
    }

    final qp = query.map((k, v) => MapEntry(k, v?.toString()));
    return uri.replace(queryParameters: qp).toString();
  }

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

  Future<ApiResponse<dynamic>> _handle(
    Future<http.Response> Function() doCall, {
    bool allowRefresh = true,
  }) async {
    http.Response res;
    try {
      res = await doCall().timeout(_config.timeout);
    } catch (e) {
      throw NetworkException('Koneksi gagal: $e');
    }

    final status = res.statusCode;
    final body = res.body;
    final headers = res.headers;

    dynamic data;
    try {
      data = body.isNotEmpty ? jsonDecode(body) : null;
    } catch (_) {
      data = body; // fallback non-JSON
    }

    // 401 → coba refresh token (sekali)
    if (status == 401 && allowRefresh && _config.refreshToken != null) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          final old = await _config.tokenProvider?.call();
          final newToken = await _config.refreshToken!.call(old);
          _isRefreshing = false;
          if (newToken != null && newToken.isNotEmpty) {
            // Ulang sekali setelah refresh
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

  // ===== HTTP METHODS =====
  // Menerima:
  // - [query] sebagai named param
  // - [opts] yang juga bisa memuat query (opts.query override query)
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
