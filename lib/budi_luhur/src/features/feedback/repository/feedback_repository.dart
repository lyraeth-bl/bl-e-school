import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

abstract class FeedbackRepository {
  Future<Result<FeedbackResponse>> sendFeedback(
    FeedbackRequest feedbackRequest,
  );

  Future<Result<FeedbackResponse>> fetchFeedback();

  Future<Result<FeedbackResponse>> editFeedback({
    required int id,
    required FeedbackRequest feedbackRequest,
  });

  Future<Unit> deleteFeedback({required int id});

  Future<Unit> saveFeedback(List<Feedback> listFeedback);

  List<Feedback>? getStoredFeedback();
}
