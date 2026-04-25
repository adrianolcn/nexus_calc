import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';

import '../models/calculator_model.dart';
import '../utils/app_theme.dart';

class HistoryPanel extends StatelessWidget {
  const HistoryPanel({
    super.key,
    this.scrollController,
  });

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorModel>(
      builder: (context, model, _) {
        return Container(
          color: NexusColors.bg0,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(
                  itemCount: model.history.length,
                  onClear: model.clearHistory,
                ),
                Expanded(
                  child: model.history.isEmpty
                      ? const _EmptyState()
                      : ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          itemCount: model.history.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final entry = model.history[index];
                            return _HistoryTile(
                              entry: entry,
                              onTap: () {
                                model.recallHistory(entry);
                                Navigator.of(context).pop();
                              },
                            )
                                .animate(delay: (index * 30).ms)
                                .fadeIn(duration: 200.ms)
                                .slideX(
                                  begin: 0.06,
                                  end: 0,
                                  duration: 200.ms,
                                  curve: Curves.easeOut,
                                );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.itemCount,
    required this.onClear,
  });

  final int itemCount;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 14),
      decoration: const BoxDecoration(
        color: NexusColors.bg1,
        border: Border(
          bottom: BorderSide(color: NexusColors.border),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: NexusColors.borderBright,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'HISTORY',
                style: NexusTextStyles.chip(context).copyWith(
                  color: NexusColors.cyan,
                  fontSize: 12,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                itemCount == 1
                    ? '1 saved calculation'
                    : '$itemCount saved calculations',
                style: NexusTextStyles.historyExpression(context).copyWith(
                  color: NexusColors.textMuted,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (itemCount > 0)
            TextButton(
              onPressed: onClear,
              child: Text(
                'CLEAR',
                style: NexusTextStyles.chip(context).copyWith(
                  color: NexusColors.red.withValues(alpha: 0.8),
                  fontSize: 11,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            color: NexusColors.textMuted,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.entry,
    required this.onTap,
  });

  final HistoryEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final timeFormatter = DateFormat('HH:mm');

    return InkWell(
      onTap: onTap,
      splashColor: NexusColors.cyanGlow,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: NexusColors.bg1.withValues(alpha: 0.45),
          border: Border.all(color: NexusColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.expression,
                style: NexusTextStyles.historyExpression(context),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    timeFormatter.format(entry.timestamp),
                    style: NexusTextStyles.badge(context).copyWith(
                      color: NexusColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '= ${entry.result}',
                    style: NexusTextStyles.historyResult(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history, size: 48, color: NexusColors.textMuted),
            const SizedBox(height: 12),
            Text(
              'No calculations yet',
              style: NexusTextStyles.chip(context).copyWith(
                color: NexusColors.textMuted,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your latest results will appear here for quick recall.',
              style: NexusTextStyles.historyExpression(context).copyWith(
                color: NexusColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
