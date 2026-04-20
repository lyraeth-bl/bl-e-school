import 'dart:async';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class RealtimeProgressTime extends StatefulWidget {
  final TimeTable timeTable;

  const RealtimeProgressTime({super.key, required this.timeTable});

  @override
  State<RealtimeProgressTime> createState() => _RealtimeProgressTimeState();
}

class _RealtimeProgressTimeState extends State<RealtimeProgressTime> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  late final jamMulaiToDateTime = Utils.timeStringToToday(
    widget.timeTable.jamMulai,
  );
  late final jamSelesaiToDateTime = Utils.timeStringToToday(
    widget.timeTable.jamSelesai,
  );
  final now = DateTime.now();

  late final isSameDay =
      widget.timeTable.hari.toLowerCase() ==
      Utils.formatNumberDaysToStringDays(now.weekday);

  late final isNow =
      isSameDay &&
      now.isAfter(jamMulaiToDateTime!) &&
      now.isBefore(jamSelesaiToDateTime!);

  final isWeekend =
      ((DateTime.now().weekday != (DateTime.saturday)) &&
      (DateTime.now().weekday != (DateTime.sunday)));

  late final lessonDay =
      Utils.weekDaysFullFormTranslated
          .map((e) => e.toLowerCase())
          .toList()
          .indexOf(widget.timeTable.hari.toLowerCase()) +
      1;

  late final isPastDay = lessonDay < now.weekday;
  late final isFutureDay = lessonDay > now.weekday;

  late final isBeforeLesson = isSameDay && now.isBefore(jamMulaiToDateTime!);
  late final isAfterLesson = isSameDay && now.isAfter(jamSelesaiToDateTime!);

  late final progress = Utils.calculateLessonProgress(
    start: jamMulaiToDateTime!,
    end: jamSelesaiToDateTime!,
    now: now,
  );

  late double progressValue;

  @override
  Widget build(BuildContext context) {
    if (lessonDay == 0) {
      progressValue = 0;
    }

    if (isPastDay) {
      // pelajaran hari kemarin
      progressValue = 1;
    } else if (isFutureDay) {
      // pelajaran besok
      progressValue = 0;
    } else if (isSameDay && isBeforeLesson) {
      // hari ini tapi belum mulai
      progressValue = 0;
    } else if (isSameDay && isAfterLesson) {
      // hari ini tapi sudah selesai
      progressValue = 1;
    } else if (isSameDay && isNow) {
      // sedang berlangsung
      progressValue = progress;
    } else {
      progressValue = 0;
    }

    return LinearProgressIndicator(
      value: progressValue,
      minHeight: 6,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      valueColor: AlwaysStoppedAnimation(
        Theme.of(context).colorScheme.primaryFixedDim,
      ),
      borderRadius: BorderRadius.circular(16),
    );
  }
}
