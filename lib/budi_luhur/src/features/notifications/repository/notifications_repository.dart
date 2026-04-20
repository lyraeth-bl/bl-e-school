import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_client.dart';
import '../../../core/dependencies_injection/get_it_instance.dart';
import '../../../core/storage/hive_box_keys/hive_box_keys.dart';
import '../../../utils/shared/error_handling/error_message_and_code.dart';
import '../../sessions/repository/sessions_repository.dart';
import '../data/model/notifications_details/notifications_details.dart';

const String _tempNotifKey = 'temp_notifications_queue';

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
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();

      final existing = prefs.getStringList(_tempNotifKey) ?? [];
      existing.add(jsonEncode(data));

      await prefs.setStringList(_tempNotifKey, existing);

      debugPrint(
        '[Notif] addNotificationTemporarily success (total: ${existing.length})',
      );
      debugPrint('[Notif] Key used: $_tempNotifKey');
    } catch (e) {
      debugPrint('[Notif] addNotificationTemporarily failed: $e');
    }
  }

  static Future<List<Map<String, dynamic>>>
  getTemporarilyStoredNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    // Cek kedua key — key lama (dengan titik) dan key baru — untuk migrasi.
    // Setelah semua user pakai versi baru, bisa hapus baris key lama.
    final fromOldKey =
        prefs.getStringList(temporarilyStoredNotificationsKey) ?? [];
    final fromNewKey = prefs.getStringList(_tempNotifKey) ?? [];

    final all = [...fromOldKey, ...fromNewKey];

    debugPrint(
      '[Notif] getTemporarilyStoredNotifications: found ${all.length} items '
      '(old key: ${fromOldKey.length}, new key: ${fromNewKey.length})',
    );

    if (fromOldKey.isNotEmpty) {
      // Migrate: hapus key lama supaya tidak kebaca dobel lain kali
      await prefs.remove(temporarilyStoredNotificationsKey);
      debugPrint('[Notif] Migrated ${fromOldKey.length} items from old key');
    }

    return all
        .map((item) => Map<String, dynamic>.from(jsonDecode(item)))
        .toList();
  }

  static Future<void> clearTemporarilyNotification() async {
    final prefs = await SharedPreferences.getInstance();
    // await wajib — kalau tidak di-await, clear bisa belum selesai
    // sebelum fetchNotifications selesai dan notif kebaca lagi.
    await prefs.remove(_tempNotifKey);
    await prefs.remove(
      temporarilyStoredNotificationsKey,
    ); // clear key lama juga
    debugPrint('[Notif] Temporary notifications cleared.');
  }

  Future<bool> sendTestNotification() async {
    final nis = sI<SessionsRepository>().getLoggedStudentDetails()?.nis;

    final bodyNotification = {
      "targetNis": nis,
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
