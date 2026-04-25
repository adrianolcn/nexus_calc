import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AngleMode { deg, rad }

class HistoryEntry {
  const HistoryEntry({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  final String expression;
  final String result;
  final DateTime timestamp;

  String toStorageString() =>
      '${timestamp.millisecondsSinceEpoch}|$expression|$result';

  static HistoryEntry? fromStorageString(String value) {
    final parts = value.split('|');
    if (parts.length < 3) return null;

    final timestamp = int.tryParse(parts.first);
    if (timestamp == null) return null;

    return HistoryEntry(
      expression: parts[1],
      result: parts.sublist(2).join('|'),
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }
}

class CalculatorModel extends ChangeNotifier {
  CalculatorModel() {
    _loadHistory();
  }

  static const _historyKey = 'nexus_history';

  String _expression = '';
  String get expression => _expression;

  String _result = '0';
  String get result => _result;

  bool _hasError = false;
  bool get hasError => _hasError;

  bool _resultFresh = false;
  bool get resultFresh => _resultFresh;

  AngleMode _angleMode = AngleMode.deg;
  AngleMode get angleMode => _angleMode;

  double _memory = 0;
  bool get hasMemory => _memory != 0;

  final List<HistoryEntry> _history = [];
  List<HistoryEntry> get history => List.unmodifiable(
        _history.reversed.toList(),
      );

  bool _secondMode = false;
  bool get secondMode => _secondMode;

  int _openParens = 0;
  String get parenButtonLabel => _openParens > 0 ? ')' : '(';

  void appendToken(String token) {
    if (_resultFresh && _isOperator(token)) {
      _expression = _result + token;
      _resultFresh = false;
    } else if (_resultFresh && !_isOperator(token)) {
      _expression = token;
      _resultFresh = false;
    } else {
      _expression += token;
    }

    _updateParenDepthFromToken(token);
    _hasError = false;
    _evaluateLive();
    notifyListeners();
  }

  void toggleSecond() {
    _secondMode = !_secondMode;
    notifyListeners();
  }

  void toggleAngleMode() {
    _angleMode =
        _angleMode == AngleMode.deg ? AngleMode.rad : AngleMode.deg;
    _evaluateLive();
    notifyListeners();
  }

  void toggleSign() {
    if (_expression.isEmpty) {
      _expression = '-';
      _resultFresh = false;
      _evaluateLive();
      notifyListeners();
      return;
    }

    if (_resultFresh) {
      _expression =
          _result.startsWith('-') ? _result.substring(1) : '-$_result';
      _resultFresh = false;
      _evaluateLive();
      notifyListeners();
      return;
    }

    final lastNumberMatch = RegExp(r'(-?\d*\.?\d+)$').firstMatch(_expression);
    if (lastNumberMatch != null) {
      final token = lastNumberMatch.group(0)!;
      final replacement =
          token.startsWith('-') ? token.substring(1) : '-$token';
      _expression = _expression.replaceRange(
        lastNumberMatch.start,
        lastNumberMatch.end,
        replacement,
      );
    } else if (_isOperator(_expression[_expression.length - 1])) {
      _expression += '-';
    } else {
      _expression = '-($_expression)';
    }

    _hasError = false;
    _openParens = _countOpenParens(_expression);
    _evaluateLive();
    notifyListeners();
  }

  void backspace() {
    if (_expression.isEmpty) return;

    if (_resultFresh) {
      clear();
      return;
    }

    final functionMatch = RegExp(
      r'(sin|cos|tan|asin|acos|atan|log|ln|sqrt|cbrt|abs|exp)\($',
    ).firstMatch(_expression);

    if (functionMatch != null) {
      _expression = _expression.substring(
        0,
        _expression.length - functionMatch.group(0)!.length,
      );
    } else {
      final last = _expression[_expression.length - 1];
      if (last == '(') _openParens = math.max(0, _openParens - 1);
      if (last == ')') _openParens++;
      _expression = _expression.substring(0, _expression.length - 1);
    }

    _hasError = false;
    _evaluateLive();
    notifyListeners();
  }

  void clear() {
    _expression = '';
    _result = '0';
    _hasError = false;
    _resultFresh = false;
    _secondMode = false;
    _openParens = 0;
    notifyListeners();
  }

  void evaluate() {
    if (_expression.isEmpty) return;

    try {
      final value = _compute(_sanitise(_expression));
      final resultString = _format(value);

      _history.add(
        HistoryEntry(
          expression: _expression,
          result: resultString,
          timestamp: DateTime.now(),
        ),
      );
      _saveHistory();

      _result = resultString;
      _hasError = false;
      _resultFresh = true;
      _openParens = 0;
      notifyListeners();
    } catch (_) {
      _result = 'Error';
      _hasError = true;
      _resultFresh = false;
      notifyListeners();
    }
  }

  void autoCloseParen() {
    if (_openParens > 0) appendToken(')');
  }

  void memoryStore() {
    final value = double.tryParse(_result);
    if (value == null) return;
    _memory = value;
    notifyListeners();
  }

  void memoryRecall() {
    appendToken(_format(_memory));
  }

  void memoryAdd() {
    final value = double.tryParse(_result);
    if (value == null) return;
    _memory += value;
    notifyListeners();
  }

  void memoryClear() {
    _memory = 0;
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    _saveHistory();
    notifyListeners();
  }

  void recallHistory(HistoryEntry entry) {
    _expression = entry.expression;
    _result = entry.result;
    _hasError = false;
    _resultFresh = false;
    _openParens = _countOpenParens(_expression);
    notifyListeners();
  }

  void _evaluateLive() {
    if (_expression.isEmpty) {
      _result = '0';
      return;
    }

    try {
      final value = _compute(_sanitise(_expression));
      if (!value.isNaN && !value.isInfinite) {
        _result = _format(value);
      }
    } catch (_) {
      // Mid-typing failures are expected.
    }
  }

  String _sanitise(String expression) {
    var sanitized = expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-')
        .replaceAll('π', '(${math.pi})');

    sanitized = sanitized.replaceAllMapped(
      RegExp(r'(?<![A-Za-z0-9_])e(?![A-Za-z0-9_])'),
      (_) => '(${math.e})',
    );

    sanitized = sanitized.replaceAllMapped(
      RegExp(r'(\d+(?:\.\d+)?)%'),
      (match) => '(${match[1]}/100)',
    );

    if (_angleMode == AngleMode.deg) {
      sanitized = sanitized.replaceAllMapped(
        RegExp(r'(?<![A-Za-z])(asin|acos|atan)\('),
        (match) => '(180/${math.pi})*${match[1]}(',
      );
      sanitized = sanitized.replaceAllMapped(
        RegExp(r'(?<![A-Za-z])(sin|cos|tan)\('),
        (match) => '${match[1]}(${math.pi}/180*',
      );
    }

    sanitized += ')' * _openParens;
    return sanitized;
  }

  double _compute(String expression) {
    var parsedExpression = expression;

    if (parsedExpression.contains('!')) {
      parsedExpression = parsedExpression.replaceAllMapped(
        RegExp(r'(\d+)!'),
        (match) {
          final value = int.tryParse(match[1]!);
          if (value == null || value < 0) {
            throw const FormatException('Invalid factorial');
          }
          return _factorial(value).toString();
        },
      );
    }

    final parser = Parser();
    final expressionTree = parser.parse(parsedExpression);
    final context = ContextModel();
    return expressionTree.evaluate(EvaluationType.REAL, context) as double;
  }

  String _format(double value) {
    if (value.isInfinite) return value > 0 ? '∞' : '-∞';
    if (value.isNaN) return 'Error';

    final abs = value.abs();
    if (abs != 0 && (abs >= 1e10 || abs < 1e-6)) {
      return value
          .toStringAsExponential(6)
          .replaceAll(RegExp(r'0+e'), 'e');
    }

    final fixed = value.toStringAsFixed(10);
    if (fixed.contains('.')) {
      return fixed
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }

    return fixed;
  }

  void _updateParenDepthFromToken(String token) {
    for (final character in token.split('')) {
      if (character == '(') _openParens++;
      if (character == ')') _openParens = math.max(0, _openParens - 1);
    }
  }

  int _countOpenParens(String expression) {
    var depth = 0;
    for (final character in expression.split('')) {
      if (character == '(') depth++;
      if (character == ')') depth = math.max(0, depth - 1);
    }
    return depth;
  }

  bool _isOperator(String token) => '+-×÷*/^'.contains(token);

  num _factorial(int value) {
    if (value == 0 || value == 1) return 1;
    num result = 1;
    for (var i = 2; i <= value; i++) {
      result *= i;
    }
    return result;
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _history
        .takeLast(100)
        .map((entry) => entry.toStorageString())
        .toList();
    await prefs.setStringList(_historyKey, encoded);
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_historyKey) ?? [];
    for (final value in stored) {
      final entry = HistoryEntry.fromStorageString(value);
      if (entry != null) _history.add(entry);
    }
    notifyListeners();
  }
}

extension _TakeLast<T> on List<T> {
  List<T> takeLast(int count) => length <= count ? this : sublist(length - count);
}
