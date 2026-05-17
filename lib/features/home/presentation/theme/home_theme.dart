import 'package:flutter/material.dart';

abstract final class HomeTheme {
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceElevated = Color(0xFF242424);
  static const Color border = Color(0xFF333333);
  static const Color headline = Color(0xFFFFFFFF);
  static const Color body = Color(0xFFB3B3B3);
  static const Color muted = Color(0xFF888888);
  static const Color accent = Color(0xFFFF8C00);
  static const Color statValue = Color(0xFF66BB6A);

  static const LinearGradient primaryButton = LinearGradient(
    colors: [Color(0xFFFFCA28), Color(0xFFFF7043)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static TextStyle get greetingStyle => const TextStyle(
        color: headline,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static TextStyle get sectionTitleStyle => const TextStyle(
        color: headline,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get linkStyle => const TextStyle(
        color: accent,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );
}
