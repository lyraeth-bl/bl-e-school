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
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  void _fetchData() async {
    context.read<FeedbackBloc>().add(FeedbackEvent.started());
  }

  void _refreshData() async {
    context.read<FeedbackBloc>().add(FeedbackEvent.started(forceRefresh: true));
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
    return RefreshIndicator(
      onRefresh: () async => _refreshData(),
      child: BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (c, s) {
          return s.maybeWhen(
            hasData: (userFeedbackList) {
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
            emptyData: () {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  CustomContainer(
                    padding: const EdgeInsets.all(16),
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
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
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
            },
            orElse: () => SizedBox.shrink(),
            loading: () => Center(child: CircularProgressIndicator()),
            failure: (failure) => Center(
              child: ErrorContainer(
                errorMessageCode: failure.messageKey.translate(),
                onTapRetry: () => _refreshData(),
              ),
            ),
          );
        },
      ),
    );
  }
}
