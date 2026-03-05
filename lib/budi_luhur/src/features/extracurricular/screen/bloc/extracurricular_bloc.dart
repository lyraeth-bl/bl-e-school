import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'extracurricular_bloc.freezed.dart';
part 'extracurricular_event.dart';
part 'extracurricular_state.dart';

class ExtracurricularBloc
    extends Bloc<ExtracurricularEvent, ExtracurricularState> {
  final ExtracurricularRepository _extracurricularRepository;

  ExtracurricularBloc(this._extracurricularRepository)
    : super(const ExtracurricularState.initial()) {
    on<_FetchExtracurriculer>(_onFetchExtracurriculer);
  }

  Future<void> _onFetchExtracurriculer(
    _FetchExtracurriculer event,
    Emitter<ExtracurricularState> emit,
  ) async {
    if (!event.forceRefresh && state is _Success) return;

    final storedExtracurricularData = _extracurricularRepository
        .getStoredExtracurricular();

    if (storedExtracurricularData != null) {
      emit(
        ExtracurricularState.success(
          extracurricularList: storedExtracurricularData,
        ),
      );
      debugPrint("ExtracurricularState.success() with local data");
      return;
    }

    emit(ExtracurricularState.loading());

    final result = await _extracurricularRepository.fetchExtracurricular();

    final failure = result.match((l) => l, (r) => null);
    final extracurricularResponse = result.match((l) => null, (r) => r);

    if (failure != null) {
      emit(ExtracurricularState.failure(failure));
      return;
    }

    if (extracurricularResponse != null) {
      await _extracurricularRepository.saveExtracurricular(
        extracurricularResponse.listExtracurricular,
      );
      debugPrint("_extracurricularRepository.saveExtracurricular() success");
      emit(
        ExtracurricularState.success(
          extracurricularList: extracurricularResponse.listExtracurricular,
        ),
      );
    }
  }
}
