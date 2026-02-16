import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  static Widget routeInstance() {
    return ContactUsScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: CustomMaterialAppBar(titleKey: contactUsKey),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.getTranslatedLabel(contactUsDescKey),
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            CustomContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.getTranslatedLabel(costumerSupportKey),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ContactUsListContainer(
                    onTap: () => Utils.openDialPad("+62217306247"),
                    title: Utils.getTranslatedLabel(contactNumberKey),
                    subtitle: "(021) - 730 6247",
                    leadingIcon: LucideIcons.phoneCall,
                  ),
                  ContactUsListContainer(
                    onTap: () => Utils.createEmail("sma@budiluhur.sch.id"),
                    title: "${Utils.getTranslatedLabel(emailKey)} SMA",
                    subtitle: "sma@budiluhur.sch.id",
                    leadingIcon: LucideIcons.mail,
                  ),
                  ContactUsListContainer(
                    onTap: () => Utils.createEmail("smk@budiluhur.sch.id"),
                    title: "${Utils.getTranslatedLabel(emailKey)} SMK",
                    subtitle: "smk@budiluhur.sch.id",
                    leadingIcon: LucideIcons.mail,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            CustomContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${Utils.getTranslatedLabel(socialMediaKey)} SMA Budi Luhur",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ContactUsClickableListContainer(
                    url: "https://www.instagram.com/budiluhursma/",
                    iconColor: Colors.white,
                    backgroundIconColor: Colors.pinkAccent.shade100,
                    title: instagramKey,
                    subtitle: "@budiluhursma",
                    leadingIcon: LucideIcons.instagram,
                  ),
                  ContactUsClickableListContainer(
                    url: "https://www.youtube.com/@smabudiluhur4113",
                    iconColor: Colors.white,
                    backgroundIconColor: Colors.red,
                    title: youtubeKey,
                    subtitle: "@smabudiluhur4113",
                    leadingIcon: LucideIcons.youtube,
                  ),
                  ContactUsClickableListContainer(
                    url: "https://www.tiktok.com/@sma.budiluhur",
                    iconColor: Colors.white,
                    backgroundIconColor: Colors.black,
                    title: tiktokKey,
                    subtitle: "@sma.budiluhur",
                    leadingIcon: Icons.tiktok,
                  ),
                  ContactUsClickableListContainer(
                    url: "https://sma.sekolahbudiluhur.sch.id/",
                    title: websiteKey,
                    subtitle: "sma.sekolahbudiluhur.sch.id",
                    leadingIcon: LucideIcons.earth,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            CustomContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${Utils.getTranslatedLabel(socialMediaKey)} SMK Budi Luhur",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ContactUsClickableListContainer(
                    url: "https://www.instagram.com/smk.budiluhur/",
                    iconColor: Colors.white,
                    backgroundIconColor: Colors.pinkAccent.shade100,
                    title: instagramKey,
                    subtitle: "@smk.budiluhur",
                    leadingIcon: LucideIcons.instagram,
                  ),
                  ContactUsClickableListContainer(
                    url: "https://www.youtube.com/@smkbudiluhurchannel4019",
                    iconColor: Colors.white,
                    backgroundIconColor: Colors.red,
                    title: youtubeKey,
                    subtitle: "@smkbudiluhurchannel4019",
                    leadingIcon: LucideIcons.youtube,
                  ),
                  ContactUsClickableListContainer(
                    url: "https://www.tiktok.com/@smk.budiluhur",
                    iconColor: Colors.white,
                    backgroundIconColor: Colors.black,
                    title: tiktokKey,
                    subtitle: "@smk.budiluhur",
                    leadingIcon: Icons.tiktok,
                  ),
                  ContactUsClickableListContainer(
                    url: "https://smk.sekolahbudiluhur.sch.id/",
                    title: websiteKey,
                    subtitle: "smk.sekolahbudiluhur.sch.id",
                    leadingIcon: LucideIcons.earth,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
