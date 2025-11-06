import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_cubit.freezed.dart';
part 'notifications_state.dart';

/// A [Cubit] that manages the state of notifications.
///
/// This cubit is responsible for fetching notifications from a repository,
/// handling notifications received in the background, and providing the
/// UI with a list of notifications.
class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _notificationsRepository;

  /// Creates a new instance of [NotificationsCubit].
  ///
  /// Requires a [NotificationsRepository] to interact with the data layer.
  NotificationsCubit(this._notificationsRepository) : super(const _Initial());

  /// Fetches all notifications.
  ///
  /// This method performs the following steps:
  /// 1. Emits a [_Loading] state to indicate that notifications are being fetched.
  /// 2. Retrieves any temporarily stored notifications that were received while
  ///    the app was in the background.
  /// 3. Moves the temporarily stored notifications to permanent storage (Hive).
  /// 4. Clears the temporary notification storage.
  /// 5. Fetches all notifications from the permanent storage.
  /// 6. Emits a [_Success] state with the list of notifications if the fetch is successful.
  /// 7. Emits a [_Failure] state with an error message if the fetch fails.
  void fetchNotifications() async {
    try {
      emit(const _Loading());

      // Retrieve temporarily stored notifications (from background processing).
      final temporarilyStoredNotifications =
          await NotificationsRepository.getTemporarilyStoredNotifications();

      // Move temporary notifications to permanent storage (Hive).
      if (temporarilyStoredNotifications.isNotEmpty) {
        for (var notificationData in temporarilyStoredNotifications) {
          await NotificationsRepository.addNotification(
            notificationDetails: NotificationsDetails.fromJson(
              notificationData,
            ),
          );
        }

        // Clear temporary notifications after moving them.
        await NotificationsRepository.clearTemporarilyNotification();
      }

      // Fetch all notifications from permanent storage.
      final listNotifications = await _notificationsRepository
          .fetchNotifications();

      emit(_Success(listNotifications: listNotifications));
    } catch (e) {
      emit(_Failure(e.toString()));
    }
  }
}
