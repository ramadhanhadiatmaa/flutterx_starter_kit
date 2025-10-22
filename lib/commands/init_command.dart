import 'dart:io';
import 'package:args/args.dart';

class InitCommand {
  final _startMarker = '// Start code';
  final _endMarker = '// End code';

  ArgParser get argParser {
    return ArgParser()
      ..addOption(
        'file',
        abbr: 'f',
        defaultsTo: 'lib/main.dart',
        help: 'Path to main.dart',
      )
      ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');
  }

  Future<void> run(ArgResults results) async {
    if (results['help']) {
      _printHelp();
      return;
    }

    final filePath = results['file'] as String;
    final file = File(filePath);

    if (!file.existsSync()) {
      throw Exception('File not found: $filePath');
    }

    print('📝 Reading file: $filePath');
    String content = await file.readAsString();

    if (content.contains(_startMarker)) {
      print('⚠️  Update data...');
      content = _removeExistingInjection(content);
    }

    // Inject code baru
    content = _injectCode(content);

    // Tulis kembali ke file
    await file.writeAsString(content);
    print('✅ Success $filePath');
  }

  String _removeExistingInjection(String content) {
    final startIndex = content.indexOf(_startMarker);
    final endIndex = content.indexOf(_endMarker);

    if (startIndex != -1 && endIndex != -1) {
      return content.substring(0, startIndex) +
          content.substring(endIndex + _endMarker.length);
    }

    return content;
  }

  String _injectCode(String content) {
    // You must add async to main function
    final mainPattern = RegExp(r'void\s+main\s*\(\s*\)\s+async\s*\{');
    final match = mainPattern.firstMatch(content);

    if (match == null) {
      throw Exception('"void main() async {" not found in the file.');
    }

    final injectionCode =
        '''

  $_startMarker
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  final base = dotenv.env['API_BASE_URL'];
  ApiClient.init(ApiConfig(baseUrl: base!));
  $_endMarker
''';

    final insertPosition = match.end;
    return content.substring(0, insertPosition) +
        injectionCode +
        content.substring(insertPosition);
  }

  void _printHelp() {
    print('''
Inject initialization code to main.dart

Usage: flutterx init [options]

Options:
${argParser.usage}

Examples:
  flutterx init
  flutterx init --file lib/main.dart
  flutterx init -f lib/app.dart
''');
  }
}
