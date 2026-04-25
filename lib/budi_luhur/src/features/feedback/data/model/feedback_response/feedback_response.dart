import 'package:freezed_annotation/freezed_annotation.dart';

import '../feedback/feedback.dart';

part 'feedback_response.freezed.dart';
part 'feedback_response.g.dart';

@freezed
abstract class FeedbackResponse with _$FeedbackResponse {
  const factory FeedbackResponse({
    required bool error,
    String? message,
    @JsonKey(name: "data") required List<Feedback> listFeedback,
  }) = _FeedbackResponse;

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedbackResponseFromJson(json);
}
