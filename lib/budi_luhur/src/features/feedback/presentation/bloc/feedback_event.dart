part of 'feedback_bloc.dart';

@freezed
abstract class FeedbackEvent with _$FeedbackEvent {
  const factory FeedbackEvent.started({@Default(false) bool forceRefresh}) =
      _Started;

  const factory FeedbackEvent.sendFeedback({
    required FeedbackRequest feedbackRequest,
  }) = _SendFeedback;

  const factory FeedbackEvent.editFeedback({
    required int id,
    required FeedbackRequest feedbackRequest,
  }) = _EditFeedback;

  const factory FeedbackEvent.deleteFeedback({required int id}) =
      _DeleteFeedback;
}
