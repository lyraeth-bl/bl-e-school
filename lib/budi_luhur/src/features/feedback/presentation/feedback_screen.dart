import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  static Widget routeInstance() {
    return FeedbackScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
        title: Text(
          Utils.getTranslatedLabel(feedbackKey),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
      ),
      body: FeedbackContainer(),
      floatingActionButton: BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (context, state) {
          return state.maybeWhen(
            hasData: (listFeedback) {
              return SizedBox.shrink();
            },
            orElse: () => FloatingActionButton(
              onPressed: () async {
                final result = await Get.toNamed(
                  BudiLuhurRoutes.studentAddFeedback,
                );

                if (result == true) {
                  context.read<FeedbackBloc>().add(
                    FeedbackEvent.started(forceRefresh: true),
                  );
                }
              },
              tooltip: "Add feedback",
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
