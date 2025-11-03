// AttendanceCharts.dart
import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AttendanceCharts extends StatefulWidget {
  /// map of status -> value (e.g. {'Hadir': 10, 'Sakit': 1, 'Izin': 2, 'Alpha': 0})
  final Map<String, double> data;

  /// optional order override (if you want consistent order)
  final List<String>? order;

  const AttendanceCharts({super.key, required this.data, this.order});

  @override
  State<AttendanceCharts> createState() => _AttendanceChartsState();
}

class _AttendanceChartsState extends State<AttendanceCharts> {
  int _touchedIndex = -1;
  Timer? _clearTouchTimer;

  @override
  void dispose() {
    _clearTouchTimer?.cancel();
    super.dispose();
  }

  void _handleTouchedIndex(int idx) {
    _clearTouchTimer?.cancel();
    setState(() => _touchedIndex = idx);

    _clearTouchTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _touchedIndex = -1);
    });
  }

  // default color mapping - uses theme where possible
  Color _colorForStatus(String status, ThemeData theme) {
    final scheme = theme.colorScheme;
    switch (status.toLowerCase()) {
      case 'hadir':
        return scheme.primaryContainer;
      case 'sakit':
        return Colors.orange;
      case 'izin':
        return Colors.amber;
      case 'alpha':
      case 'alpa':
      case 'absent':
        return scheme.errorContainer;
      default:
        return scheme.surfaceContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Build ordered list of entries
    final entries = <MapEntry<String, double>>[];
    if (widget.order != null) {
      for (final key in widget.order!) {
        if (widget.data.containsKey(key) && widget.data[key]! > 0) {
          entries.add(MapEntry(key, widget.data[key]!));
        }
      }
      // append leftovers not in order
      widget.data.forEach((k, v) {
        if ((widget.order ?? []).contains(k)) return;
        if (v > 0) entries.add(MapEntry(k, v));
      });
    } else {
      widget.data.forEach((k, v) {
        if (v > 0) entries.add(MapEntry(k, v));
      });
    }

    final total = entries.fold<double>(0, (p, e) => p + e.value);

    // layout params
    const double baseRadius = 70;
    const double touchedExtra = 14;

    // Create sections
    final sections = List<PieChartSectionData>.generate(entries.length, (i) {
      final label = entries[i].key;
      final value = entries[i].value;
      final percent = total == 0 ? 0.0 : (value / total) * 100;
      final isTouched = _touchedIndex == i;
      final color = _colorForStatus(label, theme);

      return PieChartSectionData(
        value: value,
        color: color,
        radius: baseRadius + (isTouched ? touchedExtra : 0),
        title: total == 0 ? '' : '${percent.toStringAsFixed(0)}%',
        titleStyle: TextStyle(
          fontSize: isTouched ? 18 : 14,
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.onPrimaryContainer,
        ),
        titlePositionPercentageOffset: 0.6,
        showTitle: true,
        borderSide: BorderSide.none,
      );
    });

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                sectionsSpace: 6,
                centerSpaceRadius: 60,
                pieTouchData: PieTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    if (response == null || response.touchedSection == null) {
                      return;
                    }
                    final touched =
                        response.touchedSection!.touchedSectionIndex;
                    _handleTouchedIndex(touched);
                  },
                ),
                sections: sections,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Legend + summary row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // legend column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(entries.length, (i) {
                      final label = entries[i].key;
                      final value = entries[i].value;
                      final percent = total == 0 ? 0.0 : (value / total) * 100;
                      final isHighlighted = _touchedIndex == i;
                      final color = _colorForStatus(label, theme);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              width: isHighlighted ? 18 : 14,
                              height: isHighlighted ? 18 : 14,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: isHighlighted
                                    ? [
                                        BoxShadow(
                                          color: color.withValues(alpha: 0.32),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                label,
                                style: theme.textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${value.toInt()}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${percent.toStringAsFixed(0)}%',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

                // summary column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Total', style: theme.textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(
                        '${total.toInt()} hari',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        total == 0
                            ? 'Belum ada data'
                            : 'Kehadiran: ${((widget.data['Hadir'] ?? 0) / (total == 0 ? 1 : total) * 100).toStringAsFixed(1)}%',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
