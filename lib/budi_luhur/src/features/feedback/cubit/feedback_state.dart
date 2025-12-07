part of 'feedback_cubit.dart';

/// Represents the various states of the feedback feature.
///
/// This sealed class, generated with the `freezed` package, defines the possible
/// states for the [FeedbackCubit]. Each state corresponds to a different phase
/// of the data lifecycle, such as initial, loading, success (with data),
/// empty, or failure.
@freezed
abstract class FeedbackState with _$FeedbackState {
  /// The initial state of the cubit, before any data has been loaded.
  ///
  /// This is the default state when the cubit is first created.
  const factory FeedbackState.initial() = _Initial;

  /// The state indicating that feedback data is currently being fetched.
  ///
  /// The UI can use this state to show a loading indicator.
  const factory FeedbackState.loading() = _Loading;

  /// The state representing that no feedback data was found for the user.
  const factory FeedbackState.emptyData() = _EmptyData;

  /// The state indicating that feedback data has been successfully loaded.
  ///
  /// This state contains the feedback data that can be displayed by the UI.
  const factory FeedbackState.hasData({
    /// The user's feedback data. Can be null if no specific feedback is loaded yet.
    Feedback? feedbackUser,

    /// The timestamp of when the data was last fetched from the server.
    ///
    /// This is used to determine if the cached data is stale and needs to be refreshed.
    DateTime? lastFetched,
  }) = _HasData;

  /// The state indicating that an error occurred while fetching feedback data.
  ///
  /// Contains an [errorMessage] that can be displayed to the user.
  const factory FeedbackState.failure(String errorMessage) = _Failure;
}
