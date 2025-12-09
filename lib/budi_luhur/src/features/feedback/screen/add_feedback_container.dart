import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFeedbackContainer extends StatefulWidget {
  const AddFeedbackContainer({super.key});

  @override
  State<AddFeedbackContainer> createState() => _AddFeedbackContainerState();
}

class _AddFeedbackContainerState extends State<AddFeedbackContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SendFeedbackForm(
        nis: context.read<AuthCubit>().getStudentDetails.nis,
      ),
    );
  }
}
