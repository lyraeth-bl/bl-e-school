import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_bloc.freezed.dart';
part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FeedbackRepository _feedbackRepository;

  FeedbackBloc(this._feedbackRepository)
    : super(const FeedbackState.initial()) {
    on<_Started>(_onStarted);
    on<_SendFeedback>(_onSendFeedback);
    on<_EditFeedback>(_onEditFeedback);
    on<_DeleteFeedback>(_onDeleteFeedback);
  }

  Future<void> _onStarted(_Started event, Emitter<FeedbackState> emit) async {
    emit(const FeedbackState.loading());

    final storedFeedbackData = _feedbackRepository.getStoredFeedback();

    if (!event.forceRefresh &&
        storedFeedbackData != null &&
        storedFeedbackData.isNotEmpty) {
      emit(FeedbackState.hasData(listFeedback: storedFeedbackData));
      return;
    }

    final result = await _feedbackRepository.fetchFeedback();

    final failure = result.fold((f) => f, (_) => null);
    final feedbackResponse = result.fold((_) => null, (r) => r);

    if (failure != null) {
      emit(const FeedbackState.emptyData());
      return;
    }

    if (feedbackResponse != null) {
      await _feedbackRepository.saveFeedback(feedbackResponse.listFeedback);

      if (feedbackResponse.listFeedback.isEmpty) {
        emit(const FeedbackState.emptyData());
        return;
      }

      emit(FeedbackState.hasData(listFeedback: feedbackResponse.listFeedback));
    }
  }

  Future<void> _onSendFeedback(
    _SendFeedback event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackState.actionLoading());

    final result = await _feedbackRepository.sendFeedback(
      event.feedbackRequest,
    );

    final failure = result.fold((f) => f, (_) => null);
    final feedbackResponse = result.fold((_) => null, (r) => r);

    if (failure != null) {
      emit(FeedbackState.actionFailure(failure));
      return;
    }

    if (feedbackResponse != null) {
      add(const FeedbackEvent.started());
    }
  }

  Future<void> _onEditFeedback(
    _EditFeedback event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackState.actionLoading());

    final result = await _feedbackRepository.editFeedback(
      id: event.id,
      feedbackRequest: event.feedbackRequest,
    );

    final failure = result.fold((f) => f, (_) => null);

    if (failure != null) {
      emit(FeedbackState.actionFailure(failure));
      return;
    }

    emit(const FeedbackState.actionSuccess());
    add(const FeedbackEvent.started());
  }

  Future<void> _onDeleteFeedback(
    _DeleteFeedback event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackState.actionLoading());

    try {
      await _feedbackRepository.deleteFeedback(id: event.id);
      emit(const FeedbackState.actionSuccess());
      add(const FeedbackEvent.started());
    } catch (e) {
      emit(FeedbackState.actionFailure(Failure.fromDio(e)));
    }
  }
}
