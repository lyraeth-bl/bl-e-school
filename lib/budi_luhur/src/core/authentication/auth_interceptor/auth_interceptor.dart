import 'package:bl_e_school/budi_luhur/src/features/sessions/presentation/bloc/sessions_bloc.dart';
import 'package:bl_e_school/budi_luhur/src/features/sessions/repository/sessions_repository.dart';
import 'package:dio/dio.dart';

/// A Dio interceptor for handling authentication and token refreshing.
///
/// This interceptor automatically adds the JWT token to outgoing requests
/// and handles 401 Unauthorized errors by attempting to refresh the token.
class AuthInterceptor extends Interceptor {
  final SessionsRepository sessionsRepository;
  final SessionsBloc sessionsBloc;

  /// Creates an [AuthInterceptor].
  ///
  /// Requires a [Dio] instance and an [AuthCubit].
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

  /// Intercepts Dio errors.
  ///
  /// If a 401 Unauthorized error occurs, it attempts to refresh the token.
  /// If token refresh is successful, the original request is retried with the new token.
  /// If token refresh fails, the user is signed out.
  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401) {
      await sessionsRepository.clearSession();

      sessionsBloc.add(SessionsEvent.loggedOut());
    }
    handler.next(error);
  }
}
