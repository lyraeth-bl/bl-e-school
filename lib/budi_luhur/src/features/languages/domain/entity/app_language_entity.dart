import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_language_entity.freezed.dart';

@freezed
abstract class AppLanguageEntity with _$AppLanguageEntity {
  const factory AppLanguageEntity({
    /// Name of the Languages.
    /// ex: Indonesian, English.
    required String languageName,

    /// Code of the Languages.
    /// ex: "id", "en".
    required String languageCode,
  }) = _AppLanguageEntity;
}
