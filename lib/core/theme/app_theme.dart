import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_palette.dart';

abstract final class AppTheme {
  static ThemeData light() => _buildTheme(
        brightness: Brightness.light,
        palette: AppPalette.light,
        scaffoldBackground: AppPalette.light.background,
        appBarBackground: AppPalette.light.surface,
        appBarForeground: AppPalette.light.headline,
        inputFill: AppPalette.light.surface,
        inputBorder: AppPalette.light.border,
        divider: AppPalette.light.border,
      );

  static ThemeData dark() => _buildTheme(
        brightness: Brightness.dark,
        palette: AppPalette.dark,
        scaffoldBackground: AppPalette.dark.background,
        appBarBackground: AppPalette.dark.surface,
        appBarForeground: AppPalette.dark.headline,
        inputFill: AppPalette.dark.surfaceElevated,
        inputBorder: AppPalette.dark.border,
        divider: AppPalette.dark.border,
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required AppPalette palette,
    required Color scaffoldBackground,
    required Color appBarBackground,
    required Color appBarForeground,
    required Color inputFill,
    required Color inputBorder,
    required Color divider,
  }) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: palette.accent,
      brightness: brightness,
      primary: palette.accent,
      surface: palette.surface,
      onSurface: palette.headline,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: colorScheme,
      extensions: [palette],
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          statusBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: palette.background,
          systemNavigationBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.accent,
        foregroundColor: palette.onAccentButton,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: palette.onAccentButton,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.accent, width: 2),
        ),
      ),
      dividerColor: divider,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? palette.surfaceElevated : palette.headline,
        contentTextStyle: TextStyle(color: isDark ? palette.headline : Colors.white),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        titleTextStyle: TextStyle(
          color: palette.headline,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        contentTextStyle: TextStyle(color: palette.body, fontSize: 14),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return palette.accent;
          }
          return null;
        }),
      ),
      fontFamily: 'Roboto',
    );
  }
}
