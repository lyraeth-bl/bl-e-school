import 'dart:io';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// A client for making HTTP requests to the application's API.
///
/// This class provides static methods for performing GET, POST, PUT, and download
/// operations. It handles common tasks such as adding authentication headers,
/// logging requests and responses (in debug mode), and managing various
/// error scenarios.
class ApiClient {
  /// Constructs the request headers, including the authorization token if available.
  ///
  /// Retrieves the JWT token from [AuthRepository] and includes it in the
  /// "Authorization" header as a Bearer token.
  /// Returns a map of headers for the HTTP request.
  static Map<String, dynamic> headers() {
    final String jwtToken = AuthRepository().getJwtToken();

    return {"Authorization": "Bearer $jwtToken", "Accept": "application/json"};
  }

  /// Performs a GET request.
  ///
  /// - [url]: The endpoint URL.
  /// - [useAuthToken]: Whether to include the authentication token in the headers.
  /// - [queryParameters]: Optional parameters to be appended to the URL.
  ///
  /// Throws an [ApiException] if the request fails, with a code indicating the error type.
  /// Returns a `Future<Map<String, dynamic>>` containing the response data if successful.
  static Future<Map<String, dynamic>> get({
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Dio dio = Dio();

      dio.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true),
      );

      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: useAuthToken ? Options(headers: headers()) : null,
      );

      return Map.from(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ApiException(ErrorMessageKeysAndCode.unauthenticatedErrorCode);
      }
      if (e.response?.statusCode == 503 || e.response?.statusCode == 500) {
        throw ApiException(ErrorMessageKeysAndCode.internetServerErrorCode);
      }
      throw ApiException(
        e.error is SocketException
            ? ErrorMessageKeysAndCode.noInternetCode
            : ErrorMessageKeysAndCode.defaultErrorMessageCode,
      );
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  /// Performs a PUT request, typically for updating existing data.
  ///
  /// - [body]: The data to be sent in the request body.
  /// - [url]: The endpoint URL.
  /// - [useAuthToken]: Whether to include the authentication token in the headers.
  /// - Other optional parameters for cancellation and progress tracking.
  ///
  /// Throws an [ApiException] if the request fails.
  /// Returns a `Future<Map<String, dynamic>>` containing the response data if successful.
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
      final Dio dio = Dio();

      final FormData formData = FormData.fromMap(
        body,
        ListFormat.multiCompatible,
      );

      dio.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true),
      );

      final response = await dio.put(
        url,
        data: formData,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: useAuthToken ? Options(headers: headers()) : null,
      );

      return Map.from(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.response?.data);
      }
      if (e.response?.statusCode == 503 || e.response?.statusCode == 500) {
        throw ApiException(ErrorMessageKeysAndCode.internetServerErrorCode);
      }

      throw ApiException(
        e.error is SocketException
            ? ErrorMessageKeysAndCode.noInternetCode
            : ErrorMessageKeysAndCode.defaultErrorMessageCode,
      );
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  /// Performs a POST request, typically for creating new data.
  ///
  /// - [body]: The data to be sent in the request body.
  /// - [url]: The endpoint URL.
  /// - [useAuthToken]: Whether to include the authentication token in the headers.
  /// - Other optional parameters for cancellation and progress tracking.
  ///
  /// Throws an [ApiException] if the request fails.
  /// Returns a `Future<Map<String, dynamic>>` containing the response data if successful.
  static Future<Map<String, dynamic>> post({
    required Map<String, dynamic> body,
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final Dio dio = Dio();

      final FormData formData = FormData.fromMap(
        body,
        ListFormat.multiCompatible,
      );

      dio.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true),
      );

      final response = await dio.post(
        url,
        data: formData,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: useAuthToken ? Options(headers: headers()) : null,
      );

      return Map.from(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.response?.data);
      }
      if (e.response?.statusCode == 503 || e.response?.statusCode == 500) {
        throw ApiException(ErrorMessageKeysAndCode.internetServerErrorCode);
      }

      throw ApiException(
        e.error is SocketException
            ? ErrorMessageKeysAndCode.noInternetCode
            : ErrorMessageKeysAndCode.defaultErrorMessageCode,
      );
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  /// Downloads a file from the given [url] and saves it to [savePath].
  ///
  /// - [url]: The URL of the file to download.
  /// - [cancelToken]: A token to cancel the download operation.
  /// - [savePath]: The local path where the file will be saved.
  /// - [updateDownloadedPercentage]: A callback to report download progress.
  ///
  /// Throws an [ApiException] if the download fails.
  static Future<void> download({
    required String url,
    required CancelToken cancelToken,
    required String savePath,
    required Function updateDownloadedPercentage,
  }) async {
    try {
      final Dio dio = Dio();

      await dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) {
          final double percentage = (count / total) * 100;
          updateDownloadedPercentage(percentage < 0.0 ? 99.0 : percentage);
        },
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 503 || e.response?.statusCode == 500) {
        throw ApiException(ErrorMessageKeysAndCode.internetServerErrorCode);
      }
      if (e.response?.statusCode == 404) {
        throw ApiException(ErrorMessageKeysAndCode.fileNotFoundErrorCode);
      }
      throw ApiException(
        e.error is SocketException
            ? ErrorMessageKeysAndCode.noInternetCode
            : ErrorMessageKeysAndCode.defaultErrorMessageCode,
      );
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }
}
