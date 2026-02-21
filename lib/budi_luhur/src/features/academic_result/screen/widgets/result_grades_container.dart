import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultGradesContainer extends StatelessWidget {
  const ResultGradesContainer({
    super.key,
    required this.titleKey,
    required this.resultList,
    required this.summary,
    this.forMIDPAS = false,
  });

  final String titleKey;

  final List<AcademicResult> resultList;

  final AcademicResultSummary summary;

  final bool forMIDPAS;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final List<AcademicResult> filteredList = forMIDPAS
        ? resultList
              .where(
                (e) =>
                    e.keterangan.toLowerCase() == "mid" ||
                    e.keterangan.toLowerCase() == "semester",
              )
              .toList()
        : resultList
              .where(
                (e) =>
                    e.keterangan.toLowerCase() != "mid" &&
                    e.keterangan.toLowerCase() != "semester",
              )
              .toList();

    if (filteredList.isEmpty) {
      return CustomContainer(
        enableShadow: false,
        border: Border.all(color: colorScheme.outlineVariant),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 8,
              ),
              child: Text(
                Utils.getTranslatedLabel(titleKey),
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            CustomContainer(
              enableShadow: false,
              padding: const EdgeInsets.symmetric(vertical: 16),
              margin: const EdgeInsets.only(top: 8),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(32),
                topLeft: Radius.circular(32),
              ),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Center(
                child: Text(
                  Utils.getTranslatedLabel(noDataFoundKey),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return CustomContainer(
      enableShadow: false,
      border: Border.all(color: colorScheme.outlineVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: 8,
            ),
            child: Text(
              Utils.getTranslatedLabel(titleKey),
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          CustomContainer(
            enableShadow: false,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 8),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(32),
              topLeft: Radius.circular(32),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filteredList.length,
              separatorBuilder: (context, index) => Divider(
                color: colorScheme.onPrimaryContainer,
                thickness: 0.3,
              ),
              itemBuilder: (context, index) {
                final data = filteredList[index];

                return InkWell(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(32),
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(16),
                  ),
                  onTap: () {
                    if (!Get.isBottomSheetOpen!) {
                      Get.bottomSheet(
                        detailsResultBottomSheet(context, academicResult: data),
                        enableDrag: true,
                        backgroundColor: colorScheme.surface,
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                forMIDPAS
                                    ? "MID"
                                    : "${Utils.getTranslatedLabel(taskKey)} - ${data.nilaiKe}",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              // if (data.remedial == "1" ||
                              //     data.remedial == "2") ...[
                              //   const SizedBox(width: 8),
                              //   CustomChipContainer(
                              //     backgroundColor: colorScheme.errorContainer,
                              //     child: Text(
                              //       Utils.getTranslatedLabel(remedialKey),
                              //       style: textTheme.labelSmall?.copyWith(
                              //         color: colorScheme.onErrorContainer,
                              //       ),
                              //     ),
                              //   ),
                              // ],
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(
                            Utils.formatToDayMonthYear(data.tanggal),
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),

                      Text(
                        data.nilai.toString(),
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget detailsResultBottomSheet(
    BuildContext context, {
    required AcademicResult academicResult,
  }) {
    String? nameTask;

    if (academicResult.keterangan.toLowerCase() == "mid") {
      nameTask = "MID";
    } else if (academicResult.keterangan.toLowerCase() == "semester") {
      nameTask = "Semester";
    } else {
      nameTask =
          "${Utils.getTranslatedLabel(taskKey)} - ${academicResult.nilaiKe}";
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslatedLabel(taskDetailsKey),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 24),

          CustomContainer(
            enableShadow: false,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      Utils.getTranslatedLabel(nameKey),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      nameTask,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    Text(
                      Utils.getTranslatedLabel(resultKey),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      academicResult.nilai.toString(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    Text(
                      Utils.getTranslatedLabel(remedialKey),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      (academicResult.remedial == "-")
                          ? academicResult.remedial
                          : "${academicResult.remedial}x",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          CustomContainer(
            enableShadow: false,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      Utils.getTranslatedLabel(valueAspectKey),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      academicResult.aspekNilai,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    Text(
                      Utils.getTranslatedLabel(schoolYearKey),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      academicResult.tajaran,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    Text(
                      Utils.getTranslatedLabel(semesterKey),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      academicResult.semester,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          CustomContainer(
            enableShadow: false,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getTranslatedLabel(taskDescriptionKey),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  academicResult.keterangan,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
