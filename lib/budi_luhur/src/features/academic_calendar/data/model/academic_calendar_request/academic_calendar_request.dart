import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_calendar_request.freezed.dart';
part 'academic_calendar_request.g.dart';

@freezed
abstract class AcademicCalendarRequest with _$AcademicCalendarRequest {
  const factory AcademicCalendarRequest({
    required int year,
    required int month,
    required String unit,
  }) = _AcademicCalendarRequest;

  factory AcademicCalendarRequest.fromJson(Map<String, dynamic> json) =>
      _$AcademicCalendarRequestFromJson(json);
}
