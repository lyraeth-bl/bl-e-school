import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class AcademicCalendarScreen extends StatelessWidget {
  const AcademicCalendarScreen({super.key});

  static Widget routeInstance() {
    return AcademicCalendarScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AcademicCalendarContainer());
  }
}
