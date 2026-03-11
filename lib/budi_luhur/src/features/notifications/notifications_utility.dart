import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

const String notificationChannelKey = "basic_channel";

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage remoteMessage,
) async {
  // Initialize Hive for background processing.
  await Hive.initFlutter();
  await Hive.openBox(notificationsBoxKey);

  final type = (remoteMessage.data['type'] ?? "").toString();
  if (kDebugMode) {
    debugPrint("Background Notification Type: $type");
  }

  final nis = sI<SessionsRepository>().getLoggedStudentDetails()?.nis;
  NotificationsRepository.addNotificationTemporarily(
    data: NotificationsDetails(
      nis: nis ?? "",
      title: remoteMessage.notification?.title ?? "",
      body: remoteMessage.notification?.body ?? "",
      type: remoteMessage.data['type'] ?? "",
      attachmentUrl: remoteMessage.data['image_url'] ?? "",
      createdAt: DateTime.timestamp(),
    ).toJson(),
  );

  if (kDebugMode) {
    debugPrint("Notifikasi background disimpan sementara.");
  }
}

class NotificationsUtility {
  // --- Notification Type Constants ---

  static String generalNotificationType = "general";

  static String assignmentNotificationType = "assignment";

  static String attendanceNotificationType = "attendance";

  static String paymentNotificationType = "payment";

  static String notificationType = "notification";

  static String messageType = "message";

  static Future<void> setUpNotificationService() async {
    NotificationSettings notificationSettings = await FirebaseMessaging.instance
        .getNotificationSettings();

    // Request permission if it's not determined or has been denied.
    if (notificationSettings.authorizationStatus ==
            AuthorizationStatus.notDetermined ||
        notificationSettings.authorizationStatus ==
            AuthorizationStatus.denied) {
      notificationSettings = await FirebaseMessaging.instance
          .requestPermission();

      // If permission is granted (authorized or provisional), initialize listeners.
      if (notificationSettings.authorizationStatus ==
              AuthorizationStatus.authorized ||
          notificationSettings.authorizationStatus ==
              AuthorizationStatus.provisional) {
        initNotificationListener();
      }
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.denied) {
      // If permission is explicitly denied, do nothing further.
      return;
    }
    // If permissions were already granted, initialize listeners.
    initNotificationListener();
  }

  static void initNotificationListener() {
    // Note: FirebaseMessaging.onMessage is handled directly in `main.dart`
    // or another initialization point to call `foregroundMessageListener`.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedAppListener);
  }

  static Future<void> foregroundMessageListener(
    RemoteMessage remoteMessage,
  ) async {
    final type = (remoteMessage.data['type'] ?? "").toString();

    // Specific logic for payment notifications.
    if (type == paymentNotificationType.toLowerCase()) {
      // Example: could auto-refresh a payment screen.
    } else {
      final nis = sI<SessionsRepository>().getLoggedStudentDetails()?.nis;
      // For general notifications, add to the repository for persistence.
      NotificationsRepository.addNotification(
        notificationDetails: NotificationsDetails(
          nis: nis ?? "",
          attachmentUrl: remoteMessage.data['image_url'] ?? "",
          type: remoteMessage.data['type'] ?? "",
          body: remoteMessage.notification?.body ?? "",
          createdAt: DateTime.timestamp(),
          title: remoteMessage.notification?.title ?? "",
        ),
      );
      if (kDebugMode) {
        debugPrint("Notifikasi foreground disimpan.");
      }
    }

    // Display the incoming message as a local notification.
    createLocalNotification(dismissable: true, message: remoteMessage);
  }

  static void onMessageOpenedAppListener(RemoteMessage remoteMessage) {
    _onTapNotificationScreenNavigateCallback(
      remoteMessage.data['type'] ?? "",
      remoteMessage.data,
    );
  }

  static Future<void> _onTapNotificationScreenNavigateCallback(
    String type,
    Map<String, dynamic> data,
  ) async {
    debugPrint("type from _onTapNotificationScreenNavigateCallback : $type");
    if (type.isEmpty) return;

    if (type == generalNotificationType) {
      if (Get.currentRoute != BudiLuhurRoutes.home) {
        Get.toNamed(BudiLuhurRoutes.home);
      }
      return;
    }

    if (type == notificationType) {
      if (Get.currentRoute != BudiLuhurRoutes.notifications) {
        Get.toNamed(BudiLuhurRoutes.notifications);
      }
      return;
    }

    if (type == attendanceNotificationType.toLowerCase()) {
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
      return;
    }
  }

  static Future<void> initializeAwesomeNotification() async {
    await AwesomeNotifications().initialize(null, [
      // Channel for general notifications
      NotificationChannel(
        channelKey: notificationChannelKey,
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        vibrationPattern: highVibrationPattern,
        importance: NotificationImportance.Max,
        playSound: true,
      ),
      // Channel for download progress bars
      NotificationChannel(
        channelKey: 'download_channel',
        channelName: 'Download Notifications',
        channelDescription: 'Notifications for file downloads with progress',
        importance: NotificationImportance.High,
        playSound: false,
        enableVibration: false,
      ),
      // Channel for download completion alerts
      NotificationChannel(
        channelKey: 'download_complete_channel',
        channelName: 'Download Complete Notifications',
        channelDescription: 'Shows download completion status',
        importance: NotificationImportance.Max,
        playSound: false,
        enableVibration: false,
      ),
    ]);
  }

