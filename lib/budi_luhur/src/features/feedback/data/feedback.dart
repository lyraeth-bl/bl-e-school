import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback.freezed.dart';
part 'feedback.g.dart';

/// Represents the type of feedback submitted by the user.
enum FeedbackType {
  /// A complaint about a service or feature.
  complaint,

  /// A suggestion for a new feature or improvement.
  suggestion,

  /// A report of a technical issue or bug.
  bug,

  /// A general question.
  question,
}

/// Represents the status of a feedback submission.
enum FeedbackStatus {
  /// The feedback has been submitted but not yet viewed by an admin.
  pending,

  /// The feedback has been viewed by an admin.
  read,

  /// The feedback is being actively worked on.
  inProgress,

  /// The feedback has been resolved.
  resolved,
}

/// Represents the priority level of a feedback submission.
enum FeedbackPriority {
  /// Low priority.
  low,

  /// Medium priority.
  medium,

  /// High priority.
  high,
}

/// Represents a user feedback submission.
///
/// This class is immutable and generated using the `freezed` package.
@freezed
abstract class Feedback with _$Feedback {
  /// Creates a new [Feedback] instance.
  const factory Feedback({
    /// A unique identifier for the feedback.
    required int id,

    /// The student identification number of the user who submitted the feedback.
    required String nis,

    /// The category of the feedback (e.g., "Academic", "Technical").
    String? category,

    /// The type of feedback.
    required FeedbackType type,

    /// The main content of the feedback message.
    required String message,

    /// An optional URL to an attachment file.
    @JsonKey(name: "attachments") String? attachments,

    /// The current status of the feedback.
    required FeedbackStatus status,

    /// The priority level of the feedback.
    required FeedbackPriority priority,

    /// An optional response from an administrator.
    @JsonKey(name: "admin_response") String? adminResponse,

    /// The time the administrator responded.
    @JsonKey(name: "responded_at") DateTime? adminResponseTime,

    /// The version of the application from which the feedback was submitted.
    @JsonKey(name: "app_version") String? appVersion,

    /// The operating system of the device from which the feedback was submitted.
    String? os,

    @JsonKey(name: "created_at") required DateTime createdAt,

    @JsonKey(name: "updated_at") required DateTime updatedAt,
  }) = _Feedback;

  /// Creates a [Feedback] instance from a JSON map.
  factory Feedback.fromJson(Map<String, dynamic> json) =>
      _$FeedbackFromJson(json);
}
