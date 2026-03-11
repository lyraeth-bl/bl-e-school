import 'dart:convert';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsRepository {
  static Future<void> addNotification({
    required NotificationsDetails notificationDetails,
  }) async {
    try {
      await Hive.box(notificationsBoxKey).put(
        notificationDetails.createdAt.toString(),
        notificationDetails.toJson(),
      );
    } catch (_) {}
  }

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

      final currentUserNIS = sI<SessionsRepository>()
          .getLoggedStudentDetails()
          ?.nis;

      notifications = notifications
          .where((element) => element.nis == currentUserNIS)
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
      debugPrint("addNotificationTemporarily failed");
    }
  }

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

  static Future<void> clearTemporarilyNotification() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList(temporarilyStoredNotificationsKey, []);
  }

  Future<bool> sendTestNotification() async {
    final nis = sI<SessionsRepository>().getLoggedStudentDetails()?.nis;

    final bodyNotification = {
      "targetNis": "${[nis]}",
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
        url: ApiEndpoints.sendNotificationSanctum,
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
