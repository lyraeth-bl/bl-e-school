import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DiagnosisSettingButton extends StatelessWidget {
  const DiagnosisSettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButtonContainer(
      onTap: () => Get.toNamed(BudiLuhurRoutes.diagnosis),
      textKey: diagnosisKey,
      leadingIcon: LucideIcons.stethoscope,
    );
  }
}
