import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications.freezed.dart';
part 'notifications.g.dart';

/// Represents a single notification record from the backend.
///
/// This class models the structure of a notification, including its content,
/// targeting information, and status. It is designed to be immutable and is
/// used for deserializing notification data from the API.
@freezed
abstract class Notifications with _$Notifications {
  /// Creates an instance of [Notifications].
  const factory Notifications({
    /// The unique identifier for the notification.
    required int id,

    /// The category or type of the notification (e.g., "General", "Payment").
    required String type,

    /// The title of the notification.
    required String title,

    /// The main content or body of the notification.
    required String body,

    /// An optional URL for an image to be displayed in the notification.
    @JsonKey(name: "image_url") String? imageUrl,

    /// A flexible data payload containing additional information, often in JSON format.
    @JsonKey(name: "data_payload") required Object dataPayload,

    /// Specifies the type of target for the notification (e.g., "nis", "class").
    @JsonKey(name: "target_type") required String targetType,

    /// The specific value for the target (e.g., a student's NIS or a class ID).
    @JsonKey(name: "target_value") required String targetValue,

    /// The student identification number (NIS) of the intended recipient.
    @JsonKey(name: "recipient_nis") required String recipientNis,

    /// The delivery status of the notification (e.g., "sent", "failed").
    required String status,

    /// The unique message ID from Firebase Cloud Messaging (FCM), if available.
    @JsonKey(name: "fcm_message_id") String? fcmMessageId,

    /// An error message if the notification failed to send.
    @JsonKey(name: "error_message") String? errorMessage,

    /// The timestamp indicating when the notification was sent.
    @JsonKey(name: "sent_at") required DateTime sentAt,

    /// A flag indicating whether the notification has been read by the user ('0' or '1').
    @JsonKey(name: "is_read") required String isRead,

    /// The timestamp indicating when the notification was marked as read.
    @JsonKey(name: "is_read_at") DateTime? isReadAt,

    /// The timestamp indicating when the notification record was created in the database.
    @JsonKey(name: "created_at") required DateTime createdAt,

    /// The timestamp indicating the last time the notification record was updated.
    @JsonKey(name: "updated_at") DateTime? updatedAt,
  }) = _Notifications;

  /// Creates a [Notifications] instance from a JSON map.
  factory Notifications.fromJson(Map<String, dynamic> json) =>
      _$NotificationsFromJson(json);
}
