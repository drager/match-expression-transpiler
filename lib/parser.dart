library parser;

import 'package:analyzer/analyzer.dart';
import 'package:path/path.dart' as pathTools;
import 'dart:io';

List<CompilationUnit> parseDartFiles(String path) {
  var files = _findDartFiles(path);
  return _parseDartFiles(files);
}

/// Finds all Dart files in [path] recursively
List<String> _findDartFiles(String path) {
  var uri = new Uri.file(pathTools.absolute(path));
  var files = [];

  try {
    var fileList = new Directory.fromUri(uri).listSync();
    fileList.forEach((entity) {
      var type = FileSystemEntity.typeSync(entity.path);

      if (type == FileSystemEntityType.DIRECTORY) {
        if (pathTools.basename(entity.path) == 'packages' ||
            (pathTools.basename(entity.path) != 'test' &&
                fileList.any((file) =>
                    pathTools.basename(entity.path) == 'pubspec.yaml'))) return;
        files.addAll(_findDartFiles(entity.path));
      } else if (type != FileSystemEntityType.FILE) {
        return;
      }

      if (pathTools.extension(entity.path) != '.dart') {
        return;
      }

      files.add(entity.absolute.path);
    });
  } on FileSystemException catch (e) {
    if (e.message == 'Directory listing failed') {
      return [path];
    }
    throw e;
  }

  return files;
}

/// Parses all Dart files into ASTs.
List<CompilationUnit> _parseDartFiles(List<String> paths) {
  var compilationUnits = [];
  for (var path in paths) {
    // Capture errors if the repo contains code that isn't valid Dart
    try {
      if (FileSystemEntity.typeSync(path) == FileSystemEntityType.FILE) {
        compilationUnits.add(parseDartFile(path));
      }
    } catch (_) {
      print(_);
    }
  }

  return compilationUnits;
}
