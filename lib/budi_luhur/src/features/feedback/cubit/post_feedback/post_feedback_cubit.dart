import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_feedback_cubit.freezed.dart';
part 'post_feedback_state.dart';

class PostFeedbackCubit extends Cubit<PostFeedbackState> {
  final FeedbackRepository _feedbackRepository;

  PostFeedbackCubit(this._feedbackRepository) : super(const _Initial());

  Future<void> sendFeedback({
    required String nis,
    required String message,
    String? category,
    FeedbackType? type,
    String? attachment,
  }) async {
    emit(_Loading());

    try {
      final result = await _feedbackRepository.sendFeedback(
        nis: nis,
        message: message,
        category: category,
        type: type,
        attachment: attachment,
      );

      final Feedback data = result['feedbackData'];

      emit(_Success(feedback: data));
    } catch (e) {
      emit(_Failure(e.toString()));
    }
  }
}
