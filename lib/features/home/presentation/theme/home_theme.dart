import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

abstract final class HomeTheme {
  static AppPalette colors(BuildContext context) => context.appPalette;

  static TextStyle greetingStyle(BuildContext context) => TextStyle(
        color: colors(context).headline,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static TextStyle sectionTitleStyle(BuildContext context) => TextStyle(
        color: colors(context).headline,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      );

  static TextStyle linkStyle(BuildContext context) => TextStyle(
        color: colors(context).accent,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );
}
