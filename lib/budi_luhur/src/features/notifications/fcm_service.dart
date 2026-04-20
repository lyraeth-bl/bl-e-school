import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../app/routes/app_routes.dart';
import '../../core/dependencies_injection/get_it_instance.dart';
import '../device_tokens/repository/device_token_repository.dart';
import '../home/screen/home_screen.dart';
import '../sessions/presentation/bloc/sessions_bloc.dart';
import 'data/model/notifications_details/notifications_details.dart';
import 'presentation/cubit/notifications_cubit.dart';
import 'repository/notifications_repository.dart';

// ---------------------------------------------------------------------------
// Background handler — top-level function (wajib), berjalan di isolate terpisah.
//
// PENTING: Jangan akses sI<>() / GetIt di sini karena DI container TIDAK
// ter-inisialisasi di background isolate. Simpan ke SharedPreferences saja
// lewat helper static yang sudah ada.
// ---------------------------------------------------------------------------
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notification = message.notification;
  if (notification == null) return;

  /// Simpan sementara notifikasi ke [SharedPreferences].
  /// Notifikasi nantinya akan di flush ke [Hive] saat app dibuka kembali
  /// lewat [NotificationsCubit.fetchNotifications()].
  await NotificationsRepository.addNotificationTemporarily(
    data: NotificationsDetails(
      // NIS dibiarkan kosong terlebih dahulu, akan diisi saat sync.
      nis: "",
      title: notification.title ?? "",
      body: notification.body ?? "",
      attachmentUrl: message.data['image_url'] ?? "",
      type: message.data['type'] ?? "",
      createdAt: DateTime.timestamp(),
    ).toJson(),
  );

  if (kDebugMode) debugPrint('[FCM] Background notif saved temporarily.');
}

@pragma('vm:entry-point')
void onLocalNotifBackgroundTapped(NotificationResponse response) {
  // Saat background tap, navigasi sudah ditangani oleh onMessageOpenedApp FCM.
  // Callback ini cukup kosong atau hanya log.
  if (kDebugMode) {
    debugPrint('[FCM] Local notif background tapped: ${response.payload}');
  }
}

/// Notification Type.
///
/// Silahkan tambah type jika memang diperlukan.
abstract class NotificationTypes {
  static const String general = 'general';
  static const String assignment = 'assignment';
  static const String attendance = 'attendance';
  static const String payment = 'payment';
  static const String notification = 'notification';
  static const String message = 'message';
}

