import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'discipline_bloc.freezed.dart';
part 'discipline_bloc.g.dart';
part 'discipline_event.dart';
part 'discipline_state.dart';

class DisciplineBloc extends HydratedBloc<DisciplineEvent, DisciplineState> {
  final DisciplineRepository repository;

  DisciplineBloc(this.repository) : super(const DisciplineState.initial()) {
    on<_Load>(_onLoad);
    on<_Refresh>(_onRefresh);
  }

  Future<void> _onLoad(_Load event, Emitter<DisciplineState> emit) async {
    final currentState = state;

    if (!event.forceRefresh && currentState is _Loaded) return;

    emit(const DisciplineState.loading());

    try {
      final meritResponse = await repository.fetchMerit(
        DisciplineParams(
          nis: event.nis,
          schoolSession: event.schoolSession,
          semester: event.semester,
        ),
      );

      final demeritResponse = await repository.fetchDemerit(
        DisciplineParams(
          nis: event.nis,
          schoolSession: event.schoolSession,
          semester: event.semester,
        ),
      );

      final totalMerit = meritResponse.disciplineList.fold<int>(
        0,
        (sum, e) => sum + e.point,
      );

      final totalDemerit = demeritResponse.disciplineList.fold<int>(
        100,
        (sum, e) => sum - e.point,
      );

      emit(
        DisciplineState.loaded(
          meritList: meritResponse.disciplineList,
          demeritList: demeritResponse.disciplineList,
          totalMerit: totalMerit,
          totalDemerit: totalDemerit,
        ),
      );
    } catch (e) {
      emit(DisciplineState.error(e.toString()));
    }
  }

  Future<void> _onRefresh(_Refresh event, Emitter<DisciplineState> emit) async {
    add(
      DisciplineEvent.load(
        nis: event.nis,
        schoolSession: event.schoolSession,
        semester: event.semester,
        forceRefresh: true,
      ),
    );
  }

  @override
  DisciplineState? fromJson(Map<String, dynamic> json) {
    try {
      return DisciplineState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(DisciplineState state) {
    return state.maybeWhen(
      loaded: (meritList, demeritList, totalMerit, totalDemerit) =>
          state.toJson(),
      orElse: () => null,
    );
  }
}
