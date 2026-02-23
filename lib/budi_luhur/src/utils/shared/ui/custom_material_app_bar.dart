import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class CustomMaterialAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomMaterialAppBar({
    super.key,
    required this.titleKey,
    this.centerTitle,
    this.appBarHeight,
    this.backgroundColor,
  });

  /// Tinggi dari [AppBar].
  /// Defaultnya 80.
  final double? appBarHeight;

  /// Sudah di bungkus dengan [Utils.getTranslatedLabel]
  final String titleKey;

  /// Membuat [titleKey] berada di tengah [AppBar].
  /// Default false.
  final bool? centerTitle;

  /// Warna [AppBar].
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      title: Text(
        Utils.getTranslatedLabel(titleKey),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: centerTitle ?? false,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? 80);
}
