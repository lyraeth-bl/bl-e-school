import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'merit_response.freezed.dart';
part 'merit_response.g.dart';

@freezed
abstract class MeritResponse with _$MeritResponse {
  const factory MeritResponse({
    required bool status,
    required DisciplineType type,
    required int total,
    required List<Merit> disciplineList,
  }) = _MeritResponse;

  factory MeritResponse.fromJson(Map<String, dynamic> json) =>
      _$MeritResponseFromJson(json);
}