  static Future<bool> isLocalNotificationAllowed() async {
    const notificationPermission = Permission.notification;
    final status = await notificationPermission.status;
    return status.isGranted;
  }

  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // Your code goes here
  }

  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    _onTapNotificationScreenNavigateCallback(
      (receivedAction.payload ?? {})['type'] ?? "",
      Map.from(receivedAction.payload ?? {}),
    );
  }

  // --- Download Notification Methods ---

  static Future<void> showDownloadNotification({
    required int notificationId,
    required String fileName,
    required int progress,
  }) async {
    try {
      if (!await AwesomeNotifications().isNotificationAllowed()) return;

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'download_channel',
          title: Utils.getTranslatedLabel(downloadingFileKey),
          body: fileName,
          notificationLayout: NotificationLayout.ProgressBar,
          progress: progress.toDouble(),
          category: NotificationCategory.Progress,
          autoDismissible: false,
          showWhen: true,
        ),
      );
    } catch (e) {
      // Handle notification errors silently to prevent app crashes.
    }
  }

  static Future<void> updateDownloadNotification({
    required int notificationId,
    required String fileName,
    required int progress,
  }) async {
    try {
      if (!await AwesomeNotifications().isNotificationAllowed()) return;

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'download_channel',
          title: "${Utils.getTranslatedLabel(downloadingFileKey)} \n$progress%",
          body: fileName,
          notificationLayout: NotificationLayout.ProgressBar,
          progress: progress.toDouble(),
          category: NotificationCategory.Progress,
          autoDismissible: false,
          showWhen: true,
        ),
      );
    } catch (e) {
      // Handle notification errors silently.
    }
  }

  static Future<void> showDownloadCompleteNotification({
    required int notificationId,
    required String fileName,
  }) async {
    try {
      if (!await AwesomeNotifications().isNotificationAllowed()) return;

      // Use a different notification ID for completion to avoid race conditions.
      final completionNotificationId = notificationId + 1000;

      // Dismiss the active progress notification.
      await AwesomeNotifications().dismiss(notificationId);

      // Short delay to ensure the OS has processed the dismissal.
      await Future.delayed(const Duration(milliseconds: 100));

      // Show the completion notification.
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: completionNotificationId,
          channelKey: 'download_complete_channel',
          title: '\n${Utils.getTranslatedLabel(downloadCompleteKey)} ✅',
          body:
              '\n$fileName \n${Utils.getTranslatedLabel(fileDownloadedSuccessfullyKey)}',
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Status,
          autoDismissible: true,
          showWhen: true,
        ),
      );

      // Automatically dismiss the completion notification after a few seconds.
      Future.delayed(const Duration(seconds: 5), () {
        AwesomeNotifications().dismiss(completionNotificationId).ignore();
      });
    } catch (e) {
      // Handle notification errors silently.
    }
  }

  static Future<void> showDownloadErrorNotification({
    required int notificationId,
    required String fileName,
    required String error,
  }) async {
    try {
      if (!await AwesomeNotifications().isNotificationAllowed()) return;

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'download_channel',
          title: '\${Utils.getTranslatedLabel(downloadFailedKey)} ❌',
          body:
              '\${Utils.getTranslatedLabel(failedToDownloadFileKey)} \$fileName',
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Error,
          autoDismissible: true,
          showWhen: true,
        ),
      );

      // Auto-dismiss the error notification after a few seconds.
      Future.delayed(const Duration(seconds: 5), () {
        AwesomeNotifications().dismiss(notificationId).ignore();
      });
    } catch (e) {
      // Handle notification errors silently.
    }
  }

  static Future<void> createLocalNotification({
    required bool dismissable,
    required RemoteMessage message,
  }) async {
    final String title = message.notification?.title ?? "";
    final String body = message.notification?.body ?? "";
    final String imageUrl =
        message.data['image'] ?? message.data['image_url'] ?? "";

    // Ensure awesome_notifications is allowed to send notifications.
    if (!await AwesomeNotifications().isNotificationAllowed()) {
      // Optionally, you can request permission at runtime.
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    final int notifId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notifId,
        title: title,
        body: body,
        locked: !dismissable,
        payload: {...message.data, 'type': message.data['type'] ?? ''},
        channelKey: notificationChannelKey,
        notificationLayout: imageUrl.isNotEmpty
            ? NotificationLayout.BigPicture
            : NotificationLayout.Default,
        autoDismissible: dismissable,
        bigPicture: imageUrl.isNotEmpty ? imageUrl : null,
        largeIcon: imageUrl.isNotEmpty ? imageUrl : null,
      ),
    );
  }
}
