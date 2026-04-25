import '../../../features/languages/domain/entity/app_language_entity.dart';

/// Default languages of the App
const String defaultLanguageCode = "en";

/// Languages List
/// add languages code to the list after ut app support new languages
/// visit this to find languageCode for your respective language
/// https://developers.google.com/admin-sdk/directory/v1/languages
const List<AppLanguageEntity> appLanguages = [
  AppLanguageEntity(languageName: "English", languageCode: "en"),
  AppLanguageEntity(languageName: "Indonesia", languageCode: "id"),
];
