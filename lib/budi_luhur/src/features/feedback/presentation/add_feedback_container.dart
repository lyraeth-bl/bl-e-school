import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../sessions/presentation/bloc/sessions_bloc.dart';
import 'widget/send_feedback_form.dart';

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
        nis: context.read<SessionsBloc>().studentDetails?.nis ?? "",
      ),
    );
  }
}
