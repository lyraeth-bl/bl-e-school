import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcademicCalendarScreen extends StatelessWidget {
  const AcademicCalendarScreen({super.key});

  static Widget routeInstance() {
    return BlocProvider<AcademicCalendarCubit>(
      create: (_) => AcademicCalendarCubit(AcademicCalendarRepository()),
      child: AcademicCalendarScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AcademicCalendarContainer());
  }
}
