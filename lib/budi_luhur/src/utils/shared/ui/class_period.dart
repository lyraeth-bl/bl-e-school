class Period {
  final int index;
  final String label;
  final DateTime start;
  final DateTime end;

  Period({
    required this.index,
    required this.label,
    required this.start,
    required this.end,
  });

  @override
  String toString() => '$label: ${_time(start)} - ${_time(end)}';

  static String _time(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

String ordinal(int n) {
  if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
  switch (n % 10) {
    case 1:
      return '${n}st';
    case 2:
      return '${n}nd';
    case 3:
      return '${n}rd';
    default:
      return '${n}th';
  }
}

List<Period> generatePeriods({
  DateTime? dayRef,
  int startHour = 7,
  int startMinute = 0,
  int periodMinutes = 45,
  DateTime? break1Start,
  DateTime? break1End,
  DateTime? break2Start,
  DateTime? break2End,
  DateTime? schoolEnd,
}) {
  final ref = dayRef ?? DateTime(2000, 1, 1);
  final periodLen = Duration(minutes: periodMinutes);

  DateTime mk(int h, int m) => DateTime(ref.year, ref.month, ref.day, h, m);

  final b1s = break1Start ?? mk(10, 0);
  final b1e = break1End ?? mk(10, 30);
  final b2s = break2Start ?? mk(12, 45);
  final b2e = break2End ?? mk(13, 30);
  final end = schoolEnd ?? mk(15, 30);
  DateTime cur = mk(startHour, startMinute);

  final List<Period> out = [];
  int idx = 1;

  while (cur.isBefore(end)) {
    if (!cur.isBefore(b1s) && cur.isBefore(b1e)) {
      cur = b1e;
      continue;
    }
    if (!cur.isBefore(b2s) && cur.isBefore(b2e)) {
      cur = b2e;
      continue;
    }

    DateTime candidateEnd = cur.add(periodLen);

    if (cur.isBefore(b1s) && candidateEnd.isAfter(b1s)) {
      candidateEnd = b1s;
    }
    if (cur.isBefore(b2s) && candidateEnd.isAfter(b2s)) {
      candidateEnd = b2s;
    }

    if (candidateEnd.isAfter(end)) candidateEnd = end;

    out.add(
      Period(
        index: idx,
        label: '${ordinal(idx)} Period',
        start: cur,
        end: candidateEnd,
      ),
    );

    idx += 1;
    cur = candidateEnd;

    if (cur.isAtSameMomentAs(b1s)) cur = b1e;
    if (cur.isAtSameMomentAs(b2s)) cur = b2e;

    if (out.length > 100) break;
  }

  return out;
}

String getPeriodFromTime(DateTime now, {DateTime? dayRef}) {
  final ref = dayRef ?? DateTime(2000, 1, 1);
  DateTime mk(int h, int m) => DateTime(ref.year, ref.month, ref.day, h, m);
  final b1s = mk(10, 0), b1e = mk(10, 30);
  final b2s = mk(12, 45), b2e = mk(13, 30);
  final end = mk(15, 30);
  final start = mk(7, 0);

  final nowRef = DateTime(
    ref.year,
    ref.month,
    ref.day,
    now.hour,
    now.minute,
    now.second,
  );

  if (nowRef.isBefore(start) || !nowRef.isBefore(end)) {
    return 'Outside school hours';
  }
  if (!nowRef.isBefore(b1e) && nowRef.isBefore(b2s)) {}
  if (!nowRef.isBefore(b1s) && nowRef.isBefore(b1e)) {
    return 'Break 1 (10:00 - 10:30)';
  }
  if (!nowRef.isBefore(b2s) && nowRef.isBefore(b2e)) {
    return 'Break 2 (12:45 - 13:30)';
  }

  final periods = generatePeriods(
    dayRef: ref,
    schoolEnd: end,
    break1Start: b1s,
    break1End: b1e,
    break2Start: b2s,
    break2End: b2e,
  );

  for (final p in periods) {
    if ((nowRef.isAtSameMomentAs(p.start) || nowRef.isAfter(p.start)) &&
        nowRef.isBefore(p.end)) {
      return p.label;
    }
  }

  return 'Between periods / transition';
}
