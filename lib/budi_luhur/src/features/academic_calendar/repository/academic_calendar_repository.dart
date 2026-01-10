import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

/// A repository responsible for fetching academic calendar data from the API.
class AcademicCalendarRepository {
  /// Fetches a custom academic calendar for a specific [unit], [month], and [year].
  ///
  /// This method makes a GET request to the API to retrieve academic calendar
  /// events based on the provided parameters. The response is then parsed into
  /// an [AcademicCalendarResponse] object.
  ///
  /// - Parameters:
  ///   - [unit]: The academic unit (e.g., faculty) to filter by.
  ///   - [month]: The month of the desired academic calendar.
  ///   - [year]: The year of the desired academic calendar.
  ///
  /// - Returns: A [Future] that resolves to an [AcademicCalendarResponse]
  ///   containing the list of academic events and pagination information.
  Future<Map<String, dynamic>> fetchCustomAcademicCalendar({
    required String unit,
    required int month,
    required int year,
  }) async {
    final response = await ApiClient.get(
      url: "${ApiEndpoints.academicCalendar}/$year/$month/$unit",
      useAuthToken: true,
    );

    final listAcademicCalendar = (response['data'] as List)
        .map((e) => AcademicCalendar.fromJson(e))
        .toList();

    return {"listAcademicCalendar": listAcademicCalendar};
  }
}
