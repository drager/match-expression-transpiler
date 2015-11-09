library transpiler;

import 'dart:math';

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/src/generated/java_core.dart';

transpile(Iterable<CompilationUnit> compilationUnits) {
  final files = compilationUnits.map((compilationUnit) {
    final writer = new PrintStringWriter();
    new Transpiler(writer).visitCompilationUnit(compilationUnit);
    return writer.toString();
  });

  files.forEach(print);
}

class Variable {
  final String type;
  final String name;
  final String fromVariable;

  Variable(this.type, this.name, this.fromVariable);
}

class Transpiler extends ToSourceVisitor {
  final characters = 'abcdefghijklmnopqrstuvxyz0123456789'.split('');
  final PrintWriter _writer;
  var variableName;
  List<Variable> variablesToDeclare;

  Transpiler(PrintWriter writer)
      : _writer = writer,
        super(writer);

  visitTypeTestPattern(TypeTestPattern node) {
    _writer.print('$variableName is ');
    node.type.accept(this);
    variablesToDeclare.add(new Variable(
        node.type.toString(), node.identifier.toString(), variableName));
  }

  visitRangePattern(RangePattern node) {
    _writer.print('$variableName >= ');
    node.startRange.accept(this);
    _writer.print(' && ');
    _writer.print('$variableName <= ');
    node.endRange.accept(this);
  }

  visitPatternGuard(PatternGuard node) {
    _writer.print('if (');
    node.condition.accept(this);
    _writer.print(') {');
  }

  visitMatchExpression(MatchExpression node) {
    final rand = new Random();
    variableName = r'_$';
    for (var i = 0; i < 10; i++) {
      variableName += characters[rand.nextInt(characters.length)];
    }
    _writer.print('($variableName) {');
    node.clauses.accept(this);
    _writer.print('} (');
    node.expression.accept(this);
    _writer.print(')');
  }

  visitMatchClause(MatchClause node) {
    variablesToDeclare = [];
    _writer.print('if (');
    int size = node.patterns.length;
    for (int i = 0; i < size; i++) {
      if (i > 0) {
        _writer.print(' || ');
      }
      node.patterns[i].accept(this);
    }
    _writer.print(') {');

    variablesToDeclare = variablesToDeclare.fold([],
        (List<Variable> list, Variable variable) {
      if (!list.any((v) => v.name == variable.name)) {
        list.add(variable);
      }
      return list;
    });
    for (var variable in variablesToDeclare) {
      _writer.print(variable.type);
      _writer.print(' ');
      _writer.print(variable.name);
      _writer.print(' = ');
      _writer.print(variable.fromVariable);
      _writer.print(';');
    }

    if (node.patternGuard != null) {
      node.patternGuard.accept(this);
    }
    _writer.print('return ');
    node.armExpression.accept(this);
    if (node.patternGuard != null) {
      _writer.print('}');
    }
    _writer.print('}');
  }

  visitLiteralPattern(LiteralPattern node) {
    _writer.print('$variableName == ');
    node.literal.accept(this);
  }

  visitIdentifierPattern(IdentifierPattern node) {
    _writer.print('true');
    variablesToDeclare
        .add(new Variable('var', node.identifier.toString(), variableName));
  }

  visitDestructuredListPattern(DestructuredListPattern node) {
    _writer.print('$variableName is List && ');
    _writer.print('$variableName.length == ${node.elements.length}');
    var oldVariableName = variableName;
    try {
      var index = 0;
      for (var element in node.elements) {
        variableName = '$oldVariableName[$index]';
        _writer.print(' && ');
        element.accept(this);
        index += 1;
      }
    } finally {
      variableName = oldVariableName;
    }
  }

  visitConstantValuePattern(ConstantValuePattern node) {
    _writer.print('$variableName == ');
    node.identifier.accept(this);
  }
}
