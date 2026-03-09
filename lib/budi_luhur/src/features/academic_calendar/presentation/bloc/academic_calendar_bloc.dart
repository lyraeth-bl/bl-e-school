import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_calendar_bloc.freezed.dart';
part 'academic_calendar_event.dart';
part 'academic_calendar_state.dart';

class AcademicCalendarBloc
    extends Bloc<AcademicCalendarEvent, AcademicCalendarState> {
  final AcademicCalendarRepository _academicCalendarRepository;

  AcademicCalendarBloc(this._academicCalendarRepository)
    : super(const AcademicCalendarState.initial()) {
    on<_Fetch>(_onFetch);
  }

  Future<void> _onFetch(
    _Fetch event,
    Emitter<AcademicCalendarState> emit,
  ) async {
    emit(const AcademicCalendarState.loading());

    final result = await _academicCalendarRepository.fetchAcademicCalendar(
      academicCalendarRequest: event.academicCalendarRequest,
      forceRefresh: event.forceRefresh,
    );

    result.match(
      (failure) => emit(AcademicCalendarState.failure(failure)),
      (data) => emit(
        AcademicCalendarState.success(
          listAcademicCalendar: data.list,
          year: event.academicCalendarRequest.year,
          month: event.academicCalendarRequest.month,
          lastUpdated: data.lastUpdated,
        ),
      ),
    );
  }
}
