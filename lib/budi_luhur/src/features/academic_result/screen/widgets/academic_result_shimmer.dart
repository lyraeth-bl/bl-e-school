import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class AcademicResultOverallSummaryShimmer extends StatelessWidget {
  const AcademicResultOverallSummaryShimmer({super.key, this.length = 3});

  final int length;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ShimmerLoadingContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(length, (index) {
          return CustomContainerShimmer(
            enableShadow: false,
            width: width,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  height: 22,
                  width: width * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class AcademicResultSubjectListShimmer extends StatelessWidget {
  const AcademicResultSubjectListShimmer({super.key, this.length = 5});

  final int length;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ShimmerLoadingContainer(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return CustomContainerShimmer(
            enableShadow: false,
            shadowsOffset: const Offset(5, 5),
            padding: const EdgeInsets.all(16),
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Container(
                      height: 14,
                      width: width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),

                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
