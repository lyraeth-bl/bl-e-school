import 'dart:io';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// A repository for handling user feedback.
///
/// This repository provides methods for sending, retrieving, editing, and deleting feedback.
/// It also interacts with local storage to cache feedback data.
class FeedbackRepository {
  /// Sends user feedback to the server.
  ///
  /// The [nis] is the user's student identification number.
  /// The [message] is the feedback content.
  /// The optional [category] specifies the feedback category.
  /// The optional [type] specifies the feedback type.
  /// The optional [attachment] is a URL to an attachment.
  ///
  /// Throws an [ApiException] if the request fails.
  Future<void> sendFeedback({
    required String nis,
    required String message,
    String? category,
    FeedbackType? type,
    String? attachment,
  }) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final String resolvedAppVersion = packageInfo.version;
    final String resolvedOs = Platform.isIOS ? "iOS" : "Android";

    final Map<String, dynamic> data = {
      "nis": nis,
      "message": message,
      "category": category,
      "type": type?.name,
      "attachment": attachment,
      "app_version": resolvedAppVersion,
      "os": resolvedOs,
    };

    try {
      final response = await ApiClient.post(
        body: data,
        url: ApiEndpoints.feedback,
        useAuthToken: true,
      );

      final Feedback feedbackMap = response['data'];

      await Future.wait([setStoredFeedbackUser(feedbackMap)]);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Retrieves a user's feedback from the server.
  ///
  /// The [nis] is the user's student identification number.
  ///
  /// Returns a [FeedbackDTO] containing a list of the user's feedback.
  /// Throws an [ApiException] if the request fails.
  Future<FeedbackDTO> getUserFeedback({required String nis}) async {
    try {
      final response = await ApiClient.get(
        url: "${ApiEndpoints.feedback}/$nis",
        useAuthToken: true,
      );

      final List<Feedback> userFeedbackList = (response['data'] as List)
          .map((feedback) => Feedback.fromJson(feedback))
          .toList();

      if (userFeedbackList.isEmpty) {
        return FeedbackDTO(feedbackList: []);
      }

      await Future.wait([setStoredFeedbackUser(userFeedbackList.first)]);

      return FeedbackDTO(feedbackList: userFeedbackList);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Edits a user's feedback on the server.
  ///
  /// The [id] is the ID of the feedback to edit.
  /// The optional [type] is the new feedback type.
  /// The optional [message] is the new feedback message.
  /// The optional [category] is the new feedback category.
  /// The optional [attachment] is the new attachment URL.
  ///
  /// Returns a map containing the edited [Feedback] object.
  /// Throws an [ApiException] if the request fails.
  Future<Map<String, dynamic>> editFeedback({
    required int id,
    FeedbackType? type,
    String? message,
    String? category,
    String? attachment,
  }) async {
    final Map<String, dynamic> data = {
      if (message != null) "message": message,
      if (category != null) "category": category,
      if (type != null) "type": type.name,
      if (attachment != null) "attachment": attachment,
    };

    try {
      final response = await ApiClient.put(
        body: data,
        url: "${ApiEndpoints.feedback}/$id",
        useAuthToken: true,
      );

      final Feedback editedFeedback = Feedback.fromJson(response['data']);

      return {"editedFeedback": editedFeedback};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Deletes a user's feedback from the server.
  ///
  /// The [id] is the ID of the feedback to delete.
  ///
  /// Throws an [ApiException] if the request fails.
  Future<void> deleteFeedback({required int id}) async {
    try {
      await ApiClient.delete(
        url: "${ApiEndpoints.feedback}/$id",
        useAuthToken: true,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Stores a user's feedback in local storage.
  ///
  /// The [feedback] object is stored in a Hive box.
  Future<void> setStoredFeedbackUser(Feedback feedback) =>
      Hive.box(feedbackBoxKey).put(studentFeedbackKey, feedback.toJson());

  /// Clears all stored feedback data from local storage.
  Future<void> clearStoredFeedbackData() => Hive.box(feedbackBoxKey).clear();

  /// Retrieves the stored feedback for the current user.
  ///
  /// Returns a [Feedback] object from the Hive box.
  /// Returns an empty [Feedback] object if no data is found.
  Feedback get getStoredFeedbackUser => Feedback.fromJson(
    Map<String, dynamic>.from(
      Hive.box(feedbackBoxKey).get(studentFeedbackKey) ?? {},
    ),
  );
}
