import 'dart:developer';
import 'dart:io';
import 'package:args/args.dart';

/// CLI subcommand that injects font configuration code into a Flutter app
/// ### Typical Usage
/// flutterx font
/// flutterx font --name fredoka
/// flutterx font --file lib/main.dart --name montserrat
/// flutterx font -f lib/app.dart -n roboto
class FontCommand {
  /// Start marker used to identify the beginning of the injected block.
  final _startMarker = '// Start font config';

  /// End marker used to identify the end of the injected block.
  final _endMarker = '// End font config';

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
        'name',
        abbr: 'n',
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
    final fontName = results['name'] as String;
    final file = File(filePath);

    if (!file.existsSync()) {
      throw Exception('File not found: $filePath');
    }

    log('📝 Reading file: $filePath');
    log('🎨 Setting font: $fontName');
    String content = await file.readAsString();

    // If previously injected, clean it up first (idempotent).
    if (content.contains(_startMarker)) {
      log('⚠️  Detected previous font configuration, updating...');
      content = _removeExistingInjection(content);
    }

    // Inject the new snippet with font configuration.
    content = _injectCode(content, fontName);

    // Persist changes.
    await file.writeAsString(content);
    log('✅ Success: $filePath');
    log('💡 TextKit is ready with $fontName font!');
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

  /// Injects the font configuration snippet into [content] with the specified [fontName].
  /// Injects AFTER API init block if exists, otherwise AFTER WidgetsFlutterBinding,
  /// otherwise at the start of main() async {
  String _injectCode(String content, String fontName) {
    // Sanitize font name: lowercase, remove special characters
    final sanitizedFont = fontName.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]'),
      '',
    );

    // The snippet we inject (bounded by markers).
    final injectionCode =
        '''

  $_startMarker
  // Configure TextKit font
  TextKitConfig.setFont('$sanitizedFont');
  $_endMarker
''';

    // Priority 1: Try to inject after API init block
    final apiEndMarker = '// End API init';
    if (content.contains(apiEndMarker)) {
      final apiEndIndex = content.indexOf(apiEndMarker);
      final insertPosition = apiEndIndex + apiEndMarker.length;

      log('💡 Injecting after API init block');
      return content.substring(0, insertPosition) +
          injectionCode +
          content.substring(insertPosition);
    }

    // Priority 2: Try to inject after WidgetsFlutterBinding.ensureInitialized()
    final bindingPattern = RegExp(
      r'WidgetsFlutterBinding\.ensureInitialized\(\);',
    );
    final bindingMatch = bindingPattern.firstMatch(content);

    if (bindingMatch != null) {
      final insertPosition = bindingMatch.end;

      log('💡 Injecting after WidgetsFlutterBinding');
      return content.substring(0, insertPosition) +
          injectionCode +
          content.substring(insertPosition);
    }

    // Priority 3: Inject at the start of main() async {
    final mainPattern = RegExp(r'void\s+main\s*\(\s*\)\s+async\s*\{');
    final mainMatch = mainPattern.firstMatch(content);

    if (mainMatch == null) {
      throw Exception('"void main() async {" not found in the file.');
    }

    log('💡 Injecting at the start of main()');
    final insertPosition = mainMatch.end;
    return content.substring(0, insertPosition) +
        injectionCode +
        content.substring(insertPosition);
  }

  /// Prints CLI help/usage for this command.
  void _printHelp() {
    log('''
Configure TextKit font by injecting font configuration code to main.dart

Usage: flutterx font [options]

Options:
${argParser.usage}

Examples:
  flutterx font
  flutterx font --name fredoka
  flutterx font --file lib/main.dart --name montserrat
  flutterx font -f lib/app.dart -n roboto

Available fonts:
  poppins (default), fredoka, roboto, montserrat, opensans, 
  lato, nunito, raleway, inter, and any Google Font name

What gets injected:
  - TextKit font configuration

Injection Priority:
  1. After API init block (if exists)
  2. After WidgetsFlutterBinding.ensureInitialized() (if exists)
  3. At the start of main() async

Requirements:
  - Your main() must be async: void main() async { }
  - Dependencies: google_fonts

Note: For REST API initialization, use 'flutterx init' command
''');
  }
}
