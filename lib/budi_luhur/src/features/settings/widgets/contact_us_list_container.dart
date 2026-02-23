import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class ContactUsListContainer extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final String subtitle;
  final IconData leadingIcon;

  const ContactUsListContainer({
    super.key,
    this.onTap,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          child: Icon(leadingIcon),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class ContactUsClickableListContainer extends StatelessWidget {
  final String url;
  final String title;
  final String? subtitle;
  final IconData leadingIcon;
  final Color? iconColor;
  final Color? backgroundIconColor;

  const ContactUsClickableListContainer({
    super.key,
    required this.url,
    required this.title,
    this.subtitle,
    required this.leadingIcon,
    this.iconColor,
    this.backgroundIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => Utils.launchThisUrl(url),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor:
              backgroundIconColor ??
              Theme.of(context).colorScheme.surfaceContainer,
          child: Icon(leadingIcon, color: iconColor),
        ),
        title: Text(
          Utils.getTranslatedLabel(title),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              )
            : null,
      ),
    );
  }
}
