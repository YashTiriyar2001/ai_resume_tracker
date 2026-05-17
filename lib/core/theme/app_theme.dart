import 'package:custom_design_system/custom_design_system.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData light() {
    const primary = BrandColors.kAppPrimaryColor;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: BrandColors.kBackgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: PrimaryColor.base,
        secondary: SecondaryColor.base,
        error: ErrorColor.base,
        surface: BrandColors.kSurfaceColor,
        onSurface: NeutralColor.color8,
      ),
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
        fillColor: Shades.white,
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
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NeutralColor.color9,
      colorScheme: ColorScheme.fromSeed(
        seedColor: PrimaryColor.base,
        brightness: Brightness.dark,
        primary: PrimaryColor.base,
        surface: NeutralColor.color8,
      ),
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
