/// Manages the state of user feedback data.
///
/// This cubit is responsible for fetching user feedback from the
/// [FeedbackRepository] and emitting the appropriate states.
// get_feedback_cubit.dart
import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'get_feedback_cubit.freezed.dart';
part 'get_feedback_state.dart';

/// A [Cubit] that manages the state of the user feedback.
///
/// It fetches the user feedback from the [FeedbackRepository] and updates the
/// state accordingly.
class GetFeedbackCubit extends Cubit<GetFeedbackState> {
  final FeedbackRepository _feedbackRepository;

  /// Creates a new instance of [GetFeedbackCubit].
  GetFeedbackCubit(this._feedbackRepository) : super(const _Initial());

  /// Fetches the user feedback for the given [nis].
  ///
  /// If [forceRefresh] is true, it will always fetch new data from the
  /// repository. Otherwise, it will only fetch new data if the current state
  /// is not a success state.
  ///
  /// Emits a [_Loading] state while fetching the data.
  /// Emits a [_Success] state with the fetched data if the request is
  /// successful.
  /// Emits a [_Failure] state with an error message if the request fails.
  Future<void> fetchUserFeedback({
    required String nis,
  }) async {
    emit(const _Loading());

    try {
      final result = await _feedbackRepository.getUserFeedback(nis: nis);

      final data = result.feedbackList;

      final now = DateTime.now();

      emit(_Success(userFeedbackList: data, lastUpdate: now));
    } catch (e) {
      emit(_Failure(e.toString()));
    }
  }
}
