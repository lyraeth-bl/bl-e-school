import 'dart:io';

/// A custom [HttpOverrides] implementation that bypasses SSL certificate validation.
///
/// This class is used to prevent handshake errors that can occur on some devices
/// when connecting to servers with self-signed or invalid SSL certificates.
///
/// **Warning:** This should only be used for development and testing purposes.
/// Using this in a production environment is highly discouraged as it exposes
/// the application to security risks, such as man-in-the-middle attacks.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      // This callback accepts all certificates, effectively disabling validation.
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
