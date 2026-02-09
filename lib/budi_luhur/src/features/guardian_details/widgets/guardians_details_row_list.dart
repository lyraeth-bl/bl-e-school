import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class GuardiansDetailsRowList extends StatelessWidget {
  final String titleKey;
  final String? value;

  const GuardiansDetailsRowList({
    super.key,
    required this.titleKey,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = Utils.formatEmptyValue(value);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Utils.getTranslatedLabel(titleKey),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          Utils.formatEmptyValue(displayValue),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class GuardiansDetailsColumnList extends StatelessWidget {
  final String titleKey;
  final String? value;

  const GuardiansDetailsColumnList({
    super.key,
    required this.titleKey,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = Utils.formatEmptyValue(value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslatedLabel(titleKey),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          Utils.formatEmptyValue(displayValue),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
