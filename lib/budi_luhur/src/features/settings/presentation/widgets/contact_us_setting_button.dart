import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../utils/shared/label_keys/label_keys.dart';
import '../../../../utils/shared/ui/custom_button_container.dart';

class ContactUsSettingButton extends StatelessWidget {
  const ContactUsSettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButtonContainer(
      onTap: () => Get.toNamed(BudiLuhurRoutes.contactUs),
      textKey: contactUsKey,
      leadingIcon: LucideIcons.hotel,
    );
  }
}
