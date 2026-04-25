import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../utils/shared/label_keys/label_keys.dart';
import '../../../../utils/shared/ui/custom_button_container.dart';

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
