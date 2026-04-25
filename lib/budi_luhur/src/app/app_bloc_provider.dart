import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/authentication/biometric/biometric_auth.dart';
import '../core/dependencies_injection/get_it_instance.dart';
import '../features/features.dart';

class AppBlocProvider extends StatelessWidget {
  const AppBlocProvider({super.key, required this.child});

  final Widget child;

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
        BlocProvider<AppConfigBloc>.value(value: sI<AppConfigBloc>()),
        BlocProvider<TimeTableBloc>.value(value: sI<TimeTableBloc>()),
        BlocProvider<ExtracurricularBloc>.value(
          value: sI<ExtracurricularBloc>(),
        ),
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
        BlocProvider<AcademicResultBloc>.value(value: sI<AcademicResultBloc>()),
        BlocProvider<FeedbackBloc>.value(value: sI<FeedbackBloc>()),

        BlocProvider<AppLocalizationCubit>(
          create: (_) => AppLocalizationCubit(SettingsRepository()),
        ),
      ],
      child: child,
    );
  }
}
