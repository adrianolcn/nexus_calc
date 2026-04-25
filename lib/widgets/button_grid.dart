import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/calculator_model.dart';
import 'calc_button.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({
    super.key,
    required this.compact,
    required this.landscape,
  });

  final bool compact;
  final bool landscape;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CalculatorModel>();
    final second = model.secondMode;
    final angleLabel = model.angleMode == AngleMode.deg ? 'DEG' : 'RAD';

    void push(String token) => model.appendToken(token);
    void fn(String name) => model.appendToken('$name(');

    return LayoutBuilder(
      builder: (context, constraints) {
        final rowGap = compact ? 6.0 : 8.0;
        final horizontalPadding = compact ? 6.0 : 10.0;
        final buttonPadding = compact ? 3.0 : 4.0;
        final buttonHeight = ((constraints.maxHeight - (rowGap * 7)) / 8)
            .clamp(54.0, landscape ? 76.0 : 84.0)
            .toDouble();

        Widget row(List<Widget> children) {
          return SizedBox(
            height: buttonHeight,
            child: Row(children: children),
          );
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            10,
            horizontalPadding,
            compact ? 8 : 12,
          ),
          child: Column(
            children: [
              row([
                CalcButton(
                  label: '2nd',
                  type: ButtonType.second,
                  isActive: second,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: model.toggleSecond,
                ),
                CalcButton(
                  label: angleLabel,
                  type: ButtonType.utility,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: model.toggleAngleMode,
                ),
                CalcButton(
                  label: second ? 'x²' : 'xʸ',
                  type: ButtonType.function,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push(second ? '^2' : '^'),
                ),
                CalcButton(
                  label: second ? '∛' : '√',
                  type: ButtonType.function,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => fn(second ? 'cbrt' : 'sqrt'),
                ),
                CalcButton(
                  label: second ? 'n!' : '%',
                  type: ButtonType.function,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push(second ? '!' : '%'),
                ),
              ]),
              SizedBox(height: rowGap),
              row([
                CalcButton(
                  label: second ? 'sin⁻¹' : 'sin',
                  type: ButtonType.function,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => fn(second ? 'asin' : 'sin'),
                ),
                CalcButton(
                  label: second ? 'cos⁻¹' : 'cos',
                  type: ButtonType.function,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => fn(second ? 'acos' : 'cos'),
                ),
                CalcButton(
                  label: second ? 'tan⁻¹' : 'tan',
                  type: ButtonType.function,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => fn(second ? 'atan' : 'tan'),
                ),
                CalcButton(
                  label: second ? 'eˣ' : 'ln',
                  type: ButtonType.function,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => fn(second ? 'exp' : 'ln'),
                ),
                CalcButton(
                  label: second ? '10ˣ' : 'log',
                  type: ButtonType.function,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => second ? push('10^') : fn('log'),
                ),
              ]),
              SizedBox(height: rowGap),
              row([
                CalcButton(
                  label: 'MC',
                  type: ButtonType.memory,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: model.memoryClear,
                ),
                CalcButton(
                  label: 'MR',
                  type: ButtonType.memory,
                  isActive: model.hasMemory,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: model.memoryRecall,
                ),
                CalcButton(
                  label: 'M+',
                  type: ButtonType.memory,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: model.memoryAdd,
                ),
                CalcButton(
                  label: 'MS',
                  type: ButtonType.memory,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: model.memoryStore,
                ),
                CalcButton(
                  label: '|x|',
                  type: ButtonType.function,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => fn('abs'),
                ),
              ]),
              SizedBox(height: rowGap),
              row([
                CalcButton(
                  label: 'AC',
                  type: ButtonType.utility,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: model.clear,
                ),
                CalcButton(
                  label: '⌫',
                  type: ButtonType.utility,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: model.backspace,
                ),
                CalcButton(
                  label: model.parenButtonLabel,
                  type: ButtonType.utility,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => model.parenButtonLabel == '('
                      ? push('(')
                      : model.autoCloseParen(),
                ),
                CalcButton(
                  label: 'π',
                  type: ButtonType.function,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('π'),
                ),
                CalcButton(
                  label: '÷',
                  type: ButtonType.operator,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('÷'),
                ),
              ]),
              SizedBox(height: rowGap),
              row([
                CalcButton(
                  label: '7',
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('7'),
                ),
                CalcButton(
                  label: '8',
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('8'),
                ),
                CalcButton(
                  label: '9',
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('9'),
                ),
                CalcButton(
                  label: 'e',
                  type: ButtonType.function,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('e'),
                ),
                CalcButton(
                  label: '×',
                  type: ButtonType.operator,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('×'),
                ),
              ]),
              SizedBox(height: rowGap),
              row([
                CalcButton(
                  label: '4',
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('4'),
                ),
                CalcButton(
                  label: '5',
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('5'),
                ),
                CalcButton(
                  label: '6',
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('6'),
                ),
                CalcButton(
                  label: '+/-',
                  type: ButtonType.utility,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: model.toggleSign,
                ),
                CalcButton(
                  label: '−',
                  type: ButtonType.operator,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('-'),
                ),
              ]),
              SizedBox(height: rowGap),
              row([
                CalcButton(
                  label: '1',
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('1'),
                ),
                CalcButton(
                  label: '2',
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('2'),
                ),
                CalcButton(
                  label: '3',
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('3'),
                ),
                CalcButton(
                  label: '^',
                  type: ButtonType.operator,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('^'),
                ),
                CalcButton(
                  label: '+',
                  type: ButtonType.operator,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('+'),
                ),
              ]),
              SizedBox(height: rowGap),
              row([
                CalcButton(
                  label: '0',
                  flex: 2,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('0'),
                ),
                CalcButton(
                  label: '.',
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: () => push('.'),
                ),
                CalcButton(
                  label: '=',
                  type: ButtonType.equals,
                  flex: 2,
                  height: buttonHeight,
                  padding: buttonPadding,
                  onTap: model.evaluate,
                ),
              ]),
            ],
          ),
        );
      },
    );
  }
}
