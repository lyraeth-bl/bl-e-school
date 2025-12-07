import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A repository for handling attendance-related data.
///
/// This class provides methods for interacting with both local storage (Hive)
/// and a remote API to manage student attendance information.
class AttendanceRepository {
  /// Retrieves the stored daily attendance data from local storage.
  ///
  /// This method retrieves the daily attendance information from the Hive box.
  /// If no data is found, it returns a [DailyAttendance] object with default values.
  ///
  /// Returns a [DailyAttendance] object.
  DailyAttendance getStoredDailyAttendance() {
    return DailyAttendance.fromJson(
      Map.from(Hive.box(attendanceBoxKey).get(studentDailyAttendanceKey) ?? {}),
    );
  }

  /// Stores the daily attendance data in local storage.
  ///
  /// Takes a [DailyAttendance] object and saves it to the Hive box.
  /// This is useful for caching attendance data locally.
  Future<void> setStoredDailyAttendance(DailyAttendance dailyAttendance) {
    return Hive.box(
      attendanceBoxKey,
    ).put(studentDailyAttendanceKey, dailyAttendance.toJson());
  }

  Future<void> clearStoredDailyAttendanceData() =>
      Hive.box(attendanceBoxKey).clear();

  /// Checks if the daily attendance has been posted.
  ///
  /// Returns `true` if the attendance has been posted, otherwise `false`.
  /// This is determined by checking a flag in the Hive box.
  bool getHasPostDailyAttendance() {
    return Hive.box(attendanceBoxKey).get(studentHasPostDailyAttendanceKey) ??
        false;
  }

  /// Sets the flag indicating whether the daily attendance has been posted.
  ///
  /// Takes a boolean [value] to be stored in the Hive box.
  /// This is used to track whether the initial attendance for the day has been submitted.
  Future<void> setHasPostDailyAttendance(bool value) {
    return Hive.box(
      attendanceBoxKey,
    ).put(studentHasPostDailyAttendanceKey, value);
  }

  /// Checks if the user has checked in.
  ///
  /// Returns `true` if the user has checked in, otherwise `false`.
  /// This is determined by checking a flag in the Hive box.
  bool getHasCheckIn() {
    return Hive.box(attendanceBoxKey).get(studentHasCheckInKey) ?? false;
  }

  /// Sets the flag indicating whether the user has checked in.
  ///
  /// Takes a boolean [value] to be stored in the Hive box.
  /// This is used to track the check-in status for the day.
  Future<void> setHasCheckIn(bool value) {
    return Hive.box(attendanceBoxKey).put(studentHasCheckInKey, value);
  }

  /// Checks if the user has checked out.
  ///
  /// Returns `true` if the user has checked out, otherwise `false`.
  /// This is determined by checking a flag in the Hive box.
  bool getHasCheckOut() {
    return Hive.box(attendanceBoxKey).get(studentHasCheckOutKey) ?? false;
  }

  /// Sets the flag indicating whether the user has checked out.
  ///
  /// Takes a boolean [value] to be stored in the Hive box.
  /// This is used to track the check-out status for the day.
  Future<void> setHasCheckOut(bool value) {
    return Hive.box(attendanceBoxKey).put(studentHasCheckOutKey, value);
  }

