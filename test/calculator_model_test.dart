import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_calc/models/calculator_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late CalculatorModel calc;

  setUp(() async {
    await SharedPreferences.setMockInitialValues({});
    calc = CalculatorModel();
    await Future<void>.delayed(Duration.zero);
  });

  void type(String value) {
    for (final character in value.split('')) {
      calc.appendToken(character);
    }
  }

  group('Basic arithmetic', () {
    test('addition', () {
      type('2+3');
      calc.evaluate();
      expect(calc.result, '5');
    });

    test('subtraction', () {
      type('10-4');
      calc.evaluate();
      expect(calc.result, '6');
    });

    test('multiplication', () {
      type('6×7');
      calc.evaluate();
      expect(calc.result, '42');
    });

    test('division', () {
      type('9÷3');
      calc.evaluate();
      expect(calc.result, '3');
    });

    test('chained operations respect precedence', () {
      type('2+3×4');
      calc.evaluate();
      expect(calc.result, '14');
    });
  });

  group('Parentheses', () {
    test('simple grouping', () {
      type('(2+3)×4');
      calc.evaluate();
      expect(calc.result, '20');
    });

    test('nested grouping', () {
      type('((2+3)×2)+1');
      calc.evaluate();
      expect(calc.result, '11');
    });
  });

  group('Scientific functions in RAD mode', () {
    setUp(() {
      if (calc.angleMode == AngleMode.deg) {
        calc.toggleAngleMode();
      }
    });

    test('sin(pi/2) = 1', () {
      calc.appendToken('sin(');
      calc.appendToken('π');
      type('/2)');
      calc.evaluate();
      expect(double.parse(calc.result), closeTo(1.0, 0.0001));
    });

    test('ln(e) = 1', () {
      calc.appendToken('ln(');
      calc.appendToken('e');
      type(')');
      calc.evaluate();
      expect(double.parse(calc.result), closeTo(1.0, 0.0001));
    });

    test('exp(1) = e', () {
      calc.appendToken('exp(');
      type('1)');
      calc.evaluate();
      expect(double.parse(calc.result), closeTo(math.e, 0.0001));
    });
  });

  group('Scientific functions in DEG mode', () {
    test('sin(30) = 0.5', () {
      calc.appendToken('sin(');
      type('30)');
      calc.evaluate();
      expect(double.parse(calc.result), closeTo(0.5, 0.0001));
    });

    test('asin(0.5) = 30', () {
      calc.appendToken('asin(');
      type('0.5)');
      calc.evaluate();
      expect(double.parse(calc.result), closeTo(30.0, 0.0001));
    });
  });

  group('Constants and symbols', () {
    test('pi parses correctly', () {
      calc.appendToken('π');
      calc.evaluate();
      expect(double.parse(calc.result), closeTo(math.pi, 0.0001));
    });

    test('percentage converts to fraction', () {
      type('25%');
      calc.evaluate();
      expect(calc.result, '0.25');
    });
  });

  group('Input editing', () {
    test('clear resets the calculator', () {
      type('123');
      calc.clear();
      expect(calc.expression, '');
      expect(calc.result, '0');
    });

    test('backspace removes the last token', () {
      type('123');
      calc.backspace();
      expect(calc.expression, '12');
    });

    test('toggle sign flips the current number', () {
      type('12');
      calc.toggleSign();
      expect(calc.expression, '-12');
    });
  });

  group('Memory', () {
    test('store and recall', () {
      type('42');
      calc.evaluate();
      calc.memoryStore();
      calc.clear();
      calc.memoryRecall();
      expect(calc.expression, '42');
    });

    test('memory add', () {
      type('10');
      calc.evaluate();
      calc.memoryStore();
      calc.clear();
      type('5');
      calc.evaluate();
      calc.memoryAdd();
      calc.clear();
      calc.memoryRecall();
      expect(calc.expression, '15');
    });
  });

  group('History', () {
    test('evaluations are recorded', () {
      type('5+5');
      calc.evaluate();
      expect(calc.history, isNotEmpty);
      expect(calc.history.first.result, '10');
    });

    test('history can be recalled', () {
      type('7×6');
      calc.evaluate();
      final entry = calc.history.first;
      calc.clear();
      calc.recallHistory(entry);
      expect(calc.expression, '7×6');
    });
  });

  group('Angle mode', () {
    test('starts in DEG mode', () {
      expect(calc.angleMode, AngleMode.deg);
    });

    test('toggle switches to RAD', () {
      calc.toggleAngleMode();
      expect(calc.angleMode, AngleMode.rad);
    });

    test('toggling updates the live result', () {
      calc.appendToken('sin(');
      calc.appendToken('3');
      calc.appendToken('0');
      calc.appendToken(')');
      expect(double.parse(calc.result), closeTo(0.5, 0.0001));

      calc.toggleAngleMode();

      expect(double.parse(calc.result), isNot(closeTo(0.5, 0.0001)));
    });
  });
}
