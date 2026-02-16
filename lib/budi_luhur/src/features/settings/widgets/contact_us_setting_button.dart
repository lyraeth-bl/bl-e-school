import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
