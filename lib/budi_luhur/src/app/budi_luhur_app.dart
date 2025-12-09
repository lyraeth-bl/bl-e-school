import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class BudiLuhurApp extends StatelessWidget {
  const BudiLuhurApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(
          create: (_) => SettingsCubit(
            SettingsRepository(),
            BiometricAuth("Please authenticate first"),
          ),
        ),
        BlocProvider<AppLocalizationCubit>(
          create: (_) => AppLocalizationCubit(SettingsRepository()),
        ),
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            AuthRepository(),
            BiometricAuth("Please authenticate to login"),
          ),
        ),
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
          );
        },
      ),
    );
  }
}
