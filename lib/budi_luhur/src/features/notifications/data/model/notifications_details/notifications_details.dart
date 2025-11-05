import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_details.freezed.dart';
part 'notifications_details.g.dart';

/// Represents the detailed information of a single notification.
///
/// This class is used to model the data for a notification, including its
/// content, associated user, and metadata. It is designed to be immutable
/// and is used for both local storage and data transfer.
@freezed
abstract class NotificationsDetails with _$NotificationsDetails {
  /// Creates an instance of [NotificationsDetails].
  const factory NotificationsDetails({
    /// The student identification number (NIS) of the recipient.
    required String nis,

    /// The title of the notification.
    required String title,

    /// The main content or body of the notification.
    required String body,

    /// An optional URL for an attachment, such as an image.
    required String attachmentUrl,

    /// The category or type of the notification (e.g., "General", "Payment").
    required String type,

    /// The timestamp indicating when the notification was created.
    required DateTime createdAt,
  }) = _NotificationsDetails;

  /// Creates a [NotificationsDetails] instance from a JSON map.
  factory NotificationsDetails.fromJson(Map<String, dynamic> json) =>
      _$NotificationsDetailsFromJson(json);
}
