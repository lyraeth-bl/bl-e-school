import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_table_response.freezed.dart';
part 'time_table_response.g.dart';

@freezed
abstract class TimeTableResponse with _$TimeTableResponse {
  const factory TimeTableResponse({
    @JsonKey(name: "status") required bool status,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "data") required List<TimeTable> listTimeTable,
  }) = _TimeTableResponse;

  factory TimeTableResponse.fromJson(Map<String, dynamic> json) =>
      _$TimeTableResponseFromJson(json);
}
