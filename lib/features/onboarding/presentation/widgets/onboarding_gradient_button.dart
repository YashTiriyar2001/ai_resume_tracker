import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../theme/onboarding_theme.dart';

class OnboardingGradientButton extends StatelessWidget {
  const OnboardingGradientButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: colors.accent.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(32),
          child: Ink(
            height: 56,
            decoration: BoxDecoration(
              gradient: OnboardingTheme.primaryButton(context),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: colors.isDark ? Colors.white : colors.onAccentButton,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
