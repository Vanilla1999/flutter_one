// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_one/main.dart';

void main() {
  group('Тестирование 3-х примеров ', () {
    test('\n10*5+4/2-1', () {
      final exppr = ExpressionEvaluator("10*5+4/2-1");
      expect(exppr.convert(), 51);
    });

    test('\n(x*3-5)/5 x=10', () {
      final exppr = ExpressionEvaluator("(x*3-5)/5");
      expect(exppr.convert({"x": 10}), 5);
    });

    test('\n 3*x+15/(3+2) x=10', () {
      final exppr = ExpressionEvaluator("3*x+15/(3+2)");
      expect(exppr.convert({"x": 10}), 33);
    });
  });
}
