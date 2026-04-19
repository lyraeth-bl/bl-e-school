import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import 'add_feedback_container.dart';

class AddFeedbackScreen extends StatelessWidget {
  const AddFeedbackScreen({super.key});

  static Widget routeInstance() {
    return AddFeedbackScreen();
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
