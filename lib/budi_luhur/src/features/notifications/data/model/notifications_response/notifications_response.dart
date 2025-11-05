import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_response.freezed.dart';
part 'notifications_response.g.dart';

/// Represents the paginated response from the notifications API.
///
/// This class encapsulates the list of notifications as well as all
/// the metadata required to handle pagination, such as page numbers,
/// URLs for navigation, and total counts.
@freezed
abstract class NotificationsResponse with _$NotificationsResponse {
  /// Creates an instance of [NotificationsResponse].
  const factory NotificationsResponse({
    /// The current page number being displayed.
    @JsonKey(name: "current_page") int? currentPage,

    /// The list of [Notifications] for the current page.
    @JsonKey(name: "data") required List<Notifications> notificationsList,

    /// The URL to get the first page of results.
    @JsonKey(name: "first_page_url") String? firstPageUrl,

    /// The index of the first item on the page.
    @JsonKey(name: "from") int? from,

    /// The number of the last page available.
    @JsonKey(name: "last_page") int? lastPage,

    /// The URL to get the last page of results.
    @JsonKey(name: "last_page_url") String? lastPageUrl,

    /// A list of pagination link objects.
    @JsonKey(name: "links") List<Links>? links,

    /// The URL to get the next page of results, or `null` if on the last page.
    @JsonKey(name: "next_page_url") String? nextPageUrl,

    /// The base path for the API endpoint.
    @JsonKey(name: "path") String? path,

    /// The number of notifications included per page.
    @JsonKey(name: "per_page") int? perPage,

    /// The URL to get the previous page of results, or `null` if on the first page.
    @JsonKey(name: "prev_page_url") String? prevPageUrl,

    /// The index of the last item on the page.
    @JsonKey(name: "to") int? to,

    /// The total number of notifications available across all pages.
    @JsonKey(name: "total") int? total,
  }) = _NotificationsResponse;

  /// Creates a [NotificationsResponse] instance from a JSON map.
  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseFromJson(json);
}
