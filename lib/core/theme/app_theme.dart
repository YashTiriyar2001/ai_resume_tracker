import 'package:custom_design_system/custom_design_system.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData light() {
    const primary = BrandColors.kAppPrimaryColor;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: PrimaryColor.base,
      secondary: SecondaryColor.base,
      error: ErrorColor.base,
    ).copyWith(
      surface: BrandColors.kSurfaceColor,
      onSurface: NeutralColor.color8,
      background: BrandColors.kBackgroundColor,
      onBackground: BrandColors.kTextPrimaryColor,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: BrandColors.kBackgroundColor,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: BrandColors.kSurfaceColor,
        foregroundColor: BrandColors.kTextPrimaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: PrimaryColor.base,
        foregroundColor: Shades.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BrandColors.kSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NeutralColor.color2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NeutralColor.color2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PrimaryColor.base, width: 2),
        ),
      ),
      dividerColor: NeutralColor.color2,
      fontFamily: 'Roboto',
    );
  }

  static ThemeData dark() {
    const background = NeutralColor.color9;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: PrimaryColor.base,
      brightness: Brightness.dark,
      primary: PrimaryColor.base,
    ).copyWith(
      surface: NeutralColor.color8,
      background: background,
      onBackground: Shades.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: NeutralColor.color8,
        foregroundColor: Shades.white,
        elevation: 0,
        centerTitle: true,
      ),
      fontFamily: 'Roboto',
    );
  }
}
