import 'package:flutter/material.dart';

import 'academic_calendar_container.dart';

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
