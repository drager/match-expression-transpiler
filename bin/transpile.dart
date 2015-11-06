import 'package:match-expression-transpiler/transpiler.dart';

main(List<String> arguments) {
  try {
    var compilationUnits = parseDartFiles(arguments.first);
    print(compilationUnits);
  } catch (_) {}
}
