import 'package:awesome_notifications/awesome_notifications.dart';

import '../../utils/utils.dart';
import '../../utils/utils_export.dart';

// ---------------------------------------------------------------------------
// DownloadNotificationService
//
// Dipisah dari FCMService karena:
//   - Masih butuh awesome_notifications untuk NotificationLayout.ProgressBar
//     (flutter_local_notifications tidak support progress bar secemerlang ini)
//   - Scope tanggung jawabnya berbeda: bukan FCM, tapi local progress tracking
//
// Cara pakai:
//   await DownloadNotificationService.showProgress(id: 1, fileName: 'file.pdf', progress: 0);
//   await DownloadNotificationService.updateProgress(id: 1, fileName: 'file.pdf', progress: 60);
//   await DownloadNotificationService.showComplete(id: 1, fileName: 'file.pdf');
//   await DownloadNotificationService.showError(id: 1, fileName: 'file.pdf', error: '...');
// ---------------------------------------------------------------------------
abstract class DownloadNotificationService {
  static const _progressChannel = 'download_channel';
  static const _completeChannel = 'download_complete_channel';

  // ---------------------------------------------------------------------------
  // Inisialisasi channel — panggil sekali saat app start, setelah
  // AwesomeNotifications().initialize() sudah dipanggil di main.
  // ---------------------------------------------------------------------------
  static Future<void> initChannels() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: _progressChannel,
        channelName: 'Download Notifications',
        channelDescription: 'Notifikasi progress download file',
        importance: NotificationImportance.High,
        playSound: false,
        enableVibration: false,
      ),
      NotificationChannel(
        channelKey: _completeChannel,
        channelName: 'Download Complete',
        channelDescription: 'Notifikasi selesai download file',
        importance: NotificationImportance.Max,
        playSound: false,
        enableVibration: false,
      ),
    ]);
  }

  // ---------------------------------------------------------------------------
  // Progress notification (0–100)
  // ---------------------------------------------------------------------------
  static Future<void> showProgress({
    required int id,
    required String fileName,
    required int progress,
  }) async {
    if (!await _isAllowed()) return;
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: _progressChannel,
          title: Utils.getTranslatedLabel(downloadingFileKey),
          body: fileName,
          notificationLayout: NotificationLayout.ProgressBar,
          progress: progress.toDouble(),
          category: NotificationCategory.Progress,
          autoDismissible: false,
          showWhen: true,
        ),
      );
    } catch (_) {}
  }

  static Future<void> updateProgress({
    required int id,
    required String fileName,
    required int progress,
  }) async {
    if (!await _isAllowed()) return;
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: _progressChannel,
          title: '${Utils.getTranslatedLabel(downloadingFileKey)} $progress%',
          body: fileName,
          notificationLayout: NotificationLayout.ProgressBar,
          progress: progress.toDouble(),
          category: NotificationCategory.Progress,
          autoDismissible: false,
          showWhen: true,
        ),
      );
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Completion notification
  // ---------------------------------------------------------------------------
  static Future<void> showComplete({
    required int id,
    required String fileName,
  }) async {
    if (!await _isAllowed()) return;
    try {
      final completeId = id + 1000;

      await AwesomeNotifications().dismiss(id);
      await Future.delayed(const Duration(milliseconds: 100));

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: completeId,
          channelKey: _completeChannel,
          title: '${Utils.getTranslatedLabel(downloadCompleteKey)} ✅',
          body:
              '$fileName\n${Utils.getTranslatedLabel(fileDownloadedSuccessfullyKey)}',
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Status,
          autoDismissible: true,
          showWhen: true,
        ),
      );

      Future.delayed(
        const Duration(seconds: 5),
        () => AwesomeNotifications().dismiss(completeId).ignore(),
      );
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Error notification
  // ---------------------------------------------------------------------------
  static Future<void> showError({
    required int id,
    required String fileName,
    required String error,
  }) async {
    if (!await _isAllowed()) return;
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: _progressChannel,
          title: '${Utils.getTranslatedLabel(downloadFailedKey)} ❌',
          body:
              '${Utils.getTranslatedLabel(failedToDownloadFileKey)} $fileName',
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Error,
          autoDismissible: true,
          showWhen: true,
        ),
      );

      Future.delayed(
        const Duration(seconds: 5),
        () => AwesomeNotifications().dismiss(id).ignore(),
      );
    } catch (_) {}
  }

  static Future<bool> _isAllowed() =>
      AwesomeNotifications().isNotificationAllowed();
}
