import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../../core/failure/failure.dart';
import '../../data/model/demerit/demerit.dart';
import '../../data/model/merit/merit.dart';
import '../../data/model/params/discipline_params.dart';
import '../../repository/discipline_repository.dart';

part 'discipline_bloc.freezed.dart';
part 'discipline_event.dart';
part 'discipline_state.dart';

class DisciplineBloc extends Bloc<DisciplineEvent, DisciplineState> {
  final DisciplineRepository _disciplineRepository;

  DisciplineBloc(this._disciplineRepository)
    : super(const DisciplineState.initial()) {
    on<_FetchMeritAndDemerit>(_onFetchMeritAndDemerit);
  }

  Future<void> _onFetchMeritAndDemerit(
    _FetchMeritAndDemerit event,
    Emitter<DisciplineState> emit,
  ) async {
    if (!event.forceRefresh && state is _Success) return;

    final storedListMeritData = _disciplineRepository.getStoredMerit();
    debugPrint(
      "_disciplineRepository.getStoredMerit() : ${_disciplineRepository.getStoredMerit()}",
    );

    final storedListDemeritData = _disciplineRepository.getStoredDemerit();
    debugPrint(
      "_disciplineRepository.getStoredDemerit() : ${_disciplineRepository.getStoredDemerit()}",
    );
    final totalStoredMerit = storedListMeritData?.fold(
      0,
      (sum, e) => sum + e.point,
    );

    final totalStoredDemerit = storedListDemeritData?.fold(
      100,
      (sum, e) => sum - e.point,
    );

    if (!event.forceRefresh &&
        (storedListMeritData != null && storedListMeritData.isNotEmpty) &&
        (storedListDemeritData != null && storedListDemeritData.isNotEmpty)) {
      emit(
        DisciplineState.success(
          meritList: storedListMeritData,
          demeritList: storedListDemeritData,
          totalMerit: totalStoredMerit,
          totalDemerit: totalStoredDemerit,
        ),
      );
      debugPrint("DisciplineState.success with local data");
      return;
    }

    emit(const DisciplineState.loading());

    final meritResult = await _disciplineRepository.fetchMerit(
      DisciplineParams(
        schoolSession: event.schoolSession,
        semester: event.semester,
      ),
    );

    final demeritResult = await _disciplineRepository.fetchDemerit(
      DisciplineParams(
        schoolSession: event.schoolSession,
        semester: event.semester,
      ),
    );

    final meritFailure = meritResult.match((f) => f, (_) => null);
    final demeritFailure = demeritResult.match((f) => f, (_) => null);
    final meritResponse = meritResult.match((_) => null, (r) => r);
    final demeritResponse = demeritResult.match((_) => null, (r) => r);

    if (meritFailure != null) {
      emit(DisciplineState.failure(meritFailure));
      return;
    }

    if (demeritFailure != null) {
      emit(DisciplineState.failure(demeritFailure));
      return;
    }

    if (meritResponse != null) {
      await _disciplineRepository.storeMerit(
        meritResponse.disciplineList ?? [],
      );
      debugPrint("_disciplineRepository.storeMerit() success");
    }

    if (demeritResponse != null) {
      await _disciplineRepository.storeDemerit(
        demeritResponse.disciplineList ?? [],
      );
      debugPrint("_disciplineRepository.storeDemerit() success");
    }

    final totalMerit = meritResponse?.disciplineList?.fold(
      0,
      (sum, e) => sum + e.point,
    );
    final totalDemerit = demeritResponse?.disciplineList?.fold(
      100,
      (sum, e) => sum - e.point,
    );

    if (meritResponse != null && demeritResponse != null) {
      emit(
        DisciplineState.success(
          meritList: meritResponse.disciplineList ?? [],
          demeritList: demeritResponse.disciplineList ?? [],
          totalMerit: totalMerit,
          totalDemerit: totalDemerit,
        ),
      );
    }
  }
}
