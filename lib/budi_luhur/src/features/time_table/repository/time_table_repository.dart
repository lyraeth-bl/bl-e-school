import 'package:fpdart/fpdart.dart';

import '../../../utils/shared/types/types.dart';
import '../data/model/time_table/time_table.dart';
import '../data/model/time_table_response/time_table_response.dart';

abstract class TimeTableRepository {
  Future<Result<TimeTableResponse>> fetchTimeTable({required String kelas});

  List<TimeTable>? getStoredTimeTable();

  Future<Unit> storeTimeTable(List<TimeTable> listTimeTable);
}
