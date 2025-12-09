import 'dart:io';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// A client for making HTTP requests to the application's API.
///
/// This class acts as a wrapper around the [Dio] library, providing a simplified
/// and centralized way to interact with the backend API. It includes static methods
/// for common HTTP verbs (GET, POST, PUT, DELETE) and file downloads.
///
/// Key features:
/// - Automatic addition of authentication headers.
/// - Centralized and consistent error handling, converting [DioException]s into
///   a custom [ApiException].
/// - Request and response logging in debug mode for easier debugging.
/// - Simplified interface for multipart form data requests (for POST and PUT).
class ApiClient {
  /// A static Dio instance shared across all API client methods.
  ///
  /// It is configured with a logger for debug builds to provide detailed
  /// information about network requests and responses.
  static final Dio _dio = _createDio();

  /// Creates and configures a [Dio] instance.
  static Dio _createDio() {
    final dio = Dio();
    // Add logger for debug builds
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
    return dio;
  }

  /// Constructs the request headers, including the authorization token if available.
  ///
  /// Retrieves the JWT token from [AuthRepository] and includes it in the
  /// "Authorization" header as a Bearer token. It also sets the "Accept" header
  /// to "application/json".
  ///
  /// Returns a map of headers for the HTTP request.
  static Map<String, dynamic> _headers() {
    final String jwtToken = AuthRepository().getJwtToken();
    return {
      "Authorization": "Bearer $jwtToken",
      "Accept": "application/json",
    };
  }

  /// Performs a GET request.
  ///
  /// - [url]: The endpoint URL for the request.
  /// - [useAuthToken]: If `true`, includes the authentication token in the request headers.
  /// - [queryParameters]: (Optional) A map of key-value pairs to be appended to the URL as query parameters.
  ///
  /// Returns a `Future<Map<String, dynamic>>` containing the JSON response data.
  ///
  /// Throws an [ApiException] with a specific error code in case of failure:
  /// - [ErrorMessageKeysAndCode.unauthenticatedErrorCode] for 401 Unauthorized.
  /// - [ErrorMessageKeysAndCode.internetServerErrorCode] for 500/503 Server Errors.
  /// - [ErrorMessageKeysAndCode.noInternetCode] for socket exceptions (no internet).
  /// - [ErrorMessageKeysAndCode.defaultErrorMessageCode] for other Dio errors.
  /// - [ErrorMessageKeysAndCode.defaultErrorMessageKey] for any other exceptions.
  static Future<Map<String, dynamic>> get({
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: useAuthToken ? Options(headers: _headers()) : null,
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
  /// The request body is sent as `multipart/form-data`.
  ///
  /// - [body]: The data to be sent in the request body.
  /// - [url]: The endpoint URL.
  /// - [useAuthToken]: Whether to include the authentication token in the headers.
  /// - [queryParameters]: Optional parameters to be appended to the URL.
  /// - [cancelToken]: (Optional) A token to cancel the request.
  /// - [onSendProgress]: (Optional) A callback for tracking upload progress.
  /// - [onReceiveProgress]: (Optional) A callback for tracking download progress of the response.
  ///
  /// Returns a `Future<Map<String, dynamic>>` containing the response data.
  ///
  /// Throws an [ApiException] with a specific error code in case of failure.
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

      final response = await _dio.put(
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
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  /// Performs a POST request, typically for creating new data.
  ///
  /// The request body is sent as `multipart/form-data`.
  ///
  /// - [body]: The data to be sent in the request body.
  /// - [url]: The endpoint URL.
  /// - [useAuthToken]: Whether to include the authentication token in the headers.
  /// - [queryParameters]: Optional parameters to be appended to the URL.
  /// - [cancelToken]: (Optional) A token to cancel the request.
  /// - [onSendProgress]: (Optional) A callback for tracking upload progress.
  /// - [onReceiveProgress]: (Optional) A callback for tracking download progress of the response.
  ///
  /// Returns a `Future<Map<String, dynamic>>` containing the response data.
  ///
  /// Throws an [ApiException] with a specific error code in case of failure.
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
      final FormData formData = FormData.fromMap(
        body,
        ListFormat.multiCompatible,
      );

      final response = await _dio.post(
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
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  /// Downloads a file from the given [url] and saves it to [savePath].
  ///
  /// - [url]: The URL of the file to download.
  /// - [savePath]: The local path where the file will be saved.
  /// - [updateDownloadedPercentage]: A callback that reports the download progress
  ///   as a percentage (0.0 to 100.0).
  /// - [cancelToken]: (Optional) A token to cancel the download operation.
  ///
  /// Returns `Future<void>`.
  ///
  /// Throws an [ApiException] in case of failure, with specific codes for
  /// server errors (500/503), file not found (404), or no internet connection.
  static Future<void> download({
    required String url,
    required String savePath,
    required Function(double) updateDownloadedPercentage,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dio.download(
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

  /// Performs a DELETE request, typically for deleting a resource.
  ///
  /// - [url]: The endpoint URL for the resource to delete.
  /// - [useAuthToken]: If `true`, includes the authentication token in the request headers.
  ///
  /// Returns `Future<void>`. The future completes if the request is successful.
  ///
  /// Throws an [ApiException] with a specific error code in case of failure.
  static Future<void> delete({
    required String url,
    required bool useAuthToken,
  }) async {
    try {
      await _dio.delete(
        url,
        options: useAuthToken ? Options(headers: _headers()) : null,
      );
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
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }
}
