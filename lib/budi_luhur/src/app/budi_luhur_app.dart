import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

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
            getPages: BudiLuhurRoutes.getPages,
            initialRoute: BudiLuhurRoutes.splash,
            locale: context.read<AppLocalizationCubit>().state.language,
            fallbackLocale: const Locale("en"),
            translationsKeys: AppTranslation.translationsKeys,
            builder: (context, child) {
              return BlocListener<AuthCubit, AuthState>(
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
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    );
                  }
                },
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}
