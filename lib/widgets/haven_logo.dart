import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Haven logo mark from Figma brand assets.
enum HavenLogoVariant { primary, light, dark }

class HavenLogo extends StatelessWidget {
  const HavenLogo({
    super.key,
    this.variant = HavenLogoVariant.primary,
    this.height = 48,
  });

  final HavenLogoVariant variant;
  final double height;

  static const _assets = {
    HavenLogoVariant.primary: 'assets/brand/logo/haven-icon-primary.svg',
    HavenLogoVariant.light: 'assets/brand/logo/haven-icon-light.svg',
    HavenLogoVariant.dark: 'assets/brand/logo/haven-icon-dark.svg',
  };

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _assets[variant]!,
      height: height,
      semanticsLabel: 'Haven',
    );
  }
}
