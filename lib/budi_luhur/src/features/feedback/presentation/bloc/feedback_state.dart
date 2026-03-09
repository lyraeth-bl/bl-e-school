part of 'feedback_bloc.dart';

@freezed
abstract class FeedbackState with _$FeedbackState {
  const factory FeedbackState.initial() = _Initial;

  const factory FeedbackState.loading() = _Loading;

  const factory FeedbackState.hasData({required List<Feedback> listFeedback}) =
      _HasData;

  const factory FeedbackState.emptyData() = _EmptyData;

  const factory FeedbackState.failure(Failure failure) = _Failure;

  // State terpisah untuk aksi CUD supaya UI bisa bedain
  // antara "loading list" vs "loading submit"
  const factory FeedbackState.actionLoading() = _ActionLoading;

  const factory FeedbackState.actionSuccess() = _ActionSuccess;

  const factory FeedbackState.actionFailure(Failure failure) = _ActionFailure;
}
