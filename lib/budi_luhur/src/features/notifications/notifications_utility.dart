import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

/// The key for the primary notification channel used for general alerts.
const String notificationChannelKey = "basic_channel";

/// A top-level callback to handle incoming messages when the app is in the
/// background or terminated.
///
/// This function must be a top-level function (not a class method) to be
/// used as a background handler. It checks the notification `type` and, if it's
/// a standard "Notification", it stores it in local storage to be viewed later.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage remoteMessage,
) async {
  // Initialize Hive for background processing.
  await Hive.initFlutter();
  await Hive.openBox(authBoxKey);
  await Hive.openBox(notificationsBoxKey);

  final type = (remoteMessage.data['type'] ?? "").toString();
  if (kDebugMode) {
    print("Background Notification Type: $type");
  }

  // If it's a general notification, store it temporarily.
  if (type.toLowerCase() ==
      NotificationsUtility.notificationType.toLowerCase()) {
    final studentDetails = AuthRepository.getStudentDetails();
    NotificationsRepository.addNotificationTemporarily(
      data: NotificationsDetails(
        nis: studentDetails.nis,
        title: remoteMessage.notification?.title ?? "",
        body: remoteMessage.notification?.body ?? "",
        type: remoteMessage.data['type'] ?? "",
        attachmentUrl: remoteMessage.data['image_url'] ?? "",
        createdAt: DateTime.timestamp(),
      ).toJson(),
    );
    if (kDebugMode) {
      print("Notifikasi background disimpan sementara.");
    }
  }
}

/// A utility class responsible for managing all notification-related functionalities.
///
/// This class handles the setup of Firebase Cloud Messaging (FCM), manages
/// notification permissions, and orchestrates how incoming notifications are
/// processed and displayed, whether the app is in the foreground, background,
/// or terminated. It uses the `awesome_notifications` package to create and
/// manage local notifications, including specialized ones for downloads.
class NotificationsUtility {
  // --- Notification Type Constants ---

  /// Type identifier for general-purpose notifications.
  static String generalNotificationType = "general";

  /// Type identifier for notifications related to assignments.
  static String assignmentNotificationType = "assignment";

  /// Type identifier for notifications related to attendance.
  static String attendanceNotificationType = "attendance";

  /// Type identifier for notifications related to payments.
  static String paymentNotificationType = "payment";

  /// Type identifier for standard informational notifications.
  static String notificationType = "notification";

  /// Type identifier for chat messages.
  static String messageType = "message";

  /// Sets up the notification service by checking and requesting permissions.
  ///
  /// This method checks the current notification authorization status. If permissions
  /// have not been granted or have been denied, it will request them from the user.
  /// If permissions are authorized (either fully or provisionally), it proceeds to
  /// initialize the notification listeners.
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

  /// Initializes the listeners for various Firebase Messaging events.
  ///
  /// This sets up handlers for:
  /// - `onBackgroundMessage`: For messages received when the app is in the background or terminated.
  /// - `onMessageOpenedApp`: For when the user taps a notification, opening the app.
  static void initNotificationListener() {
    // Note: FirebaseMessaging.onMessage is handled directly in `main.dart`
    // or another initialization point to call `foregroundMessageListener`.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedAppListener);
  }

  /// Handles incoming FCM messages when the app is in the foreground.
  ///
  /// It processes the notification data, adds it to the local repository if applicable,
  /// and then calls `createLocalNotification` to display a visible alert to the user.
  static Future<void> foregroundMessageListener(
    RemoteMessage remoteMessage,
  ) async {
    final type = (remoteMessage.data['type'] ?? "").toString();

    // Specific logic for payment notifications.
    if (type == paymentNotificationType.toLowerCase()) {
      // Example: could auto-refresh a payment screen.
    } else if (type.toLowerCase() == notificationType.toLowerCase()) {
      // For general notifications, add to the repository for persistence.
      NotificationsRepository.addNotification(
        notificationDetails: NotificationsDetails(
          nis: AuthRepository.getStudentDetails().nis,
          attachmentUrl: remoteMessage.data['image_url'] ?? "",
          type: remoteMessage.data['type'] ?? "",
          body: remoteMessage.notification?.body ?? "",
          createdAt: DateTime.timestamp(),
          title: remoteMessage.notification?.title ?? "",
        ),
      );
      if (kDebugMode) {
        print("Notifikasi foreground disimpan.");
      }
    }

    // Display the incoming message as a local notification.
    createLocalNotification(dismissable: true, message: remoteMessage);
  }

