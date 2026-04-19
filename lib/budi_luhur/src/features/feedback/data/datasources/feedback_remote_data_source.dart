import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../utils/shared/types/types.dart';
import '../model/feedback_request/feedback_request.dart';
import '../model/feedback_response/feedback_response.dart';

abstract class FeedbackRemoteDataSource {
  Future<Result<FeedbackResponse>> sendFeedback(
    FeedbackRequest feedbackRequest,
  );

  Future<Result<FeedbackResponse>> fetchFeedback();

  Future<Result<FeedbackResponse>> editFeedback({
    required int id,
    required FeedbackRequest feedbackRequest,
  });

  Future<Unit> deleteFeedback({required int id});
}

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  @override
  Future<Unit> deleteFeedback({required int id}) async {
    await ApiClient.delete(url: "${ApiEndpoints.feedbackSanctum}/$id");

    return unit;
  }

  @override
  Future<Result<FeedbackResponse>> editFeedback({
    required int id,
    required FeedbackRequest feedbackRequest,
  }) async {
    try {
      final Map<String, dynamic> data = FeedbackRequest(
        message: feedbackRequest.message,
        type: feedbackRequest.type,
        os: feedbackRequest.os,
        appVersion: feedbackRequest.appVersion,
        category: feedbackRequest.category,
        attachment: feedbackRequest.attachment,
      ).toJson();

      final response = await ApiClient.put(
        body: data,
        url: "${ApiEndpoints.feedbackSanctum}/$id",
      );

      return Right(FeedbackResponse.fromJson(response));
    } catch (e) {
      return Left(Failure.fromDio(e));
    }
  }

  @override
  Future<Result<FeedbackResponse>> fetchFeedback() async {
    try {
      final response = await ApiClient.get(url: ApiEndpoints.feedbackSanctum);

      return Right(FeedbackResponse.fromJson(response));
    } catch (e) {
      return Left(Failure.fromDio(e));
    }
  }

  @override
  Future<Result<FeedbackResponse>> sendFeedback(
    FeedbackRequest feedbackRequest,
  ) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final String resolvedAppVersion = packageInfo.version;
      final String resolvedOs = Platform.isIOS ? "iOS" : "Android";

      // Build base payload (exclude null values where possible)
      final Map<String, dynamic> data = FeedbackRequest(
        message: feedbackRequest.message,
        attachment: feedbackRequest.attachment,
        category: feedbackRequest.category,
        type: feedbackRequest.type,
        appVersion: resolvedAppVersion,
        os: resolvedOs,
      ).toJson();

      // If attachment path provided and file exists -> convert to MultipartFile
      if (feedbackRequest.attachment != null) {
        final File file = File(feedbackRequest.attachment!);
        if (await file.exists()) {
          final String filename = path.basename(file.path);
          final MultipartFile multipartFile = await MultipartFile.fromFile(
            file.path,
            filename: filename,
          );

          data['attachments'] = multipartFile;
        } else {
          if (kDebugMode) {
            debugPrint(
              'Attachment path provided but file does not exist: ${feedbackRequest.attachment}',
            );
          }
        }
      }

      final response = await ApiClient.post(
        body: data,
        url: ApiEndpoints.feedbackSanctum,
      );

      return Right(FeedbackResponse.fromJson(response));
    } catch (e) {
      return Left(Failure.fromDio(e));
    }
  }
}
