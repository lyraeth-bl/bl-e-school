import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static Widget routeInstance() {
    return AboutUsScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: CustomMaterialAppBar(titleKey: aboutUsKey),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            CustomButtonContainer(
              onTap: () => Get.to(AboutUsBudiLuhurScreen(isSMK: false)),
              textKey: "SMA Budi Luhur",
            ),

            SizedBox(height: 12),

            CustomButtonContainer(
              onTap: () => Get.to(AboutUsBudiLuhurScreen(isSMK: true)),
              textKey: "SMK Budi Luhur",
            ),
          ],
        ),
      ),
    );
  }
}
