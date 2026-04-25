import 'package:flutter/material.dart';

import 'attendance_container.dart';

class StudentAttendanceScreen extends StatelessWidget {
  const StudentAttendanceScreen({super.key});

  static Widget routeInstance() {
    return StudentAttendanceScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: AttendanceContainer(),
    );
  }
}
