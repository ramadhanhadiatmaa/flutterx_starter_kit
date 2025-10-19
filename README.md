# FlutterX Starter Kit

[![pub package](https://img.shields.io/pub/v/flutterx_starter_kit.svg)](https://pub.dev/packages/flutterx_starter_kit)
[![popularity](https://img.shields.io/pub/popularity/flutterx_starter_kit?logo=dart)](https://pub.dev/packages/flutterx_starter_kit/score)
[![likes](https://img.shields.io/pub/likes/flutterx_starter_kit?logo=dart)](https://pub.dev/packages/flutterx_starter_kit/score)
[![pub points](https://img.shields.io/pub/points/flutterx_starter_kit?logo=dart)](https://pub.dev/packages/flutterx_starter_kit/score)

A comprehensive starter kit to accelerate Flutter application development with ready-to-use components following best practices.

## Features

### ✅ Currently Available

- 🌐 **ApiClient** - Powerful HTTP client with complete features:
  - Singleton pattern for easy global access
  - Support for all HTTP methods (GET, POST, PUT, PATCH, DELETE)
  - Auto token management & refresh token mechanism
  - Custom headers per request or globally
  - Query parameters support
  - Automatic JSON encoding/decoding
  - Built-in error handling & custom exceptions
  - Timeout configuration
  - Environment-based base URL

### 🚧 Coming Soon

- 🎨 **UI Components** - Widget library (Button, Card, Input, etc.)
- 📱 **Responsive Utils** - Helper for responsive design
- 🔐 **Auth Helper** - Authentication utilities
- 📊 **Logger** - Advanced logging system

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  flutterx_starter_kit: ^0.0.1
```

Or install via command line:

```bash
flutter pub add flutterx_starter_kit
```

## Getting Started

### 1. Initialize ApiClient

Initialize `ApiClient` in `main()` before `runApp()`:

```dart
import 'package:flutter/material.dart';
import 'package:flutterx_starter_kit/flutterx_starter_kit.dart';

void main() {
  // Initialize API Client
  ApiClient.init(ApiConfig(
    baseUrl: const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:8080',
    ),
  ));
  
  runApp(MyApp());
}
```

### 2. Basic Usage

```dart
import 'package:flutterx_starter_kit/flutterx_starter_kit.dart';

// GET request
final response = await ApiClient.I.get('/users');
print(response.data); // parsed JSON response

// POST request
final newUser = await ApiClient.I.post('/users', {
  'name': 'John Doe',
  'email': 'john@example.com',
});

// PUT request
final updated = await ApiClient.I.put('/users/1', {
  'name': 'Jane Doe',
});

// DELETE request
await ApiClient.I.delete('/users/1');
```

## Usage

### Advanced Configuration

#### With Token Provider & Refresh Token

```dart
ApiClient.init(ApiConfig(
  baseUrl: 'https://api.example.com',
  timeout: Duration(seconds: 30),
  
  // Provide access token for authenticated requests
  tokenProvider: () async {
    // Get token from secure storage, SharedPreferences, etc
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  },
  
  // Auto refresh token when 401
  refreshToken: (oldToken) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.example.com/refresh'),
        body: {'token': oldToken},
      );
      final data = jsonDecode(response.body);
      
      // Save new token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access_token']);
      
      return data['access_token'];
    } catch (e) {
      return null; // Return null if refresh failed
    }
  },
  
  // Handle unauthorized (after refresh token failed)
  onUnauthorized: (statusCode, body) async {
    // Navigate to login screen, clear session, etc
    print('Session expired. Please login again.');
  },
  
  // Add global headers
  defaultHeaders: () async {
    return {
      'X-App-Version': '1.0.0',
      'X-Platform': Platform.isAndroid ? 'android' : 'ios',
    };
  },
));
```

#### Custom HTTP Client (for logging/mocking)

```dart
class LoggingClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    print('${request.method} ${request.url}');
    return _inner.send(request);
  }
}

ApiClient.init(ApiConfig(
  baseUrl: 'https://api.example.com',
  httpClient: LoggingClient(),
));
```

### Request Options

#### Query Parameters

```dart
// Method 1: Using query parameter
final users = await ApiClient.I.get(
  '/users',
  query: {'page': 1, 'limit': 10, 'role': 'admin'},
);

// Method 2: Using ApiRequestOptions
final users = await ApiClient.I.get(
  '/users',
  opts: ApiRequestOptions(
    query: {'page': 1, 'limit': 10},
  ),
);
```

#### Custom Headers per Request

```dart
final response = await ApiClient.I.get(
  '/users',
  opts: ApiRequestOptions(
    headers: {
      'X-Custom-Header': 'value',
      'Accept-Language': 'en',
    },
  ),
);
```

#### Skip Authentication

```dart
// For public endpoints
final response = await ApiClient.I.get(
  '/public/data',
  opts: ApiRequestOptions(skipAuth: true),
);
```

#### Override Base URL

```dart
// Use different base URL for specific request
final response = await ApiClient.I.get(
  '/external-api/data',
  opts: ApiRequestOptions(
    baseUrl: 'https://external-api.com',
  ),
);
```

### Error Handling

```dart
try {
  final response = await ApiClient.I.get('/users');
  print('Success: ${response.data}');
} on ApiException catch (e) {
  // HTTP errors (4xx, 5xx)
  print('API Error: ${e.message}');
  print('Status Code: ${e.statusCode}');
  print('Response Data: ${e.data}');
} on NetworkException catch (e) {
  // Network/connection errors
  print('Network Error: ${e.message}');
} catch (e) {
  // Other errors
  print('Unexpected Error: $e');
}
```

### Working with Response

```dart
final response = await ApiClient.I.get('/users');

// Access response data
print(response.statusCode); // 200
print(response.data); // parsed JSON (Map or List)
print(response.headers); // response headers

// Type-safe parsing
if (response.data is List) {
  final users = (response.data as List)
      .map((json) => User.fromJson(json))
      .toList();
}
```

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutterx_starter_kit/flutterx_starter_kit.dart';

void main() {
  ApiClient.init(ApiConfig(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    timeout: Duration(seconds: 30),
  ));
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> users = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await ApiClient.I.get('/users');
      setState(() {
        users = response.data as List;
        isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        error = 'Error: ${e.message}';
        isLoading = false;
      });
    } on NetworkException catch (e) {
      setState(() {
        error = 'Network error: ${e.message}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user['name']),
                      subtitle: Text(user['email']),
                    );
                  },
                ),
    );
  }
}
```

## API Reference

### `ApiClient`

Singleton HTTP client for REST API communication.

#### Static Methods

- `init(ApiConfig config)` - Initialize singleton instance
- `I` - Get singleton instance

#### Instance Methods

- `get(String endpoint, {Map<String, dynamic>? query, ApiRequestOptions opts})` - GET request
- `post(String endpoint, dynamic body, {Map<String, dynamic>? query, ApiRequestOptions opts})` - POST request
- `put(String endpoint, dynamic body, {Map<String, dynamic>? query, ApiRequestOptions opts})` - PUT request
- `patch(String endpoint, dynamic body, {Map<String, dynamic>? query, ApiRequestOptions opts})` - PATCH request
- `delete(String endpoint, {Map<String, dynamic>? query, ApiRequestOptions opts, dynamic body})` - DELETE request

### `ApiConfig`

Configuration for ApiClient.

**Properties:**

- `baseUrl` (String) - API base URL without trailing slash
- `timeout` (Duration) - Request timeout, default 20 seconds
- `tokenProvider` (TokenProvider?) - Function to get access token
- `refreshToken` (RefreshToken?) - Function to refresh token on 401
- `defaultHeaders` (DefaultHeadersBuilder?) - Function for global headers
- `onUnauthorized` (OnUnauthorized?) - Callback when unauthorized
- `httpClient` (http.Client?) - Custom HTTP client

### `ApiRequestOptions`

Per-request options to override global configuration.

**Properties:**

- `baseUrl` (String?) - Override base URL for this request
- `headers` (Map<String, String>?) - Additional/override headers
- `skipAuth` (bool) - Skip Authorization header, default false
- `query` (Map<String, dynamic>?) - Query parameters

### `ApiResponse<T>`

Response wrapper from HTTP request.

**Properties:**

- `statusCode` (int) - HTTP status code
- `data` (T?) - Parsed response body (JSON → Map/List)
- `headers` (Map<String, String>) - Response headers

### Exceptions

#### `ApiException`

Exception for HTTP errors (4xx, 5xx).

**Properties:**

- `statusCode` (int?) - HTTP status code
- `message` (String) - Error message
- `data` (dynamic) - Response body

#### `NetworkException`

Exception for network/connection errors. Extends `ApiException`.

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
|---------|-----|-------|-----|-------|---------|
| ✅      | ✅  | ✅    | ✅  | ✅    | ✅      |

## Requirements

- Flutter: `>=1.17.0`
- Dart: `>=3.9.0`

## Examples

See the [/example](https://github.com/ramadhanhadiatmaa/flutterx_starter_kit/tree/main/example) folder for complete usage examples of this package.

## Additional Information

### Contributing

Contributions are welcome! Please:

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Issues and Feedback

If you find a bug or have a feature suggestion:

- 🐛 [Report bugs](https://github.com/ramadhanhadiatmaa/flutterx_starter_kit/issues)
- 💡 [Request features](https://github.com/ramadhanhadiatmaa/flutterx_starter_kit/issues)
- 💬 [Ask questions](https://github.com/ramadhanhadiatmaa/flutterx_starter_kit/discussions)

### Roadmap

- [ ] UI Components (Button, Card, TextField, etc.)
- [ ] Responsive utilities
- [ ] State management integration
- [ ] Form validation helpers
- [ ] Internationalization (i18n) support
- [ ] Theme management
- [ ] Navigation utilities
- [ ] Advanced logging system
- [ ] Performance monitoring

### Changelog

See [CHANGELOG.md](https://github.com/ramadhanhadiatmaa/flutterx_starter_kit/blob/main/CHANGELOG.md) for version history.

### License

This package is licensed under the [MIT License](https://github.com/ramadhanhadiatmaa/flutterx_starter_kit/blob/main/LICENSE).

### Author

#### Ramadhan Hadiatma

- GitHub: [@ramadhanhadiatmaa](https://github.com/ramadhanhadiatmaa)
- Repository: [flutterx_starter_kit](https://github.com/ramadhanhadiatmaa/flutterx_starter_kit)

### Support

If this package helps you, consider:

- ⭐ Star the repository on [GitHub](https://github.com/ramadhanhadiatmaa/flutterx_starter_kit)
- 👍 Like the package on [pub.dev](https://pub.dev/packages/flutterx_starter_kit)
- 📢 Share with other Flutter developers

---

Made with ❤️ by [Ramadhan Hadiatma](https://github.com/ramadhanhadiatmaa)
