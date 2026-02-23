import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class AppVersionSettingsText extends StatelessWidget {
  const AppVersionSettingsText({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils.getAppVersion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        if (snapshot.hasError) {
          return const Text("Version error");
        }

        final version = snapshot.data ?? "-";

        return Text(
          "${Utils.getTranslatedLabel(appVersionKey)} : v$version",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
      },
    );
  }
}
