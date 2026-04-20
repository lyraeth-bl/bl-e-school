import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../features/features.dart';
import '../utils/shared/theme/theme.dart';
import 'app_bloc_provider.dart';
import 'init/init_languages.dart';
import 'routes/app_routes.dart';

class BudiLuhurApp extends StatelessWidget {
  const BudiLuhurApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocProvider(
      child: Builder(
        builder: (context) {
          return BlocListener<SessionsBloc, SessionsState>(
            listener: (context, state) {
              state.whenOrNull(
                unauthenticated: () {
                  Get.offNamed(BudiLuhurRoutes.auth);
                },
                authenticated: (student, accessToken) {
                  if (!kIsWeb) {
                    FcmService.instance.initialize().then((_) {
                      FcmService.instance.registerToken();
                    });
                  }

                  context.read<AppConfigBloc>().add(
                    AppConfigEvent.appConfigRequested(),
                  );

                  context.read<TimeTableBloc>().add(
                    TimeTableEvent.timeTableRequested(
                      kelas:
                          "${student!.kelasSaatIni!}${student.noKelasSaatIni}",
                      forceRefresh: true,
                    ),
                  );

                  context.read<TodayAttendanceBloc>().add(
                    TodayAttendanceEvent.started(),
                  );

                  Get.offNamed(BudiLuhurRoutes.home);
                },
              );
            },
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
