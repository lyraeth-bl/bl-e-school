import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomButtonContainer extends StatelessWidget {
  const CustomButtonContainer({
    super.key,
    required this.onTap,
    required this.textKey,
    this.leadingIcon,
    this.trailingIcon,
  });

  final GestureTapCallback? onTap;

  final IconData? leadingIcon;

  final String textKey;

  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(32),
        topLeft: Radius.circular(32),
        topRight: Radius.circular(16),
      ),
      child: CustomContainer(
        shadowsOffset: Offset(5, 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: 16),
                  const SizedBox(width: 8),
                ],
                Text(
                  Utils.getTranslatedLabel(textKey),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            Icon(trailingIcon ?? LucideIcons.chevronRight, size: 16),
          ],
        ),
      ),
    );
  }
}
