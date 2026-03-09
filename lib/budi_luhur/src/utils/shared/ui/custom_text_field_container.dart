import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldContainer extends StatelessWidget {
  final String hintTextKey;
  final bool hideText;
  final double? bottomPadding;
  final Widget? suffixWidget;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFieldContainer({
    super.key,
    required this.hintTextKey,
    required this.hideText,
    this.bottomPadding,
    this.suffixWidget,
    this.textEditingController,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      border: Border.all(color: context.colors.outlineVariant),
      height: 50,
      margin: EdgeInsets.only(bottom: bottomPadding ?? 24),
      padding: const EdgeInsetsDirectional.only(start: 24.0),
      child: TextField(
        style: TextStyle(color: context.colors.onSurface),
        controller: textEditingController,
        obscureText: hideText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        enableInteractiveSelection: true,
        enableSuggestions: keyboardType != TextInputType.number,
        autofocus: false,
        decoration: InputDecoration(
          suffixIcon: suffixWidget,
          hintStyle: TextStyle(color: context.colors.onSurface),
          hintText: hintTextKey,
          border: InputBorder.none,
          contentPadding: suffixWidget != null ? (12.5).onlyTop : null,
        ),
      ),
    );
  }
}
