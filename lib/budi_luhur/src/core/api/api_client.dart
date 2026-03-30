import 'dart:io';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static late Dio dio;

  static void init({required Dio dioInstance}) {
    dio = dioInstance;
  }

  static Future<Map<String, dynamic>> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        data: data,
      );

      return Map.from(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<List<dynamic>> getList({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(url, queryParameters: queryParameters);

      if (response.data.runtimeType != List<dynamic>) {
        debugPrint("Response is not List");
        throw ApiException("Response is not List");
      }

      return response.data;
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

  static Future<Map<String, dynamic>> put({
    required Map<String, dynamic> body,
    required String url,
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

  static Future<Map<String, dynamic>> post({
    required Map<String, dynamic> body,
    required String url,
    Map<String, dynamic>? extra,
  }) async {
    final response = await dio.post(
      url,
      data: FormData.fromMap(body),
      options: Options(extra: extra),
    );

    return Map.from(response.data);
  }

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

  static Future<void> delete({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    try {
      await dio.delete(url, data: data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static void _handleDioError(DioException e) {
    if (e.error is SocketException) {
      throw ApiException(ErrorMessageKeysAndCode.noInternetCode);
    }

    if (e.response?.statusCode == 503 || e.response?.statusCode == 500) {
      throw ApiException(ErrorMessageKeysAndCode.internetServerErrorCode);
    }

    if (e.response?.statusCode == 404) {
      throw ApiException(ErrorMessageKeysAndCode.fileNotFoundErrorCode);
    }

    if (e.response?.statusCode == 401) {
      throw ApiException(ErrorMessageKeysAndCode.unauthenticatedErrorCode);
    }

    throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageCode);
  }
}
