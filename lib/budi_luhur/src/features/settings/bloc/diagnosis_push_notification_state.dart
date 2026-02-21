part of 'diagnosis_push_notification_bloc.dart';

@freezed
abstract class DiagnosisPushNotificationState
    with _$DiagnosisPushNotificationState {
  const factory DiagnosisPushNotificationState({
    @Default(DiagnosisStatus.initial) DiagnosisStatus status,
    @Default(false) bool isNotificationActive,
    String? fcmToken,
    @Default(false) bool isNotificationSuccess,
    @Default(0) int currentStep,
  }) = _DiagnosisPushNotificationState;
}

enum DiagnosisStatus { initial, loading, success, failed }
