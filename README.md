# FlutterX Starter Kit

[![pub package](https://img.shields.io/pub/v/flutterx_starter_kit.svg)](https://pub.dev/packages/flutterx_starter_kit)
[![likes](https://img.shields.io/pub/likes/flutterx_starter_kit?logo=dart)](https://pub.dev/packages/flutterx_starter_kit/score)
[![pub points](https://img.shields.io/pub/points/flutterx_starter_kit?logo=dart)](https://pub.dev/packages/flutterx_starter_kit/score)

A comprehensive starter kit to accelerate Flutter application development with ready-to-use components following best practices.

## Features

### ✅ Currently Available

- 🌐 **ApiClient** - Powerful HTTP client with complete features

### 🚧 Coming Soon

- 🎨 **UI Components** - Widget library (Button, Card, Input, etc.)
- 📱 **Responsive Utils** - Helper for responsive design
- 📊 **Logger** - Advanced logging system

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  flutterx_starter_kit: <latest-version>
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
      // If API_BASE_URL not setup in env
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
final response = await ApiClient.instance.get('/users');
print(response.data); // parsed JSON response

// POST request
final newUser = await ApiClient.instance.post('/users', {
  'name': 'John Doe',
  'email': 'john@example.com',
});

// PUT request
final updated = await ApiClient.instance.put('/users/1', {
  'name': 'Jane Doe',
});

// DELETE request
await ApiClient.instance.delete('/users/1');
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
      final response = await ApiClient.instance.get('/users');
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
- `instance` - Get singleton instance

#### Instance Methods

- GET request - `get(String endpoint, {Map<String, dynamic>? query, ApiRequestOptions opts})`
- POST request - `post(String endpoint, dynamic body, {Map<String, dynamic>? query, ApiRequestOptions opts})`
- PUT request - `put(String endpoint, dynamic body, {Map<String, dynamic>? query, ApiRequestOptions opts})`
- PATCH request - `patch(String endpoint, dynamic body, {Map<String, dynamic>? query, ApiRequestOptions opts})`
- DELETE request - `delete(String endpoint, {Map<String, dynamic>? query, ApiRequestOptions opts, dynamic body})`

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

| Android | iOS | MacOS | Web |
|---------|-----|-------|-----|
| ✅      | ✅  | ✅    | ✅  |

## Requirements

- Flutter: `>=1.17.0`
- Dart: `>=3.9.0`

## Examples

See the [/example](https://github.com/ramadhanhadiatmaa/flutterx_starter_kit/tree/main/example) folder for complete usage examples of this package.

## Additional Information

### Contributing

Contributions are welcome!

### Issues and Feedback

If you find a bug or have a feature suggestion:

- 🐛 [Report bugs](https://github.com/ramadhanhadiatmaa/flutterx_starter_kit/issues)
- 💡 [Request features](https://github.com/ramadhanhadiatmaa/flutterx_starter_kit/issues)
- 💬 [Ask questions](https://github.com/ramadhanhadiatmaa/flutterx_starter_kit/discussions)

### Roadmap

- [ ] UI Components (Button, Card, TextField, etc.)
- [ ] Responsive utilities
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
