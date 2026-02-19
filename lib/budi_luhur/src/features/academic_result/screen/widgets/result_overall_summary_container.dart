import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class ResultOverallSummaryContainer extends StatelessWidget {
  const ResultOverallSummaryContainer({
    super.key,
    required this.overallSummary,
  });

  final AcademicResultOverallSummary overallSummary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final List<String> listTitle = [
      finalSummativeScoreKey,
      finalGradeScoreKey,
      semesterGradeScoreKey,
    ];

    final List<double> listScore = [
      overallSummary.sumatifAverage, // finalGradeScoreKey
      overallSummary.raporAverage, // finalGradeScoreKey
      overallSummary.raporSemesterAverage, // semesterGradeScoreKey
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(listTitle.length, (index) {
        return CustomContainer(
          enableShadow: false,
          width: MediaQuery.of(context).size.width,
          backgroundColor: colorScheme.secondaryContainer,
          border: Border.all(color: colorScheme.outlineVariant),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.getTranslatedLabel(listTitle[index]),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                listScore[index].toString(),
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
