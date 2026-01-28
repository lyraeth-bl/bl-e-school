import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ChangeLanguageSettingsButton extends StatelessWidget {
  const ChangeLanguageSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLocalizationCubit, AppLocalizationState>(
      builder: (context, state) {
        final String languageName = appLanguages
            .where(
              (element) => element.languageCode == state.language.languageCode,
            )
            .toList()
            .first
            .languageName;

        return InkWell(
          onTap: () async {
            if (!Get.isBottomSheetOpen!) {
              Get.bottomSheet(
                ChangeLanguageBottomSheet(),
                isDismissible: true,
                enableDrag: false,
                isScrollControlled: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.languages),
                    const SizedBox(width: 12),
                    Text(
                      languageName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                Icon(LucideIcons.chevronRight),
              ],
            ),
          ),
        );
      },
    );
  }
}
