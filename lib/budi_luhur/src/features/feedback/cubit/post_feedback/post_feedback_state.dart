part of 'post_feedback_cubit.dart';

@freezed
abstract class PostFeedbackState with _$PostFeedbackState {
  const factory PostFeedbackState.initial() = _Initial;

  const factory PostFeedbackState.loading() = _Loading;

  const factory PostFeedbackState.success({required Feedback feedback}) =
      _Success;

  const factory PostFeedbackState.failure(String errorMessage) = _Failure;
}
