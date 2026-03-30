import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      // This callback accepts all certificates, effectively disabling validation.
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
