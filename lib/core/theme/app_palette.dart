import 'package:flutter/material.dart';

/// Semantic colors for ATSify screens (home, analysis, onboarding).
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.border,
    required this.headline,
    required this.body,
    required this.muted,
    required this.accent,
    required this.statValue,
    required this.progressTrack,
    required this.navBar,
    required this.sectionListItem,
    required this.roastCardGradientStart,
    required this.roastCardGradientEnd,
    required this.chipBackground,
    required this.chipBorder,
    required this.chipLabel,
    required this.outlinedButtonBorder,
    required this.onAccentButton,
    required this.dotInactive,
    required this.dotInactiveOutline,
    required this.emberIntensity,
    required this.isDark,
  });

  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color border;
  final Color headline;
  final Color body;
  final Color muted;
  final Color accent;
  final Color statValue;
  final Color progressTrack;
  final Color navBar;
  final Color sectionListItem;
  final Color roastCardGradientStart;
  final Color roastCardGradientEnd;
  final Color chipBackground;
  final Color chipBorder;
  final Color chipLabel;
  final Color outlinedButtonBorder;
  final Color onAccentButton;
  final Color dotInactive;
  final Color dotInactiveOutline;
  final double emberIntensity;
  final bool isDark;

  static const dark = AppPalette(
    background: Color(0xFF000000),
    surface: Color(0xFF1A1A1A),
    surfaceElevated: Color(0xFF242424),
    border: Color(0xFF333333),
    headline: Color(0xFFFFFFFF),
    body: Color(0xFFB3B3B3),
    muted: Color(0xFF888888),
    accent: Color(0xFFFF8C00),
    statValue: Color(0xFF66BB6A),
    progressTrack: Color(0xFF2A2A2A),
    navBar: Color(0xFF1E1E1E),
    sectionListItem: Color(0xFFE0E0E0),
    roastCardGradientStart: Color(0xFF2A1A10),
    roastCardGradientEnd: Color(0xFF1A1A1A),
    chipBackground: Color(0xFF2A2A2A),
    chipBorder: Color(0xFF444444),
    chipLabel: Color(0xFFFFB74D),
    outlinedButtonBorder: Color(0xFF555555),
    onAccentButton: Color(0xFF000000),
    dotInactive: Color(0xFF4D4D4D),
    dotInactiveOutline: Color(0x66FFFFFF),
    emberIntensity: 1,
    isDark: true,
  );

  static const light = AppPalette(
    background: Color(0xFFFAFAFA),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFF0F0F0),
    border: Color(0xFFE0E0E0),
    headline: Color(0xFF1A1A1A),
    body: Color(0xFF5C5C5C),
    muted: Color(0xFF757575),
    accent: Color(0xFFFF8C00),
    statValue: Color(0xFF2E7D32),
    progressTrack: Color(0xFFE8E8E8),
    navBar: Color(0xFFFFFFFF),
    sectionListItem: Color(0xFF424242),
    roastCardGradientStart: Color(0xFFFFF3E0),
    roastCardGradientEnd: Color(0xFFFFFFFF),
    chipBackground: Color(0xFFFFF8E1),
    chipBorder: Color(0xFFFFE0B2),
    chipLabel: Color(0xFFE65100),
    outlinedButtonBorder: Color(0xFFBDBDBD),
    onAccentButton: Color(0xFF000000),
    dotInactive: Color(0xFFCCCCCC),
    dotInactiveOutline: Color(0x66000000),
    emberIntensity: 0.35,
    isDark: false,
  );

  LinearGradient get primaryButton => const LinearGradient(
        colors: [Color(0xFFFFCA28), Color(0xFFFF7043)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  LinearGradient get onboardingButton => const LinearGradient(
        colors: [Color(0xFFFFB74D), Color(0xFFFF7043)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? border,
    Color? headline,
    Color? body,
    Color? muted,
    Color? accent,
    Color? statValue,
    Color? progressTrack,
    Color? navBar,
    Color? sectionListItem,
    Color? roastCardGradientStart,
    Color? roastCardGradientEnd,
    Color? chipBackground,
    Color? chipBorder,
    Color? chipLabel,
    Color? outlinedButtonBorder,
    Color? onAccentButton,
    Color? dotInactive,
    Color? dotInactiveOutline,
    double? emberIntensity,
    bool? isDark,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      border: border ?? this.border,
      headline: headline ?? this.headline,
      body: body ?? this.body,
      muted: muted ?? this.muted,
      accent: accent ?? this.accent,
      statValue: statValue ?? this.statValue,
      progressTrack: progressTrack ?? this.progressTrack,
      navBar: navBar ?? this.navBar,
      sectionListItem: sectionListItem ?? this.sectionListItem,
      roastCardGradientStart:
          roastCardGradientStart ?? this.roastCardGradientStart,
      roastCardGradientEnd: roastCardGradientEnd ?? this.roastCardGradientEnd,
      chipBackground: chipBackground ?? this.chipBackground,
      chipBorder: chipBorder ?? this.chipBorder,
      chipLabel: chipLabel ?? this.chipLabel,
      outlinedButtonBorder:
          outlinedButtonBorder ?? this.outlinedButtonBorder,
      onAccentButton: onAccentButton ?? this.onAccentButton,
      dotInactive: dotInactive ?? this.dotInactive,
      dotInactiveOutline: dotInactiveOutline ?? this.dotInactiveOutline,
      emberIntensity: emberIntensity ?? this.emberIntensity,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated:
          Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      headline: Color.lerp(headline, other.headline, t)!,
      body: Color.lerp(body, other.body, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      statValue: Color.lerp(statValue, other.statValue, t)!,
      progressTrack: Color.lerp(progressTrack, other.progressTrack, t)!,
      navBar: Color.lerp(navBar, other.navBar, t)!,
      sectionListItem:
          Color.lerp(sectionListItem, other.sectionListItem, t)!,
      roastCardGradientStart: Color.lerp(
        roastCardGradientStart,
        other.roastCardGradientStart,
        t,
      )!,
      roastCardGradientEnd:
          Color.lerp(roastCardGradientEnd, other.roastCardGradientEnd, t)!,
      chipBackground: Color.lerp(chipBackground, other.chipBackground, t)!,
      chipBorder: Color.lerp(chipBorder, other.chipBorder, t)!,
      chipLabel: Color.lerp(chipLabel, other.chipLabel, t)!,
      outlinedButtonBorder:
          Color.lerp(outlinedButtonBorder, other.outlinedButtonBorder, t)!,
      onAccentButton: Color.lerp(onAccentButton, other.onAccentButton, t)!,
      dotInactive: Color.lerp(dotInactive, other.dotInactive, t)!,
      dotInactiveOutline:
          Color.lerp(dotInactiveOutline, other.dotInactiveOutline, t)!,
      emberIntensity: emberIntensity + (other.emberIntensity - emberIntensity) * t,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get appPalette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.dark;
}
