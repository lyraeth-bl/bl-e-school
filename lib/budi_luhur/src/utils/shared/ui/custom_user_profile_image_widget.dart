import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomUserProfileImageWidget extends StatelessWidget {
  final String profileUrl;
  final Color? color;
  final BorderRadius? radius;

  const CustomUserProfileImageWidget({
    super.key,
    required this.profileUrl,
    this.color,
    this.radius,
  });

  _imageOrDefaultProfileImage() {
    // Check if the profile URL is an SVG
    if (profileUrl.isSvgUrl()) {
      return SvgPicture.network(
        profileUrl,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color!, BlendMode.srcIn),
        fit: BoxFit.cover,
        placeholderBuilder: (context) => SvgPicture.asset(
          "assets/images/default_profile.svg",
          colorFilter: color == null
              ? null
              : ColorFilter.mode(color!, BlendMode.srcIn),
          fit: BoxFit.contain,
        ),
      );
    }

    // For non-SVG images, use CachedNetworkImage
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: profileUrl,
      errorWidget: (context, url, error) {
        return SvgPicture.asset(
          "assets/images/default_profile.svg",
          colorFilter: color == null
              ? null
              : ColorFilter.mode(color!, BlendMode.srcIn),
          fit: BoxFit.contain,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return radius != null
        ? ClipRRect(borderRadius: radius!, child: _imageOrDefaultProfileImage())
        : ClipOval(child: _imageOrDefaultProfileImage());
  }
}
