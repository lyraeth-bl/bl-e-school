import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_calendar_response.freezed.dart';
part 'academic_calendar_response.g.dart';

@freezed
abstract class AcademicCalendarResponse with _$AcademicCalendarResponse {
  const factory AcademicCalendarResponse({
    required bool error,
    required String message,
    @JsonKey(name: "data") required List<AcademicCalendar> listAcademicCalendar,
  }) = _AcademicCalendarResponse;

  factory AcademicCalendarResponse.fromJson(Map<String, dynamic> json) =>
      _$AcademicCalendarResponseFromJson(json);
}
