import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'daily_attendance_cubit.freezed.dart';
part 'daily_attendance_state.dart';

/// Manages the state for daily attendance, including fetching, caching, and
/// persisting data.
///
/// This cubit extends [HydratedCubit] to automatically save and restore its state,
/// ensuring that attendance information is preserved across application restarts.
/// It handles user actions like check-in and check-out, and keeps track of
/// whether the attendance has been posted.
class DailyAttendanceCubit extends HydratedCubit<DailyAttendanceState> {
  /// The repository for accessing attendance-related data from the API and
  /// local storage.
  final AttendanceRepository _attendanceRepository;

  /// The Time-To-Live for the cached data.
  ///
  /// This duration determines how long the cached data is considered fresh.
  /// After this duration, the data will be refreshed from the server upon request.
  final Duration ttl = const Duration(hours: 6);

  /// Creates a new instance of [DailyAttendanceCubit].
  ///
  /// Requires an [AttendanceRepository] to interact with the data layer.
  /// The cubit is initialized immediately upon creation.
  DailyAttendanceCubit(this._attendanceRepository) : super(const _Initial()) {
    _init();
  }

  /// Initializes the cubit by loading data from cache if the state is initial.
  ///
  /// This method is called in the constructor to ensure that the cubit is
  /// hydrated with data as soon as it is created.
  void _init() {
    if (state is _Initial) {
      loadFromCacheOrFetch();
    }
  }

  /// Loads daily attendance data from local storage.
  ///
  /// If [force] is `true`, it will always reload the data from the local cache.
  /// Otherwise, it first checks if the current state data is fresh based on the [ttl].
  /// If the data is fresh, no action is taken. If it's stale or doesn't exist,
  /// it reloads from the locally stored attendance data in the repository.
  Future<void> loadFromCacheOrFetch({bool force = false}) async {
    if (!force && state is _HasData) {
      final last = (state as _HasData).lastUpdate;
      if (last != null) {
        if (DateTime.now().difference(last) < ttl) return;
      }
    }

    final storedData = _attendanceRepository.getStoredDailyAttendance();

    emit(
      _HasData(
        dailyAttendance: storedData,
        hasCheckIn: _attendanceRepository.getHasCheckIn(),
        hasCheckOut: _attendanceRepository.getHasCheckOut(),
        hasPost: _attendanceRepository.getHasPostDailyAttendance(),
        lastUpdate: storedData.updatedAt,
      ),
    );
  }

  /// Emits a new [_HasData] state with the provided attendance details.
  ///
  /// This method is used to manually update the state from other parts of the
  /// application, for instance after a successful check-in or check-out operation.
  void hasDataDailyAttendance({
    required DailyAttendance dailyAttendance,
    required bool hasPost,
    required bool hasCheckIn,
    required bool hasCheckOut,
  }) {
    emit(
      _HasData(
        dailyAttendance: dailyAttendance,
        hasPost: hasPost,
        hasCheckIn: hasCheckIn,
        hasCheckOut: hasCheckOut,
        lastUpdate: DateTime.now(),
      ),
    );
  }

  /// Refreshes the daily attendance data from the remote server.
  ///
  /// Fetches the latest attendance data for the given [nis] (student ID).
  /// On success, it updates the state with the new data.
  /// On failure, it gracefully reverts to the last known data to prevent
  /// the UI from showing an error state.
  Future<void> refreshDataDailyAttendance({required String nis}) async {
    final isCheckIn = _attendanceRepository.getHasCheckIn();
    final isCheckOut = _attendanceRepository.getHasCheckOut();
    final lastData = _attendanceRepository.getStoredDailyAttendance();
    final isPost = _attendanceRepository.getHasPostDailyAttendance();

    try {
      final result = await _attendanceRepository.getDailyAttendanceUserForToday(
        nis: nis,
      );

      final dailyAttendanceData =
          result['dailyAttendanceUser'] as DailyAttendance;

      emit(
        _HasData(
          dailyAttendance: dailyAttendanceData,
          hasCheckIn: isCheckIn,
          hasCheckOut: isCheckOut,
          hasPost: isPost,
          lastUpdate: dailyAttendanceData.updatedAt,
        ),
      );
    } catch (e) {
      // Revert to the last known state in case of an error to ensure UI stability.
      emit(
        _HasData(
          dailyAttendance: lastData,
          hasCheckIn: isCheckIn,
          hasCheckOut: isCheckOut,
          hasPost: isPost,
        ),
      );
    }
  }

