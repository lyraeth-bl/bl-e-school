import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AboutUsSettingsButton extends StatelessWidget {
  const AboutUsSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButtonContainer(
      onTap: () => Get.toNamed(BudiLuhurRoutes.aboutUs),
      textKey: aboutUsKey,
      leadingIcon: LucideIcons.circleQuestionMark,
    );
  }
}
