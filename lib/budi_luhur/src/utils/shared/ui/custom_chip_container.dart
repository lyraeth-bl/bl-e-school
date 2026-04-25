import 'package:flutter/material.dart';

import 'custom_container.dart';

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
