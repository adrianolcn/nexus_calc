import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_theme.dart';

enum ButtonType {
  digit,
  operator,
  function,
  memory,
  utility,
  equals,
  second,
}

class CalcButton extends StatefulWidget {
  const CalcButton({
    super.key,
    required this.label,
    required this.onTap,
    this.type = ButtonType.digit,
    this.subLabel,
    this.flex = 1,
    this.isActive = false,
    this.height = 64,
    this.padding = 4,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback onTap;
  final ButtonType type;
  final String? subLabel;
  final int flex;
  final bool isActive;
  final double height;
  final double padding;
  final String? semanticLabel;

  @override
  State<CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  late final Animation<double> _scale;

  bool _held = false;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _press, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  Color get _faceColor {
    if (widget.isActive) return _glowColor.withOpacity(0.25);

    return switch (widget.type) {
      ButtonType.equals => NexusColors.green,
      ButtonType.memory => NexusColors.bg2,
      _ => NexusColors.bg3,
    };
  }

  Color get _glowColor => switch (widget.type) {
        ButtonType.equals => NexusColors.green,
        ButtonType.operator => NexusColors.violet,
        ButtonType.function => NexusColors.cyan,
        ButtonType.memory => NexusColors.amberDim,
        ButtonType.utility => NexusColors.cyanDim,
        ButtonType.second => NexusColors.amber,
        _ => NexusColors.borderBright,
      };

  Color get _borderColor => switch (widget.type) {
        ButtonType.equals => NexusColors.green,
        ButtonType.operator => NexusColors.violetDim,
        ButtonType.function => NexusColors.cyanDim,
        ButtonType.second =>
          widget.isActive ? NexusColors.amber : NexusColors.border,
        _ => NexusColors.border,
      };

  TextStyle _labelStyle(BuildContext context) => switch (widget.type) {
        ButtonType.digit => NexusTextStyles.btnDigit(context),
        ButtonType.operator => NexusTextStyles.btnOperator(context),
        ButtonType.function => NexusTextStyles.btnFunction(context),
        ButtonType.equals => NexusTextStyles.btnEquals(context),
        ButtonType.memory => NexusTextStyles.btnFunction(context).copyWith(
            color: NexusColors.amber,
          ),
        ButtonType.utility => NexusTextStyles.btnDigit(context).copyWith(
            color: NexusColors.textSecondary,
            fontSize: 18,
          ),
        ButtonType.second => NexusTextStyles.btnFunction(context).copyWith(
            color: widget.isActive ? NexusColors.amber : NexusColors.cyan,
          ),
      };

  List<BoxShadow> get _shadows => _held
      ? [
          BoxShadow(
            color: _glowColor.withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ]
      : widget.isActive
          ? [
              BoxShadow(
                color: _glowColor.withOpacity(0.35),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ]
          : [
              BoxShadow(
                color: _glowColor.withOpacity(0.12),
                blurRadius: 8,
              ),
            ];

  void _onTapDown(TapDownDetails _) {
    setState(() => _held = true);
    _press.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _held = false);
    _press.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _held = false);
    _press.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Semantics(
          button: true,
          label: widget.semanticLabel ?? widget.label,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedBuilder(
              animation: _scale,
              builder: (context, child) => Transform.scale(
                scale: _scale.value,
                child: child,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                height: widget.height,
                decoration: BoxDecoration(
                  color: _faceColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _held ? _glowColor.withOpacity(0.8) : _borderColor,
                    width: widget.type == ButtonType.equals ? 1.6 : 1,
                  ),
                  boxShadow: _shadows,
                ),
                child: _ButtonContent(
                  label: widget.label,
                  subLabel: widget.subLabel,
                  labelStyle: _labelStyle(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.labelStyle,
    this.subLabel,
  });

  final String label;
  final String? subLabel;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: labelStyle,
                  maxLines: 1,
                ),
              ),
            ),
          ),
          if (subLabel != null)
            Positioned(
              top: 8,
              right: 10,
              child: Text(
                subLabel!,
                style: NexusTextStyles.badge(context).copyWith(
                  color: NexusColors.amber.withOpacity(0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
