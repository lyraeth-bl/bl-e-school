import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_calendar.freezed.dart';
part 'academic_calendar.g.dart';

@freezed
abstract class AcademicCalendar with _$AcademicCalendar {
  const factory AcademicCalendar({
    required int id,
    required String judul,
    required String unit,
    @JsonKey(name: 'tanggal_mulai') required String tanggalMulai,
    @JsonKey(name: 'tanggal_selesai') required String tanggalSelesai,
    required String keterangan,
  }) = _AcademicCalendar;

  factory AcademicCalendar.fromJson(Map<String, dynamic> json) =>
      _$AcademicCalendarFromJson(json);
}
