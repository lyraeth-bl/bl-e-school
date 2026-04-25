import 'package:dio/dio.dart';

import '../../../features/features.dart';

class AuthInterceptor extends Interceptor {
  final SessionsRepository sessionsRepository;
  final SessionsBloc sessionsBloc;

  AuthInterceptor({
    required this.sessionsRepository,
    required this.sessionsBloc,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final skip = options.extra['skipAuthInterceptor'] == true;

    if (!skip) {
      final token = await sessionsRepository.getAccessToken();

      if (token != null && token.isNotEmpty) {
        options.headers["Authorization"] = "Bearer $token";
      }
    }

    options.headers["Accept"] = "application/json";

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await sessionsRepository.clearSession();

      sessionsBloc.add(SessionsEvent.loggedOut());
    }
    handler.next(err);
  }
}
