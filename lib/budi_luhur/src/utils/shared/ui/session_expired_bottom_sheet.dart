import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SessionExpiredBottomSheet extends StatelessWidget {
  const SessionExpiredBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Get.offAllNamed(
            BudiLuhurRoutes.authStudent,
            arguments: {"fromSessionBottomSheet": "true"},
          );
        }
      },
      child: Padding(
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
                child: Lottie.asset("assets/animations/session_expired.json"),
              ),

              SizedBox(height: 16),

              Text(
                Utils.getTranslatedLabel(sessionExpiredKey),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              SizedBox(height: 24),

              Text(
                Utils.getTranslatedLabel(sessionExpiredDescKey),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

              Spacer(),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: FilledButton(
                  onPressed: () {
                    Get.offAllNamed(
                      BudiLuhurRoutes.authStudent,
                      arguments: {"fromSessionBottomSheet": "true"},
                    );
                  },
                  child: Text(Utils.getTranslatedLabel(reLoginKey)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
