part of 'get_feedback_cubit.dart';

/// Represents the different states of the feedback retrieval process.
///
/// This sealed class defines the possible states: initial, loading, success,
/// and failure.
@freezed
abstract class GetFeedbackState with _$GetFeedbackState {
  /// The initial state before any feedback has been fetched.
  const factory GetFeedbackState.initial() = _Initial;

  /// The state when feedback is currently being fetched.
  const factory GetFeedbackState.loading() = _Loading;

  /// The state when feedback has been successfully fetched.
  const factory GetFeedbackState.success({
    /// The list of feedback items.
    required List<Feedback> userFeedbackList,

    /// The timestamp of the last successful update.
    required DateTime lastUpdate,
  }) = _Success;

  /// The state when an error has occurred during feedback fetching.
  const factory GetFeedbackState.failure(
    /// The error message describing the failure.
    String errorMessage,
  ) = _Failure;
}
