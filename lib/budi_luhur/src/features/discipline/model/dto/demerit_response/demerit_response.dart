import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'demerit_response.freezed.dart';
part 'demerit_response.g.dart';

@freezed
abstract class DemeritResponse with _$DemeritResponse {
  const factory DemeritResponse({
    required bool status,
    required DisciplineType type,
    required int total,
    required List<Demerit> disciplineList,
  }) = _DemeritResponse;

  factory DemeritResponse.fromJson(Map<String, dynamic> json) =>
      _$DemeritResponseFromJson(json);
}
