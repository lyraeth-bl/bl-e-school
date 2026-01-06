import 'dart:io';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// A simple and professional API client for making HTTP requests.
class ApiClient {
  /// The Dio instance for making requests.
  static late Dio dio;

  /// Initializes the [ApiClient] with a [Dio] instance.
  static void init({required Dio dioInstance}) {
    dio = dioInstance;
  }

  /// Returns the authorization headers.
  static Map<String, dynamic> _headers() {
    final String jwtToken = AuthRepository().getJwtToken();
    return {"Authorization": "Bearer $jwtToken", "Accept": "application/json"};
  }

  /// Sends a GET request.
  static Future<Map<String, dynamic>> get({
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: useAuthToken ? Options(headers: _headers()) : null,
      );
      return Map.from(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  /// Sends a PUT request.
  static Future<Map<String, dynamic>> put({
    required Map<String, dynamic> body,
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final FormData formData = FormData.fromMap(
        body,
        ListFormat.multiCompatible,
      );

      final response = await dio.put(
        url,
        data: formData,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: useAuthToken ? Options(headers: _headers()) : null,
      );

      return Map.from(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.response?.data);
      }
      _handleDioError(e);
      rethrow;
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  /// Sends a POST request.
  static Future<Map<String, dynamic>> post({
    required Map<String, dynamic> body,
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
    Map<String, dynamic>? extra,
  }) async {
    try {
      final FormData formData = FormData.fromMap(
        body,
        ListFormat.multiCompatible,
      );

      final response = await dio.post(
        url,
        data: formData,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: useAuthToken
            ? Options(headers: _headers(), extra: extra)
            : null,
      );

      return Map.from(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.response?.data);
      }
      _handleDioError(e);
      rethrow;
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  /// Downloads a file.
  static Future<void> download({
    required String url,
    required String savePath,
    required Function(double) updateDownloadedPercentage,
    CancelToken? cancelToken,
  }) async {
    try {
      await dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) {
          if (total != -1) {
            final double percentage = (count / total) * 100;
            updateDownloadedPercentage(percentage);
          }
        },
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  /// Sends a DELETE request.
  static Future<void> delete({
    required String url,
    required bool useAuthToken,
  }) async {
    try {
      await dio.delete(
        url,
        options: useAuthToken ? Options(headers: _headers()) : null,
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  /// Handles Dio errors and throws an [ApiException].
  static void _handleDioError(DioException e) {
    if (e.error is SocketException) {
      throw ApiException(ErrorMessageKeysAndCode.noInternetCode);
    }

    if (e.response?.statusCode == 503 || e.response?.statusCode == 500) {
      throw ApiException(ErrorMessageKeysAndCode.internetServerErrorCode);
    }

    if (e.response?.statusCode == 401) {
      throw ApiException(ErrorMessageKeysAndCode.unauthenticatedErrorCode);
    }

    throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageCode);
  }
}
