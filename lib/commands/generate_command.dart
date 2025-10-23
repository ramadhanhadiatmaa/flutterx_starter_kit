import 'dart:developer';
import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

/// CLI subcommand that scaffolds boilerplate files/folders.
///
/// Supported `--type` values:
/// - `feature`  → multi-folder structure (model, repository, page)
/// - `api`      → small HTTP wrapper class
/// - `model`    → simple data model with `fromJson`/`toJson`
/// - `page`     → minimal Flutter `Scaffold` page
class GenerateCommand {
  /// Returns the argument parser for this subcommand.
  /// Options:
  /// - `--name` / `-n`   : required feature/module name to scaffold
  /// - `--type` / `-t`   : scaffold type; allowed values:
  ///                       `feature`, `api`, `model`, `page`
  /// - `--output` / `-o` : output directory (default: `lib`)
  /// - `--help` / `-h`   : show help
  ArgParser get argParser {
    return ArgParser()
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Feature/module name to generate (e.g., "user").',
      )
      ..addOption(
        'type',
        abbr: 't',
        defaultsTo: 'feature',
        allowed: ['feature', 'api', 'model', 'page'],
        help: 'Type of code to generate.',
      )
      ..addOption(
        'output',
        abbr: 'o',
        defaultsTo: 'lib',
        help: 'Output directory.',
      )
      ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help.');
  }

  /// Executes the command using parsed [results].
  Future<void> run(ArgResults results) async {
    if (results['help'] == true) {
      _printHelp();
      return;
    }

    final name = results['name'] as String?;
    if (name == null || name.trim().isEmpty) {
      throw Exception(
        '--name is required. Usage: flutterx generate --name <name>',
      );
    }

    final type = results['type'] as String;
    final output = results['output'] as String;

    log('🚀 Generating $type: $name ...');

    switch (type) {
      case 'feature':
        await _generateFeature(name, output);
        break;
      case 'api':
        await _generateApi(name, output);
        break;
      case 'model':
        await _generateModel(name, output);
        break;
      case 'page':
        await _generatePage(name, output);
        break;
      default:
        throw Exception('Unknown type: $type');
    }

    log('✅ Generate complete!');
  }

  /// Generates a **feature** folder structure with initial files.
  Future<void> _generateFeature(String name, String outputPath) async {
    final rc = ReCase(name);
    final featurePath = path.join(outputPath, 'features', rc.snakeCase);

    // Create folder structure
    await _createDirectory(path.join(featurePath, 'data/models'));
    await _createDirectory(path.join(featurePath, 'data/repositories'));
    await _createDirectory(path.join(featurePath, 'domain/entities'));
    await _createDirectory(path.join(featurePath, 'domain/repositories'));
    await _createDirectory(path.join(featurePath, 'domain/usecases'));
    await _createDirectory(path.join(featurePath, 'presentation/pages'));
    await _createDirectory(path.join(featurePath, 'presentation/widgets'));
    await _createDirectory(path.join(featurePath, 'presentation/bloc'));

    // Generate files
    await _generateModel(name, featurePath);
    await _generateRepository(name, featurePath);
    await _generatePage(name, featurePath);

    log('  📁 Feature structure created at: $featurePath');
  }

  /// Generates a simple **API** wrapper class under `data/api/`.
  Future<void> _generateApi(String name, String outputPath) async {
    final rc = ReCase(name);
    final apiPath = path.join(outputPath, 'data', 'api');
    await _createDirectory(apiPath);

    final file = File(path.join(apiPath, '${rc.snakeCase}_api.dart'));
    final content = _getApiTemplate(rc);
    await file.writeAsString(content);

    log('  ✅ API created: ${file.path}');
  }

  /// Generates a simple **model** with `fromJson`/`toJson` under `data/models/`.
  Future<void> _generateModel(String name, String outputPath) async {
    final rc = ReCase(name);
    final modelPath = path.join(outputPath, 'data', 'models');
    await _createDirectory(modelPath);

    final file = File(path.join(modelPath, '${rc.snakeCase}_model.dart'));
    final content = _getModelTemplate(rc);
    await file.writeAsString(content);

    log('  ✅ Model created: ${file.path}');
  }

  /// Generates a **repository** interface and implementation files.
  Future<void> _generateRepository(String name, String repoPath) async {
    final rc = ReCase(name);

    // Interface
    final interfacePath = path.join(repoPath, 'domain', 'repositories');
    await _createDirectory(interfacePath);
    final interfaceFile = File(
      path.join(interfacePath, '${rc.snakeCase}_repository.dart'),
    );
    await interfaceFile.writeAsString(_getRepositoryInterfaceTemplate(rc));

    // Implementation
    final implPath = path.join(repoPath, 'data', 'repositories');
    await _createDirectory(implPath);
    final implFile = File(
      path.join(implPath, '${rc.snakeCase}_repository_impl.dart'),
    );
    await implFile.writeAsString(_getRepositoryImplTemplate(rc));

    log('  ✅ Repository created: ${interfaceFile.path}');
  }

  /// Generates a minimal **page** under `presentation/pages/`.
  Future<void> _generatePage(String name, String outputPath) async {
    final rc = ReCase(name);
    final pagePath = path.join(outputPath, 'presentation', 'pages');
    await _createDirectory(pagePath);

    final file = File(path.join(pagePath, '${rc.snakeCase}_page.dart'));
    final content = _getPageTemplate(rc);
    await file.writeAsString(content);

    log('  ✅ Page created: ${file.path}');
  }

  /// Creates a directory (recursively) if it doesn't already exist.
  Future<void> _createDirectory(String dirPath) async {
    final dir = Directory(dirPath);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
  }

  /// Template for a simple model.
  String _getModelTemplate(ReCase rc) {
    return '''
class ${rc.pascalCase}Model {
  final String id;
  final String name;
  
  ${rc.pascalCase}Model({
    required this.id,
    required this.name,
  });

  factory ${rc.pascalCase}Model.fromJson(Map<String, dynamic> json) {
    return ${rc.pascalCase}Model(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
''';
  }

  /// Template for a tiny API wrapper using `http`.
  String _getApiTemplate(ReCase rc) {
    return '''
import 'package:http/http.dart' as http;
import 'dart:convert';

class ${rc.pascalCase}Api {
  final String baseUrl;

  ${rc.pascalCase}Api({required this.baseUrl});

  Future<List<Map<String, dynamic>>> get${rc.pascalCase}s() async {
    final response = await http.get(
      Uri.parse('\$baseUrl/${rc.snakeCase}s'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load ${rc.snakeCase}s');
    }
  }

  Future<Map<String, dynamic>> get${rc.pascalCase}(String id) async {
    final response = await http.get(
      Uri.parse('\$baseUrl/${rc.snakeCase}s/\$id'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load ${rc.snakeCase}');
    }
  }

  Future<Map<String, dynamic>> create${rc.pascalCase}(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('\$baseUrl/${rc.snakeCase}s'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create ${rc.snakeCase}');
    }
  }
}
''';
  }

  /// Template for a repository **interface**.
  String _getRepositoryInterfaceTemplate(ReCase rc) {
    return '''
abstract class ${rc.pascalCase}Repository {
  Future<List<${rc.pascalCase}Model>> get${rc.pascalCase}s();
  Future<${rc.pascalCase}Model> get${rc.pascalCase}(String id);
  Future<${rc.pascalCase}Model> create${rc.pascalCase}(${rc.pascalCase}Model ${rc.camelCase});
}
''';
  }

  /// Template for a repository **implementation**.
  String _getRepositoryImplTemplate(ReCase rc) {
    return '''
import '../models/${rc.snakeCase}_model.dart';
import '../../domain/repositories/${rc.snakeCase}_repository.dart';

class ${rc.pascalCase}RepositoryImpl implements ${rc.pascalCase}Repository {
  // final ${rc.pascalCase}Api api;

  // ${rc.pascalCase}RepositoryImpl({required this.api});

  @override
  Future<List<${rc.pascalCase}Model>> get${rc.pascalCase}s() async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<${rc.pascalCase}Model> get${rc.pascalCase}(String id) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<${rc.pascalCase}Model> create${rc.pascalCase}(${rc.pascalCase}Model ${rc.camelCase}) async {
    // TODO: Implement
    throw UnimplementedError();
  }
}
''';
  }

  /// Template for a minimal Flutter page.
  String _getPageTemplate(ReCase rc) {
    return '''
import 'package:flutter/material.dart';

class ${rc.pascalCase}Page extends StatelessWidget {
  const ${rc.pascalCase}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${rc.titleCase}'),
      ),
      body: Center(
        child: Text('${rc.pascalCase} Page'),
      ),
    );
  }
}
''';
  }

  /// Prints CLI help/usage for this subcommand.
  void _printHelp() {
    log('''
Generate boilerplate code

Usage: flutterx generate [options]

Options:
${argParser.usage}

Examples:
  flutterx generate --name user --type feature
  flutterx generate -n product -t api
  flutterx generate -n order -t model
  flutterx generate -n dashboard -t page
''');
  }
}
