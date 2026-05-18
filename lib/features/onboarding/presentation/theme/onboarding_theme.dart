import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

abstract final class OnboardingTheme {
  static TextStyle headerStyle(BuildContext context) => TextStyle(
        color: context.appPalette.headline,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static TextStyle titleStyle(BuildContext context) => TextStyle(
        color: context.appPalette.headline,
        fontSize: 26,
        fontWeight: FontWeight.w800,
        height: 1.25,
        letterSpacing: -0.5,
      );

  static TextStyle subtitleStyle(BuildContext context) => TextStyle(
        color: context.appPalette.body,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );

  static Color dotActive(BuildContext context) => context.appPalette.accent;

  static Color dotInactive(BuildContext context) => context.appPalette.dotInactive;

  static Color dotInactiveOutline(BuildContext context) =>
      context.appPalette.dotInactiveOutline;

  static LinearGradient primaryButton(BuildContext context) =>
      context.appPalette.onboardingButton;
}
