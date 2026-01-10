import 'dart:io';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// A repository for managing device tokens for push notifications.
///
/// This class is responsible for obtaining the device's FCM (Firebase Cloud Messaging)
/// token and sending it to the application's backend to be associated with a user.
class DeviceTokenRepository {
  /// Retrieves the FCM token and registers it with the backend.
  ///
  /// This method performs the following steps:
  /// 1. Gets the unique FCM token for the device.
  /// 2. Determines the device's platform (iOS or Android).
  /// 3. Sends this information to the backend API.
  ///
  /// - [nis]: The student's NIS (Nomor Induk Siswa) to associate with the device token.
  /// - [appVersion]: The current version of the application.
  ///
  /// Throws an [ApiException] if the API call fails.
  /// Returns a `Future<Map<String, dynamic>>` containing the `DeviceToken`
  /// object returned by the backend on success.
  Future<Map<String, dynamic>> postDeviceToken({
    required String nis,
    String? appVersion,
  }) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final platform = Platform.isIOS ? "ios" : "android";

      final Map<String, dynamic> data = {
        'NIS': nis,
        'token': fcmToken,
        'platform': platform,
        'app_version': appVersion ?? "0.0.3",
      };

      final response = await ApiClient.post(
        body: data,
        url: ApiEndpoints.deviceTokens,
        useAuthToken: true,
      );

      if (kDebugMode) {
        debugPrint("Post Device Token success");
      }

      return {'deviceToken': DeviceToken.fromJson(Map.from(response['data']))};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
