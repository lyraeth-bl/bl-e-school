import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_token.freezed.dart';
part 'device_token.g.dart';

/// Represents a device token used for push notifications.
///
/// This model stores information about a specific device, including the user it belongs to,
/// the platform, and the token itself, which is necessary for sending targeted notifications.
@freezed
abstract class DeviceToken with _$DeviceToken {
  /// Creates an instance of [DeviceToken].
  ///
  /// - [id]: The unique identifier for the device token record.
  /// - [nis]: The student's NIS (Nomor Induk Siswa) associated with this device.
  /// - [token]: The actual push notification token provided by the platform (FCM, APNS).
  /// - [platform]: The operating system of the device (e.g., "android" or "ios").
  /// - [appVersion]: The version of the application installed on the device.
  /// - [lastActiveAt]: The timestamp when the user was last active on this device.
  /// - [createdAt]: The timestamp when the device token was first created.
  /// - [updatedAt]: The timestamp of the last update to this record.
  const factory DeviceToken({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'NIS') required String nis,
    @JsonKey(name: 'token') required String token,
    @JsonKey(name: 'platform') required String platform,
    @JsonKey(name: 'app_version') String? appVersion,
    @JsonKey(name: 'last_active_at') DateTime? lastActiveAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _DeviceToken;

  /// Creates a [DeviceToken] instance from a JSON map.
  ///
  /// This factory is used for deserializing the JSON response from the API
  /// into a `DeviceToken` object.
  factory DeviceToken.fromJson(Map<String, dynamic> json) =>
      _$DeviceTokenFromJson(json);
}
