part of 'notifications_cubit.dart';

@freezed
abstract class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = _Initial;

  const factory NotificationsState.loading() = _Loading;

  const factory NotificationsState.success({
    required List<NotificationsDetails> listNotifications,
  }) = _Success;

  const factory NotificationsState.failure(String errorMessage) = _Failure;
}
