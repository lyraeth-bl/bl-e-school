import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_calendar.freezed.dart';
part 'academic_calendar.g.dart';

/// A data model that represents an academic calendar event.
@freezed
abstract class AcademicCalendar with _$AcademicCalendar {
  /// Creates an instance of [AcademicCalendar].
  const factory AcademicCalendar({
    /// The unique identifier for the academic calendar event.
    required int id,

    /// The title of the academic calendar event.
    required String judul,

    /// The academic unit or faculty associated with the event.
    required String unit,

    /// The start date of the event.
    @JsonKey(name: 'tanggal_mulai') required String tanggalMulai,

    /// The end date of the event.
    @JsonKey(name: 'tanggal_selesai') required String tanggalSelesai,

    /// A description or additional details about the event.
    required String keterangan,
  }) = _AcademicCalendar;

  /// Creates an [AcademicCalendar] instance from a JSON object.
  factory AcademicCalendar.fromJson(Map<String, dynamic> json) =>
      _$AcademicCalendarFromJson(json);
}
