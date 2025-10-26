import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Registers the license for the Google Fonts used in the application.
///
/// This function loads the OFL.txt license file from the assets and adds it
/// to the [LicenseRegistry]. This ensures that the font licenses are
/// available in the application's license page.
Future<void> initRegisterGoogleFontsLicences() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');

    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
}
