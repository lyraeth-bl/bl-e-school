import 'package:flutter/material.dart';

import '../../../utils/shared/ui/custom_container.dart';

class GuardiansDetailsListContainer extends StatelessWidget {
  final Widget child;

  const GuardiansDetailsListContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: MediaQuery.of(context).size.width * (0.9),
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }
}
