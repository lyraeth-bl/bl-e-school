import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

abstract class TimeTableLocalDataSource {
  List<TimeTable>? getStoredTimeTable();

  Future<Unit> storeTimeTable(List<TimeTable> listTimeTable);
}

class TimeTableLocalDataSourceImpl implements TimeTableLocalDataSource {
  @override
  List<TimeTable>? getStoredTimeTable() {
    final raw = Hive.box(sessionsBoxKey).get(sessionsListTimeTableKey);

    if (raw == null) return null;

    final list = (raw as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return list.map((e) => TimeTable.fromJson(e)).toList();
  }

  @override
  Future<Unit> storeTimeTable(List<TimeTable> listTimeTable) async {
    final jsonList = listTimeTable.map((e) => e.toJson()).toList();

    await Hive.box(sessionsBoxKey).put(sessionsListTimeTableKey, jsonList);

    return unit;
  }
}
