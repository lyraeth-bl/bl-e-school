import 'dart:io';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class AppUpdateButtonDownload extends StatefulWidget {
  final String appUrlDownload;

  const AppUpdateButtonDownload({super.key, required this.appUrlDownload});

  @override
  State<AppUpdateButtonDownload> createState() =>
      _AppUpdateButtonDownloadState();
}

class _AppUpdateButtonDownloadState extends State<AppUpdateButtonDownload> {
  // Track download states for each file URL
  final Map<String, bool> _downloadingFiles = {};

  Future<String?> _downloadFromUrl(String url) async {
    final fileName = url.split("/").last;
    debugPrint("Filename : $fileName");
    final notificationId = fileName.hashCode;

    try {
      final dirs = await getExternalStorageDirectories(
        type: StorageDirectory.downloads,
      );
      debugPrint("dirs : $dirs");

      if (dirs == null || dirs.isEmpty) {
        throw Exception("Download directory not found");
      }

      final downloadDir = dirs.first;
      final mediaDir = Directory("${downloadDir.path}/MyBudiLuhur");
      debugPrint("mediaDir : $mediaDir");

      // Create Media directory if it doesn't exist
      if (!await mediaDir.exists()) {
        await mediaDir.create(recursive: true);
        debugPrint("Create media success");
      }

      final path = "${mediaDir.path}/$fileName";
      debugPrint("Path : $path");
      final file = File(path);
      debugPrint("File : $file");

      // Check if file already exists locally
      if (await file.exists()) {
        debugPrint("File exist");
        // File exists, return path immediately for instant access
        return path;
      }

      // File doesn't exist, need to download it
      // Set loading state for UI
      setState(() {
        _downloadingFiles[url] = true;
      });

      // Show initial download notification
      await NotificationsUtility.showDownloadNotification(
        notificationId: notificationId,
        fileName: fileName,
        progress: 0,
      );

      // Create cancel token for the download
      final cancelToken = CancelToken();

      // Download the file with progress tracking using custom API method
      await ApiClient.download(
        url: url,
        savePath: path,
        cancelToken: cancelToken,
        updateDownloadedPercentage: (double percentage) async {
          final progress = percentage.round();

          // Update notification progress
          await NotificationsUtility.updateDownloadNotification(
            notificationId: notificationId,
            fileName: fileName,
            progress: progress,
          );
        },
      );

      // Verify file was downloaded successfully
      if (await File(path).exists()) {
        // Show completion notification
        await NotificationsUtility.showDownloadCompleteNotification(
          notificationId: notificationId,
          fileName: fileName,
        );

        // Install app
        await installApk(path);
      } else {
        throw Exception('File was not downloaded properly');
      }

      return path;
    } catch (e) {
      // Show error notification
      await NotificationsUtility.showDownloadErrorNotification(
        notificationId: notificationId,
        fileName: fileName,
        error: e.toString(),
      );

      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    } finally {
      if (mounted) {
        setState(() {
          _downloadingFiles[url] = false;
        });
      }
    }
  }

  Future<void> installApk(String apkPath) async {
    final result = await OpenFilex.open(
      apkPath,
      type: "application/vnd.android.package-archive",
    );

    debugPrint("Install result: ${result.message}");
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () {
        _downloadFromUrl(widget.appUrlDownload);
        Get.back();
      },
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
        ),
      ),
      child: Text(
        Utils.getTranslatedLabel(downloadKey),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }
}
