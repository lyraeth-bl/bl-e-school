import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

abstract class TimeTableRepository {
  Future<Result<TimeTableResponse>> fetchTimeTable({required String kelas});

  List<TimeTable>? getStoredTimeTable();

  Future<Unit> storeTimeTable(List<TimeTable> listTimeTable);
}
