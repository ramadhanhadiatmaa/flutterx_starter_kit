#!/usr/bin/env dart

import 'dart:developer';
import 'dart:io';
import 'package:args/args.dart';
import 'package:flutterx_starter_kit/commands/init_command.dart';
import 'package:flutterx_starter_kit/commands/generate_command.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  // Add subcommands dengan parser masing-masing
  final initCommand = InitCommand();
  parser.addCommand('init', initCommand.argParser);

  final generateCommand = GenerateCommand();
  parser.addCommand('generate', generateCommand.argParser);

  try {
    final results = parser.parse(arguments);

    if (results['help'] || arguments.isEmpty) {
      _printHelp(parser);
      return;
    }

    final command = results.command;

    switch (command?.name) {
      case 'init':
        await initCommand.run(command!);
        break;
      case 'generate':
        await generateCommand.run(command!);
        break;
      default:
        log('Command not found: ${command?.name}');
        _printHelp(parser);
        exit(1);
    }
  } catch (e) {
    log('Error: $e');
    exit(1);
  }
}

void _printHelp(ArgParser parser) {
  log('''
FlutterX Starter Kit - CLI Code Generator

Usage: flutterx <command> [arguments]

Commands:
  init        Inject initialization code to main.dart
  generate    Generate boilerplate code for new feature

Global options:
${parser.usage}

Examples:
  flutterx init --file lib/main.dart
  flutterx generate --name user --type feature
  flutterx generate --name product --type api

For specific command help:
  flutterx init --help
  flutterx generate --help
''');
}
