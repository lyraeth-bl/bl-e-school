import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/features/settings/cubit/settings/settings_cubit.dart';
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

        BlocProvider<SessionsBloc>.value(value: sI<SessionsBloc>()),
        BlocProvider<AuthBloc>.value(value: sI<AuthBloc>()),
        BlocProvider<DeviceTokenBloc>.value(value: sI<DeviceTokenBloc>()),
        BlocProvider<AppConfigBloc>.value(value: sI<AppConfigBloc>()),
        BlocProvider<TimeTableBloc>.value(value: sI<TimeTableBloc>()),
        BlocProvider<DisciplineBloc>.value(value: sI<DisciplineBloc>()),
        BlocProvider<TodayAttendanceBloc>.value(
          value: sI<TodayAttendanceBloc>(),
        ),
        BlocProvider<MonthlyAttendanceBloc>.value(
          value: sI<MonthlyAttendanceBloc>(),
        ),
        BlocProvider<AcademicCalendarBloc>.value(
          value: sI<AcademicCalendarBloc>(),
        ),

        BlocProvider<AppLocalizationCubit>(
          create: (_) => AppLocalizationCubit(SettingsRepository()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocListener(
            listeners: [
              BlocListener<SessionsBloc, SessionsState>(
                listener: (context, state) {
                  state.whenOrNull(
                    unauthenticated: () => Get.offNamed(BudiLuhurRoutes.auth),
                    authenticated: (student, accessToken) {
                      context.read<DeviceTokenBloc>().add(
                        DeviceTokenEvent.postRequested(),
                      );

                      context.read<AppConfigBloc>().add(
                        AppConfigEvent.appConfigRequested(),
                      );

                      context.read<TimeTableBloc>().add(
                        TimeTableEvent.timeTableRequested(
                          kelas:
                              "${student!.kelasSaatIni!}${student.noKelasSaatIni}",
                        ),
                      );

                      context.read<TodayAttendanceBloc>().add(
                        TodayAttendanceEvent.started(),
                      );

                      Get.offNamed(BudiLuhurRoutes.home);
                    },
                  );
                },
              ),
            ],
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: BudiLuhurTheme.lightMode(),
              darkTheme: BudiLuhurTheme.darkMode(),
              themeMode: ThemeMode.system,
              getPages: BudiLuhurRoutes.getPages,
              initialRoute: BudiLuhurRoutes.splash,
              locale: context.read<AppLocalizationCubit>().state.language,
              fallbackLocale: const Locale("en"),
              translationsKeys: AppTranslation.translationsKeys,
            ),
          );
        },
      ),
    );
  }
}
