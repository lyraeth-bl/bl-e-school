import 'package:freezed_annotation/freezed_annotation.dart';

import '../demerit/demerit.dart';
import '../discipline_type.dart';

part 'demerit_response.freezed.dart';
part 'demerit_response.g.dart';

@freezed
abstract class DemeritResponse with _$DemeritResponse {
  const factory DemeritResponse({
    required bool status,
    required DisciplineType type,
    required int total,
    @JsonKey(name: "data") List<Demerit>? disciplineList,
  }) = _DemeritResponse;

  factory DemeritResponse.fromJson(Map<String, dynamic> json) =>
      _$DemeritResponseFromJson(json);
}
