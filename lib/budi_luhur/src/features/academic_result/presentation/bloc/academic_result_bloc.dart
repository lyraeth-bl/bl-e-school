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
  }

  Future<void> _onFetchResult(
    _FetchResult event,
    Emitter<AcademicResultState> emit,
  ) async {
    if (state is _Success && !event.forceRefresh) return;

    emit(AcademicResultState.loading());

    final result = await _repository.getResult();

    final failure = result.match((l) => l, (r) => null);
    final academicResultResponse = result.match((l) => null, (r) => r);

    if (failure != null) {
      emit(AcademicResultState.failure(failure));
      return;
    }

    if (academicResultResponse != null) {
      final subjectNames = academicResultResponse.data.categories
          .map((e) => e.subjectName)
          .toList();

      emit(
        AcademicResultState.success(
          response: academicResultResponse,
          subjectNames: subjectNames,
        ),
      );
    }
  }
}
