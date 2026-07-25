import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TimelineStep {
  final String title;
  final String? subtitle;
  final bool isCompleted;
  final bool isCurrent;
  final Color completedColor;
  final Color textColor;
  final IconData? icon;

  const TimelineStep({
    required this.title,
    this.subtitle,
    required this.isCompleted,
    this.isCurrent = false,
    required this.completedColor,
    required this.textColor,
    this.icon,
  });
}

class StatusTimeline extends StatelessWidget {
  final List<TimelineStep> steps;

  const StatusTimeline({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final step = steps[index];
          final isLast = index == steps.length - 1;
          // Determine if the line below this node should be solid or dotted
          // It's solid if the NEXT step is completed, otherwise dotted.
          final nextStepCompleted = !isLast && steps[index + 1].isCompleted;
          
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: -50.0, // Drop down from top to bottom
              child: FadeInAnimation(
                child: _TimelineNode(
                  step: step,
                  isLast: isLast,
                  solidLine: nextStepCompleted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final TimelineStep step;
  final bool isLast;
  final bool solidLine;

  const _TimelineNode({
    required this.step,
    required this.isLast,
    required this.solidLine,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isActiveNode = step.isCompleted || step.isCurrent;
    final nodeColor = isActiveNode ? step.completedColor : colorScheme.outlineVariant;
    final iconColor = step.isCompleted ? step.textColor : step.completedColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline graphic
        Column(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: isActiveNode ? value : 1.0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: step.isCompleted ? step.completedColor : Colors.transparent,
                      border: Border.all(
                        color: nodeColor,
                        width: step.isCurrent ? 1.5 : 0,
                      ),
                    ),
                    child: step.icon != null
                        ? Icon(
                            step.icon,
                            size: 14,
                            color: iconColor,
                          )
                        : null,
                  ),
                );
              },
            ),
            if (!isLast)
              solidLine
                  ? Container(
                      width: 2,
                      height: 48,
                      color: nodeColor,
                    )
                  : _DottedLine(height: 48, color: colorScheme.outlineVariant),
          ],
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: textTheme.titleMedium?.copyWith(
                  color: isActiveNode ? colorScheme.onSurface : colorScheme.outline,
                  fontWeight: isActiveNode ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              if (step.subtitle != null)
                Text(
                  step.subtitle!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              else
                Text(
                  'Pending',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _DottedLine extends StatelessWidget {
  final double height;
  final Color color;

  const _DottedLine({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          (height / 6).floor(),
          (index) => Container(width: 2, height: 3, color: color),
        ),
      ),
    );
  }
}
