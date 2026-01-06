import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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

  bool _isTimeInRange(DateTime now, int sh, int sm, int eh, int em) {
    final from = DateTime(now.year, now.month, now.day, sh, sm);
    final to = DateTime(now.year, now.month, now.day, eh, em);
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
    return _isTimeInRange(now, 15, 30, 23, 59);
  }

  bool get _isBreakMorning {
    final now = _now ?? DateTime.now();
    return _isTimeInRange(now, 10, 0, 10, 30);
  }

  bool get _isBreakAfternoon {
    final now = _now ?? DateTime.now();
    return _isTimeInRange(now, 12, 45, 13, 30);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(BudiLuhurRoutes.studentTimeTable),
      child: Card(
        elevation: 3,
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header clock
            Container(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 8,
              ),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RealTimeClock(
                      onTick: _handleTick,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            BlocBuilder<TimeTableCubit, TimeTableState>(
              builder: (context, state) {
                return state.maybeWhen(
                  success: (timeTableList) {
                    final now = _now ?? DateTime.now();
                    final todayStr = Utils.formatNumberDaysToStringDays(
                      now.weekday,
                    ).toLowerCase();

                    // ======== WEEKEND ========
                    if (_isWeekend) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/animations/beach.json',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 16),
                              Text(
                                Utils.getTranslatedLabel(
                                  weekendScheduleTextKey,
                                ),
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // ======== AFTER SCHOOL ========
                    if (_isAfterSchool) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.school),
                            SizedBox(width: 16),
                            Text(
                              Utils.getTranslatedLabel(thatAllForTodayKey),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      );
                    }

                    // ======== BREAK (no next class) ========
                    if (_isBreakMorning || _isBreakAfternoon) {
                      final start = _isBreakMorning
                          ? DateTime(now.year, now.month, now.day, 10, 0)
                          : DateTime(now.year, now.month, now.day, 12, 45);
                      final end = _isBreakMorning
                          ? DateTime(now.year, now.month, now.day, 10, 30)
                          : DateTime(now.year, now.month, now.day, 13, 30);

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/animations/break.json',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  Utils.getTranslatedLabel(breakKey),
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer, size: 16),
                                    SizedBox(width: 6),
                                    Text(
                                      "${Utils.formatTime(start)} - ${Utils.formatTime(end)}",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }

                    // ======== CURRENT PERIOD ========
                    final period = _periodLabel.isNotEmpty
                        ? _periodLabel.substring(0, 1)
                        : "";
                    final isNum = RegExp(r'^\d+$').hasMatch(period);

                    final current = isNum
                        ? timeTableList
                              .where(
                                (e) =>
                                    e.jamKe == period &&
                                    e.hari.toLowerCase() == todayStr,
                              )
                              .toList()
                        : <dynamic>[];

                    if (current.isNotEmpty) {
                      final tt = current.first;

                      String takeOnlyTwoOnName = "-";

                      if (tt.namaGuru.trim().isNotEmpty) {
                        takeOnlyTwoOnName = tt.namaGuru
                            .split(' ')
                            .take(2)
                            .join(' ');
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.timer),
                                  SizedBox(width: 8),
                                  Text(
                                    Utils.getTranslatedLabel(timeKey),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              Text(
                                "${Utils.formatTime(Utils.timeStringToToday(tt.jamMulai)!)} - ${Utils.formatTime(Utils.timeStringToToday(tt.jamSelesai)!)}",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.book),
                                      SizedBox(width: 8),
                                      Text(
                                        Utils.getTranslatedLabel(subjectsKey),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    tt.kodeMataPelajaran,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        Utils.getTranslatedLabel(teachersKey),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    takeOnlyTwoOnName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // ======== NEXT CLASS (only if NOT break) ========
                    final upcoming = timeTableList.where((e) {
                      if (e.hari.toLowerCase() != todayStr) return false;
                      final dt = Utils.timeStringToToday(e.jamMulai);
                      return dt != null && dt.isAfter(now);
                    }).toList();

                    if (upcoming.isNotEmpty) {
                      upcoming.sort((a, b) {
                        final aDt = Utils.timeStringToToday(a.jamMulai)!;
                        final bDt = Utils.timeStringToToday(b.jamMulai)!;
                        return aDt.compareTo(bDt);
                      });

                      final next = upcoming.first;

                      String takeOnlyTwoOnName = "-";

                      if (next.namaGuru.trim().isNotEmpty) {
                        takeOnlyTwoOnName = next.namaGuru
                            .split(' ')
                            .take(2)
                            .join(' ');
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.timer),
                                  SizedBox(width: 8),
                                  Text(
                                    Utils.getTranslatedLabel(timeKey),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              Text(
                                "${Utils.formatTime(Utils.timeStringToToday(next.jamMulai)!)} - ${Utils.formatTime(Utils.timeStringToToday(next.jamSelesai)!)}",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.book),
                                      SizedBox(width: 8),
                                      Text(
                                        Utils.getTranslatedLabel(nextClassKey),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    next.kodeMataPelajaran,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        Utils.getTranslatedLabel(teachersKey),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    takeOnlyTwoOnName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // ======== NO MORE SCHEDULE TODAY ========
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.free_breakfast),
                          SizedBox(width: 16),
                          Text(
                            Utils.getTranslatedLabel(noMoreScheduleTodayKey),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                  orElse: () => Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.free_breakfast),
                        SizedBox(width: 16),
                        Text(
                          Utils.getTranslatedLabel(noMoreScheduleTodayKey),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
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