  /// Updates the state with a new [DailyAttendance] object.
  ///
  /// This method preserves the existing `hasCheckIn`, `hasCheckOut`, and `hasPost`
  /// statuses from the repository while updating the core attendance data.
  void updateDailyAttendanceData(DailyAttendance dailyAttendance) {
    final isCheckIn = _attendanceRepository.getHasCheckIn();
    final isCheckOut = _attendanceRepository.getHasCheckOut();
    final isPost = _attendanceRepository.getHasPostDailyAttendance();

    emit(
      _HasData(
        dailyAttendance: dailyAttendance,
        hasCheckIn: isCheckIn,
        hasCheckOut: isCheckOut,
        hasPost: isPost,
        lastUpdate: dailyAttendance.updatedAt,
      ),
    );
  }

  /// Clears all attendance data and resets the state to initial.
  ///
  /// This is useful for logging out a user or resetting the application state.
  Future<void> clearAllData() async {
    await _attendanceRepository.setStoredDailyAttendance(
      DailyAttendance(
        id: 0,
        nis: '',
        tanggal: DateTime.now(),
        status: '',
        unit: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    await _attendanceRepository.setHasCheckIn(false);
    await _attendanceRepository.setHasCheckOut(false);
    await _attendanceRepository.setHasPostDailyAttendance(false);
    emit(const _Initial());
  }

  /// Returns the current [DailyAttendance] data, or `null` if not available.
  DailyAttendance? get getDailyAttendance => state.maybeWhen(
    hasData: (dailyAttendance, hasPost, hasCheckIn, hasCheckOut, lastUpdate) =>
        dailyAttendance,
    orElse: () => null,
  );

  /// Returns `true` if the user has checked in, `false` otherwise.
  bool get getHasCheckIn => state.maybeWhen(
    hasData: (dailyAttendance, hasPost, hasCheckIn, hasCheckOut, lastUpdate) =>
        hasCheckIn,
    orElse: () => false,
  );

  /// Returns `true` if the user has checked out, `false` otherwise.
  bool get getHasCheckOut => state.maybeWhen(
    hasData: (dailyAttendance, hasPost, hasCheckIn, hasCheckOut, lastUpdate) =>
        hasCheckOut,
    orElse: () => false,
  );

  /// Returns `true` if the daily attendance has been posted, `false` otherwise.
  bool get getHasPost => state.maybeWhen(
    hasData: (dailyAttendance, hasPost, hasCheckIn, hasCheckOut, lastUpdate) =>
        hasPost,
    orElse: () => false,
  );

  /// Returns the last update [DateTime], or `null` if not available.
  DateTime? get getLastUpdate => state.maybeWhen(
    hasData: (dailyAttendance, hasPost, hasCheckIn, hasCheckOut, lastUpdate) =>
        lastUpdate,
    orElse: () => null,
  );

  /// Deserializes the cubit's state from a JSON map.
  ///
  /// This method is called by [HydratedCubit] when restoring the state. It handles
  /// converting the stored JSON back into a valid [DailyAttendanceState]. If the
  /// JSON is invalid or an error occurs during parsing, it returns `null` to
  /// fall back to the initial state.
  @override
  DailyAttendanceState? fromJson(Map<String, dynamic> json) {
    try {
      final type = json['type'] as String? ?? 'initial';
      switch (type) {
        case 'has':
          final dailyMap = (json['dailyAttendance'] as Map<String, dynamic>?);
          if (dailyMap == null) return const _Initial();
          final daily = DailyAttendance.fromJson(dailyMap);
          final lastFetch = json['lastUpdate'] != null
              ? DateTime.tryParse(json['lastUpdate'] as String)
              : null;
          return _HasData(
            dailyAttendance: daily,
            hasPost: json['hasPost'] as bool? ?? false,
            hasCheckIn: json['hasCheckIn'] as bool? ?? false,
            hasCheckOut: json['hasCheckOut'] as bool? ?? false,
            lastUpdate: lastFetch,
          );
        case 'initial':
        default:
          return const _Initial();
      }
    } catch (_) {
      return null;
    }
  }

  /// Serializes the current state to a JSON map for persistence.
  ///
  /// This method is called by [HydratedCubit] to save the state. It converts
  /// the current [DailyAttendanceState] into a serializable map.
  @override
  Map<String, dynamic>? toJson(DailyAttendanceState state) {
    return state.map(
      initial: (_) => {'type': 'initial'},
      hasData: (s) => {
        'type': 'has',
        'dailyAttendance': s.dailyAttendance.toJson(),
        'hasPost': s.hasPost,
        'hasCheckIn': s.hasCheckIn,
        'hasCheckOut': s.hasCheckOut,
        'lastUpdate': s.lastUpdate?.toIso8601String(),
      },
      emptyData: (_) => {'type': 'none'},
    );
  }
}
