import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback.freezed.dart';
part 'feedback.g.dart';

enum FeedbackType { complaint, suggestion, bug, question }

enum FeedbackStatus { pending, read, inProgress, resolved }

enum FeedbackPriority { low, medium, high }

@freezed
abstract class Feedback with _$Feedback {
  const factory Feedback({
    required int id,
    required String nis,
    String? category,
    required FeedbackType type,
    required String message,
    @JsonKey(name: "attachments") String? attachments,
    required FeedbackStatus status,
    required FeedbackPriority priority,
    @JsonKey(name: "admin_response") String? adminResponse,
    @JsonKey(name: "responded_at") DateTime? adminResponseTime,
    @JsonKey(name: "app_version") String? appVersion,
    String? os,
    @JsonKey(name: "created_at") required DateTime createdAt,
    @JsonKey(name: "updated_at") required DateTime updatedAt,
  }) = _Feedback;

  factory Feedback.fromJson(Map<String, dynamic> json) =>
      _$FeedbackFromJson(json);
}
