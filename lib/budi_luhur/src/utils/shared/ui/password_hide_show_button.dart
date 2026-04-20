import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../extensions/extension.dart';

class PasswordHideShowButton extends StatelessWidget {
  final bool hidePassword;
  final Function onTap;
  final double? allSidePadding;

  const PasswordHideShowButton({
    super.key,
    required this.hidePassword,
    required this.onTap,
    this.allSidePadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: allSidePadding?.all ?? 12.all,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Icon(
          hidePassword ? LucideIcons.eyeClosed : LucideIcons.eye,
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
