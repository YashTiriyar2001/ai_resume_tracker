import 'package:flutter/material.dart';

abstract final class OnboardingTheme {
  static const Color background = Color(0xFF000000);
  static const Color headline = Color(0xFFFFFFFF);
  static const Color body = Color(0xFFB3B3B3);
  static const Color dotActive = Color(0xFFFF8C00);
  static const Color dotInactive = Color(0xFF4D4D4D);
  static const Color dotInactiveOutline = Color(0x66FFFFFF);

  static const LinearGradient primaryButton = LinearGradient(
    colors: [Color(0xFFFFB74D), Color(0xFFFF7043)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient primaryButtonGlow = LinearGradient(
    colors: [Color(0x40FF8C00), Color(0x00FF8C00)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static TextStyle get headerStyle => const TextStyle(
        color: headline,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static TextStyle get titleStyle => const TextStyle(
        color: headline,
        fontSize: 26,
        fontWeight: FontWeight.w800,
        height: 1.25,
        letterSpacing: -0.5,
      );

  static TextStyle get subtitleStyle => const TextStyle(
        color: body,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );
}
