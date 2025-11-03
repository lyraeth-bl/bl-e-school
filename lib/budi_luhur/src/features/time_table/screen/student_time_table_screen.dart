import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentTimeTableScreen extends StatelessWidget {
  const StudentTimeTableScreen({super.key});

  static Widget routeInstance() {
    return BlocProvider<TimeTableCubit>(
      create: (_) => TimeTableCubit(TimeTableRepository()),
      child: StudentTimeTableScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TimeTableContainer());
  }
}
