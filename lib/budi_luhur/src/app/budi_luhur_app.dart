import 'dart:io';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BudiLuhurApp extends StatelessWidget {
  final AuthCubit authCubit;

  const BudiLuhurApp({super.key, required this.authCubit});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppConfigurationCubit>(
          create: (_) => AppConfigurationCubit(AppConfigurationRepository()),
        ),
        BlocProvider<SettingsCubit>(
          create: (_) => SettingsCubit(
            SettingsRepository(),
            BiometricAuth("Please authenticate first"),
          ),
        ),
        BlocProvider<AppLocalizationCubit>(
          create: (_) => AppLocalizationCubit(SettingsRepository()),
        ),
        BlocProvider.value(value: authCubit),
        BlocProvider<DeviceTokenCubit>(
          create: (_) => DeviceTokenCubit(DeviceTokenRepository()),
        ),
        BlocProvider<TimeTableCubit>(
          create: (_) => TimeTableCubit(TimeTableRepository()),
        ),
        BlocProvider<DailyAttendanceCubit>(
          create: (_) => DailyAttendanceCubit(AttendanceRepository()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: BudiLuhurTheme.lightMode(),
            darkTheme: BudiLuhurTheme.darkMode(),
            themeMode: ThemeMode.system,
            getPages: BudiLuhurRoutes.getPages,
            initialRoute: BudiLuhurRoutes.splash,
            locale: context.read<AppLocalizationCubit>().state.language,
            fallbackLocale: const Locale("en"),
            translationsKeys: AppTranslation.translationsKeys,
            builder: (context, child) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<AuthCubit, AuthState>(
                    listenWhen: (previous, current) =>
                        previous.maybeWhen(
                          authenticated: (isStudent, student, timeAuth) => true,
                          orElse: () => false,
                        ) &&
                        current.maybeWhen(
                          unauthenticated: (reason) =>
                              reason == LogoutReason.sessionExpired,
                          orElse: () => false,
                        ),
                    listener: (context, state) {
                      if (!Get.isBottomSheetOpen!) {
                        Get.bottomSheet(
                          const SessionExpiredBottomSheet(),
                          enableDrag: false,
                          isDismissible: false,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                        );
                      }
                    },
                  ),

                  BlocListener<AppConfigurationCubit, AppConfigurationState>(
                    listenWhen: (previous, current) =>
                        previous != current &&
                        current.maybeWhen(
                          success: (_) => true,
                          orElse: () => false,
                        ),
                    listener: (context, state) {
                      state.maybeWhen(
                        success: (config) async {
                          // Inisialisasi packages
                          PackageInfo packageInfo =
                              await PackageInfo.fromPlatform();

                          // ambil versi dari DB
                          final remoteVersion = Platform.isIOS
                              ? config.iosAppVersion
                              : config.androidAppVersion;

                          // ambil versi dari app
                          final localVersion = packageInfo.version;

                          // ambil link dari db
                          final appLink = Platform.isIOS
                              ? config.iosAppLink
                              : config.androidAppLink;

                          // null check
                          if (remoteVersion == null ||
                              remoteVersion.isEmpty ||
                              remoteVersion == "-") {
                            return;
                          }

                          // ==== Testing ==== //
                          // debugPrint("localVersion : $localVersion");
                          // debugPrint("remoteVersion : $remoteVersion");
                          // debugPrint(
                          //   "Hasil compare version : ${(Utils.compareVersion(localVersion, remoteVersion) < 0)}",
                          // );
                          // debugPrint(
                          //   "Hasil config.forceAppUpdate : ${config.forceAppUpdate}",
                          // );
                          // debugPrint(
                          //   "Hasil compare keduanya : ${((Utils.compareVersion(localVersion, remoteVersion) < 0) && config.forceAppUpdate)}",
                          // );

                          // compare versi dan hasil appUpdate dari db
                          if ((Utils.compareVersion(
                                    localVersion,
                                    remoteVersion,
                                  ) <
                                  0) &&
                              config.forceAppUpdate) {
                            if (!Get.isBottomSheetOpen!) {
                              // tampilkan bottomSheet
                              Get.bottomSheet(
                                AppUpdateBottomSheet(urlGithub: appLink ?? ""),
                                enableDrag: true,
                                isDismissible: true,
                                backgroundColor: Colors.white,
                              );
                            }
                          }
                        },
                        orElse: () {},
                      );
                    },
                  ),
                ],
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
