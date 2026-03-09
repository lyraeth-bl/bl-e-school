import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

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
