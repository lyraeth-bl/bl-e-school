import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ChangeBiometricSettingsButton extends StatelessWidget {
  const ChangeBiometricSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final bool isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        final bool isEnabled = state.maybeWhen(
          success: (biometricLogin, _) => biometricLogin,
          orElse: () => false,
        );

        return BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) {
            state.whenOrNull(
              success: (biometricLogin, showFeedback) {
                if (!showFeedback) return;
                if (Get.isBottomSheetOpen!) return;

                Get.bottomSheet(
                  CustomBottomSheet(
                    success: true,
                    successString: biometricLogin
                        ? "Biometric berhasil diaktifkan"
                        : "Biometric dinonaktifkan",
                    successDescString: biometricLogin
                        ? "Sekarang kamu bisa login pakai biometrik"
                        : "Kamu bisa aktifkan lagi kapan saja",
                  ),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                );
              },
              failure: (err) {
                if (Get.isBottomSheetOpen!) return;

                Get.bottomSheet(
                  CustomBottomSheet(
                    success: false,
                    failedString: "Biometric gagal",
                    failedDescString: err,
                  ),
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.fingerprintPattern),
                    const SizedBox(width: 12),
                    Text(
                      Utils.getTranslatedLabel(biometricLoginKey),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                if (isLoading)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  CupertinoSwitch(
                    value: isEnabled,
                    onChanged: (val) {
                      context.read<SettingsCubit>().toggleBiometricLogin(
                        enable: val,
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
