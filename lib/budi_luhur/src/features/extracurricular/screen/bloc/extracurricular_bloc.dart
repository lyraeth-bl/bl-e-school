import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'extracurricular_bloc.freezed.dart';
part 'extracurricular_bloc.g.dart';
part 'extracurricular_event.dart';
part 'extracurricular_state.dart';

class ExtracurricularBloc
    extends HydratedBloc<ExtracurricularEvent, ExtracurricularState> {
  final ExtracurricularRepository _repository;

  ExtracurricularBloc(this._repository)
    : super(const ExtracurricularState.initial()) {
    on<_FetchExtracurriculer>(_onFetch);
    on<_Refresh>(_onRefresh);
  }

  Future<void> _onFetch(
    _FetchExtracurriculer event,
    Emitter<ExtracurricularState> emit,
  ) async {
    final currentState = state;

    if (!event.forceRefresh && currentState is _Success) return;

    emit(ExtracurricularState.loading());

    try {
      final result = await _repository.fetchExtracurricular(nis: event.nis);

      emit(ExtracurricularState.success(extracurricularList: result));
    } catch (e) {
      emit(ExtracurricularState.failure(e.toString()));
    }
  }

  Future<void> _onRefresh(
    _Refresh event,
    Emitter<ExtracurricularState> emit,
  ) async {
    add(
      ExtracurricularEvent.fetchExtracurricular(
        nis: event.nis,
        forceRefresh: event.forceRefresh,
      ),
    );
  }

  @override
  ExtracurricularState? fromJson(Map<String, dynamic> json) {
    try {
      return ExtracurricularState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ExtracurricularState state) {
    return state.maybeWhen(
      success: (extracurricularList) => state.toJson(),
      orElse: () => null,
    );
  }
}
