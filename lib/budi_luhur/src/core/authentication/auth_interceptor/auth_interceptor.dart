import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:dio/dio.dart';

/// A Dio interceptor for handling authentication and token refreshing.
///
/// This interceptor automatically adds the JWT token to outgoing requests
/// and handles 401 Unauthorized errors by attempting to refresh the token.
class AuthInterceptor extends Interceptor {
  /// The Dio instance used for making requests.
  final Dio dio;

  /// The authentication cubit for managing authentication state.
  final AuthCubit authCubit;

  bool _isRefreshing = false;

  /// Creates an [AuthInterceptor].
  ///
  /// Requires a [Dio] instance and an [AuthCubit].
  AuthInterceptor({required this.dio, required this.authCubit});

  /// Intercepts Dio errors.
  ///
  /// If a 401 Unauthorized error occurs, it attempts to refresh the token.
  /// If token refresh is successful, the original request is retried with the new token.
  /// If token refresh fails, the user is signed out.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final skip = err.requestOptions.extra['skipAuthInterceptor'] == true;
    if (skip) return handler.next(err);

    final isAuth = authCubit.state.maybeWhen(
      authenticated: (_, __, ___) => true,
      orElse: () => false,
    );

    if (!isAuth || err.response?.statusCode != 401) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      return handler.next(err);
    }

    _isRefreshing = true;

    bool refreshed = false;
    try {
      refreshed = await authCubit.biometricRefreshToken();
    } catch (_) {
      refreshed = false;
    }

    if (!refreshed) {
      authCubit.signOut(reason: LogoutReason.sessionExpired);
      _isRefreshing = false;
      return;
    }

    _isRefreshing = false;

    final opts = err.requestOptions;
    final newHeaders = Map<String, dynamic>.from(opts.headers);
    newHeaders['Authorization'] = 'Bearer ${authCubit.getJwtToken}';

    try {
      final response = await dio.request(
        opts.path,
        data: opts.data,
        queryParameters: opts.queryParameters,
        options: Options(method: opts.method, headers: newHeaders),
      );

      return handler.resolve(response);
    } catch (_) {
      authCubit.signOut(reason: LogoutReason.sessionExpired);
      return;
    }
  }
}