  /// A listener that triggers when a user taps a notification, opening the app
  /// from a background or terminated state.
  static void onMessageOpenedAppListener(RemoteMessage remoteMessage) {
    _onTapNotificationScreenNavigateCallback(
      remoteMessage.data['type'] ?? "",
      remoteMessage.data,
    );
  }

  /// Handles navigation when a notification is tapped.
  ///
  /// This callback determines the destination screen based on the notification's
  /// `type` payload.
  ///
  /// - [type]: The notification type (e.g., 'general', 'notification').
  /// - [data]: The full payload of the notification.
  static Future<void> _onTapNotificationScreenNavigateCallback(
    String type,
    Map<String, dynamic> data,
  ) async {
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
        Get.toNamed(BudiLuhurRoutes.home);
      }
      return;
    }
  }

  /// Initializes `awesome_notifications` with the required channels.
  ///
  /// This sets up different channels for various notification types, such as
  /// basic alerts, download progress, and download completion.
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

  /// Checks if the app is permitted to display local notifications.
  static Future<bool> isLocalNotificationAllowed() async {
    const notificationPermission = Permission.notification;
    final status = await notificationPermission.status;
    return status.isGranted;
  }

  /// A callback for when a new notification is created by `awesome_notifications`.
  /// (Currently unused, but available for future logic).
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  /// A callback for when a new notification is displayed by `awesome_notifications`.
  /// (Currently unused, but available for future logic).
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  /// A callback for when a user dismisses a notification.
  /// (Currently unused, but available for future logic).
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // Your code goes here
  }

  /// A callback for when a user taps on a notification or a notification action button.
  ///
  /// This is the entry point for handling taps on local notifications created by
  /// `awesome_notifications`. It extracts the payload and navigates the user.
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    _onTapNotificationScreenNavigateCallback(
      (receivedAction.payload ?? {})['type'] ?? "",
      Map.from(receivedAction.payload ?? {}),
    );
  }

  // --- Download Notification Methods ---

  /// Displays an initial notification with a progress bar for a file download.
  ///
  /// - [notificationId]: A unique integer to identify the notification.
  /// - [fileName]: The name of the file being downloaded.
  /// - [progress]: The initial download progress (usually 0).
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

  /// Updates an existing download notification with the latest progress.
  ///
  /// - [notificationId]: The ID of the notification to update.
  /// - [fileName]: The name of the file.
  /// - [progress]: The current download progress (0-100).
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
          title:
              '\${Utils.getTranslatedLabel(downloadingFileKey)} (\$progress%)',
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

  /// Displays a notification indicating that a download has completed successfully.
  ///
  /// This method first dismisses the progress notification and then shows a new,
  /// auto-dismissing "complete" notification.
  ///
  /// - [notificationId]: The ID of the original download notification.
  /// - [fileName]: The name of the completed file.
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
          title: '\${Utils.getTranslatedLabel(downloadCompleteKey)} ✅',
          body:
              '\$fileName \${Utils.getTranslatedLabel(fileDownloadedSuccessfullyKey)}',
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

  /// Displays a notification indicating that a download has failed.
  ///
  /// - [notificationId]: The ID of the original download notification.
  /// - [fileName]: The name of the file that failed to download.
  /// - [error]: A description of the error.
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

  /// Creates and displays a local notification from a [RemoteMessage].
  ///
  /// This is typically used to show a notification when an FCM message is
  /// received while the app is in the foreground.
  ///
  /// - [dismissable]: Whether the user can swipe to dismiss the notification.
  /// - [message]: The incoming FCM [RemoteMessage].
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
