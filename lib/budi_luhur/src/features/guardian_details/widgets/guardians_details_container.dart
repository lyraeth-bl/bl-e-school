import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

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
