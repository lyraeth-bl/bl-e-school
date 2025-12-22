import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

class AppConfigurationRepository {
  Future<AppConfigurationDTO> fetchAppConfiguration() async {
    try {
      final response = await ApiClient.get(
        url: ApiEndpoints.appConfiguration,
        useAuthToken: true,
      );

      final data = response['data'];

      final List<AppConfiguration> convertDataToApp = (data as List)
          .map((e) => AppConfiguration.fromJson(e))
          .toList();

      final AppConfiguration appConfigurationFirst = convertDataToApp.first;

      return AppConfigurationDTO(appConfiguration: appConfigurationFirst);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
