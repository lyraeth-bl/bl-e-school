import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AcademicResultContainer extends StatefulWidget {
  const AcademicResultContainer({super.key});

  @override
  State<AcademicResultContainer> createState() =>
      _AcademicResultContainerState();
}

class _AcademicResultContainerState extends State<AcademicResultContainer> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchResult());
    super.initState();
  }

  void _fetchResult() async =>
      context.read<AcademicResultBloc>().add(AcademicResultEvent.fetchResult());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: CustomMaterialAppBar(
        titleKey: academicResultKey,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AcademicResultBloc>().add(
            AcademicResultEvent.refreshResult(),
          );
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            top: 24,
            right: 24,
            bottom: Utils.getScrollViewBottomPadding(context),
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.getTranslatedLabel(overallSummaryKey),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                Utils.getTranslatedLabel(overallSummaryDescKey),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 12),

              BlocBuilder<AcademicResultBloc, AcademicResultState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    success: (response, subjectNames) {
                      return ResultOverallSummaryContainer(
                        overallSummary: response.data.overallSummaryResult,
                      );
                    },
                    orElse: () =>
                        AcademicResultOverallSummaryShimmer(length: 3),
                  );
                },
              ),

              const SizedBox(height: 12),

              Text(
                Utils.getTranslatedLabel(subjectsKey),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                Utils.getTranslatedLabel(choiceSubjectsDescKey),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              BlocBuilder<AcademicResultBloc, AcademicResultState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    success: (response, subjectList) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final String data = subjectList[index];

                          final String? teacherName = response
                              .data
                              .categories[index]
                              .subjectTeacherName;

                          final category = response.data.categories[index];

                          return CustomButtonContainer(
                            onTap: () => Get.to(
                              ResultScreen(
                                overallSummary:
                                    response.data.overallSummaryResult,
                                resultList: category.listResult,
                                summary: category.summary,
                                subjectName: data,
                                teacherName: teacherName,
                              ),
                            ),
                            textKey: data,
                            leadingIcon: Utils.iconForSubject(
                              category.subjectName,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 24),
                        itemCount: response.data.categories.length,
                      );
                    },
                    orElse: () => AcademicResultSubjectListShimmer(),
                  );
                },
              ),

              const SizedBox(height: 24),

              Text(
                Utils.getTranslatedLabel(noSubjectFoundOnListKey),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
