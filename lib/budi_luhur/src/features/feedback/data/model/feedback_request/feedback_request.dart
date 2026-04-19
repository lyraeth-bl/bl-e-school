import 'package:freezed_annotation/freezed_annotation.dart';

import '../feedback/feedback.dart';

part 'feedback_request.freezed.dart';
part 'feedback_request.g.dart';

@freezed
abstract class FeedbackRequest with _$FeedbackRequest {
  const factory FeedbackRequest({
    required String message,
    String? category,
    FeedbackType? type,
    String? attachment,
    @JsonKey(name: "app_version") String? appVersion,
    String? os,
  }) = _FeedbackRequest;

  factory FeedbackRequest.fromJson(Map<String, dynamic> json) =>
      _$FeedbackRequestFromJson(json);
}
