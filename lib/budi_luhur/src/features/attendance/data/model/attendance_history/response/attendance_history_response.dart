import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_history_response.freezed.dart';
part 'attendance_history_response.g.dart';

@freezed
abstract class AttendanceHistoryResponse with _$AttendanceHistoryResponse {
  const factory AttendanceHistoryResponse({
    int? currentPage,
    required List<AttendanceHistory> listAttendance,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    List<Links>? links,
    String? nextPageUrl,
    String? path,
    int? perPage,
    String? prevPageUrl,
    int? to,
    int? total,
  }) = _AttendanceHistoryResponse;

  factory AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceHistoryResponseFromJson(json);
}
