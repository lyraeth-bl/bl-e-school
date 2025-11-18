import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScheduleCard extends StatefulWidget {
  const HomeScheduleCard({super.key});

  @override
  State<HomeScheduleCard> createState() => _HomeScheduleCardState();
}

class _HomeScheduleCardState extends State<HomeScheduleCard> {
  DateTime? _now;
  String _periodLabel = '';

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _periodLabel = getPeriodFromTime(_now!);
  }

  void _handleTick(DateTime now) {
    final newLabel = getPeriodFromTime(now);
    if (newLabel != _periodLabel) {
      setState(() {
        _now = now;
        _periodLabel = newLabel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Utils.getTranslatedLabel(scheduleKey),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RealTimeClock(onTick: _handleTick),
              ],
            ),
          ),

          Divider(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withValues(alpha: 0.5),
            indent: 16,
            endIndent: 16,
          ),

          BlocBuilder<TimeTableCubit, TimeTableState>(
            builder: (context, state) {
              return state.maybeWhen(
                success: (timeTableList) {
                  final now = DateTime.now();

                  final rawPeriod = _periodLabel.isNotEmpty
                      ? _periodLabel.substring(0, 1)
                      : '';
                  final isNumericPeriod = RegExp(r'^\d+$').hasMatch(rawPeriod);

                  final todayStr = Utils.formatNumberDaysToStringDays(
                    now.weekday,
                  ).toLowerCase();

                  final currentMatches = isNumericPeriod
                      ? timeTableList
                            .where(
                              (e) =>
                                  e.jamKe == rawPeriod &&
                                  e.hari.toLowerCase() == todayStr,
                            )
                            .toList()
                      : <dynamic>[];

                  if (currentMatches.isNotEmpty) {
                    final timeTimeTable = currentMatches.first;
                    return ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: Colors.red),
                          SizedBox(width: 4),
                          Text(
                            "${Utils.formatTime(Utils.timeStringToToday(timeTimeTable.jamMulai)!)} - ${Utils.formatTime(Utils.timeStringToToday(timeTimeTable.jamSelesai)!)}",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              Utils.getPeriodString(_periodLabel.toLowerCase()),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onTertiaryContainer,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.book, size: 16, color: Colors.green),
                              SizedBox(width: 4),
                              Text(timeTimeTable.namaMataPelajaran),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.person, size: 16, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(timeTimeTable.namaGuru),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    );
                  }

                  final upcoming = timeTableList
                      .where(
                        (e) =>
                            e.hari.toLowerCase() == todayStr &&
                            (() {
                              final jamMulaiDt = Utils.timeStringToToday(
                                e.jamMulai,
                              );
                              return jamMulaiDt != null &&
                                  jamMulaiDt.isAfter(now);
                            })(),
                      )
                      .toList();

                  if (upcoming.isNotEmpty) {
                    upcoming.sort((a, b) {
                      final aDt = Utils.timeStringToToday(a.jamMulai)!;
                      final bDt = Utils.timeStringToToday(b.jamMulai)!;
                      return aDt.compareTo(bDt);
                    });
                    final next = upcoming.first;
                    return ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.coffee, size: 16, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            "${Utils.getTranslatedLabel(breakKey)} - ${Utils.getTranslatedLabel(nextClassKey)} : ${next.namaMataPelajaran}",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.timer, size: 16, color: Colors.red),
                              SizedBox(width: 4),
                              Text(
                                "${Utils.formatTime(Utils.timeStringToToday(next.jamMulai)!)} - ${Utils.formatTime(Utils.timeStringToToday(next.jamSelesai)!)}",
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.person, size: 16, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(next.namaGuru),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    );
                  }

                  // Tidak ada jadwal lagi hari ini
                  return ListTile(
                    title: Row(
                      children: [
                        Icon(
                          Icons.free_breakfast,
                          size: 16,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Istirahat / Tidak ada jadwal",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    subtitle: SizedBox.shrink(),
                  );
                },
                orElse: () => Center(child: Text("Tidak ada jadwal")),
              );
            },
          ),
        ],
      ),
    );
  }
}
