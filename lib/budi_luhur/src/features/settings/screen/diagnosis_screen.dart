import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DiagnosisScreen extends StatelessWidget {
  DiagnosisScreen({super.key});

  static Widget routeInstance() {
    return DiagnosisScreen();
  }

  final List<String> listDiagnosis = [diagnosisPushNotificationKey];
  final List<IconData> listLeadingIcon = [LucideIcons.bell];
  final List<String> listPages = [BudiLuhurRoutes.diagnosisPushNotification];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomMaterialAppBar(titleKey: diagnosisKey, centerTitle: true),
      backgroundColor: colorScheme.surfaceContainer,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: List.generate(listDiagnosis.length, (index) {
            final data = listDiagnosis[index];
            final leadingIcon = listLeadingIcon[index];
            final pages = listPages[index];

            return CustomButtonContainer(
              leadingIcon: leadingIcon,
              onTap: () => Get.toNamed(pages),
              textKey: data,
            );
          }),
        ),
      ),
    );
  }
}
