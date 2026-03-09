import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

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
