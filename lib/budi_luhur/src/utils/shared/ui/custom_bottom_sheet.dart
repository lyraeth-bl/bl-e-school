import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CustomBottomSheet extends StatelessWidget {
  final bool success;
  final String? successString;
  final String? failedString;
  final String? successDescString;
  final String? failedDescString;

  const CustomBottomSheet({
    super.key,
    required this.success,
    this.failedString,
    this.successString,
    this.failedDescString,
    this.successDescString,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * (0.35),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: success
                  ? Lottie.asset("assets/animations/check-success.json")
                  : Lottie.asset("assets/animations/failed.json"),
            ),

            SizedBox(height: 16),

            Text(
              success ? successString ?? "" : failedString ?? "",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 24),

            Text(
              success ? successDescString ?? "" : failedDescString ?? "",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            Spacer(),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: FilledButton(
                onPressed: () => Get.back(),
                child: success
                    ? Text(Utils.getTranslatedLabel(greatKey))
                    : Text(Utils.getTranslatedLabel(tryAgainKey)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
