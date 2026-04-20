import 'package:flutter/material.dart';

import '../../../../utils/utils.dart';
import '../../../../utils/utils_export.dart';
import '../widgets/about_us_settings_button.dart';
import '../widgets/app_version_settings_text.dart';
import '../widgets/change_biometric_settings_button.dart';
import '../widgets/change_language_settings_button.dart';
import '../widgets/contact_us_setting_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static Widget routeInstance() {
    return SettingsScreen();
  }

  Widget _buildAppbar(BuildContext context) {
    return ScreenTopBackgroundContainer(
      padding: EdgeInsets.zero,
      heightPercentage: Utils.appBarSmallerHeightPercentage,
      child: Stack(
        children: [
          Center(
            child: Text(
              Utils.getTranslatedLabel(settingsKey),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: Utils.screenTitleFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.only(
                bottom: Utils.getScrollViewBottomPadding(context),
                top:
                    Utils.getScrollViewTopPadding(
                      context: context,
                      appBarHeightPercentage:
                          Utils.appBarSmallerHeightPercentage,
                    ) -
                    10,
                end: 24,
                start: 24,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ChangeBiometricSettingsButton(),

                  SizedBox(height: 16),

                  ChangeLanguageSettingsButton(),

                  SizedBox(height: 16),

                  AboutUsSettingsButton(),

                  SizedBox(height: 16),

                  ContactUsSettingButton(),

                  // SizedBox(height: 16),
                  //
                  // DiagnosisSettingButton(),
                  SizedBox(height: 24),

                  AppVersionSettingsText(),
                ],
              ),
            ),
          ),

          _buildAppbar(context),
        ],
      ),
    );
  }
}
