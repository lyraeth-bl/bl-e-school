import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AttendanceShimmer extends StatelessWidget {
  const AttendanceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                height: 250,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 24),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                height: 300,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
