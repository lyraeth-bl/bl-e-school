import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackLocalDataSource _localDataSource;
  final FeedbackRemoteDataSource _remoteDataSource;

  FeedbackRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Unit> deleteFeedback({required int id}) async {
    await _remoteDataSource.deleteFeedback(id: id);

    return unit;
  }

  @override
  Future<Result<FeedbackResponse>> editFeedback({
    required int id,
    required FeedbackRequest feedbackRequest,
  }) async {
    final response = await _remoteDataSource.editFeedback(
      id: id,
      feedbackRequest: feedbackRequest,
    );

    return response.match(
      (failure) => Left(failure),
      (FeedbackResponse feedbackResponse) => Right(feedbackResponse),
    );
  }

  @override
  Future<Result<FeedbackResponse>> fetchFeedback() async {
    final response = await _remoteDataSource.fetchFeedback();

    return response.match(
      (failure) => Left(failure),
      (FeedbackResponse feedbackResponse) => Right(feedbackResponse),
    );
  }

  @override
  List<Feedback>? getStoredFeedback() => _localDataSource.getStoredFeedback();

  @override
  Future<Unit> saveFeedback(List<Feedback> listFeedback) async =>
      _localDataSource.saveFeedback(listFeedback);

  @override
  Future<Result<FeedbackResponse>> sendFeedback(
    FeedbackRequest feedbackRequest,
  ) async {
    final response = await _remoteDataSource.sendFeedback(feedbackRequest);

    return response.match(
      (failure) => Left(failure),
      (FeedbackResponse feedbackResponse) => Right(feedbackResponse),
    );
  }
}
