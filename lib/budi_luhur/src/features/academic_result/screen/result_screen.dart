import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.resultList,
    required this.summary,
    required this.subjectName,
    required this.overallSummary,
    this.teacherName,
  });

  final List<AcademicResult> resultList;

  final AcademicResultSummary summary;

  final AcademicResultOverallSummary overallSummary;

  final String subjectName;

  final String? teacherName;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late List<AcademicResult> _sortedResults;

  @override
  void initState() {
    super.initState();

    /// copy list data yang didapat dari screen sebelumnya
    _sortedResults = [...widget.resultList];

    /// sorting data copy
    _sortedResults.sort((a, b) {
      /// pertama sort datanya berdasarkan tanggal secara desc.
      /// contohnya pada list tersebut ada data perolehan nilai di tanggal
      ///
      /// 1. 03 Oktober 2025
      /// 2. 29 September 2025
      /// 3. 21 September 2025
      ///
      /// code dibawah akan membuat data otomatis menjadi :
      ///
      /// 1. 21 September 2025
      /// 2. 29 September 2025
      /// 3. 03 Oktober 2025
      ///
      int sortedList = a.tanggal.compareTo(b.tanggal);

      /// setelah proses sort tanggal diatas
      /// lanjut sort urutan nilaiKe-nya
      /// contoh :
      ///
      /// 1. 21 September 2025 - 3
      /// 2. 21 September 2025 - 2
      /// 3. 21 September 2025 - 3
      /// 4. 21 September 2025 - 1
      /// 5. 21 September 2025 - 2
      /// 6. 21 September 2025 - 1
      ///
      /// code dibawah akan membuat data menjadi :
      ///
      /// 1. 21 September 2025 - 1
      /// 2. 21 September 2025 - 1
      /// 3. 21 September 2025 - 2
      /// 4. 21 September 2025 - 2
      /// 5. 21 September 2025 - 3
      /// 6. 21 September 2025 - 3
      if (sortedList == 0) {
        return a.nilaiKe.compareTo(b.nilaiKe);
      }

      // return hasil sort
      return sortedList;
    });
  }

  /// Menghitung minggu keberapa dalam bulan
  ///
  /// Penjelasan :
  ///
  /// - 1–7 → Minggu 1
  /// - 8–14 → Minggu 2
  /// - 15–21 → Minggu 3
  /// - 22–28 → Minggu 4
  /// - 29–31 → Minggu 5
  ///
  /// Contoh :
  /// 02 Oktober → (2 - 1 = 1 hari) → minggu 1
  /// 14 Oktober → (13 hari) → minggu 2
  ///
  int getWeekOfMonth(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);

    final difference = date.difference(firstDayOfMonth).inDays;

    return (difference ~/ 7) + 1;
  }

  String getMonthKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  String formatMonthLabel(String monthKey) {
    final parts = monthKey.split("-");
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);

    final date = DateTime(year, month);
    return Utils.formatToMonthYear(date);
  }

  /// Group list data berdasarkan bulannya kemudian minggunya
  Map<String, Map<int, List<AcademicResult>>> groupByMonthAndWeek(
    List<AcademicResult> list,
  ) {
    final Map<String, Map<int, List<AcademicResult>>> grouped = {};

    for (final item in list) {
      final date = item.tanggal;
      final monthKey = getMonthKey(date);
      final week = getWeekOfMonth(date);

      grouped.putIfAbsent(monthKey, () => {});
      grouped[monthKey]!.putIfAbsent(week, () => []);
      grouped[monthKey]![week]!.add(item);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      appBar: CustomMaterialAppBar(titleKey: widget.subjectName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Summary
            CustomContainer(
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
                      Utils.getTranslatedLabel(summaryKey),
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
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Utils.getTranslatedLabel(totalKey),
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),

                            Text(
                              widget.summary.totalData.toString(),
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        Divider(
                          color: colorScheme.onPrimaryContainer,
                          thickness: 0.3,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Utils.getTranslatedLabel(teacherKey),
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),

                            Text(
                              Utils.formatEmptyValue(widget.teacherName),
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Nilai Sumatif
            ResultGradesContainer(
              titleKey: summativeAssessmentScoreKey,
              resultList: _sortedResults,
              summary: widget.summary,
            ),

            const SizedBox(height: 24),

            // Nilai Semester
            ResultGradesContainer(
              titleKey: midtermExamScoreKey,
              resultList: _sortedResults,
              summary: widget.summary,
              forMIDPAS: true,
            ),
          ],
        ),
      ),
    );
  }
}
