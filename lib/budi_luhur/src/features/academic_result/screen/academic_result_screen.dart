import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcademicResultScreen extends StatelessWidget {
  const AcademicResultScreen({super.key});

  static Widget routeInstance() {
    return BlocProvider<AcademicResultBloc>(
      create: (_) => AcademicResultBloc(AcademicResultRepository()),
      child: AcademicResultScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AcademicResultContainer());
  }
}
