import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateBottomSheet extends StatelessWidget {
  final String urlGithub;

  const AppUpdateBottomSheet({super.key, required this.urlGithub});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * (0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Icon(LucideIcons.packagePlus, size: 50),
                  ),

                  SizedBox(height: 32),

                  Text(
                    Utils.getTranslatedLabel(newUpdateAvailableKey),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 12),

                  Text(
                    Utils.getTranslatedLabel(newUpdateAvailableTitleKey),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 16),

                  Text(
                    Utils.getTranslatedLabel(newUpdateAvailableDescKey),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          Divider(color: Theme.of(context).colorScheme.outlineVariant),

          Container(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 16,
              top: 4,
            ),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => _launchUrl("https://bit.ly/blapk"),
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 16),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),
                      ),
                    ),
                    child: Text(
                      Utils.getTranslatedLabel(releaseNoteKey),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 8),

                Expanded(
                  child: AppUpdateButtonDownload(appUrlDownload: urlGithub),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
