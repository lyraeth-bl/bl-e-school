import 'dart:async';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diagnosis_push_notification_bloc.freezed.dart';
part 'diagnosis_push_notification_event.dart';
part 'diagnosis_push_notification_state.dart';

class DiagnosisPushNotificationBloc
    extends
        Bloc<DiagnosisPushNotificationEvent, DiagnosisPushNotificationState> {
  final SettingsRepository _settingsRepository;
  final NotificationsRepository _notificationsRepository;

  StreamSubscription<RemoteMessage>? _messageSubscription;

  DiagnosisPushNotificationBloc(
    this._settingsRepository,
    this._notificationsRepository,
  ) : super(const DiagnosisPushNotificationState()) {
    _messageSubscription = FirebaseMessaging.onMessage.listen((message) {
      if (!isClosed) {
        add(const DiagnosisPushNotificationEvent.notificationReceived());
      }
    });

    on<_SendNotificationTest>(_onSendNotificationTest);
    on<_NotificationReceived>(_onNotificationReceived);
    on<_Timeout>(_onTimeout);
  }

  Future<void> _onSendNotificationTest(
    _SendNotificationTest event,
    Emitter<DiagnosisPushNotificationState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DiagnosisStatus.loading, currentStep: 0));

      /// STEP 1 — Permission
      final isActive = await _settingsRepository.getNotificationSettings();

      emit(state.copyWith(isNotificationActive: isActive, currentStep: 1));

      await Future.delayed(const Duration(milliseconds: 600));

      /// STEP 2 — Token
      final fcmToken = await FirebaseMessaging.instance.getToken();

      emit(state.copyWith(fcmToken: fcmToken, currentStep: 2));

      await Future.delayed(const Duration(milliseconds: 600));

      /// STEP 3 — Send Push
      await _notificationsRepository.sendTestNotification();

      emit(state.copyWith(currentStep: 3));

      /// TIMEOUT 10 DETIK
      Future.delayed(const Duration(seconds: 10), () {
        if (!isClosed && state.status == DiagnosisStatus.loading) {
          add(const DiagnosisPushNotificationEvent.timeout());
        }
      });
    } catch (e) {
      emit(state.copyWith(status: DiagnosisStatus.failed));
    }
  }

  void _onNotificationReceived(
    _NotificationReceived event,
    Emitter<DiagnosisPushNotificationState> emit,
  ) {
    emit(
      state.copyWith(
        status: DiagnosisStatus.success,
        isNotificationSuccess: true,
        currentStep: 4,
      ),
    );
  }

  void _onTimeout(
    _Timeout event,
    Emitter<DiagnosisPushNotificationState> emit,
  ) {
    emit(state.copyWith(status: DiagnosisStatus.failed));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
