import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<void> initRegisterGoogleFontsLicences() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');

    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
}
