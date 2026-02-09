import 'package:freezed_annotation/freezed_annotation.dart';

part 'discipline_params.freezed.dart';
part 'discipline_params.g.dart';

@freezed
abstract class DisciplineParams with _$DisciplineParams {
  const factory DisciplineParams({
    required String nis,
    String? schoolSession,
    String? semester,
  }) = _DisciplineParams;

  factory DisciplineParams.fromJson(Map<String, dynamic> json) =>
      _$DisciplineParamsFromJson(json);
}