  /// Fetches the daily attendance for a user for the current day from the API.
  ///
  /// Requires the student's [nis] (Nomor Induk Siswa).
  /// Returns a map containing the 'dailyAttendanceUser' data as a [DailyAttendance] object.
  ///
  /// Throws an [ApiException] if the API call fails.
  Future<Map<String, dynamic>> getDailyAttendanceUserForToday({
    required String nis,
  }) async {
    try {
      final response = await ApiClient.get(
        url: "${ApiEndpoints.absensiHarian}/$nis",
        useAuthToken: true,
      );

      final dailyAttendanceData = response['data'];

      return {
        'dailyAttendanceUser': DailyAttendance.fromJson(
          Map.from(dailyAttendanceData),
        ),
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Fetches custom daily attendance data for a user based on specified criteria.
  ///
  /// Requires [nis], [year], [month], and [unit].
  /// Returns a map containing a list of [DailyAttendance] objects under the key 'customDailyAttendanceList'.
  ///
  /// Throws an [ApiException] if the API call fails.
  Future<Map<String, dynamic>> getCustomDailyAttendanceUser({
    required String nis,
    required int year,
    required int month,
    required String unit,
  }) async {
    try {
      final response = await ApiClient.get(
        url: "${ApiEndpoints.absensiHarian}/$nis/$year/$month/$unit",
        useAuthToken: true,
      );

      final customDailyAttendanceList = response['data'];

      return {
        'customDailyAttendanceList': (customDailyAttendanceList as List)
            .map((e) => DailyAttendance.fromJson(e))
            .toList(),
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Posts the daily attendance for a user to the API.
  ///
  /// This is typically called once per day to create an initial attendance record.
  /// Requires the student's [nis] and [unit].
  /// Returns a map containing the 'dailyAttendanceData' as a [DailyAttendance] object.
  ///
  /// Throws an [ApiException] if the API call fails.
  Future<Map<String, dynamic>> postDailyAttendanceUser({
    required String nis,
    required String unit,
  }) async {
    late final Map<String, dynamic> data = {"nis": nis, "unit": unit};

    try {
      final response = await ApiClient.post(
        body: data,
        url: ApiEndpoints.absensiHarian,
        useAuthToken: true,
      );

      final dailyAttendanceData = response['data'];

      return {
        'dailyAttendanceData': DailyAttendance.fromJson(
          Map.from(dailyAttendanceData),
        ),
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Updates the daily attendance record with a check-in time.
  ///
  /// Requires the attendance record [id] and the [checkIn] time.
  /// Returns a map containing the updated 'dailyAttendanceData' as a [DailyAttendance] object.
  ///
  /// Throws an [ApiException] if the API call fails.
  Future<Map<String, dynamic>> putDailyAttendanceUserForCheckIn({
    required int id,
    required DateTime checkIn,
  }) async {
    late final Map<String, dynamic> data = {
      "checkIn": checkIn.toIso8601String(),
    };

    try {
      final response = await ApiClient.put(
        body: data,
        url: "${ApiEndpoints.absensiHarian}/$id",
        useAuthToken: true,
      );

      final dailyAttendanceData = response['data'];

      return {
        'dailyAttendanceData': DailyAttendance.fromJson(
          Map.from(dailyAttendanceData),
        ),
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Updates the daily attendance record with a check-out time.
  ///
  /// Requires the attendance record [id] and the [checkOut] time.
  /// Returns a map containing the updated 'dailyAttendanceData' as a [DailyAttendance] object.
  ///
  /// Throws an [ApiException] if the API call fails.
  Future<Map<String, dynamic>> putDailyAttendanceUserForCheckOut({
    required int id,
    required DateTime checkOut,
  }) async {
    late final Map<String, dynamic> data = {
      "checkOut": checkOut.toIso8601String(),
    };

    try {
      final response = await ApiClient.put(
        body: data,
        url: "${ApiEndpoints.absensiHarian}/$id",
        useAuthToken: true,
      );

      final dailyAttendanceData = response['data'];

      return {
        'dailyAttendanceData': DailyAttendance.fromJson(
          Map.from(dailyAttendanceData),
        ),
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Fetches all attendance records for the user from the API.
  ///
  /// This method retrieves a paginated list of all attendance history for the current user.
  ///
  /// Returns an [AttendanceHistoryResponse] object containing the paginated data.
  ///
  /// Throws an [ApiException] if the API call fails.
  Future<AttendanceHistoryResponse> getAllAttendanceUser() async {
    try {
      final response = await ApiClient.get(
        url: ApiEndpoints.absensi,
        useAuthToken: true,
      );

      final allAttendanceList = (response['data'] as List)
          .map((e) => AttendanceHistory.fromJson(Map.from(e)))
          .toList();

      final allAttendanceLinksList = (response['links'] as List)
          .map((e) => Links.fromJson(Map.from(e)))
          .toList();

      return AttendanceHistoryResponse(
        currentPage: response['current_page'],
        listAttendance: allAttendanceList,
        total: response['total'],
        path: response['path'],
        firstPageUrl: response['first_page_url'],
        from: response['from'],
        lastPage: response['last_page'],
        lastPageUrl: response['last_page_url'],
        links: allAttendanceLinksList,
        nextPageUrl: response['next_page_url'],
        perPage: response['per_page'],
        prevPageUrl: response['prev_page_url'],
        to: response['to'],
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Fetches custom attendance data for a user with optional filters.
  ///
  /// Requires the student's [nis]. Optional parameters include [page],
  /// [unit], [year], and [month] for filtering and pagination.
  ///
  /// Returns an [AttendanceHistoryResponse] object containing paginated and filtered attendance data.
  ///
  /// Throws an [ApiException] if the API call fails.
  Future<AttendanceHistoryResponse> getCustomAttendanceUser({
    required String nis,
    int? page,
    String? unit,
    int? year,
    int? month,
  }) async {
    late final Map<String, dynamic> queryParameters = {
      "nis": nis,
      "page": page,
      "unit": unit,
      if (year != null) "year": year,
      if (month != null) "month": month,
    };

    try {
      final response = await ApiClient.get(
        url: ApiEndpoints.absensi,
        useAuthToken: true,
        queryParameters: queryParameters,
      );

      final allAttendanceList = (response['data'] as List)
          .map((e) => AttendanceHistory.fromJson(Map.from(e)))
          .toList();

      final allAttendanceLinksList = (response['links'] as List)
          .map((e) => Links.fromJson(Map.from(e)))
          .toList();

      return AttendanceHistoryResponse(
        currentPage: response['current_page'],
        listAttendance: allAttendanceList,
        total: response['total'],
        path: response['path'],
        firstPageUrl: response['first_page_url'],
        from: response['from'],
        lastPage: response['last_page'],
        lastPageUrl: response['last_page_url'],
        links: allAttendanceLinksList,
        nextPageUrl: response['next_page_url'],
        perPage: response['per_page'],
        prevPageUrl: response['prev_page_url'],
        to: response['to'],
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
