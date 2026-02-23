import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_result_bloc.freezed.dart';
part 'academic_result_event.dart';
part 'academic_result_state.dart';

class AcademicResultBloc
    extends Bloc<AcademicResultEvent, AcademicResultState> {
  final AcademicResultRepository _repository;

  AcademicResultBloc(this._repository)
    : super(const AcademicResultState.initial()) {
    on<_FetchResult>(_onFetchResult);
    on<_RefreshResult>(_onRefreshResult);
  }

  Future<void> _onFetchResult(
    _FetchResult event,
    Emitter<AcademicResultState> emit,
  ) async {
    final currentState = state;

    if (currentState is _Success && !event.forceRefresh) return;

    emit(AcademicResultState.loading());

    try {
      final result = await _repository.getResult();

      final subjectNames = result.data.categories
          .map((e) => e.subjectName)
          .toList();

      emit(
        AcademicResultState.success(
          response: result,
          subjectNames: subjectNames,
        ),
      );
    } catch (e) {
      emit(AcademicResultState.failure(e.toString()));
    }
  }

  Future<void> _onRefreshResult(
    _RefreshResult event,
    Emitter<AcademicResultState> emit,
  ) async {
    add(AcademicResultEvent.fetchResult(forceRefresh: true));
  }
}
