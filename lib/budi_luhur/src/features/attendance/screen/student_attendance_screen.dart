import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentAttendanceScreen extends StatelessWidget {
  const StudentAttendanceScreen({super.key});

  static Widget routeInstance() {
    return BlocProvider<FetchDailyAttendanceCubit>(
      create: (context) => FetchDailyAttendanceCubit(AttendanceRepository()),
      child: StudentAttendanceScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AttendanceContainer());
  }
}
