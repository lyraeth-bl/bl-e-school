import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  static Widget routeInstance() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedbackCubit>(
          create: (_) => FeedbackCubit(FeedbackRepository()),
        ),
        BlocProvider<GetFeedbackCubit>(
          create: (_) => GetFeedbackCubit(FeedbackRepository()),
        ),
      ],
      child: const FeedbackScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        title: Text(
          Utils.getTranslatedLabel(feedbackKey),
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: FeedbackContainer(),
      floatingActionButton: BlocBuilder<FeedbackCubit, FeedbackState>(
        builder: (context, state) {
          return state.maybeWhen(
            hasData: (feedbackUser, lastFetched) {
              return SizedBox.shrink();
            },
            orElse: () => FloatingActionButton(
              onPressed: () {},
              tooltip: "Add feedback",
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