/// Tanggung jawab:
/// - Minta permission FCM
/// - Setup flutter_local_notifications untuk display local notif
/// - Register foreground / background / opened-app listener
/// - Navigasi saat notif di-tap
class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  final _messsaging = FirebaseMessaging.instance;
  final _localNotification = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // Android channel untuk notifikasi dengan type general / umum.
  static const _generalChannel = AndroidNotificationChannel(
    "bl_general_channel",
    "BL Notifications",
    description: "Notifikasi umum MyBudiLuhur",
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  /// Initialize().
  /// Panggil function ini untuk inisialisasi notifikasi.
  /// Bisa panggil function ini di initState pada [HomeScreen], atau di
  /// [budiLuhurInitializeApp].
  Future<void> initialize() async {
    if (_initialized) {
      if (kDebugMode) debugPrint('[FCM] Already initialized, skipping.');
      return;
    }

    // Minta izin permission notifikasi ke user.
    final settings = await _messsaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      if (kDebugMode) debugPrint('[FCM] Permission denied.');
      return;
    }

    // Setup FlutterLocalNotifications.
    await _localNotification.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _onLocalNotifTapped,
      onDidReceiveBackgroundNotificationResponse: onLocalNotifBackgroundTapped,
    );

    // Buat Android notification channel.
    if (Platform.isAndroid) {
      await _localNotification
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_generalChannel);
    }

    // iOS tampilkan notif saat foreground.
    await _messsaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    // Register listener
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    _initialized = true;
    if (kDebugMode) debugPrint('[FCM] Initialized successfully.');
  }

  /// Token Management.
  Future<String?> getToken() => _messsaging.getToken();

  String getPlatform() => Platform.isIOS ? "iOS" : "Android";

  Future<String?> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> registerToken() async {
    final token = await getToken();
    if (token == null) return;

    final platfrom = getPlatform();
    final version = await getAppVersion();

    await sI<DeviceTokenRepository>().registerFcmToken(
      token: token,
      platform: platfrom,
      appVersion: version,
    );

    // Otomatis re-register kalau token di refresh dari Firebase.
    _messsaging.onTokenRefresh.listen((newtoken) async {
      sI<DeviceTokenRepository>().registerFcmToken(
        token: token,
        platform: platfrom,
        appVersion: version,
      );
    });
  }

  Future<void> unregisterToken() async {
    final token = await getToken();
    if (token == null) return;

    await sI<DeviceTokenRepository>().removeFcmToken(token: token);
  }

  /// Foreground message handler.
  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final type = message.data['type'] ?? "";

    if (type == NotificationTypes.payment) {
      return;
    }

    // Simpan notifikasi ke Hive secara langsung
    // (app sudah aktif dan DI sudah ready)
    final nis = sI<SessionsBloc>().studentDetails?.nis ?? "";
    await NotificationsRepository.addNotification(
      notificationDetails: NotificationsDetails(
        nis: nis,
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
        attachmentUrl: message.data['image_url'] ?? "",
        type: type,
        createdAt: DateTime.timestamp(),
      ),
    );

    // Tampilkan notifikasi local.
    await _showLocalNotification(message);

    // Refresh list notifikasi di UI (kalau NotificationsCubit sudah ada di tree)
    try {
      sI<NotificationsCubit>().fetchNotifications();
    } catch (_) {
      // Cubit belum di-provide — tidak masalah, akan ter-load saat screen dibuka
    }

    if (kDebugMode) debugPrint('[FCM] Foreground notif saved.');
  }

  /// Handler ketika notifikasi di tap oleh user dan app dibuka dari background.
  void _onMessageOpenedApp(RemoteMessage message) {
    _navigate(type: message.data['type'] ?? '', data: message.data);
  }

  // Saat user tap local notification (flutter_local_notifications)
  void _onLocalNotifTapped(NotificationResponse response) {
    // payload kita kirim sebagai "type" string sederhana
    _navigate(type: response.payload ?? '', data: {});
  }

  /// Navigasi berdasarkan type notifikasi.
  void _navigate({required String type, required Map<String, dynamic> data}) {
    if (kDebugMode) debugPrint('[FCM] Navigate for type: $type');
    if (type.isEmpty) return;

    switch (type) {
      case NotificationTypes.general:
        if (Get.currentRoute != BudiLuhurRoutes.home) {
          Get.offNamedUntil(BudiLuhurRoutes.home, (r) => false);
        }

      case NotificationTypes.notification:
        if (Get.currentRoute != BudiLuhurRoutes.notifications) {
          Get.toNamed(BudiLuhurRoutes.notifications);
        }

      case NotificationTypes.attendance:
        if (Get.currentRoute != BudiLuhurRoutes.home) {
          Get.toNamed(
            BudiLuhurRoutes.home,
            arguments: {'fromNotifications': true},
          );
        } else {
          try {
            HomeScreen.homeScreenKey.currentState
                ?.fetchDailyAttendanceFromNotification();
          } catch (_) {}
        }
    }
  }

  /// Display local notifikasi via flutter_local_notifications.
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final imageUrl = message.data['image'] ?? message.data['image_url'] ?? '';
    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    final type = message.data['type'] ?? '';

    AndroidNotificationDetails androidDetails;

    if (imageUrl.isNotEmpty) {
      // Big picture style kalau ada gambar
      androidDetails = AndroidNotificationDetails(
        _generalChannel.id,
        _generalChannel.name,
        channelDescription: _generalChannel.description,
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigPictureStyleInformation(
          FilePathAndroidBitmap(imageUrl),
          largeIcon: FilePathAndroidBitmap(imageUrl),
        ),
      );
    } else {
      androidDetails = AndroidNotificationDetails(
        _generalChannel.id,
        _generalChannel.name,
        channelDescription: _generalChannel.description,
        importance: Importance.max,
        priority: Priority.high,
      );
    }

    await _localNotification.show(
      id: id,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(),
      ),
      payload: type,
    );
  }
}
