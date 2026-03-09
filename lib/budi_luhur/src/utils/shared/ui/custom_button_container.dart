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
    this.margin,
    this.backgroundColor,
    this.enableShadow,
    this.padding,
  });

  final GestureTapCallback? onTap;

  final IconData? leadingIcon;

  final String textKey;

  final IconData? trailingIcon;

  final EdgeInsetsGeometry? margin;

  final Color? backgroundColor;

  final bool? enableShadow;

  final EdgeInsetsGeometry? padding;

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
        enableShadow: enableShadow,
        shadowsOffset: Offset(5, 5),
        margin: margin,
        padding: padding ?? 16.all,
        backgroundColor: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (leadingIcon != null) ...[Icon(leadingIcon, size: 16), 8.w],
                Text(
                  textKey.translate(),
                  style: context.text.titleSmall?.copyWith(
                    color: context.colors.onSurface,
                    fontWeight: FontWeight.w700,
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
