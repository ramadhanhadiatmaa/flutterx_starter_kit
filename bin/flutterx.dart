#!/usr/bin/env dart

import 'dart:developer';
import 'dart:io';
import 'package:args/args.dart';
import 'package:flutterx_starter_kit/commands/init_command.dart';
import 'package:flutterx_starter_kit/commands/font_command.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  // Add subcommands dengan parser masing-masing
  final initCommand = InitCommand();
  final fontCommand = FontCommand();

  parser.addCommand('init', initCommand.argParser);
  parser.addCommand('font', fontCommand.argParser);

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
      case 'font':
        await fontCommand.run(command!);
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
  init        Inject REST API initialization code to main.dart
  font        Configure TextKit font in main.dart

Global options:
${parser.usage}

Examples:
  flutterx init --file lib/main.dart
  flutterx font --name fredoka
  flutterx font -n montserrat

For specific command help:
  flutterx init --help
  flutterx font --help
''');
}
