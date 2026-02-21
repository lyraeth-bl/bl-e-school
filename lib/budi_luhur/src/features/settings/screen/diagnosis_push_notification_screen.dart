import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DiagnosisPushNotificationScreen extends StatelessWidget {
  const DiagnosisPushNotificationScreen({super.key});

  static Widget routeInstance() {
    return BlocProvider<DiagnosisPushNotificationBloc>(
      create: (context) => DiagnosisPushNotificationBloc(
        SettingsRepository(),
        NotificationsRepository(),
      )..add(DiagnosisPushNotificationEvent.sendNotificationTest()),
      child: DiagnosisPushNotificationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomMaterialAppBar(
        titleKey: diagnosisPushNotificationKey,
        centerTitle: true,
      ),
      body:
          BlocBuilder<
            DiagnosisPushNotificationBloc,
            DiagnosisPushNotificationState
          >(
            builder: (context, state) {
              return state.maybeWhen((
                status,
                isNotificationActive,
                fcmToken,
                isNotificationSuccess,
                currentSteps,
              ) {
                /// Initial
                if (status == DiagnosisStatus.initial) {
                  return _buildCheckingUI(context, state);
                }

                /// Loading
                if (status == DiagnosisStatus.loading) {
                  return _buildCheckingUI(context, state);
                }

                /// Success
                if (status == DiagnosisStatus.success) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Icon(
                            LucideIcons.badgeCheck,
                            size: 72,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Center(
                          child: Text(
                            Utils.getTranslatedLabel(pushNotificationActiveKey),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        _buildChecklistRow(
                          context,
                          checkNotificationPermissionSuccessKey,
                          isNotificationActive,
                        ),

                        const SizedBox(height: 24),

                        _buildChecklistRow(
                          context,
                          checkNotificationTokenSuccessKey,
                          fcmToken != null && fcmToken.isNotEmpty,
                        ),

                        const SizedBox(height: 24),

                        _buildChecklistRow(
                          context,
                          sendPushNotificationSuccessKey,
                          isNotificationSuccess,
                        ),

                        const SizedBox(height: 48),

                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Utils.getTranslatedLabel(havingAnyTroubleKey),
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => Get.toNamed(
                                  BudiLuhurRoutes.studentFeedback,
                                ),
                                child: Text(
                                  Utils.getTranslatedLabel(
                                    sendTheFeedbackToUsKey,
                                  ),
                                  style: textTheme.labelMedium?.copyWith(
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                /// Failed
                if (status == DiagnosisStatus.failed) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(
                          LucideIcons.circleX,
                          size: 72,
                          color: colorScheme.error,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: Text(
                          Utils.getTranslatedLabel(
                            diagnosisPushNotificationFailedKey,
                          ),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox();
              }, orElse: () => const SizedBox());
            },
          ),
    );
  }

  Widget _buildCheckingUI(
    BuildContext context,
    DiagnosisPushNotificationState state,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Icon(LucideIcons.timer, size: 72)),

          const SizedBox(height: 24),

          Center(
            child: Text(
              Utils.getTranslatedLabel(checkingRequiremetsNotificationKey),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 48),

          _buildAnimatedRow(
            context,
            text: checkNotificationPermissionKey,
            stepIndex: 0,
            currentStep: state.currentStep,
          ),

          const SizedBox(height: 24),

          _buildAnimatedRow(
            context,
            text: checkNotificationTokenKey,
            stepIndex: 1,
            currentStep: state.currentStep,
          ),

          const SizedBox(height: 24),

          _buildAnimatedRow(
            context,
            text: sendPushNotificationKey,
            stepIndex: 2,
            currentStep: state.currentStep,
          ),

          const SizedBox(height: 48),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Utils.getTranslatedLabel(havingAnyTroubleKey),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => Get.toNamed(BudiLuhurRoutes.studentFeedback),
                  child: Text(
                    Utils.getTranslatedLabel(sendTheFeedbackToUsKey),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistRow(BuildContext context, String text, bool isSuccess) {
    return Row(
      children: [
        Icon(
          isSuccess ? LucideIcons.circleCheck : Icons.cancel,
          size: 20,
          color: isSuccess ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            Utils.getTranslatedLabel(text),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedRow(
    BuildContext context, {
    required String text,
    required int stepIndex,
    required int currentStep,
  }) {
    bool isCompleted = currentStep > stepIndex;
    bool isLoading = currentStep == stepIndex;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Row(
        key: ValueKey(currentStep),
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: isCompleted
                ? const Icon(LucideIcons.circleCheck, color: Colors.green)
                : isLoading
                ? const CircularProgressIndicator(strokeWidth: 2)
                : const Icon(LucideIcons.circleCheck),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              Utils.getTranslatedLabel(text),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
