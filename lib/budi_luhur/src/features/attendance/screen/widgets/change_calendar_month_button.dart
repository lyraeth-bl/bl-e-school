import 'package:flutter/material.dart';

class ChangeCalendarMonthButton extends StatelessWidget {
  final Function onTap;
  final bool isDisable;
  final IconData icon;

  const ChangeCalendarMonthButton({
    super.key,
    required this.onTap,
    required this.isDisable,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap.call();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
