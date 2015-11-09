import 'package:match-expression-transpiler/parser.dart';
import 'package:match-expression-transpiler/transpiler.dart';

main(List<String> arguments) {
  try {
    var compilationUnits = parseDartFiles(arguments.first);
    transpile(compilationUnits);
  } catch (_) {
    rethrow;
  }
}
