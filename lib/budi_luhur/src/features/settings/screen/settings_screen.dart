import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

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

                  SizedBox(height: 16),

                  DiagnosisSettingButton(),

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
