import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class CustomChipContainer extends StatelessWidget {
  const CustomChipContainer({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  final Widget child;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.tertiaryContainer,
      enableShadow: false,
      child: child,
    );
  }
}
