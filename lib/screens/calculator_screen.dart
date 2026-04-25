import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../models/calculator_model.dart';
import '../utils/app_theme.dart';
import '../widgets/button_grid.dart';
import '../widgets/display_panel.dart';
import '../widgets/history_panel.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  void _openHistory(BuildContext context, _MobileLayoutData layout) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: layout.landscape ? 0.92 : 0.88,
        minChildSize: 0.4,
        maxChildSize: 0.96,
        builder: (_, controller) => ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: ChangeNotifierProvider.value(
            value: context.read<CalculatorModel>(),
            child: HistoryPanel(scrollController: controller),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NexusColors.bg0,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF091420), NexusColors.bg0],
          ),
        ),
        child: Stack(
          children: [
            const _AmbientBackground(),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final layout = _MobileLayoutData.fromSize(constraints.biggest);

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: layout.maxWidth),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          layout.horizontalPadding,
                          12,
                          layout.horizontalPadding,
                          layout.bottomPadding,
                        ),
                        child: Column(
                          children: [
                            _NexusAppBar(
                              layout: layout,
                              onHistoryTap: () => _openHistory(context, layout),
                            ),
                            SizedBox(height: layout.sectionSpacing),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: NexusColors.bg1.withValues(alpha: 0.92),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: NexusColors.borderBright.withValues(alpha: 0.65),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.28),
                                      blurRadius: 30,
                                      offset: const Offset(0, 18),
                                    ),
                                    const BoxShadow(
                                      color: NexusColors.cyanGlow,
                                      blurRadius: 28,
                                      spreadRadius: -16,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: layout.displayHeight,
                                      child: DisplayPanel(
                                        compact: layout.compact,
                                        landscape: layout.landscape,
                                      ),
                                    )
                                        .animate()
                                        .fadeIn(duration: 350.ms)
                                        .slideY(begin: -0.03, end: 0, duration: 350.ms),
                                    Expanded(
                                      child: ButtonGrid(
                                        compact: layout.compact,
                                        landscape: layout.landscape,
                                      )
                                          .animate()
                                          .fadeIn(duration: 450.ms, delay: 80.ms)
                                          .slideY(begin: 0.03, end: 0, duration: 450.ms),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NexusAppBar extends StatelessWidget {
  const _NexusAppBar({
    required this.layout,
    required this.onHistoryTap,
  });

  final _MobileLayoutData layout;
  final VoidCallback onHistoryTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            width: layout.compact ? 34 : 40,
            height: layout.compact ? 34 : 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: NexusColors.cyan.withValues(alpha: 0.7),
                width: 1.4,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF10273B), Color(0xFF0A1622)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: NexusColors.cyanGlow,
                  blurRadius: 14,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'N',
                style: NexusTextStyles.btnDigit(context).copyWith(
                  color: NexusColors.cyan,
                  fontSize: layout.compact ? 16 : 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NEXUS',
                style: NexusTextStyles.btnDigit(context).copyWith(
                  color: NexusColors.textPrimary,
                  fontSize: layout.compact ? 15 : 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3.6,
                ),
              ),
              Text(
                'MOBILE SCIENTIFIC CALCULATOR',
                style: NexusTextStyles.chip(context).copyWith(
                  color: NexusColors.textMuted,
                  fontSize: layout.compact ? 8 : 9,
                  letterSpacing: 1.7,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: NexusColors.bg1.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: NexusColors.border),
            ),
            child: IconButton(
              icon: const Icon(Icons.history_rounded),
              color: NexusColors.textSecondary,
              tooltip: 'History',
              onPressed: onHistoryTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileLayoutData {
  const _MobileLayoutData({
    required this.compact,
    required this.landscape,
    required this.maxWidth,
    required this.horizontalPadding,
    required this.bottomPadding,
    required this.sectionSpacing,
    required this.displayHeight,
  });

  final bool compact;
  final bool landscape;
  final double maxWidth;
  final double horizontalPadding;
  final double bottomPadding;
  final double sectionSpacing;
  final double displayHeight;

  factory _MobileLayoutData.fromSize(Size size) {
    final shortestSide = math.min(size.width, size.height);
    final compact = shortestSide < 380 || size.height < 760;
    final landscape = size.width > size.height;
    final tablet = shortestSide >= 600;

    return _MobileLayoutData(
      compact: compact,
      landscape: landscape,
      maxWidth: tablet ? 720 : 540,
      horizontalPadding: tablet ? 24 : (compact ? 12 : 16),
      bottomPadding: landscape ? 10 : 14,
      sectionSpacing: compact ? 10 : 14,
      displayHeight: landscape ? 160 : (compact ? 176 : 208),
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          top: -90,
          right: -60,
          child: _GlowOrb(size: 220, color: NexusColors.cyanGlow),
        ),
        Positioned(
          bottom: -120,
          left: -40,
          child: _GlowOrb(size: 260, color: NexusColors.violetGlow),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _DotPainter(),
          ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: size * 0.35,
              spreadRadius: size * 0.06,
            ),
          ],
        ),
      ),
    );
  }
}

class _DotPainter extends CustomPainter {
  const _DotPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 26.0;
    final paint = Paint()
      ..color = NexusColors.border.withValues(alpha: 0.34)
      ..style = PaintingStyle.fill;

    for (double x = 0; x <= size.width; x += spacing) {
      for (double y = 0; y <= size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
