import 'dart:developer';
import 'dart:io';
import 'package:args/args.dart';

/// CLI subcommand that injects initialization code into a Flutter app's
/// ### Typical Usage
/// flutterx init
/// flutterx init --file lib/main.dart
/// flutterx init --file lib/main.dart --font fredoka
/// flutterx init -f lib/app.dart --font montserrat
class InitCommand {
  /// Start marker used to identify the beginning of the injected block.
  final _startMarker = '// Start code';

  /// End marker used to identify the end of the injected block.
  final _endMarker = '// End code';

  /// Returns the argument parser for this command.
  ArgParser get argParser {
    return ArgParser()
      ..addOption(
        'file',
        abbr: 'f',
        defaultsTo: 'lib/main.dart',
        help: 'Path to main.dart',
      )
      ..addOption(
        'font',
        defaultsTo: 'poppins',
        help: 'Google Font name for TextKit (fredoka, poppins, roboto, etc)',
      )
      ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');
  }

  /// Executes the command with the parsed [results].
  Future<void> run(ArgResults results) async {
    if (results['help'] == true) {
      _printHelp();
      return;
    }

    final filePath = results['file'] as String;
    final font = results['font'] as String;
    final file = File(filePath);

    if (!file.existsSync()) {
      throw Exception('File not found: $filePath');
    }

    log('📝 Reading file: $filePath');
    log('🎨 Setting font: $font');
    String content = await file.readAsString();

    // If previously injected, clean it up first (idempotent).
    if (content.contains(_startMarker)) {
      log('⚠️  Detected previous injection, updating...');
      content = _removeExistingInjection(content);
    }

    // Inject the new snippet with font configuration.
    content = _injectCode(content, font);

    // Persist changes.
    await file.writeAsString(content);
    log('✅ Success: $filePath');
    log('💡 TextKit is ready with $font font!');
  }

  /// Removes the previously injected block delimited by [_startMarker] and
  /// [_endMarker], if both are found. If either marker is missing, returns
  /// [content] unchanged.
  String _removeExistingInjection(String content) {
    final startIndex = content.indexOf(_startMarker);
    final endIndex = content.indexOf(_endMarker);

    if (startIndex != -1 && endIndex != -1) {
      return content.substring(0, startIndex) +
          content.substring(endIndex + _endMarker.length);
    }

    return content;
  }

  /// Injects the initialization snippet into [content] with the specified [font].
  String _injectCode(String content, String font) {
    // Require an async main (this keeps dotenv usage safe).
    final mainPattern = RegExp(r'void\s+main\s*\(\s*\)\s+async\s*\{');
    final match = mainPattern.firstMatch(content);

    if (match == null) {
      throw Exception('"void main() async {" not found in the file.');
    }

    // Sanitize font name: lowercase, remove special characters
    final sanitizedFont = font.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]'),
      '',
    );

    // The snippet we inject (bounded by markers).
    final injectionCode =
        '''

  $_startMarker
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  final base = dotenv.env['API_BASE_URL'];
  ApiClient.init(ApiConfig(baseUrl: base!));

  // Configure TextKit font
  TextKitConfig.setFont('$sanitizedFont');
  $_endMarker
''';

    final insertPosition = match.end;
    return content.substring(0, insertPosition) +
        injectionCode +
        content.substring(insertPosition);
  }

  /// Prints CLI help/usage for this command.
  void _printHelp() {
    log('''
Initialize FlutterX starter kit by injecting initialization code to main.dart

Usage: flutterx init [options]

Options:
${argParser.usage}

Examples:
  flutterx init
  flutterx init --file lib/main.dart
  flutterx init --file lib/main.dart --font fredoka
  flutterx init -f lib/app.dart --font montserrat

Available fonts:
  poppins (default), fredoka, roboto, montserrat, opensans, 
  lato, nunito, raleway, inter

What gets injected:
  - WidgetsFlutterBinding initialization
  - Environment variables loading (.env)
  - ApiClient configuration
  - TextKit font configuration

Requirements:
  - Your main() must be async: void main() async { }
  - Dependencies: flutter_dotenv, google_fonts
''');
  }
}
