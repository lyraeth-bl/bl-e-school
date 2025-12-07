import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'feedback_cubit.freezed.dart';
part 'feedback_state.dart';

/// A Cubit for managing user feedback state.
///
/// This class extends [Cubit] to automatically persist and restore
/// its state across application sessions. It handles fetching, caching,
/// and refreshing user feedback data.
class FeedbackCubit extends Cubit<FeedbackState> {
  /// The repository for accessing feedback data.
  final FeedbackRepository _feedbackRepository;

  /// Creates a new instance of [FeedbackCubit].
  ///
  /// Requires a [FeedbackRepository] to interact with the data layer.
  /// The cubit is initialized immediately upon creation.
  FeedbackCubit(this._feedbackRepository) : super(const _Initial());

  /// Manually sets the state to [_HasData] with the provided feedback.
  ///
  /// This is useful for directly updating the state from other parts of the
  /// application without performing a fetch.
  void hasDataFeedback({required Feedback feedback}) =>
      emit(_HasData(feedbackUser: feedback, lastFetched: DateTime.now()));

  /// Refreshes the user feedback data from the remote server.
  ///
  /// On failure, it gracefully reverts to the last known data from the cache
  /// to prevent the UI from showing an error state.
  Future<void> refreshDataUserFeedback({required String nis}) async {
    try {
      final result = await _feedbackRepository.getUserFeedback(nis: nis);
      final data = result.feedbackList;

      if (data.isNotEmpty) {
        emit(
          _HasData(feedbackUser: data.first, lastFetched: data.first.updatedAt),
        );
      } else {
        // If refresh returns no data, check the cache.
        final lastData = _feedbackRepository.getStoredFeedbackUser;
        emit(_HasData(feedbackUser: lastData));
      }
    } catch (e) {
      final lastData = _feedbackRepository.getStoredFeedbackUser;
      emit(_HasData(feedbackUser: lastData));
    }
  }

  /// Updates the state with a new [Feedback] object.
  void updateFeedbackUserData(Feedback feedback) =>
      emit(_HasData(feedbackUser: feedback, lastFetched: feedback.updatedAt));

  /// Clears all feedback data and resets the state to initial.
  Future<void> clearAllData() async {
    // Assuming a method to clear stored feedback exists in the repository.
    await _feedbackRepository.clearStoredFeedbackData();
    emit(const _Initial());
  }

  /// Returns the current [Feedback] data, or `null` if not available.
  Feedback? get getFeedback => state.maybeWhen(
    hasData: (feedbackUser, lastFetched) => feedbackUser,
    orElse: () => null,
  );

  /// Returns the last update [DateTime], or `null` if not available.
  DateTime? get getLastFetched => state.maybeWhen(
    hasData: (feedbackUser, lastFetched) => lastFetched,
    orElse: () => null,
  );
}
