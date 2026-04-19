import 'package:freezed_annotation/freezed_annotation.dart';

import '../extracurricular/extracurricular.dart';

part 'extracurricular_response.freezed.dart';
part 'extracurricular_response.g.dart';

@freezed
abstract class ExtracurricularResponse with _$ExtracurricularResponse {
  const factory ExtracurricularResponse({
    required bool error,
    required String message,
    @JsonKey(name: "data") required List<Extracurricular> listExtracurricular,
  }) = _ExtracurricularResponse;

  factory ExtracurricularResponse.fromJson(Map<String, dynamic> json) =>
      _$ExtracurricularResponseFromJson(json);
}
