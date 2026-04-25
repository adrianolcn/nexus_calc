import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../models/calculator_model.dart';
import '../utils/app_theme.dart';

class DisplayPanel extends StatefulWidget {
  const DisplayPanel({
    super.key,
    required this.compact,
    required this.landscape,
  });

  final bool compact;
  final bool landscape;

  @override
  State<DisplayPanel> createState() => _DisplayPanelState();
}

class _DisplayPanelState extends State<DisplayPanel> {
  final ScrollController _exprScroll = ScrollController();

  @override
  void dispose() {
    _exprScroll.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_exprScroll.hasClients) {
        _exprScroll.animateTo(
          _exprScroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorModel>(
      builder: (context, model, _) {
        _scrollToEnd();

        final expressionFontSize = widget.landscape
            ? 26.0
            : (widget.compact ? 28.0 : 34.0);
        final resultFontSize = widget.landscape
            ? 40.0
            : (widget.compact ? 44.0 : 52.0);
        final padding = widget.compact
            ? const EdgeInsets.fromLTRB(18, 16, 18, 18)
            : const EdgeInsets.fromLTRB(22, 18, 22, 20);

        return Container(
          width: double.infinity,
          padding: padding,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF111B27), NexusColors.bg1],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            border: Border(
              bottom: BorderSide(color: NexusColors.border, width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StatusRow(model: model),
              SizedBox(height: widget.compact ? 10 : 12),
              SizedBox(
                height: widget.compact ? 34 : 38,
                child: SingleChildScrollView(
                  controller: _exprScroll,
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    model.expression.isEmpty ? ' ' : model.expression,
                    style: NexusTextStyles.display(context).copyWith(
                      fontSize: expressionFontSize,
                      color: model.hasError
                          ? NexusColors.red.withOpacity(0.7)
                          : NexusColors.textSecondary,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(height: widget.compact ? 6 : 8),
              Expanded(
                child: _ResultText(
                  result: model.result,
                  hasError: model.hasError,
                  isFresh: model.resultFresh,
                  fontSize: resultFontSize,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.model});

  final CalculatorModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Badge(
          label: model.angleMode == AngleMode.deg ? 'DEG' : 'RAD',
          color: NexusColors.amber,
        ),
        Row(
          children: [
            if (model.secondMode)
              const _Badge(
                label: '2ND',
                color: NexusColors.violet,
              ),
            if (model.hasMemory) ...[
              const SizedBox(width: 6),
              const _Badge(
                label: 'M',
                color: NexusColors.cyan,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        label,
        style: NexusTextStyles.badge(context).copyWith(color: color),
      ),
    );
  }
}

class _ResultText extends StatelessWidget {
  const _ResultText({
    required this.result,
    required this.hasError,
    required this.isFresh,
    required this.fontSize,
  });

  final String result;
  final bool hasError;
  final bool isFresh;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final style = hasError
        ? NexusTextStyles.resultError(context).copyWith(
            fontSize: fontSize - 8,
          )
        : NexusTextStyles.result(context).copyWith(
            fontSize: fontSize,
            color: isFresh ? NexusColors.green : NexusColors.cyan,
            shadows: isFresh
                ? [
                    Shadow(
                      color: NexusColors.green.withOpacity(0.5),
                      blurRadius: 20,
                    ),
                  ]
                : [
                    Shadow(
                      color: NexusColors.cyan.withOpacity(0.3),
                      blurRadius: 12,
                    ),
                  ],
          );

    return Align(
      alignment: Alignment.bottomRight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Text(
          result,
          style: style,
          maxLines: 1,
          key: ValueKey(result),
        )
            .animate(key: ValueKey('$result$isFresh'))
            .fadeIn(duration: 120.ms)
            .slideY(begin: 0.08, end: 0, duration: 120.ms, curve: Curves.easeOut),
      ),
    );
  }
}
