import 'dart:convert';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A repository for managing notification data, both persistent and temporary.
///
/// This class provides an interface to interact with local storage for
/// storing, retrieving, and managing notifications. It uses [Hive] for
/// persistent storage and [SharedPreferences] for temporary storage of
/// notifications that are received when the app is in the background.
class NotificationsRepository {
  /// Adds a notification to the persistent storage.
  ///
  /// This method saves a [NotificationsDetails] object to a Hive box,
  /// using the notification's creation timestamp as the key.
  ///
  /// - [notificationDetails]: The notification object to be stored.
  static Future<void> addNotification({
    required NotificationsDetails notificationDetails,
  }) async {
    try {
      await Hive.box(notificationsBoxKey).put(
        notificationDetails.createdAt.toString(),
        notificationDetails.toJson(),
      );
    } catch (_) {
      // Errors are silently ignored to prevent crashes if storage fails.
    }
  }

  /// Fetches all notifications for the current user from persistent storage.
  ///
  /// This method retrieves all notifications from the Hive box, filters them
  /// to match the currently logged-in student's NIS, and sorts them in
  /// descending order by creation date.
  ///
  /// Returns a list of [NotificationsDetails].
  ///
  /// Throws an [ApiException] if there is an error during fetching.
  Future<List<NotificationsDetails>> fetchNotifications() async {
    try {
      Box notificationBox = Hive.box(notificationsBoxKey);
      List<NotificationsDetails> notifications = [];

      for (var notificationKey in notificationBox.keys.toList()) {
        notifications.add(
          NotificationsDetails.fromJson(
            Map.from(notificationBox.get(notificationKey) ?? {}),
          ),
        );
      }

      final currentUserNis = AuthRepository.getStudentDetails().nis;

      notifications = notifications
          .where((element) => element.nis == currentUserNis)
          .toList();

      notifications.sort(
        (first, second) => second.createdAt.compareTo(first.createdAt),
      );

      return notifications;
    } catch (e, st) {
      if (kDebugMode) {
        print(
          "Error on fetchNotifications : ${e.toString()}, ${st.toString()}",
        );
      }
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  /// Temporarily stores a notification received in the background.
  ///
  /// This method is used to save incoming notifications (as a JSON map) to
  /// [SharedPreferences]. This is a temporary holding area for notifications
  /// that can be processed later, for instance, when the app is opened.
  ///
  /// - [data]: The notification payload as a `Map<String, dynamic>`.
  static Future<void> addNotificationTemporarily({
    required Map<String, dynamic> data,
  }) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.reload();
      List<String> notifications =
          sharedPreferences.getStringList(temporarilyStoredNotificationsKey) ??
          List<String>.from([]);

      notifications.add(jsonEncode(data));

      await sharedPreferences.setStringList(
        temporarilyStoredNotificationsKey,
        notifications,
      );

      debugPrint("addNotificationTemporarily success");
    } catch (_) {
      // Errors are silently ignored.
      debugPrint("addNotificationTemporarily failed");
    }
  }

  /// Retrieves all temporarily stored notifications.
  ///
  /// This method fetches the list of JSON-encoded notification strings from
  /// [SharedPreferences], decodes them into a list of maps, and returns them.
  ///
  /// Returns a `Future<List<Map<String, dynamic>>>`.
  static Future<List<Map<String, dynamic>>>
  getTemporarilyStoredNotifications() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    List<String> notifications =
        sharedPreferences.getStringList(temporarilyStoredNotificationsKey) ??
        List<String>.from([]);

    return notifications
        .map(
          (notificationData) =>
              Map<String, dynamic>.from(jsonDecode(notificationData) ?? {}),
        )
        .toList();
  }

  /// Clears all temporarily stored notifications.
  ///
  /// This method removes all notifications from the temporary storage in
  /// [SharedPreferences]. It is typically called after the notifications
  /// have been processed and moved to persistent storage.
  static Future<void> clearTemporarilyNotification() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList(temporarilyStoredNotificationsKey, []);
  }

  Future<bool> sendTestNotification() async {
    final nis = AuthRepository.getStudentDetails().nis;

    final bodyNotification = {
      "targetNis": [nis],
      "title": "Push Notification Aktif",
      "body":
          "Ini adalah tampilan notifikasi MyBudiLuhur yang akan muncul di device kamu",
      "data": {
        "type": "general",
        "createdAt": DateTime.now().toIso8601String(),
      },
    };
    try {
      final response = await ApiClient.post(
        body: bodyNotification,
        url: ApiEndpoints.sendNotification,
        useAuthToken: true,
      );

      if (response["error"] == true) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      rethrow;
    }
  }
}
