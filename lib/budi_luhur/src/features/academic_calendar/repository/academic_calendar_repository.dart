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
  Future<AcademicCalendarResponse> fetchCustomAcademicCalendar({
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

    final listLinks = (response['links'] as List)
        .map((e) => Links.fromJson(e))
        .toList();

    return AcademicCalendarResponse(
      currentPage: response['current_page'],
      listAcademicCalendar: listAcademicCalendar,
      total: response['total'],
      path: response['path'],
      firstPageUrl: response['first_page_url'],
      from: response['from'],
      lastPage: response['last_page'],
      lastPageUrl: response['last_page_url'],
      links: listLinks,
      nextPageUrl: response['next_page_url'],
      perPage: response['per_page'],
      prevPageUrl: response['prev_page_url'],
      to: response['to'],
    );
  }
}
