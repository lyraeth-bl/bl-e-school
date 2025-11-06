import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_table_response.freezed.dart';
part 'time_table_response.g.dart';

/// Represents the response from the API when fetching a list of timetable entries.
///
/// This model encapsulates the paginated response structure, including metadata
/// about the request status, message, and the list of [TimeTable] data.
@freezed
abstract class TimeTableResponse with _$TimeTableResponse {
  /// Creates an instance of a [TimeTableResponse].
  const factory TimeTableResponse({
    /// Indicates the success status of the API request.
    /// `true` if the request was successful, `false` otherwise.
    @JsonKey(name: "status") required bool status,

    /// A message from the API, which can be an error message or a success confirmation.
    @JsonKey(name: "message") required String message,

    /// The list of timetable entries for the current page.
    /// This can be `null` if there is no data or an error occurred.
    @JsonKey(name: "data") List<TimeTable>? listTimeTable,
  }) = _TimeTableResponse;

  /// Creates a [TimeTableResponse] instance from a JSON map.
  ///
  /// This factory is used for deserializing the JSON response from the API
  /// into a `TimeTableResponse` object.
  factory TimeTableResponse.fromJson(Map<String, dynamic> json) =>
      _$TimeTableResponseFromJson(json);
}
