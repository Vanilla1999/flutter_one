import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  final exppr = ExpressionEvaluator("3*x+15/(3+2)");
  print(exppr.convert({
    "x":10
}));
}

class ExpressionEvaluator {
  final String exp;
  late  String _infixExpr;
  late final String _postfixExpr;
   int _index = 0;
  final operationPriority = {
    '(': 0,
    '+': 1,
    '-': 1,
    '*': 2,
    '/': 2,
    '~': 4 //	Унарный минус
  };
  
  ExpressionEvaluator(this.exp) {
    _infixExpr = exp;
  }

  bool _isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;

  String _getStringNumber(String expr) {
    String strNumber = "";
    for (; _index < expr.length; _index++) {
      var num = expr[_index];
      if (_isDigit(num, 0)) {
        strNumber += num;
      } else {
        _index--;
        break;
      }
    }
    return strNumber;
  }

  String _toPostfix(String infixExpr) {
    _index = 0;
    String postfixExpr = "";
    List<String> stack = [];
    for (; _index < infixExpr.length; _index++) {
      final c = infixExpr[_index];
      if (_isDigit(c, 0)) {
        postfixExpr += "${_getStringNumber(infixExpr)} ";
      } else if (c == '(') {
        stack.add(c);
      } else if (c == ')') {
        while (stack.length > 0 && stack.last != '(') {
          postfixExpr += stack.removeLast();
        }
        stack.removeLast();
      } else if (operationPriority.keys.contains(c)) {
        var op = c;
        if (op == '-' &&
            (_index == 0 ||
                (_index > 1 && operationPriority.keys.contains(infixExpr[_index - 1])))) {
          op = '~';
        }

        while (stack.isNotEmpty &&
            (operationPriority[stack.last]! >= operationPriority[op]!)) {
          postfixExpr += stack.removeLast();
        }
        stack.add(op);
      }
    }
    for (var op2 =stack.length-1; op2>=0;op2--) {
      postfixExpr += stack[op2];
    }
    _index = 0;
    return postfixExpr;
  }

  double _execute(String op, double first, double second) {
    switch (op) {
      case '+':
        return first + second;
      case '-':
        return first - second;
      case '*':
        return first * second;
      case '/':
        return first / second;
      default:
        return 0;
    }
  }

  double convert([Map<String, int>? map]) {
    if (map != null && map.isNotEmpty) {
      map.forEach((key, value) {
      _infixExpr =  _infixExpr.replaceAll(key, value.toString());
      });
    }
    print(_infixExpr);
    _postfixExpr = _toPostfix(_infixExpr);
      print(_postfixExpr);
    List<double> locals = [];
    int counter = 0;
    for (; _index < _postfixExpr.length; _index++) {
      final c = _postfixExpr[_index];

      if (_isDigit(c, 0)) {
        final number = "${_getStringNumber(_postfixExpr)} ";
        locals.add(double.parse(number));
      } else if (operationPriority.keys.contains(c)) {
        counter += 1;
        if (c == '~') {
          double last = locals.length > 0 ? locals.removeLast() : 0;
          locals.add(_execute('-', 0, last));
          print("$counter {$c}{$last} = ${locals.last}");
          continue;
        }
        double second = locals.length > 0 ? locals.removeLast() : 0,
            first = locals.length > 0 ? locals.removeLast() : 0;
        locals.add(_execute(c, first, second));
        print("{$counter}) {$first} {$c} {$second} = {${locals.last}");
      }
    }
    return locals.removeLast();
  }
}

