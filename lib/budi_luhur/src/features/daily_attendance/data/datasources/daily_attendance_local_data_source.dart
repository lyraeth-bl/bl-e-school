import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

import '../../../../core/storage/hive_box_keys/hive_box_keys.dart';
import '../model/daily_attendance/daily_attendance.dart';

abstract class DailyAttendanceLocalDataSource {
  DailyAttendance? getStoredTodayAttendance();

  Future<Unit> saveStoredTodayAttendance(DailyAttendance dailyAttendance);

  List<DailyAttendance>? getStoredMonthlyAttendance({
    required int year,
    required int month,
  });

  Future<Unit> saveStoredMonthlyAttendance(
    List<DailyAttendance> list, {
    required int year,
    required int month,
  });

  DateTime? getMonthlyLastUpdated();

  Future<Unit> saveMonthlyLastUpdated(DateTime time);
}

class DailyAttendanceLocalDataSourceImpl
    implements DailyAttendanceLocalDataSource {
  @override
  DailyAttendance? getStoredTodayAttendance() {
    final raw = Hive.box(sessionsBoxKey).get(sessionsTodayAttendanceKey);

    if (raw == null) return null;

    return DailyAttendance.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<Unit> saveStoredTodayAttendance(
    DailyAttendance dailyAttendance,
  ) async {
    await Hive.box(
      sessionsBoxKey,
    ).put(sessionsTodayAttendanceKey, dailyAttendance.toJson());

    return unit;
  }

  @override
  List<DailyAttendance>? getStoredMonthlyAttendance({
    required int year,
    required int month,
  }) {
    final cachedYear =
        Hive.box(sessionsBoxKey).get(sessionsMonthlyAttendanceYearKey) as int?;
    final cachedMonth =
        Hive.box(sessionsBoxKey).get(sessionsMonthlyAttendanceMonthKey) as int?;

    if (cachedYear != year || cachedMonth != month) return null;

    final raw = Hive.box(sessionsBoxKey).get(sessionsListMonthlyAttendanceKey);
    if (raw == null) return null;
    return (raw as List)
        .map((e) => DailyAttendance.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<Unit> saveStoredMonthlyAttendance(
    List<DailyAttendance> list, {
    required int year,
    required int month,
  }) async {
    await Future.wait([
      Hive.box(sessionsBoxKey).put(
        sessionsListMonthlyAttendanceKey,
        list.map((e) => e.toJson()).toList(),
      ),
      Hive.box(sessionsBoxKey).put(sessionsMonthlyAttendanceYearKey, year),
      Hive.box(sessionsBoxKey).put(sessionsMonthlyAttendanceMonthKey, month),
    ]);
    return unit;
  }

  @override
  DateTime? getMonthlyLastUpdated() {
    final raw = Hive.box(sessionsBoxKey).get(sessionsMonthlyLastUpdatedKey);

    if (raw == null) return null;

    return DateTime.tryParse(raw as String);
  }

  @override
  Future<Unit> saveMonthlyLastUpdated(DateTime time) async {
    await Hive.box(
      sessionsBoxKey,
    ).put(sessionsMonthlyLastUpdatedKey, time.toIso8601String());

    return unit;
  }
}
