import 'package:fpdart/fpdart.dart';

import '../../../utils/shared/types/types.dart';
import '../data/model/feedback/feedback.dart';
import '../data/model/feedback_request/feedback_request.dart';
import '../data/model/feedback_response/feedback_response.dart';

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
