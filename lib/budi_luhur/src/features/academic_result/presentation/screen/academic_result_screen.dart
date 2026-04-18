import 'package:flutter/material.dart';

import 'widgets/academic_result_container.dart';

class AcademicResultScreen extends StatelessWidget {
  const AcademicResultScreen({super.key});

  static Widget routeInstance() {
    return AcademicResultScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AcademicResultContainer());
  }
}
