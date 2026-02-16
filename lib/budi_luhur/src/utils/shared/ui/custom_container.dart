import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.enableShadow,
    this.alignment,
    this.width,
    this.height,
    this.border,
  });

  final Widget child;

  final BorderRadiusGeometry? borderRadius;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  final Color? backgroundColor;

  final bool? enableShadow;

  final AlignmentGeometry? alignment;

  final double? width;

  final double? height;

  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius:
            borderRadius ??
            BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(32),
              topLeft: Radius.circular(32),
              topRight: Radius.circular(16),
            ),
        boxShadow: enableShadow == false
            ? null
            : [
                BoxShadow(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  offset: Offset(4, 4),
                ),
              ],
        border: border,
      ),
      child: child,
    );
  }
}
