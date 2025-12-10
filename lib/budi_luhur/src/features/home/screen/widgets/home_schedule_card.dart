import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

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
    } else {
      _now = now;
    }
  }

  bool _isTimeInRange(
    DateTime now,
    int startH,
    int startM,
    int endH,
    int endM,
  ) {
    final from = DateTime(now.year, now.month, now.day, startH, startM);
    final to = DateTime(now.year, now.month, now.day, endH, endM);
    return now.isAtSameMomentAs(from) ||
        (now.isAfter(from) && now.isBefore(to)) ||
        now.isAtSameMomentAs(to);
  }

  bool get _isWeekend {
    final now = _now ?? DateTime.now();
    return now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
  }

  bool get _isAfterSchool {
    final now = _now ?? DateTime.now();
    // After or at 15:30
    return _isTimeInRange(now, 15, 30, 23, 59);
  }

  bool get _isBreakMorning {
    final now = _now ?? DateTime.now();
    // 10:00 - 10:30
    return _isTimeInRange(now, 10, 0, 10, 30);
  }

  bool get _isBreakAfternoon {
    final now = _now ?? DateTime.now();
    // 12:45 - 13:30
    return _isTimeInRange(now, 12, 45, 13, 30);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(BudiLuhurRoutes.studentTimeTable);
      },
      child: Card(
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
                      fontWeight: FontWeight.w700,
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
                    final now = _now ?? DateTime.now();

                    // Weekend view
                    if (_isWeekend) {
                      return ListTile(
                        leading: Icon(
                          Icons.beach_access,
                          color: Colors.purple,
                          size: 20,
                        ),
                        title: Text(
                          Utils.getTranslatedLabel(weekendScheduleTextKey),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        subtitle: SizedBox.shrink(),
                      );
                    }

                    // After school view
                    if (_isAfterSchool) {
                      return ListTile(
                        leading: Icon(
                          Icons.school,
                          color: Colors.black54,
                          size: 20,
                        ),
                        title: Text(
                          Utils.getTranslatedLabel(thatAllForTodayKey),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        subtitle: SizedBox.shrink(),
                      );
                    }

                    // Break windows: show Break only (no next class)
                    if (_isBreakMorning || _isBreakAfternoon) {
                      final start = _isBreakMorning
                          ? DateTime(now.year, now.month, now.day, 10, 0)
                          : DateTime(now.year, now.month, now.day, 12, 45);
                      final end = _isBreakMorning
                          ? DateTime(now.year, now.month, now.day, 10, 30)
                          : DateTime(now.year, now.month, now.day, 13, 30);

                      return ListTile(
                        leading: Icon(
                          Icons.free_breakfast,
                          color: Colors.orange,
                          size: 20,
                        ),
                        title: Text(
                          Utils.getTranslatedLabel(breakKey),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.timer, size: 16, color: Colors.red),
                              SizedBox(width: 6),
                              Text(
                                "${Utils.formatTime(start)} - ${Utils.formatTime(end)}",
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final rawPeriod = _periodLabel.isNotEmpty
                        ? _periodLabel.substring(0, 1)
                        : '';
                    final isNumericPeriod = RegExp(
                      r'^\d+\$',
                    ).hasMatch(rawPeriod);

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
                                    fontWeight: FontWeight.w700,
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
                                Utils.getPeriodString(
                                  _periodLabel.toLowerCase(),
                                ),
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
                                Expanded(
                                  child: Text(
                                    timeTimeTable.namaMataPelajaran,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    timeTimeTable.namaGuru ?? '-',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      );
                    }

                    // Find next classes for today
                    final upcoming = timeTableList.where((e) {
                      final hariMatch = e.hari.toLowerCase() == todayStr;
                      if (!hariMatch) return false;
                      final jamMulaiDt = Utils.timeStringToToday(e.jamMulai);
                      return jamMulaiDt != null && jamMulaiDt.isAfter(now);
                    }).toList();

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
                            Expanded(
                              child: Text(
                                "${Utils.getTranslatedLabel(breakKey)} - ${Utils.getTranslatedLabel(nextClassKey)} : ${next.namaMataPelajaran}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontWeight: FontWeight.w700,
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
                                Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    next.namaGuru,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      );
                    }

                    // Default fallback: no more schedule today
                    return ListTile(
                      leading: Icon(
                        Icons.free_breakfast,
                        size: 16,
                        color: Colors.grey,
                      ),
                      title: Text(
                        Utils.getTranslatedLabel(noMoreScheduleTodayKey),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: SizedBox.shrink(),
                    );
                  },
                  orElse: () => Center(
                    child: Text(Utils.getTranslatedLabel(noMoreScheduleKey)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
