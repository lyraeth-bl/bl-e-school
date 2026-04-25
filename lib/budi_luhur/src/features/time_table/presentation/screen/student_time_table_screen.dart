import 'package:flutter/material.dart';

import 'student_time_table_container.dart';

class StudentTimeTableScreen extends StatelessWidget {
  const StudentTimeTableScreen({super.key});

  static Widget routeInstance() {
    return StudentTimeTableScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: TimeTableContainer(),
    );
  }
}
