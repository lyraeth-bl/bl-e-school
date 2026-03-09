import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

abstract class AcademicCalendarLocalDataSource {
  List<AcademicCalendar>? getStoredMonthlyAcademic({
    required int year,
    required int month,
  });

  Future<Unit> saveStoredMonthlyAcademic(
    List<AcademicCalendar> list, {
    required int year,
    required int month,
  });

  DateTime? getMonthlyLastUpdated();

  Future<Unit> saveMonthlyLastUpdated(DateTime time);
}

class AcademicCalendarLocalDataSourceImpl
    implements AcademicCalendarLocalDataSource {
  @override
  List<AcademicCalendar>? getStoredMonthlyAcademic({
    required int year,
    required int month,
  }) {
    final cachedYear =
        Hive.box(sessionsBoxKey).get(sessionsMonthlyAcademicYearKey) as int?;
    final cachedMonth =
        Hive.box(sessionsBoxKey).get(sessionsMonthlyAcademicMonthKey) as int?;

    if (cachedYear != year || cachedMonth != month) return null;

    final raw = Hive.box(sessionsBoxKey).get(sessionsListMonthlyAcademicKey);
    if (raw == null) return null;
    return (raw as List)
        .map((e) => AcademicCalendar.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<Unit> saveStoredMonthlyAcademic(
    List<AcademicCalendar> list, {
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
    final raw = Hive.box(
      sessionsBoxKey,
    ).get(sessionsMonthlyAcademicLastUpdatedKey);

    if (raw == null) return null;

    return DateTime.tryParse(raw as String);
  }

  @override
  Future<Unit> saveMonthlyLastUpdated(DateTime time) async {
    await Hive.box(
      sessionsBoxKey,
    ).put(sessionsMonthlyAcademicLastUpdatedKey, time.toIso8601String());

    return unit;
  }
}
