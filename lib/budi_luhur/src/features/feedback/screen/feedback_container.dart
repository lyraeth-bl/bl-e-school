import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class FeedbackContainer extends StatefulWidget {
  const FeedbackContainer({super.key});

  @override
  State<FeedbackContainer> createState() => _FeedbackContainerState();
}

class _FeedbackContainerState extends State<FeedbackContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchUserFeedback());
  }

  Future<void> _fetchUserFeedback() async {
    final authDetails = context.read<AuthCubit>().getStudentDetails;
    await context.read<GetFeedbackCubit>().fetchUserFeedback(
      nis: authDetails.nis,
    );
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '-';
    final dt = d.toLocal();
    final yyyy = dt.year.toString().padLeft(4, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$yyyy-$mm-$dd $hh:$min';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetFeedbackCubit, GetFeedbackState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (userFeedbackList, lastUpdate) {
            if (userFeedbackList.isNotEmpty) {
              context.read<FeedbackCubit>().updateFeedbackUserData(
                userFeedbackList.first,
              );
            } else {
              context.read<FeedbackCubit>().setInitial();
            }
          },
          orElse: () {},
        );
      },
      child: RefreshIndicator(
        onRefresh: () async => _fetchUserFeedback(),
        child: BlocBuilder<GetFeedbackCubit, GetFeedbackState>(
          builder: (c, s) {
            return s.maybeWhen(
              success: (userFeedbackList, lastUpdate) {
                if (userFeedbackList.isEmpty) {
                  return ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              "assets/animations/empty-ghost.json",
                              height: 150,
                              width: 150,
                            ),
                            SizedBox(height: 24),
                            Text(
                              Utils.getTranslatedLabel(noDataFoundKey),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      FeedbackTermsAndConditions(),
                    ],
                  );
                }
                return ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    FeedbackCard(
                      feedback: userFeedbackList.first,
                      formatDate: _formatDate,
                    ),

                    SizedBox(height: 24),

                    FeedbackTermsAndConditions(),
                  ],
                );
              },
              orElse: () => SizedBox.shrink(),
              loading: () => Center(child: CircularProgressIndicator()),
              failure: (errorMessage) => Center(
                child: ErrorContainer(
                  errorMessageCode: errorMessage,
                  onTapRetry: () => _fetchUserFeedback(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
