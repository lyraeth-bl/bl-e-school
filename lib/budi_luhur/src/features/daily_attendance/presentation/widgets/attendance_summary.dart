import 'package:flutter/material.dart';

class AttendanceSummary extends StatelessWidget {
  const AttendanceSummary({
    super.key,
    required this.absent,
    required this.hadir,
  });

  final int hadir;
  final int absent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statCard(
          context,
          'Hadir',
          hadir.toString(),
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          textColor: Theme.of(context).colorScheme.primary,
        ),
        _statCard(
          context,
          'Alpha',
          absent.toString(),
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
          textColor: Theme.of(context).colorScheme.error,
        ),
        _statCard(
          context,
          'Total',
          (hadir + absent).toString(),
          color: Theme.of(context).colorScheme.surfaceContainer,
          textColor: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value, {
    required Color color,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: textColor),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
