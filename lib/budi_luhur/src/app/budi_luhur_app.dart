import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:bl_e_school/budi_luhur/src/features/settings/cubit/app_localization_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class BudiLuhurApp extends StatefulWidget {
  const BudiLuhurApp({super.key});

  @override
  State<BudiLuhurApp> createState() => _BudiLuhurAppState();
}

class _BudiLuhurAppState extends State<BudiLuhurApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [],
      child: Builder(
        builder: (context) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: BudiLuhurTheme.lightMode(),
            darkTheme: BudiLuhurTheme.darkMode(),
            locale: context.read<AppLocalizationCubit>().state.language,
            fallbackLocale: const Locale("en"),
            translationsKeys: AppTranslation.translationsKeys,
          );
        },
      ),
    );
  }
}
