import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../utils.dart';
import '../label_keys/label_keys.dart';

class SendFeedbackToUsText extends StatelessWidget {
  const SendFeedbackToUsText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          Utils.getTranslatedLabel(havingAnyTroubleKey),
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () => Get.toNamed(BudiLuhurRoutes.studentFeedback),
          child: Text(
            Utils.getTranslatedLabel(sendTheFeedbackToUsKey),
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
