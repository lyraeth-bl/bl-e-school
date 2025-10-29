import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_token_cubit.freezed.dart';
part 'device_token_state.dart';

/// A [Cubit] for managing the state of device token registration.
///
/// This cubit interacts with the [DeviceTokenRepository] to send the device's
/// push notification token to the backend. It emits states to reflect the
/// progress of this operation, such as loading, success, or failure.
class DeviceTokenCubit extends Cubit<DeviceTokenState> {
  final DeviceTokenRepository _deviceTokenRepository;

  /// Creates an instance of [DeviceTokenCubit].
  ///
  /// Requires a [DeviceTokenRepository] to handle the underlying API communication.
  DeviceTokenCubit(this._deviceTokenRepository) : super(_Initial());

  /// Registers the device token with the backend.
  ///
  /// This method orchestrates the process of sending the device token:
  /// 1. Emits a [_Loading] state to indicate the operation has started.
  /// 2. Calls the repository to post the token to the backend.
  /// 3. On success, emits a [_Success] state with the returned [DeviceToken].
  /// 4. On failure, emits a [_Failure] state with an error message.
  ///
  /// - [nis]: The student's NIS (Nomor Induk Siswa) to associate with the token.
  /// - [appVersion]: The optional application version.
  Future<void> postDeviceToken({
    required String nis,
    String? appVersion,
  }) async {
    emit(_Loading());

    try {
      final result = await _deviceTokenRepository.postDeviceToken(nis: nis);

      emit(_Success(deviceToken: result['deviceToken']));
    } catch (e) {
      emit(_Failure(e.toString()));
    }
  }
}
