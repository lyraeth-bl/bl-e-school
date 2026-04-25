import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/dependencies_injection/get_it_instance.dart';
import '../../../sessions/repository/sessions_repository.dart';
import '../../data/model/notifications_details/notifications_details.dart';
import '../../repository/notifications_repository.dart';

part 'notifications_cubit.freezed.dart';
part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _notificationsRepository;

  NotificationsCubit(this._notificationsRepository) : super(const _Initial());

  void fetchNotifications() async {
    if (state is _Loading) return;

    try {
      emit(const _Loading());

      // Ambil notif yang disimpan sementara saat background.
      final temporarilyStoredNotifications =
          await NotificationsRepository.getTemporarilyStoredNotifications();

      if (temporarilyStoredNotifications.isNotEmpty) {
        // Inject NIS yang benar sebelum flush ke Hive.
        // Background isolate tidak bisa akses DI, jadi NIS disimpan kosong.
        // Di sini baru kita isi dengan NIS user yang sedang login.
        final currentNis =
            sI<SessionsRepository>().getLoggedStudentDetails()?.nis ?? '';

        for (final notificationData in temporarilyStoredNotifications) {
          final nisFromData = notificationData['nis']?.toString() ?? '';

          final dataWithNis = {
            ...notificationData,
            'nis': nisFromData.isNotEmpty ? nisFromData : currentNis,
          };

          await NotificationsRepository.addNotification(
            notificationDetails: NotificationsDetails.fromJson(dataWithNis),
          );
        }

        await NotificationsRepository.clearTemporarilyNotification();
      }

      final listNotifications = await _notificationsRepository
          .fetchNotifications();

      emit(_Success(listNotifications: listNotifications));
    } catch (e) {
      emit(_Failure(e.toString()));
    }
  }
}
