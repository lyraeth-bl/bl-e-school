import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFeedbackScreen extends StatelessWidget {
  const AddFeedbackScreen({super.key});

  static Widget routeInstance() {
    return BlocProvider<PostFeedbackCubit>(
      create: (_) => PostFeedbackCubit(FeedbackRepository()),
      child: AddFeedbackScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Utils.getTranslatedLabel(addFeedbackKey),
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        physics: AlwaysScrollableScrollPhysics(),
        child: AddFeedbackContainer(),
      ),
    );
  }
}
