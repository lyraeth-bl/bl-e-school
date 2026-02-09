import 'package:flutter/material.dart';

class CircleNumberIndicator extends StatefulWidget {
  final int value;
  final double progress;
  final double size;
  final Color? backgroundColor;
  final Color? valueColor;
  final Duration duration;
  final bool enableAnimation;

  const CircleNumberIndicator({
    super.key,
    required this.value,
    required this.progress,
    this.size = 50,
    this.backgroundColor,
    this.valueColor,
    this.duration = const Duration(milliseconds: 2000),
    this.enableAnimation = false,
  });

  @override
  State<CircleNumberIndicator> createState() => _CircleNumberIndicatorState();
}

class _CircleNumberIndicatorState extends State<CircleNumberIndicator> {
  double _previousProgress = 0;

  @override
  void didUpdateWidget(covariant CircleNumberIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.progress != widget.progress) {
      _previousProgress = oldWidget.progress;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.valueColor ?? Theme.of(context).colorScheme.primary;

    if (!widget.enableAnimation) {
      return _buildContent(widget.progress, widget.value, color);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: _previousProgress, end: widget.progress),
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedProgress, _) {
        return _buildContent(animatedProgress, widget.value, color);
      },
    );
  }

  Widget _buildContent(double progress, int value, Color color) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor:
                    widget.backgroundColor ??
                    Theme.of(context).colorScheme.surfaceContainer,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            Text(
              value.toString(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
