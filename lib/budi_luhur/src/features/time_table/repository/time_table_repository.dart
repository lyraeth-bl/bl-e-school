import 'package:bl_e_school/budi_luhur/budi_luhur.dart';

/// A repository responsible for fetching timetable data from the API.
///
/// This class encapsulates the logic for interacting with the timetable endpoint,
/// handling data fetching, parsing, and error management.
class TimeTableRepository {
  /// Fetches a paginated list of timetable entries.
  ///
  /// This method sends a GET request to the [ApiEndpoints.timeTable] endpoint
  /// to retrieve timetable data. It supports pagination through the [kelas] parameter.
  ///
  /// - [kelas]: The class of student to fetch.
  ///
  /// Returns a [Future] that completes with a [TimeTableResponse] containing
  /// the list of [TimeTable] entries.
  ///
  /// Throws an [ApiException] if the API call fails, for example, due to
  /// network issues or a server-side error.
  Future<TimeTableResponse> fetchTimeTable({required String kelas}) async {
    String newKelas = kelas;

    if (newKelas.isNotEmpty && newKelas.endsWith("1")) {
      newKelas = newKelas.substring(0, newKelas.length - 1);
    }

    if (newKelas.startsWith("XANIMASI")) {
      newKelas = "XANI";
    }

    final Map<String, dynamic> queryParameters = {'kelas': newKelas};

    try {
      final response = await ApiClient.get(
        url: ApiEndpoints.timeTable,
        useAuthToken: false,
        queryParameters: queryParameters,
      );

      final timeTableList = (response['data'] as List)
          .map((e) => TimeTable.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return TimeTableResponse(
        status: response['status'],
        message: response['message'],
        listTimeTable: timeTableList,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
