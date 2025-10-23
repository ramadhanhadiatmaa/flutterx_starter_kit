# FlutterX Starter Kit

![FlutterX Starter Kit](assets/logo_fsk.png)

[![pub package](https://img.shields.io/pub/v/flutterx_starter_kit.svg)](https://pub.dev/packages/flutterx_starter_kit) [![likes](https://img.shields.io/pub/likes/flutterx_starter_kit?logo=dart)](https://pub.dev/packages/flutterx_starter_kit/score) [![pub points](https://img.shields.io/pub/points/flutterx_starter_kit?logo=dart)](https://pub.dev/packages/flutterx_starter_kit/score)

A comprehensive starter kit that accelerates Flutter app development with ready-to-use components and best practices, especially for GetX state management.

## Features

### ✅ Currently Available

- 💻 **CLI Helpers** - Generate your project fast code fast deploy
- 🌐 **ApiClient** - Powerful HTTP client with complete features
- 🎨 **UI Components** - Widget library (TextKit)

### 🚧 Coming Soon

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

### Setup

Add dependencies `flutter_dotenv`

```bash
flutter pub add flutter_dotenv
```

Create `.env` in root folder

```env
API_BASE_URL = www.example-api.com
```

Add `.env` to `assets`

```yml
flutter:
  assets:
    - .env
```

Don't forget add `async` in your `main()`

```dart
void main() async {
```

### Initialize ApiClient with CLI

```bash
flutter pub global activate flutterx_starter_kit
```

Or

```bash
dart pub global activate flutterx_starter_kit
```

And Then:

```bash
flutterx init
```

### Initialize ApiClient Manually

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

### Basic Usage

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

### Font Usage

```dart
import 'package:flutterx_starter_kit/flutterx_starter_kit.dart';
```

Initialize

```dart
# Font poppins (default)
flutterx init --file lib/main.dart

# Font fredoka
flutterx init --file lib/main.dart --font fredoka

# Font montserrat
flutterx init --file lib/main.dart --font montserrat
```

🎨 Currently Supported Fonts

| Font Name | Command | Style | Best For |
|-----------|---------|-------|----------|
| **Poppins** | `--font poppins` | Modern, Geometric | Default, General purpose, UI elements |
| **Fredoka** | `--font fredoka` | Rounded, Friendly | Playful apps, Kids content, Fun branding |
| **Roboto** | `--font roboto` | Neutral, Clean | Material Design, Android apps |
| **Montserrat** | `--font montserrat` | Elegant, Professional | Business apps, Professional content |
| **Open Sans** | `--font opensans` | Humanist, Readable | Long-form content, Articles, Blogs |
| **Lato** | `--font lato` | Warm, Stable | Corporate, Professional websites |
| **Nunito** | `--font nunito` | Rounded, Balanced | Friendly interfaces, Modern apps |
| **Raleway** | `--font raleway` | Elegant, Thin | Fashion, Luxury, Minimalist designs |
| **Inter** | `--font inter` | Modern, Precise | UI/UX, Dashboard, Data-heavy apps |

🧾 Quick Reference

| Method         | Size | Weight   | Usage                  |
|----------------|:----:|----------|------------------------|
| `displayLarge` |  57  | Light    | Splash/Onboarding hero |
| `displayMedium`|  45  | Regular  | Main page headline     |
| `displaySmall` |  36  | Regular  | Sub headline           |
| `headLineLarge`|  32  | SemiBold | Page title (AppBar)    |
| `headLineMedium`| 28  | SemiBold | Section title          |
| `headLineSmall`|  24  | SemiBold | Important subtitle     |
| `titleLarge`   |  22  | SemiBold | Card/Dialog title      |
| `titleMedium`  |  16  | Medium   | List title             |
| `titleSmall`   |  14  | Medium   | Card subtitle          |
| `bodyLarge`    |  16  | Regular  | Main paragraph         |
| `bodyMedium`   |  14  | Regular  | Secondary text         |
| `bodySmall`    |  12  | Regular  | Caption                |
| `labelLarge`   |  14  | Medium   | Button text            |
| `labelMedium`  |  12  | Medium   | Chip/Small button      |
| `labelSmall`   |  11  | Regular  | Helper/Hint text       |

example

```dart
import 'package:flutterx_starter_kit/flutterx_starter_kit.dart';

class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextKit.titleLarge('My App'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== DISPLAY STYLES =====
            TextKit.displayLarge('Hero Text'),
            SizedBox(height: 8),
            TextKit.displayMedium('Welcome Back!'),
            SizedBox(height: 8),
            TextKit.displaySmall('Subtitle Hero'),
            
            SizedBox(height: 24),
            
            // ===== HEADLINE STYLES =====
            TextKit.headlineLarge('Main Headline'),
            SizedBox(height: 8),
            TextKit.headlineMedium('Section Title'),
            SizedBox(height: 8),
            TextKit.headlineSmall('Sub Section'),
            
            SizedBox(height: 24),
            
            // ===== TITLE STYLES =====
            TextKit.titleLarge('Card Title'),
            SizedBox(height: 8),
            TextKit.titleMedium('List Item Title'),
            SizedBox(height: 8),
            TextKit.titleSmall('Small Title', color: Colors.grey),
            
            SizedBox(height: 24),
            
            // ===== BODY STYLES =====
            TextKit.bodyLarge(
              'This is the main paragraph text. Lorem ipsum dolor sit amet, '
              'consectetur adipiscing elit.',
              height: 1.6,
            ),
            SizedBox(height: 8),
            TextKit.bodyMedium(
              'Secondary description text here.',
              color: Colors.grey[700],
            ),
            SizedBox(height: 8),
            TextKit.bodySmall(
              'Small caption or note text.',
              color: Colors.grey[600],
            ),
            
            SizedBox(height: 24),
            
            // ===== LABEL STYLES (untuk Button, dll) =====
            ElevatedButton(
              onPressed: () {},
              child: TextKit.labelLarge('Button Text'),
            ),
            SizedBox(height: 8),
            Chip(
              label: TextKit.labelMedium('Chip Label', color: Colors.black),
            ),
            SizedBox(height: 8),
            TextKit.labelSmall('Helper text or hint'),
            SizedBox(height: 8),
            TextKit.bodyLarge(
              'Very long text that might overflow...',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              color: Colors.blue,
            ),
            TextKit.headlineMedium(
              'Centered Title',
              align: TextAlign.center,
              color: Theme.of(context).primaryColor,
            ),
            TextKit.bodyLarge(
              'Paragraph with custom line height for better readability.',
              height: 1.8,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}
```

### Others Example

```dart
//example 1
import 'package:flutter/material.dart';
import 'package:flutterx_starter_kit/flutterx_starter_kit.dart';

String? accessToken = 'xxx123xxx123';

void main() {
  ApiClient.init(ApiConfig(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    tokenProvider: () async => accessToken, // Set global Authorization
  ));
  runApp(MyApp());
}

//example 2
final public = await ApiClient.instance.get('/v1/info',
  opts: const ApiRequestOptions(skipAuth: true), // Skip headers
);

//example 3
await ApiClient.instance.get(
  '/v1/public-info',
  opts: const ApiRequestOptions(
    skipAuth: true,
    headers: {'X-Trace': 'abc123'}, // Need others headers
  ),
);

//example 4
ApiClient.init(ApiConfig(baseUrl: 'https://api.example.com'));
// Not set global, need authorization
final res1 = await ApiClient.instance.get(
  '/v1/secure-data',
  opts: const ApiRequestOptions(
    headers: {'Authorization': 'Bearer xxx123xxx123'}, // If not set global, add 'Bearer'
  ),
);
// Not set global, no needed authorization
final res2 = await ApiClient.instance.get('/v1/public-info');

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

Contributions are welcome for everyone!

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
