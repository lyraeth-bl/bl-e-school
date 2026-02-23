part of 'diagnosis_push_notification_bloc.dart';

@freezed
class DiagnosisPushNotificationEvent with _$DiagnosisPushNotificationEvent {
  const factory DiagnosisPushNotificationEvent.sendNotificationTest() =
      _SendNotificationTest;

  const factory DiagnosisPushNotificationEvent.notificationReceived() =
      _NotificationReceived;

  const factory DiagnosisPushNotificationEvent.timeout() = _Timeout;
}
