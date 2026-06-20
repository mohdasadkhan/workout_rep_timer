import 'package:flutter/material.dart';
import 'package:fitflow/core/theme/app_text_styles.dart';
import 'package:fitflow/features/workout_timer/domain/entity/workout_phase.dart';
import 'package:fitflow/features/workout_timer/presentation/view_models/timer_view_models.dart';

// Approximate rendered height of each sequence item (padding + content + margin).
// Used to calculate the scroll offset for the active item.
const double _kItemHeight = 56.0;

/// Scrollable list of workout phases. Automatically scrolls to keep the
/// currently active phase visible whenever [data.currentIndex] changes.
class TimerSequenceList extends StatefulWidget {
  const TimerSequenceList({super.key, required this.data});

  final SequenceViewModel data;

  @override
  State<TimerSequenceList> createState() => _TimerSequenceListState();
}

class _TimerSequenceListState extends State<TimerSequenceList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(TimerSequenceList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only scroll when the active phase actually changes, not on every tick.
    if (oldWidget.data.currentIndex != widget.data.currentIndex) {
      _scrollToCurrentItem();
    }
  }

  void _scrollToCurrentItem() {
    if (!_scrollController.hasClients) return;

    final targetOffset = widget.data.currentIndex * _kItemHeight;
    final maxScroll = _scrollController.position.maxScrollExtent;

    // Center the active item within the visible list area.
    final listHeight = _scrollController.position.viewportDimension;
    final centeredOffset = targetOffset - (listHeight / 2) + (_kItemHeight / 2);

    _scrollController.animateTo(
      centeredOffset.clamp(0.0, maxScroll),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'SEQUENCE',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: widget.data.sequence.length,
              cacheExtent: 1000,
              itemBuilder: (context, i) {
                final phase = widget.data.sequence[i];
                final isCurrent = i == widget.data.currentIndex;
                final isPast = i < widget.data.currentIndex;
                final progress =
                    isCurrent && phase.durationSeconds > 0
                        ? widget.data.remainingSeconds / phase.durationSeconds
                        : 0.0;

                return _SequenceItem(
                  key: ValueKey(i),
                  phase: phase,
                  isCurrent: isCurrent,
                  isPast: isPast,
                  progress: progress,
                  sequenceIndex: i,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SequenceItem extends StatelessWidget {
  const _SequenceItem({
    super.key,
    required this.phase,
    required this.isCurrent,
    required this.isPast,
    required this.progress,
    required this.sequenceIndex,
  });

  final WorkoutPhase phase;
  final bool isCurrent;
  final bool isPast;
  final double progress;
  final int sequenceIndex;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        // Keep margin consistent with _kItemHeight estimate.
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isCurrent
              ? phase.color.withOpacity(0.15)
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: isCurrent
              ? Border.all(color: phase.color.withOpacity(0.5), width: 1)
              : null,
        ),
        child: Row(
          children: [
            _LeadingIndicator(
              sequenceIndex: sequenceIndex,
              isPast: isPast,
              isCurrent: isCurrent,
              color: phase.color,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                phase.name,
                style: AppTextStyles.sequenceItem.copyWith(
                  fontWeight:
                      isCurrent ? FontWeight.w700 : FontWeight.w400,
                  color: isCurrent
                      ? Theme.of(context).colorScheme.onSurface
                      : isPast
                          ? Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.35)
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.65),
                ),
              ),
            ),
            _TrailingInfo(
              phase: phase,
              isCurrent: isCurrent,
              progress: progress,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeadingIndicator extends StatelessWidget {
  const _LeadingIndicator({
    required this.sequenceIndex,
    required this.isPast,
    required this.isCurrent,
    required this.color,
  });

  final int sequenceIndex;
  final bool isPast;
  final bool isCurrent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      child: isPast
          ? Icon(
              Icons.check_circle_rounded,
              size: 18,
              color: color.withOpacity(0.6),
            )
          : Text(
              '${sequenceIndex + 1}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isCurrent
                    ? color
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.25),
              ),
            ),
    );
  }
}

class _TrailingInfo extends StatelessWidget {
  const _TrailingInfo({
    required this.phase,
    required this.isCurrent,
    required this.progress,
  });

  final WorkoutPhase phase;
  final bool isCurrent;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isCurrent) ...[
          Container(
            margin: const EdgeInsets.only(right: 8),
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.12),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: phase.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
        Text(
          '${phase.durationSeconds}s',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isCurrent
                ? phase.color
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.30),
          ),
        ),
      ],
    );
  }
}